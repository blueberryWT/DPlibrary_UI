//
//  GifsWallView.m
//  PicDemo
//
//  Created by doujingxuan on 12-12-17.
//  Copyright (c) 2012年 XLHT Inc. All rights reserved.
//

#import "GifsWallView.h"
#import "UIView+UU.h"
#import "UIView+TapGesture.h"
#import "UIColor+BeeExtension.h"

@implementation GifsWallView
@synthesize labelFooter = _labelFooter;


-(id)init
{
    self = [super init];
    if (self) {
        _maxPhotoNum = 4;
        _btnViewType = TAGSWALLVIEW;
    }
    return self;
}

- (void)setClickTapEvent:(void (^)(id))block {
    if (block_clickTapEvent) {
        [block_clickTapEvent release];
    }
    block_clickTapEvent = [block copy];
}

- (void)dealloc
{
    [_labelFooter release];
    [block_clickTapEvent release];
    [super dealloc];
}

-(void)createSingleAddButton
{
    self.userInteractionEnabled = YES;
    UIImage *imageNoGifts = [UIImage imageNamed:@"UserInfo_NoGifts.png"];
    self.frame = CGRectMake(0, 0, 320, imageNoGifts.size.height + 15);
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(110, 8, imageNoGifts.size.width, imageNoGifts.size.height)];
    [button setImage:imageNoGifts forState:UIControlStateNormal];
    [self addSubview:button];
    [button setCenterX:self.width / 2];
    [button release];

    if(_labelFooter)
    {
        [_labelFooter release];
        _labelFooter = nil;
    }
    if (!_labelFooter) {
        _labelFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, button.bottom + 2, 0, 0)];
        [_labelFooter setBackgroundColor:[UIColor clearColor]];
        [_labelFooter setFont:[UIFont systemFontOfSize:15.0f]];
        [_labelFooter setText:@"还没有朋友给您送礼物"];
        [_labelFooter sizeToFit];
        [_labelFooter setTextColor:RGB(99, 99, 99)];
        [_labelFooter setCenterX:self.centerX];
        [self addSubview:_labelFooter];
    }
    [self setFrame:CGRectMake(0, 0, self.width, _labelFooter.bottom + 10)];
}

-(void)doInitWithPhotoNumbers:(NSMutableArray *)dataArray
{
    [super doInitWithPhotoNumbers:dataArray];
    if (dataArray.count <= 0) {
        [self createSingleAddButton];
        return;
    }
}
-(void)createPhotoWithPhotoNum:(NSUInteger)photoNumber
{
    [super createPhotoWithPhotoNum:photoNumber];
    if (_modPhotoNum == 0) {
        return;
    }
    else{
        for (int h = _modPhotoNum; h < _photoNumOfLine;h++) {
            NSLog(@"_lineNumber is %d",_lineNumber);
            int tag = (_lineNumber-1) * _photoNumOfLine  + h + BASEBUTTONTAG;
            UIButton *  button = (UIButton*)[self viewWithTag:tag];
            NSLog(@"button.tag is %d",button.tag);
            [button removeFromSuperview];
        }
    }
}

-(UIImage *)getPlaceHoldWithIndex:(NSUInteger)index {
    return [UIImage imageNamed:@"UserInfo_NoGifts.png"];
}

-(NSString *)getRenderImagePathWithIndex:(NSUInteger)index {
    id element = [self.dataArray objectAtIndex:index];
    if (element && [element isKindOfClass:[NSDictionary class]]) {
        NSString *imageAddr = ((NSDictionary *) element)[@"image_addr"];
        return imageAddr;
    }
    return @"";
}

-(void)handleUISignal:(BeeUISignal *)signal {
    if ([signal is:[UIView TAPPED]]) {
        // [yu] 这个方法是为了能够给礼物点击添加一个标识，可以表标明类型
        signal.object = @"giftsType";
    }
    [super handleUISignal:signal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
