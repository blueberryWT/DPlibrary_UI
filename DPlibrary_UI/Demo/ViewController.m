//
//  ViewController.m
//  DPlibrary_UI
//
//  Created by apple on 13-4-12.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ListCell.h"
#import "DPAlertInput.h"

@interface ViewController ()

@end

@implementation ViewController


-(id) init {
    self = [super init];
    if (self) {


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) handleBeeUITableBoard:(BeeUISignal *) signal {
    [super handleUISignal:signal];
    if ([signal is:[BeeUITableBoard CREATE_VIEWS]]) {
        [self.view setBackgroundColor:[UIColor grayColor]];
    } else if ([signal is:[BeeUITableBoard LOAD_DATAS]]) {
        if (nil == _models) {
            _models = [[NSMutableArray alloc] init];
        }
        [_models addObject:@"DPInputAlert"];
        [self reloadData];
    } else if ([signal is:[BeeUITableBoard WILL_APPEAR]]) {
        [self reloadData];
    }
}


#pragma mark => tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeeUITableViewCell *cell = [self dequeueWithContentClass:[ListCell class]];
    if (cell) {

        NSString *data = self.models[(NSUInteger) indexPath.row];
        if (data) {
            [cell bindData:data];
        }
        return cell;
    }

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DPAlertInput *alertInput = [[[DPAlertInput alloc] initWithTitle:@"提醒输入" withInitText:@"" withPlaceHoldText:@"请输入内容" withMaxLength:6] autorelease];
        [alertInput show];
    }
}

- (void)dealloc {
    [_models release];
    [super dealloc];
}

@end
