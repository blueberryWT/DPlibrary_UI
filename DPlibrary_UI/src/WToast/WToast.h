/**
 * @class WToast
 */

typedef enum {
	kWTShort = 1,
	kWTLong = 5
} WToastLength;

@interface WToast : UIView

+ (void)showWithText:(NSString *)text;
+ (void)showWithImage:(UIImage *)image;

+ (void)showWithText:(NSString *)text length:(WToastLength)length;
+ (void)showWithImage:(UIImage *)image length:(WToastLength)length;

@end
