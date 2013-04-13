//
//  DPWarningView.h
//  DPBeeClient
//
//  Created by doujingxuan on 13-3-19.
//
//

#import <UIKit/UIKit.h>

@interface DPWarningView : UIView
{
    UIViewController * _viewController;
}
-(id)initWithViewController:(UIViewController*)viewController;
-(void)popWarningView;
@end
