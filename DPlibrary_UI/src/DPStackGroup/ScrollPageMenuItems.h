//
// Created by BlueBerry on 12-12-17.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface ScrollPageMenuItems : UIView
{
    /** [yu]
        title 数组，里面记录着当前的所有Title
    */
    NSMutableArray *_arrayTitles;

    /** [yu]
        item数组，item主要是由Button构成，单独提出来放到数组中，是为了调用和遍历
    */
    NSMutableArray *_arrayItems;

    /** [yu]
        UI控件，显示当前所选中的标识
    */
    UIImageView *_scrollSelectTip;

    /** [yu]
        当前选中的Index
    */
    NSUInteger _currentSelectedIndex;
}
@property(nonatomic, retain) UIImageView *scrollSelectTip;
@property(nonatomic, retain) NSMutableArray *arrayItems;
@property(nonatomic, retain) NSMutableArray *arrayTitles;

/** [yu]
    选中时会触发此事件
*/
AS_SIGNAL(SELECTED_TITLE_INDEX)
@property(nonatomic) NSUInteger currentSelectedIndex;


/** [yu]
    向导航条中，添加一个title item
*/
-(void) appendTitleItem:(NSString *) title;

/** [yu]
    指定选中某一项
*/
-(void) setSelectedIndex:(NSUInteger)index;
@end