//
// Created by apple on 13-4-12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ListCell.h"
#import "Bee_UILabel.h"
#import "UIView+UU.h"
#import "UIColor+BeeExtension.h"


@implementation ListCell


-(void)load {
    [super load];
    if (!_lblName) {
        _lblName = [[BeeUILabel alloc] init];
        [_lblName setFont:[UIFont systemFontOfSize:16.0f]];
        [_lblName setTextColor:[UIColor blackColor]];
        [self addSubview:_lblName];
    }

    if (!_lblSpace) {
        _lblSpace = [[UILabel alloc] init];
        [_lblSpace setBackgroundColor:RGB(228, 228, 228)];
        [self addSubview:_lblSpace];
    }
}


-(void)bindData:(NSObject *)data {
    if (nil != data && [data isKindOfClass:[NSString class]]) {
        [_lblName setText:(NSString *) data];
    }

    [super bindData:data];
}

+(CGSize)cellSize:(NSObject *)data bound:(CGSize)bound {
    return CGSizeMake(320, 44);
}


-(void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound {
    [self.lblName sizeToFit];
    [_lblName setFrame:CGRectMake(20, (44 - self.lblName.height) / 2, self.lblName.width, self.lblName.height)];

    [_lblSpace setFrame:CGRectMake(1, 43, 320 - 2, 1)];
}

- (void)dealloc {
    [_lblName release];
    [_lblSpace release];
    [super dealloc];
}
@end