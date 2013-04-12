//
// Created by apple on 13-3-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class BeeUIActivityIndicatorView;


@interface DPRenderImageView : UIView

@property(nonatomic, retain) UIImage *renderImage;
@property(nonatomic) BOOL loading;
@property(nonatomic, copy) NSString *loadedURL;
@property(nonatomic) BOOL loaded;
@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic, retain) BeeUIActivityIndicatorView *indicator;

-(id) init;
-(id)initWithFrame:(CGRect)frame;
-(id) initWithFrame:(CGRect) frame withRenderImage:(UIImage *)renderImageValue withCornerRadius:(CGFloat) cornerRadius;

- (void)GET:(NSString *)string useCache:(BOOL)useCache;
- (void)GET:(NSString *)string useCache:(BOOL)useCache placeHolder:(UIImage *)defaultImage;

- (void)setImage:(UIImage *)image;
@end