//
//  HSBaseTableViewDelegate.m
//  uilib
//
//  Created by huishow on 4/5/12.
//  Copyright (c) 2012 Tsinghua. All rights reserved.
//

#import "HSBaseTableViewDelegate.h"
#import "HSSimpleTableViewDataSource.h"

@implementation HSBaseTableViewDelegate

@synthesize dataSource = _dataSource;

- (id)initWithParam: (UIViewController*) viewController  dataSource:(id<UITableViewDataSource>) dataSource;
{
    self = [super init];
    if (self) {
        _viewController = viewController;
        _dataSource = dataSource;
    }
    
    return self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (nil != _dataSource) {
        id tmpCell = [_dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        
        if ([tmpCell respondsToSelector:@selector(calcHeightOfCell)]) {
            NSNumber* height = [tmpCell performSelector:@selector(calcHeightOfCell)];
            //NSLog(@" %d ====== cell height ===== %d",indexPath.row,[height intValue]);
            return [height floatValue];
        }
    }
    
    return (CGFloat)44.0;
}


-(void) viewWillAppear {
    
    if (![_dataSource isKindOfClass:[HSSimpleTableViewDataSource class]]) {
        return;
    }
    
    NSInteger sectionCount = [_dataSource numberOfSectionsInTableView:nil];
    
    for (NSInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
        NSInteger rowCount = [_dataSource tableView:nil numberOfRowsInSection:sectionIndex];
        for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
            UITableViewCell* cell = [(HSSimpleTableViewDataSource*)_dataSource getCell:sectionIndex row:rowIndex];
            
            if ([cell respondsToSelector:@selector(viewWillAppear)]) {
                [cell performSelector:@selector(viewWillAppear)];
            }
        }
    }
    
}

@end
