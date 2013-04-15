//
//  HSBaseTableViewDelegate.h
//  uilib
//
//  Created by huishow on 4/5/12.
//  Copyright (c) 2012 Tsinghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBaseTableViewDelegate : NSObject<UITableViewDelegate>{
    
@protected  id<UITableViewDataSource> _dataSource;
@protected  UIViewController* _viewController;
    
}

@property(nonatomic, readonly) id<UITableViewDataSource> dataSource;

- (id)initWithParam: (UIViewController*) viewController  dataSource:(id<UITableViewDataSource>) dataSource;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void) viewWillAppear;

@end
