//
//  HSAbstractTableViewCell.h
//  uilib
//
//  Created by huishow on 4/5/12.
//  Copyright (c) 2012 Tsinghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAbstractTableViewCell : UITableViewCell {

@private CGFloat _heightOfCell ;
@private NSObject* _privateObject;
    
}

// Cell should maintain its own height
@property(nonatomic, assign,setter = setHeightOfCell:)CGFloat heightOfCell;

// for developer to keep some private information for future use
@property(nonatomic, retain) NSObject* privateObject;

- (NSNumber*) calcHeightOfCell;

-(void) viewWillAppear;
@end
