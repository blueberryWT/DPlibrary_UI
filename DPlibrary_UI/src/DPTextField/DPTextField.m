//
//  DPTextField.m
//  DPBeeClient
//
//  Created by doujingxuan on 13-2-26.
//
//

#import "DPTextField.h"

@implementation DPTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawPlaceholderInRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
   [[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0] setFill];
       
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:17.0f]];
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
