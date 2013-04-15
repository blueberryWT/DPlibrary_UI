//
//  HSSimpleTableViewDataSource.m
//  uilib
//
//  Created by huishow on 4/5/12.
//  Copyright (c) 2012 Tsinghua. All rights reserved.
//

/**
 * @author  yuqiang
 *
 * table view datasource
 **/
#import "HSSimpleTableViewDataSource.h"

@implementation HSSimpleTableViewDataSource 

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        sectionArray = [[NSMutableArray alloc] init];
        sectionCellArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void) dealloc {
	[sectionArray release];
	[sectionCellArray release];
    
	[super dealloc];
}

- (NSUInteger) addSection:(NSString*) sectionTitle; {
    NSUInteger index = [sectionArray count];
    [sectionArray insertObject:sectionTitle atIndex:index];
    
    [sectionCellArray insertObject:[[[NSMutableArray alloc] init] autorelease] atIndex:index];
    
    return index;
}


- (BOOL) addCellForSection:(NSUInteger) sectionIndex cell:(UITableViewCell*) cell{
    
    if (sectionIndex >= [sectionArray count]) {
        return NO;
    }
    
    if (sectionIndex >= [sectionCellArray count]) {
        return NO;
    }
    
    NSMutableArray* cellArray = [sectionCellArray objectAtIndex:sectionIndex];
    [cellArray addObject:cell];
    
    return YES;
}

- (NSUInteger) cellCountOfSection:(NSUInteger) sectionIndex {
    if (sectionIndex >= [sectionArray count]) {
        return 0;
    }
    
    NSMutableArray* cellArray = [sectionCellArray objectAtIndex:sectionIndex];
    
    return [cellArray count];
}

- (void) removeCellFromSection:(NSUInteger) sectionIndex cellIndex:(NSUInteger) cellIndex {
    
    if (sectionIndex >= [sectionArray count]) {
        return ;
    }
    
    NSMutableArray* cellArray = [sectionCellArray objectAtIndex:sectionIndex];
    
    [cellArray removeObjectAtIndex:cellIndex];
}

- (void) removeCellFromSection:(NSUInteger) sectionIndex cell:(id) cell {
    if (sectionIndex >= [sectionArray count]) {
        return ;
    }
    
    NSMutableArray* cellArray = [sectionCellArray objectAtIndex:sectionIndex];
    
    [cellArray removeObject:cell];
}

// deal with sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionArray count];
}

//- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return sectionArray;
//}

-(UITableViewCell*) getCell:(NSInteger) section row:(NSInteger) row {
    
    if (section >= [sectionCellArray count]) {
        return nil;
    }
    
    NSMutableArray* cellArray = [sectionCellArray objectAtIndex:section];
    
    if (row >= [cellArray count]) {
        return nil;
    }
    
    return [cellArray objectAtIndex:row];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section >= [sectionArray count]) {
        return @"InvalidSection";
    }
    
    return [sectionArray objectAtIndex:section];
}

// deal with table cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section >= [sectionCellArray count]) {
        return 0;
    }
    
    NSMutableArray* cellArray = [sectionCellArray objectAtIndex:section];
    
    return [cellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger sectionIndex = [indexPath section];
    NSUInteger cellIndex = [indexPath row];
    
    if (sectionIndex >= [sectionCellArray count]) {
        return nil;
    }
    
    NSMutableArray* cellArray = [sectionCellArray objectAtIndex:sectionIndex];
    
    if (cellIndex >= [cellArray count]) {
        return nil;
    }

    return [cellArray objectAtIndex:cellIndex];
}

- (void) resetData {
    [sectionArray release];
    [sectionCellArray release];
    
    sectionArray = [[NSMutableArray alloc] init];
    sectionCellArray = [[NSMutableArray alloc] init];
}

- (void) resetSectionCellArray:(NSUInteger) sectionIndex {
    if (sectionIndex >= [sectionCellArray count]) {
        return ;
    }
    
    NSMutableArray* cellArray = [sectionCellArray objectAtIndex:sectionIndex];
    [cellArray removeAllObjects];
}


@end
