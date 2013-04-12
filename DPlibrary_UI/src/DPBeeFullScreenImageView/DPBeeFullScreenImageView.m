//
// Created by apple on 13-3-5.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPBeeFullScreenImageView.h"
#import "CSColorizedProgressView.h"
#import "UIView+UU.h"
#import "UIView+TapGesture.h"
#import "UIView+SwipeGesture.h"
#import "Bee_UIZoomView.h"
#import "Bee_UIButton.h"
#import "UIColor+BeeExtension.h"
#import "UIImage+BeeExtension.h"
#import "NSString+BeeExtension.h"
#import "Bee_UIImageView.h"
#import "Bee_Log.h"
#import "NSObject+BeeNotification.h"

@interface DPBeeFullScreenImageView(Private)
-(void) initSelfControls;

-(void) showBigAnimation;
@end

@implementation DPBeeFullScreenImageView

DEF_SIGNAL(HIDDEN_IMAGE_SIGNAL)
DEF_SIGNAL(HIDDEN_HELP_SIGNAL)

- (id)initWithFrame:(CGRect)frame withImageURL:(NSDictionary *)imageUrl withPlaceImage:(UIImage *)holdImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.requestURL = imageUrl;
        self.placeHold = holdImage;
        [self initSelfControls];
        [self.superview setUserInteractionEnabled:NO];
    }
    return self;
}

- (void)initSelfControls {
    if (nil == _colorizedProgressView) {
        _colorizedProgressView = [[CSColorizedProgressView alloc] initWithFrame:CGRectMake(0, 0, self.placeHold.size.width, self.placeHold.size.height)];
        [_colorizedProgressView setImage:self.placeHold];

        [self addSubview:_colorizedProgressView];
        [_colorizedProgressView setCenterX:self.width / 2];
        [_colorizedProgressView setCenterY:self.height / 2];

        __block DPBeeFullScreenImageView *bSelf = self;
        _colorizedProgressView.completionBlock = ^(CGFloat completedProgress) {
            if (completedProgress >= 1.0) {
                // 做一个动画
                [bSelf showBigAnimation];
            }
        };
    }

    if (nil == _dpImageView) {
        _dpImageView = [[UIImageView alloc] init];
        [_dpImageView setBackgroundColor:[UIColor clearColor]];
        [_dpImageView makeTappable:[DPBeeFullScreenImageView HIDDEN_IMAGE_SIGNAL]];
        [_dpImageView setContentMode:UIViewContentModeScaleAspectFit];
    }

    if (nil == _zoomView) {
        _zoomView = [[BeeUIZoomView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _zoomView.backgroundColor = RGBA(0, 0, 0, 0.4f);
        [_zoomView setContent:_dpImageView animated:NO];
        [_zoomView setSwipeEnabled:YES];
        [_zoomView setSwipeDirection:UISwipeGestureRecognizerDirectionDown]; // 监听向下滑动的事件
        [self addSubview:_zoomView];
    }

    [_dpImageView setFrame:_colorizedProgressView.frame];

    BOOL showHelp = [[NSUserDefaults standardUserDefaults] boolForKey:@"helpSaveImage"];
    if (NO == showHelp) {
        _beeUIButton = [[BeeUIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_beeUIButton setBackgroundColor:RGBA(0, 0, 0, 0.7)];
        [_beeUIButton addSignal:[DPBeeFullScreenImageView HIDDEN_HELP_SIGNAL] forControlEvents:UIControlEventTouchUpInside];
        [_beeUIButton setImage:__IMAGE_FILE(@"saveHelp", @"png") forState:UIControlStateNormal];
        [self addSubview:_beeUIButton];
    }


    if (nil != self.requestURL) {
        NSString *localPath = self.requestURL[@"messageImageLocationPath"];
        NSString *netUrlPath = self.requestURL[@"msgResc"];
        UIImage *cacheImage = nil;
        if (nil != localPath && [localPath notEmpty]) {
            cacheImage = [[BeeImageCache sharedInstance] imageForURL:localPath];
        }

        if (nil == cacheImage && nil != netUrlPath && [netUrlPath notEmpty]) {
            cacheImage = [[BeeImageCache sharedInstance] imageForURL:netUrlPath];
        }

        if (cacheImage) {
            self.dpSourceImage = cacheImage;
            [self.colorizedProgressView setProgress:1.0f animated:NO];
            [self showBigAnimation];
            return;
        }


        if (nil == cacheImage && nil != netUrlPath && [netUrlPath notEmpty]) {
            [self GET:netUrlPath];
        }
    }

}

- (void)showBigAnimation {
    __block DPBeeFullScreenImageView *bSelf = self;
    [bSelf.dpImageView setImage:bSelf.dpSourceImage];
    [UIView animateWithDuration:0.5 animations:^() {
        [bSelf.dpImageView setFrame:CGRectMake(0, (bSelf.height - bSelf.dpSourceImage.size.height) / 2, bSelf.width, bSelf.dpSourceImage.size.height)];
        [bSelf.zoomView setContentSize:bSelf.dpSourceImage.size];
    } completion:^(BOOL b){
        [bSelf.zoomView layoutContent];
        [bSelf.colorizedProgressView setHidden:YES];
    }];
}


-(void)handleRequest:(BeeRequest *)request {
    if (request.sending) {
        _isLoading = YES;
        [request setShowAccurateProgress:YES];

    }else if (request.succeed) {
        NSData * data = [request responseData];
        if ( data )
        {
            UIImage * image = [UIImage imageWithData:data];
            if ( image ) {
                self.dpSourceImage = image;
            }
            NSString * string = [request.url absoluteString];
            [[BeeImageCache sharedInstance] saveImage:image forURL:string];
            [self setIsLoading:NO];
        }
        else
        {
            [self setIsLoading:NO];
        }
    }else if (request.failed) {

    }else if (request.cancelled) {

    }else if ( request.recving ) {
        // 在这里更新进度
        [self.colorizedProgressView setProgress:request.downloadPercent animated:YES];
        BeeCC(@"ccc = %f",request.downloadPercent);
    }
    else if ( request.recvProgressed ) {

    }
}


-(void)handleUISignal:(BeeUISignal *)signal {
    if ([signal is:[DPBeeFullScreenImageView HIDDEN_IMAGE_SIGNAL]]) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^() {
            [self setAlpha:0];
        } completion:^(BOOL b){
            [self.superview setUserInteractionEnabled:YES];
            [self removeFromSuperview];
        }];


    }else if ([signal is:[UIView SWIPE_DOWN]]) {
//        [DPTools showHudWithMessage:@"<tip>  保存中..."];
////        UIImageWriteToSavedPhotosAlbum(self.dpSourceImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        [DPTools saveImageToDuoPengAlbum:self.dpSourceImage WithShowSaveTip:YES];

        [self postNotification:@"savingImage" withObject:self.dpSourceImage];

    }else if ([signal is:[DPBeeFullScreenImageView HIDDEN_HELP_SIGNAL]]) {
        [_beeUIButton removeFromSuperview]; // 从父视图中删除
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"helpSaveImage"]; // 将标识保存到磁盘中
        [[NSUserDefaults standardUserDefaults] synchronize]; // 即时同步
    }
}

// 存储相册到本地的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
//    // Was there an error?
//    if (error != NULL) {
//        // Show error message...
//        [DPTools dpShowErrorHUDText:@"<tip>  保存失败  "];
//    }
//    else  // No errors
//    {
//        // Show message image successfully saved
//        [DPTools dpShowSuccessHUDText:@"<tip>  保存成功  "];
//    }
}

- (void)dealloc {
    [_requestURL release], _requestURL = nil;
    [_placeHold release], _placeHold = nil;
    [_colorizedProgressView release], _colorizedProgressView = nil;
    [_zoomView release], _zoomView = nil;
    [_dpImageView release], _dpImageView = nil;
    [_dpSourceImage release], _dpSourceImage = nil;
    [_beeUIButton release], _beeUIButton = nil;
    [super dealloc];
}
@end