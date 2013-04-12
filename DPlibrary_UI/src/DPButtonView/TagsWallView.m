//
//  TagsWallView.m
//  PicDemo
//
//  Created by doujingxuan on 12-12-17.
//  Copyright (c) 2012年 XLHT Inc. All rights reserved.
//

#import "TagsWallView.h"
#import "UIView+UU.h"
#import "UIColor+BeeExtension.h"

@implementation TagsWallView
@synthesize labelFooter = _labelFooter;
@synthesize isEmptyShow = _isEmptyShow;


-(id)init
{
    self = [super init];
    if (self) {
        _maxPhotoNum = 20;
        _btnViewType = TAGSWALLVIEW;
    }
    return self;
}
- (void)dealloc
{
    [_labelFooter release];
    [super dealloc];
}
-(void)createSingleAddButton
{
    if (!self.isEmptyShow) {
        [self setFrame:CGRectMake(0, 0, 0, 0)];
        return;
    }
    self.userInteractionEnabled = YES;
    UIImage *imageNoGifts = [UIImage imageNamed:@"UserInfo_NoLabel.png"];
    self.frame = CGRectMake(0, 0, 320, imageNoGifts.size.height + 15);
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(110, 10, imageNoGifts.size.width, imageNoGifts.size.height)];
    [button setImage:imageNoGifts forState:UIControlStateNormal];
    [self addSubview:button];
    [button setCenterX:self.width / 2];
    [button release];

    // [yu] 先创建脚页码
    if (_labelFooter) {
        [_labelFooter release];
        _labelFooter = nil;
    }

    // [yu] 创建脚标签
    if (!_labelFooter) {
        _labelFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, button.bottom + 2, 0, 0)];
        [_labelFooter setBackgroundColor:[UIColor clearColor]];
        [_labelFooter setFont:[UIFont systemFontOfSize:15.0f]];
        [_labelFooter setText:@"您还没有添加兴趣标签"];
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

-(NSString *)getRenderTitleWithIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%@  ", _dataArray[index]];
}
-(NSString *)getRenderImagePathWithIndex:(NSUInteger)index {
    return @"UserInfo_LabelNor@2x.png";
}
@end
