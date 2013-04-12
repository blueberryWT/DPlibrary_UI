//
// Created by apple on 13-3-5.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Bee_UISignal.h"

@class CSColorizedProgressView;
@class BeeUIZoomView;
@class BeeUIButton;


@interface DPBeeFullScreenImageView : UIView


@property(nonatomic, retain) NSDictionary *requestURL;
@property(nonatomic, retain) UIImage *placeHold;
@property(nonatomic, retain) CSColorizedProgressView *colorizedProgressView;

@property(nonatomic) BOOL isLoading;

@property(nonatomic, retain) BeeUIZoomView *zoomView;

@property(nonatomic, retain) UIImageView *dpImageView;


@property(nonatomic, retain) UIImage *dpSourceImage;

@property (nonatomic, retain) BeeUIButton *beeUIButton;

-(id)initWithFrame:(CGRect)frame withImageURL:(NSDictionary *) imageUrl withPlaceImage:(UIImage *) holdImage;

AS_SIGNAL(HIDDEN_IMAGE_SIGNAL)
AS_SIGNAL(HIDDEN_HELP_SIGNAL)
@end