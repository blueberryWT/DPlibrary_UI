//
// Created by BlueBerry on 12-12-17.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ScrollPageMenuItems.h"
#import "UIView+UU.h"

@interface ScrollPageMenuItems (private)
/** [yu]
    初始化所有数据相关的内容
*/
-(void)initSelfData;

/** [yu]
    初始化所有控件相关的内容
*/
-(void)initSelfControls;

@end


@implementation ScrollPageMenuItems
@synthesize scrollSelectTip = _scrollSelectTip;
@synthesize arrayItems = _arrayItems;
@synthesize arrayTitles = _arrayTitles;

DEF_SIGNAL(SELECTED_TITLE_INDEX)
@synthesize currentSelectedIndex = _currentSelectedIndex;


#pragma mark 初始化
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelfData];
        [self initSelfControls];
    }
    return self;
}

#pragma mark 私有方法
- (void)initSelfData {
    /**Author:于同非 Description:创建存储items的队列*/
    if(!_arrayItems)
    {
        _arrayItems = [[NSMutableArray alloc] init];
    }

    if (!_arrayTitles) {
        _arrayTitles = [[NSMutableArray alloc] init];
    }
    self.currentSelectedIndex = 0;
}

- (void)initSelfControls {
    /** [yu]
        创建背景图片
    */
    UIImageView *_backGroundView = [[[UIImageView alloc] init] autorelease];
    [self addSubview:_backGroundView];
    UIImage *backgroundImage = __IMAGE_FILE(@"secondMenuNav", @"png");
    [_backGroundView setImage:backgroundImage];
    [_backGroundView setFrame:CGRectMake(0, 0, self.width, backgroundImage.size.height)];

    if (!_scrollSelectTip) {
        _scrollSelectTip = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_scrollSelectTip setBackgroundColor:RGB(246, 138, 47)];
        [self addSubview:_scrollSelectTip];
    }

}


- (void)appendTitleItem:(NSString *)title {
    if (!title || [title empty]) {
        return;
    }
    [self.arrayTitles addObject:title];

    // [yu] 创建一个新的item
    BeeUIButton *titleItem = [[[BeeUIButton alloc] init] autorelease];
    [titleItem.titleLabel setFont:[DPTools dpFontWitSize:13.0f]];
    titleItem.stateNormal.title = title;
    titleItem.stateNormal.titleColor = RGB(151, 151, 151);
    [titleItem sizeToFit];
    [self addSubview:titleItem];
    [self.arrayItems addObject:titleItem];

    // [yu] 重新设置所有item的位置和尺寸
    CGFloat itemWidth = self.width / self.arrayTitles.count;
    for (NSUInteger i = 0; i < self.arrayItems.count; i++) {
        BeeUIButton *item = self.arrayItems[i];
        [item setHeight:self.height];
        [item setCenterY:self.height / 2];
        [item setCenterX:i *itemWidth + (self.width / self.arrayItems.count / 2)];
        [item addSignal:[ScrollPageMenuItems SELECTED_TITLE_INDEX] forControlEvents:UIControlEventTouchUpInside object:__INT(i)];
    }
    // [yu] 重新计算index标识
    if (self.scrollSelectTip) {
        [self.scrollSelectTip setWidth:itemWidth];
        UIView *view = self.arrayItems[self.currentSelectedIndex];
        if (view) {
            [self.scrollSelectTip setFrame:CGRectMake(view.left, self.height - 3, view.width, 3)];
        }
    }
}

- (void)setSelectedIndex:(NSUInteger)index1 {
    for (BeeUIButton *btn in self.arrayItems) {
        btn.stateNormal.titleColor = RGB(151, 151, 151);
    }
    BeeUIButton *item = self.arrayItems[(NSUInteger) index1];
    [UIView animateWithDuration:0.3 animations:^() {
        item.stateNormal.titleColor = RGB(246, 138, 47);
        [self.scrollSelectTip setFrame:CGRectMake(item.left, self.height - 3, item.width, 3)];
    }                completion:^(BOOL b) {
        BeeCC(@"点击完成");
    }];
}


-(void)handleUISignal:(BeeUISignal *)signal {
    [super handleUISignal:signal];
    if ([signal is:[ScrollPageMenuItems SELECTED_TITLE_INDEX]]) {
        int index = ((NSNumber *) signal.object).intValue;
        [self setSelectedIndex:(NSUInteger )index];
    }
}


- (void)dealloc {
    [_scrollSelectTip release];
    [_arrayItems release];
    [_arrayTitles release];
    [super dealloc];
}


@end