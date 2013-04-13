//
//  DPWarningView.m
//  DPBeeClient
//
//  Created by doujingxuan on 13-3-19.
//
//

#import "DPWarningView.h"
#import "Bee_Log.h"

@implementation DPWarningView
- (id)initWithAlertImage:(UIImage *)alertImage {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        if (alertImage) {
            self.img = alertImage;
        }
        [self popWarningView];

    }
    return self;

}

- (void)dealloc
{
    [_img release];
    [super dealloc];
}

-(void)popWarningView
{
    UIImageView * warningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 276, 176)];
    [warningImageView setImage:self.img];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissWarningView:)];
    [warningImageView  addGestureRecognizer:singleTap];
    [singleTap release];
    
    warningImageView.center = self.center;
    warningImageView.userInteractionEnabled = YES;
    BeeCC(@"self.frame is %@",NSStringFromCGRect(warningImageView.frame));
    [self addSubview:warningImageView];
    [warningImageView release];
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
