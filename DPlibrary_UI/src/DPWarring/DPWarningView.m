//
//  DPWarningView.m
//  DPBeeClient
//
//  Created by doujingxuan on 13-3-19.
//
//

#import "DPWarningView.h"
#import "DPBeeAppDelegate.h"

@implementation DPWarningView
- (void)dealloc
{
    [_viewController release];
    [super dealloc];
}
-(id)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _viewController = viewController;
        [_viewController retain];
        self.frame = [UIScreen mainScreen].bounds;
        BeeCC(@"self.frame is %@",NSStringFromCGRect(self.frame));
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    }
    return self;
}
-(void)popWarningView
{
    UIImageView * warningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 276, 176)];
    [warningImageView setImage:[UIImage imageNamed:@"Message_alert_view"]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissWarningView:)];
    [warningImageView  addGestureRecognizer:singleTap];
    [singleTap release];
    
    warningImageView.center = self.center;
    warningImageView.userInteractionEnabled = YES;
    BeeCC(@"self.frame is %@",NSStringFromCGRect(warningImageView.frame));
    [self addSubview:warningImageView];

    [warningImageView release];
    UIWindow *window = ((DPBeeAppDelegate*)[UIApplication sharedApplication].delegate).window;
    [window addSubview:self];
}
-(void)dissmissWarningView:(id)sender
{
    [self removeFromSuperview];
    /**Author:Ronaldo Description:记录点击过 警告图片*/
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"DPWarning_Alert"];
    [defaults synchronize];
}
@end
