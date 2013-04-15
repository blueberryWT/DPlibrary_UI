//
//  HSSimpleTableViewDataSource.h
//  uilib
//
//  Created by huishow on 4/5/12.
//  Copyright (c) 2012 Tsinghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSSimpleTableViewDataSource : NSObject<UITableViewDataSource> {
    
@private
    // array of NSString to contain section names
    NSMutableArray* sectionArray;
    
    // array of NSMutableArray<NSMutableArray*>  which contains each cell for each section
    NSMutableArray* sectionCellArray;
    
}

// add a section title
- (NSUInteger) addSection:(NSString*) sectionTitle;

// add a table cell for section
- (BOOL) addCellForSection:(NSUInteger) sectionIndex cell:(UITableViewCell*) cell;

- (NSUInteger) cellCountOfSection:(NSUInteger) sectionIndex;

- (void) removeCellFromSection:(NSUInteger) sectionIndex cellIndex:(NSUInteger) cellIndex;

- (void) removeCellFromSection:(NSUInteger) sectionIndex cell:(id) cell;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
//- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(UITableViewCell*) getCell:(NSInteger) section row:(NSInteger) row ;

- (void) resetData;

- (void) resetSectionCellArray:(NSUInteger) sectionIndex;

@end
