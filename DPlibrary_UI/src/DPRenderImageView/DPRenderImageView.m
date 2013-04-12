//
// Created by apple on 13-3-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPRenderImageView.h"


@interface DPRenderImageView(Private)
-(void) initSelfData;
@end

@implementation DPRenderImageView



#pragma mark => 私有方法
- (void)initSelfData {
    _loading = NO;
    self.backgroundColor = [UIColor clearColor]; // 设置背景色
}


#pragma mark => 析构函数
- (void)dealloc {

    [self cancelRequests];
    self.loading = NO;
    SAFE_RELEASE_SUBVIEW( _indicator );
    [_renderImage release], _renderImage = nil;
    [_loadedURL release], _loadedURL = nil;
    [super dealloc];
}


#pragma mark => 初始化函数

- (id)init {
    self = [self initWithFrame:CGRectZero withRenderImage:nil withCornerRadius:0];
    if (self) {

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame withRenderImage:nil withCornerRadius:0];
    if (self) {

    }
    return self;
}


-(id) initWithFrame:(CGRect) frame withRenderImage:(UIImage *)renderImageValue withCornerRadius:(CGFloat) cornerRadius {
    self = [super initWithFrame:frame];
    if (self) {
        if(renderImageValue)
            self.renderImage = renderImageValue;
        self.cornerRadius = cornerRadius;
        // 初始化数据
        [self initSelfData];
    }
    return self;
}

- (void)GET:(NSString *)string useCache:(BOOL)useCache
{
    [self GET:string useCache:useCache placeHolder:nil];
}


- (void)GET:(NSString *)string useCache:(BOOL)useCache placeHolder:(UIImage *)defaultImage
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    if ( nil == string || 0 == string.length )
        return;

    if ( [string isEqualToString:self.loadedURL] )
        return;

    if ( [self requestingURL:string] )
        return;

    [self cancelRequests];

    self.loading = NO;
    self.loadedURL = string;
    self.loaded		= NO;

    PERF_ENTER

    if ( useCache && [[BeeImageCache sharedInstance] hasCachedForURL:string] )
    {
        PERF_ENTER_(1)
        UIImage * image = [[BeeImageCache sharedInstance] imageForURL:string];
        PERF_LEAVE_(1)

        if ( image )
        {
            PERF_ENTER_(2)
            [self changeImage:image];
            PERF_LEAVE_(2)

            PERF_ENTER_(3)
            self.loaded = YES;
            PERF_LEAVE_(3)

            PERF_LEAVE
            return;
        }
    }

    PERF_ENTER_(4)
    [self changeImage:defaultImage];
    PERF_ENTER_(4)

    PERF_ENTER_(5)
    [self cancelRequests];
    PERF_ENTER_(5)

    [self GET:string];

    PERF_LEAVE
}

- (BeeUIActivityIndicatorView *)indicator
{
    if ( nil == _indicator )
    {
        CGRect indicatorFrame;
        indicatorFrame.size.width = 20.0f;
        indicatorFrame.size.height = 20.0f;
        indicatorFrame.origin.x = (self.frame.size.width - indicatorFrame.size.width) / 2.0f;
        indicatorFrame.origin.y = (self.frame.size.height - indicatorFrame.size.height) / 2.0f;

        _indicator = [[BeeUIActivityIndicatorView alloc] initWithFrame:indicatorFrame];
        _indicator.backgroundColor = [UIColor clearColor];
        [self addSubview:_indicator];
    }

    return _indicator;
}

#pragma -
#pragma NetworkRequestDelegate

- (void)handleRequest:(BeeRequest *)request
{
//    BeeCC(@"downloadPercent = %f", request.downloadPercent);
    if ( request.sending ) {
        [request setShowAccurateProgress:YES];
        [_indicator startAnimating];

        [self setLoading:YES];
        [self sendUISignal:BeeUIImageView.LOAD_START];
    }
    else if ( request.sendProgressed )
    {
    }
    else if ( request.recving )
    {
        BeeCC(@"downloadPercent = %f", request.downloadPercent);
        BeeCC(@"downloadByte = %f",request.downloadBytes / 1024.f);
    }
    else if ( request.recvProgressed ) {

    }
    else if ( request.succeed )
    {
        [_indicator stopAnimating];

        NSData * data = [request responseData];
        if ( data )
        {
            UIImage * image = [UIImage imageWithData:data];
            if ( image )
            {
                [self changeImage:image];
            }

            NSString * string = [request.url absoluteString];
            [[BeeImageCache sharedInstance] saveImage:image forURL:string];
            [[BeeImageCache sharedInstance] saveData:data forURL:string];

            [self setLoading:NO];
            self.loaded = YES;
            [self sendUISignal:BeeUIImageView.LOAD_COMPLETED];
        }
        else
        {
            [self setLoading:NO];
            self.loaded = NO;
            [self sendUISignal:BeeUIImageView.LOAD_FAILED];
        }
        // [yu] 这里执行一个切换动画的通知
        [self sendUISignal:[BeeUIImageView CHANGE_IMAGE] withObject:self];
    }
    else if ( request.failed )
    {
        [_indicator stopAnimating];

        [self setLoading:NO];
        self.loaded = NO;
        [self sendUISignal:BeeUIImageView.LOAD_FAILED];
    }
    else if ( request.cancelled )
    {
        [_indicator stopAnimating];

        [self setLoading:NO];
        [self sendUISignal:BeeUIImageView.LOAD_CANCELLED];
    }
}


- (void)setUrl:(NSString *)string
{
    [self GET:string useCache:YES];
}

- (void)setFile:(NSString *)path
{
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    if ( image )
    {
        [self changeImage:image];
    }
}

- (void)setImage:(UIImage *)image {
    [self changeImage:image];
}

- (void)changeImage:(UIImage *)image
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    if ( nil == image )
    {
        [self cancelRequests];

        self.loadedURL = nil;
        self.loading = NO;

        self.renderImage = image;
        [super setNeedsDisplay];
        return;
    }

    if ( image != self.renderImage )
    {
        [self cancelRequests];

        CGAffineTransform transform = CGAffineTransformIdentity;
        UIImageOrientation orientation = image.imageOrientation;
        switch ( orientation )
        {
            case UIImageOrientationDown:           // EXIF = 3
            case UIImageOrientationDownMirrored:   // EXIF = 4
                transform = CGAffineTransformRotate(transform, M_PI);
                break;

            case UIImageOrientationLeft:           // EXIF = 6
            case UIImageOrientationLeftMirrored:   // EXIF = 5
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;

            case UIImageOrientationRight:          // EXIF = 8
            case UIImageOrientationRightMirrored:  // EXIF = 7
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                break;
        }
        self.transform = transform;
        self.renderImage = image;
    }
    [self setNeedsDisplay];
}




// 渲染的部分
-(void)drawRect:(CGRect)rect {
    // 获取绘制的句柄
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 确定绘制的矩形
    CGRect boxRect = self.bounds;

    // 绘制圆角
    if(self.cornerRadius > 0) {
        CGFloat radius = self.cornerRadius;
        // 路径开始
        CGContextBeginPath(context);
        // 填充色：灰度0.0，透明度:0.1
//        CGContextSetGrayFillColor(context, 0.0f, 0.25);
        CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
        // 画笔移动到左上角的圆弧处
        CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
        // 开始绘制右上角圆弧：圆心x坐标，圆心y坐标，起始角，终止角，方向为顺时针
        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float) M_PI / 2, 0, 0);
        // 开始绘制右下角圆弧
        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float) M_PI / 2, 0);
        // 开始绘制左下角圆弧
        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float) M_PI / 2, (float) M_PI, 0);
        // 开始绘制左上角圆弧
        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float) M_PI, 3 * (float) M_PI / 2, 0);
//        CGContextFillPath(context);
        CGContextClosePath(context);// 关闭路径
        CGContextClip(context);
    }
    /**Author:于同非 Description:渲染图片*/
    CGImageRef image = CGImageRetain(self.renderImage.CGImage);
    drawImageToContent(context, image, CGRectMake(boxRect.origin.x, boxRect.origin.y, boxRect.size.width, boxRect.size.height));
    CGImageRelease(image);
}

@end