//
// Created by apple on 13-4-12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Bee_UIGridCell.h"

@class BeeUILabel;


@interface ListCell : BeeUIGridCell


@property(nonatomic, retain) BeeUILabel *lblName;
@property(nonatomic, retain) UILabel *lblSpace;
@end