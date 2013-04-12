//
//  TagsWallView.h
//  PicDemo
//
//  Created by doujingxuan on 12-12-17.
//  Copyright (c) 2012年 XLHT Inc. All rights reserved.
//

#import "ButtonsView.h"

@interface TagsWallView : ButtonsView
{
    UILabel* _labelFooter;

    /** [yu]
    * 这个变量功能是在没有数据时候，是否显示placehold的图片
    * 在个人信息的时候，要显示一个placehold图片
    * 在查看其他人信息的时候，不需要显示
    */
    BOOL  _isEmptyShow;
}
@property(nonatomic, retain) UILabel *labelFooter;
@property(nonatomic) BOOL isEmptyShow;


@end
