//
// Created by apple on 13-1-18.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "NSObject+BeeNotification.h"


@interface DPAlertInput : UIAlertView<UIAlertViewDelegate>

-(id) initWithTitle:(NSString *) title withInitText:(NSString *) initText withPlaceHoldText:(NSString *) placeHoldText withMaxLength:(NSUInteger) maxLength;

AS_NOTIFICATION(ALERT_INPUT_FINISH)
AS_NOTIFICATION(ALERT_INPUT_CANCEL)
@end