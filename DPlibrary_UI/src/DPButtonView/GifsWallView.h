//
//  GifsWallView.h
//  PicDemo
//
//  Created by doujingxuan on 12-12-17.
//  Copyright (c) 2012年 XLHT Inc. All rights reserved.
//

#import "ButtonsView.h"

@interface GifsWallView : ButtonsView
{
    UILabel *_labelFooter;

    void(^block_clickTapEvent)(id);
}
@property(nonatomic, retain) UILabel *labelFooter;

-(void) setClickTapEvent:(void(^)(id)) block;

@end
