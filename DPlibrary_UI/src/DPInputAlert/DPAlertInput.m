//
// Created by apple on 13-1-18.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPAlertInput.h"
#import "NSObject+BeeNotification.h"
#import "Bee_UITextView.h"
#import "NSString+BeeExtension.h"


@implementation DPAlertInput

DEF_NOTIFICATION(ALERT_INPUT_FINISH)
DEF_NOTIFICATION(ALERT_INPUT_CANCEL)

-(id) initWithTitle:(NSString *) title withInitText:(NSString *) initText withPlaceHoldText:(NSString *) placeHoldText withMaxLength:(NSUInteger) maxLength {
    self = [super initWithTitle:title message:@"\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    if (self) {
        BeeUITextView *textView = [[[BeeUITextView alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 112.0)] autorelease];
        [textView setBackgroundColor:[UIColor whiteColor]];
        if (placeHoldText && [placeHoldText notEmpty]) {
            [textView setPlaceholder:placeHoldText];
        }
        if (maxLength > 0) {
            [textView setMaxLength:maxLength];
        }
        textView.font = [UIFont boldSystemFontOfSize:15];
        textView.layer.cornerRadius = 6;
        textView.layer.masksToBounds = YES;
        [textView setText:initText];
        textView.tag = 1001;
        // [yu] 设置这句之后，当键盘弹出来时，整个alert会向上移动
        [self setTransform: CGAffineTransformMakeTranslation(0.0, -100)];
        [self addSubview: textView];
    }
    return self;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self postNotification:[DPAlertInput ALERT_INPUT_CANCEL]];
    }else if (buttonIndex == 1) {
        BeeUITextView *inputTextView = (BeeUITextView *)[alertView viewWithTag:1001];
        // #bug 412
        [inputTextView resignFirstResponder];
        NSString *inputText = @"";
        if (inputTextView) {
            inputText = inputTextView.text;
        }
        [self postNotification:[DPAlertInput ALERT_INPUT_FINISH] withObject:inputText];
    }
}



@end