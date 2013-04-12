//
// Created by apple on 13-1-23.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DPScrollBoardProtocol.h"
@class ScrollPageMenuItems;
@class DPScrollView;


@interface DPStackGroup : BeeUIBoard <UIScrollViewDelegate> {
    /** [yu]
        滚动的标题栏
    */
    ScrollPageMenuItems  * _scrollPageMenuTitle;

    /** [yu]
        当前所选择的index
    */
    NSInteger _currentShowIndex;

    /** [yu]
        Stack队列
    */
    NSMutableArray *_stacks;

    /** [yu]
        用于滚动的视图
    */
    DPScrollView *_scrollView;

}
@property(nonatomic, retain) DPScrollView *scrollView;
@property(nonatomic, retain) NSMutableArray *stacks;
@property(nonatomic) NSInteger currentShowIndex;
@property(nonatomic, retain) ScrollPageMenuItems *scrollPageMenuTitle;

AS_SIGNAL(DPSTACKGROUN_INDEX_CHANGE)


/** [yu]
    动态添加一个Stack
*/
-(void) append:(BeeUIStack *) stack;

/** [yu]
   根据Stack删除
*/
-(void) removeWithStack:(BeeUIStack *) stack;

/** [yu]
    根据Index删除一个Stack
*/
-(void) removeWithIndex:(NSUInteger) index;

/** [yu]
    跳转到对应的Stack上
*/
-(void) presentStack:(BeeUIStack *) stack;

/** [yu]
    根据索引跳转到一个页面中
*/
-(void) presentIndex:(NSUInteger) index;
@end