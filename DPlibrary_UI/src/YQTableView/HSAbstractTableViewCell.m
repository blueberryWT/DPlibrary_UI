//
//  HSAbstractTableViewCell.m
//  uilib
//
//  Created by huishow on 4/5/12.
//  Copyright (c) 2012 Tsinghua. All rights reserved.
//

#import "HSAbstractTableViewCell.h"

@implementation HSAbstractTableViewCell

@synthesize heightOfCell = _heightOfCell;
@synthesize privateObject = _privateObject;

- (id) init {
    self = [super init];
    if (self) {
        self.heightOfCell = 44.0;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.heightOfCell = 44.0;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.heightOfCell = 44.0;
    }
    return self;
}

- (void) dealloc {
    [_privateObject release];
    [super dealloc];
}

- (NSNumber*) calcHeightOfCell {
    return [NSNumber numberWithFloat:self.heightOfCell];
}

-(void) viewWillAppear {
    
}

-(void)setHeightOfCell:(CGFloat)heightOfCell{
    if (heightOfCell != _heightOfCell) {
        _heightOfCell = heightOfCell;
    }
}


@end
