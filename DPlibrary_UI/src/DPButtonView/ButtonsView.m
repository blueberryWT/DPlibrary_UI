//
//  ButtonsView.m
//  PicDemo
//
//  Created by doujingxuan on 12-12-16.
//  Copyright (c) 2012年 XLHT Inc. All rights reserved.
//

#import "ButtonsView.h"
#import "UIView+UU.h"
#import "DPRenderImageView.h"
#import "Bee_Log.h"
#import "UIView+TapGesture.h"
#import "Bee_UILabel.h"
#import "UIColor+BeeExtension.h"


@implementation ButtonsView

@synthesize photoNumOfLine = _photoNumOfLine,heightOfPhoto = _heightOfPhoto,isEdit = _isEdit,widthOfPhoto= _widthOfPhoto,btnViewType = _btnViewType;
@synthesize dataArray = _dataArray;

-(id)init
{
    self = [super init];
    if (self) {
        _btnViewType = BUTTONVIEWTYPECOUNT;
    }
    return self;
}
- (void)dealloc
{
    [_dataArray release];
    [super dealloc];
}
/**Author:窦静轩 Description:计算照片墙的高度*/
-(CGFloat)calPhotoWallHeight:(NSUInteger)photoNumber
{
    _modPhotoNum = photoNumber % _photoNumOfLine;
    switch (_btnViewType) {
        case PHOTOWALLVIEW:{
            if (_maxPhotoNum == photoNumber) {
                _lineNumber = photoNumber / _photoNumOfLine;
            }
            _lineNumber =  (photoNumber / _photoNumOfLine) <= 0 ? 1 :+ photoNumber / (_photoNumOfLine) +1;
        }
            break;
        case TAGSWALLVIEW:
        case TAGGIFTSVIEW:{
            if (_modPhotoNum == 0) {
                _lineNumber = photoNumber / _photoNumOfLine;
            }
            else{
            _lineNumber =  (photoNumber / _photoNumOfLine) <= 0 ? 1 :+ photoNumber / (_photoNumOfLine) + 1;
            }
        }
            break;
        default:
            break;
    }
    BeeCC(@"_line is %d, photoNumber is %d,_photoNumOfLine is %d",_lineNumber,photoNumber,_photoNumOfLine);
    return (_lineNumber * (_heightOfPhoto +_heightForSepPhoto)) + _heightForSepPhoto;
}

/**Author:窦静轩 Description:初始化 要生成的照片*/
-(void)createPhotoWithPhotoNum:(NSUInteger)photoNumber
{
    NSLog(@"modPhotoNum is %d",_modPhotoNum);
    NSLog(@"photoNumber is %d",photoNumber);
    NSLog(@"_lineNumber is %d",_lineNumber);
    for (int j = 0; j < _lineNumber; j++) {
        for (int i = 0;i < _photoNumOfLine; i++) {
            /**Author:于同非 Description:更改需要点击的控件,由button改为DPCustomImageView*/
            DPRenderImageView *dpCustomImageView = [[[DPRenderImageView alloc] initWithFrame:CGRectZero withRenderImage:nil withCornerRadius:5] autorelease];
//            [dpCustomImageView setRoundedRect:YES];
            [dpCustomImageView setFrame:CGRectMake(_widthForSepPhoto+(i*(_widthForSepPhoto + _widthOfPhoto)),((_heightForSepPhoto+_heightOfPhoto)*(j+1)-_heightOfPhoto), _widthOfPhoto, _heightOfPhoto)];
            dpCustomImageView.tag = j * _photoNumOfLine  + BASEBUTTONTAG + i ;
            dpCustomImageView.userInteractionEnabled = _isEdit;
            int index = j * _photoNumOfLine  + i;
            if (index >= 0 && index < _dataArray.count) {
                NSString *path = [self getRenderImagePathWithIndex:(NSUInteger) index];
                UIImage *holdImage = [self getPlaceHoldWithIndex:(NSUInteger) index];
                NSString *title = [self getRenderTitleWithIndex:(NSUInteger) index];
                if ([path hasPrefix:@"http://"]) {
                    [dpCustomImageView GET:path useCache:YES placeHolder:holdImage];
                } else {
                    [dpCustomImageView setImage:[UIImage imageNamed:path]];
                }
                if(_btnViewType != TAGSWALLVIEW)
                    [dpCustomImageView makeTappable];
                if (title) {
                    BeeUILabel *label = [[[BeeUILabel alloc] initWithFrame:CGRectMake(0, 0, dpCustomImageView.width, dpCustomImageView.height)] autorelease];
                    [label setText:title];
                    [label setFont:[UIFont systemFontOfSize:13.0f]];
                    [label setTextColor:RGB(117, 117, 117)];
                    [dpCustomImageView addSubview:label];
                }
            }
            [self addSubview:dpCustomImageView];
        }
    }
}





/**Author:窦静轩 Description:初始化照片墙 photo*/
- (void)doInitWithPhotoNumbers:(NSMutableArray *)dataArray {

    /**Author:于同非 Description:重新接收数据*/
    [_dataArray release];
    _dataArray = [dataArray retain];
    NSUInteger photoNumber = [dataArray count];
    BeeCC(@"照片数量 =  %d", photoNumber);

    /**Author:于同非 Description:容错检测*/
    if (photoNumber == 0) {
        NSLog(@"不需要生产button");
        return;
    }

    if (photoNumber > _maxPhotoNum) {
        BeeCC(@"照片数量超过大数量，多余部分不处理");
//        _maxPhotoNum = photoNumber;
        photoNumber = _maxPhotoNum;
    }
    _widthForSepPhoto = (_photoWallWidth - _widthOfPhoto * _photoNumOfLine) / (_photoNumOfLine + 1);
    _photoWallHeight = [self calPhotoWallHeight:photoNumber];
    [self createPhotoWithPhotoNum:photoNumber];
    BeeCC(@"照片墙的高度 = %f", _photoWallHeight);
    self.frame = CGRectMake(0, 100, _photoWallWidth, _photoWallHeight);
    self.backgroundColor = [UIColor clearColor];
}
-(void)refleshDataWithPhotoNumber:(NSMutableArray *)dataArray {
    for (UIView *subView in self.subviews) {
        if (subView) {
            [subView removeFromSuperview];
        }
    }
    [self doInitWithPhotoNumbers:dataArray];
    BeeCC(@"height = %f",self.height);
}

-(NSString *) getRenderImagePathWithIndex:(NSUInteger) index {
    NSString *path = _dataArray[(NSUInteger )index];
    return path;
}

-(NSString *) getRenderTitleWithIndex:(NSUInteger) index {
    return nil;
}

- (UIImage *)getPlaceHoldWithIndex:(NSUInteger)index1 {
    return nil;
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
