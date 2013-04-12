//
// Created by apple on 13-1-23.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPStackGroup.h"
#import "ScrollPageMenuItems.h"
#import "UIView+UU.h"
#import "DPMenuBoard.h"
#import "DPScrollView.h"
#import "DPBeeAppDelegate.h"


@interface DPStackGroup(Private)

-(void) initSelfControls;
-(void) initSelfData;

@end

@implementation DPStackGroup
@synthesize scrollView = _scrollView;
@synthesize stacks = _stacks;
@synthesize currentShowIndex = _currentShowIndex;

DEF_SIGNAL(DPSTACKGROUN_INDEX_CHANGE)


@synthesize scrollPageMenuTitle = _scrollPageMenuTitle;


-(void)load {
    [super load];
    [self observeNotification:UIApplicationDidEnterBackgroundNotification];
    [self observeNotification:UIApplicationWillEnterForegroundNotification];
}


#pragma mark => handle

-(void)handleUISignal:(BeeUISignal *)signal {
    [super handleUISignal:signal];
    if ([signal isKindOf:[BeeUIBoard SIGNAL]]) {
        if ([signal is:[BeeUIBoard CREATE_VIEWS]]) {
            [self initSelfControls];
        }else if ([signal is:[BeeUIBoard DELETE_VIEWS]]) {
            //  释放视图
            self.scrollPageMenuTitle = nil;
            self.scrollView = nil;
        }else if ([signal is:[BeeUIBoard FREE_DATAS]]) {
            // 释放资源
            self.currentShowIndex = -1;
            [self.stacks removeAllObjects];
            self.stacks = nil;
            self.firstEnter = YES;
        }
    }
}


-(void) handleScrollPageMenuItems:(BeeUISignal *) signal {
    [super handleUISignal:signal];
    if ([signal is:[ScrollPageMenuItems SELECTED_TITLE_INDEX]]) {
        BeeCC(@"选择了索引");
        NSNumber *number = (NSNumber *)signal.object;
        NSUInteger index = (NSUInteger )number.integerValue;
        [self presentIndex:index];
    }
}

#pragma mark => private method

- (void)initSelfControls {
    [self initSelfData];
    self.view.height = [UIScreen mainScreen].applicationFrame.size.height - self.navigationController.navigationBar.height;
    if (!_scrollPageMenuTitle) {
        _scrollPageMenuTitle = [[ScrollPageMenuItems alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 27.5)];
        [self.view addSubview:_scrollPageMenuTitle];
    }

    if (!_scrollView) {
        _scrollView = [[DPScrollView alloc] initWithFrame:CGRectMake(0, _scrollPageMenuTitle.bottom, self.view.width, self.view.height - _scrollPageMenuTitle.height)];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setDelegate:self];
        [_scrollView setCanCancelContentTouches:NO];
        [self.view addSubview:_scrollView];
    }

}

- (void)initSelfData {
    self.currentShowIndex = -1;
    if (!_stacks) {
        _stacks = [[NSMutableArray alloc] init];
    }
}



#pragma mark => public method
- (void)append:(BeeUIStack *)stack {
    if (nil == stack) {
        return;
    }
    if (NO == [self.stacks containsObject:stack]) {
        [_stacks addObject:stack];

        // [yu] 取出stack的title，当作标题显示
        NSString *stackTitle = stack.title;
        if (nil == stackTitle || [stackTitle empty]) {
            stackTitle = @" 未知视图 ";
        }
        [self.scrollPageMenuTitle appendTitleItem:stackTitle];

        // [yu] 将stack添加到当前的view中显示
        [self.scrollView addSubview:stack.view];
        [stack.view setFrame:CGRectMake((_stacks.count  - 1)* _scrollView.width, 0, _scrollView.width, _scrollView.height)];
        [_scrollView setContentSize:CGSizeMake(stack.view.right, _scrollView.height)];
    }
}

- (void)removeWithStack:(BeeUIStack *)stack {
    if (nil == stack) {
        return;
    }
    if (YES == [self.stacks containsObject:stack]) {
        if ([stack isViewLoaded]) {
            [stack.view removeFromSuperview];
        }
    }
    [_stacks removeObject:stack];
}

- (void)removeWithIndex:(NSUInteger)index1 {
    if (index1 >= _stacks.count) {
        return;
    }
    BeeUIStack *beeUIStack = _stacks[index1];
    [self removeWithStack:beeUIStack];
}

- (void)presentStack:(BeeUIStack *)stack {

    PERF_ENTER_(PRESENT_STACK)

    // [yu] 这里做一个参数的校验
    if (nil == stack) {
        return;
    }

    if (0 == _stacks.count || NO == [_stacks containsObject:stack]) {
        return;
    }

    // [yu] 处理将要消失的视图
    BeeUIStack *top = nil;
    if (_currentShowIndex >= 0) {
        top = _stacks[_currentShowIndex];
        if (top == stack) { // 如果是重复的，就不进行重复加载了
            return;
        }

        [top viewWillDisappear:NO];

        if ([top.topBoard conformsToProtocol:@protocol(DPScrollBoardProtocol)]) {
                [(id<DPScrollBoardProtocol>)top.topBoard performSelector:@selector(dpBoardWillDisappearDisplay:) withObject:nil];
        }
    }


    // [yu] 重新计算当前显示的索引
    _currentShowIndex = [_stacks indexOfObject:stack];
    _currentShowIndex = (_currentShowIndex >= _stacks.count) ? (_stacks.count - 1) : _currentShowIndex;

    // [yu] 滚动到当前这个视图上
    [self.scrollView setContentOffset:CGPointMake(_currentShowIndex * _scrollView.width, 0) animated:YES];

    // [yu] 调用viewWillAppear
//    [self.stack viewWillAppear:NO];
//    [self.stack viewDidAppear:NO];

    // [yu] 设置视图将要显示的事件 在这两个方法中可以处理数据
    if ([stack.topBoard conformsToProtocol:@protocol(DPScrollBoardProtocol)]) {
            [(id<DPScrollBoardProtocol>)stack.topBoard performSelector:@selector(dpBoardWillAppearDisplay:) withObject:nil];
    }


    // [yu] 更新bounces属性
//    [self.scrollView setBounces:!(self.currentShowIndex == 0)];
    [self.scrollView setBounces:NO];
    // [yu] 切换对应的title
    [self.scrollPageMenuTitle setSelectedIndex:_currentShowIndex];

    // [yu] 发送一个通知
    [self sendUISignal:[DPStackGroup DPSTACKGROUN_INDEX_CHANGE]];

    PERF_LEAVE_(PRESENT_STACK)
}

- (void)presentIndex:(NSUInteger)index1 {
    if(index1 < 0 || index1 >= self.stacks.count)
        return;
    BeeUIStack *stack = _stacks[index1];
    [self presentStack:stack];
}


#pragma mark => handle notification

- (void)handleNotification:(NSNotification *)notification
{
    if ( [notification is:UIApplicationDidEnterBackgroundNotification] )
    {
        for ( BeeUIStack * nav in _stacks )
        {
            [nav __enterBackground];
        }
    }
    else if ( [notification is:UIApplicationWillEnterForegroundNotification] )
    {
        for ( BeeUIStack * nav in _stacks )
        {
            [nav __enterForeground];
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        CGFloat f = scrollView.contentOffset.x;
        if (self.currentShowIndex == 0 && f == 0) {
            NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
            if (index == 0) {
                [((DPBeeAppDelegate *) [UIApplication sharedApplication].delegate).mainNav setPaneState:MSNavigationPaneStateOpen animated:YES];
            }else {
                // 如果不是根视图，则需要返回上一个页面
                [self sendUISignal:[BeeUIBoard BACK_BUTTON_TOUCHED]];
            }
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    /**Author:于同非 Description:计算当前的索引*/
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSUInteger page = (NSUInteger )(self.scrollView.contentOffset.x / pageWidth);

    // [yu] 切换到当前的页面
    [self presentIndex:page];

//    [self.scrollView setBounces:!(self.currentShowIndex == 0)];
    [self.scrollView setBounces:NO];

    /**Author:于同非 Description:更新title的位置*/
    [self.scrollPageMenuTitle setSelectedIndex:(NSUInteger) self.currentShowIndex];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}


#pragma mark => dealloc && unload
-(void) unload {
    [super unload];
    [self unobserveAllNotifications];
}
- (void)dealloc {
    [_scrollView release],_scrollView = nil;
    [_stacks release], _stacks = nil;
    [_scrollPageMenuTitle release], _scrollPageMenuTitle = nil;
    [super dealloc];
}


@end