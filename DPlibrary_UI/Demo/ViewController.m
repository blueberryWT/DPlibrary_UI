//
//  ViewController.m
//  DPlibrary_UI
//
//  Created by apple on 13-4-12.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "ViewController.h"
#import "ListCell.h"
#import "DPAlertInput.h"
#import "QuadCurveMenuItem.h"
#import "QuadCurveMenu.h"

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
        [_models addObject:@"AWESomeMenu"];
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
    }else if (indexPath.row == 1) {
        UIImage *storyMenuItemImage = [UIImage imageNamed:@"iconBGMenuItemNor.png"];
        UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"iconBGMenuItemSelected.png"];
        QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                   highlightedImage:storyMenuItemImagePressed
                                                                       ContentImage:[UIImage imageNamed:@"carmeIcon.png"]
                                                            highlightedContentImage:nil];
        QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                   highlightedImage:storyMenuItemImagePressed
                                                                       ContentImage:[UIImage imageNamed:@"carmeIcon.png"]
                                                            highlightedContentImage:nil];
        NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, nil];
        [starMenuItem1 release];
        [starMenuItem2 release];
        QuadCurveMenu *_menu = [[[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus] autorelease];
        [_menu updateCoordinate:CGPointMake(100,100)];
        [self.view addSubview:_menu];
    }
}

- (void)dealloc {
    [_models release];
    [super dealloc];
}

@end
