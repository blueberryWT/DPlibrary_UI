//
// Created by BlueBerry on 12-11-15.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^ActionBlock)();


@protocol DPButtonDelegate
@optional
-(void) longPressEventBegin:(id) sender;
-(void) longPressEventEnd:(id) sender;
@end

@interface DPButton : UIButton
{
    NSMutableDictionary *_userInfo;
    ActionBlock _actionBlock;
    id<DPButtonDelegate> _delegate;
}
@property(nonatomic, retain) NSMutableDictionary *userInfo;
@property (nonatomic, assign) id<DPButtonDelegate> delegate;
-(id) initWithFrame:(CGRect) frame withBackgroundImage:(UIImage *) image withTitle:(NSString *) title;
-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action;
@end