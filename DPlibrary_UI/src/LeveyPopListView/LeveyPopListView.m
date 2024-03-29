//
//  LeveyPopListView.m
//  LeveyPopListViewDemo
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//

#import "LeveyPopListView.h"
//#import "DPUserInfoModel.h"
//#import "SelectCityController.h"

#import "Bee.h"

#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define RADIUS 5.

@interface LeveyPopListView (private)
- (void)fadeIn;
- (void)fadeOut;
@end

@implementation LeveyPopListView
@synthesize title = _title,options = _options,saveKeyName = _saveKeyName;


#pragma mark - initialization & cleaning up
- (void)dealloc
{
    [_title release];
    [_options release];
    [_tableView release];
    [_controller release];
    [_saveKeyName release];
    [super dealloc];
}
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions controller:(UIViewController *)controller
{
    CGRect rect = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, 320, [UIScreen mainScreen].applicationFrame.size.height);
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.7f];
        _title = [aTitle retain];
        _options = [aOptions retain];
        NSLog(@"title is %@,_options is %@",_title,_options);
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(POPLISTVIEW_SCREENINSET, 
                                                                   POPLISTVIEW_SCREENINSET + POPLISTVIEW_HEADER_HEIGHT, 
                                                                   rect.size.width - 2 * POPLISTVIEW_SCREENINSET,
                                                                   rect.size.height - 2 * POPLISTVIEW_SCREENINSET - POPLISTVIEW_HEADER_HEIGHT - RADIUS)];
        _tableView.separatorColor = [UIColor grayColor];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        _controller = controller;
        [_controller retain];
    }
    return self;    
}
#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];

}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentity] autorelease];
    }
    [cell.textLabel setTextColor:[UIColor blackColor]];
    cell.textLabel.text = [_options objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // tell the delegate the selection
    NSString * selectValue = [_options objectAtIndex:indexPath.row];
    NSLog(@"selectValue is %@",selectValue);
    if ([selectValue length] <= 0 || [selectValue isKindOfClass:[NSNull class]]){
        return;
    }
    

    [self postNotification:@"notify.SelectCityController.SELECTED_CITY" withObject:[NSString stringWithFormat:@"%@-%@", _title, selectValue]];
//    if ([_saveKeyName isEqualToString:DPSAVESELECTCITYKEY]) {
//        [DPUserInfoModel sharedInstance].city = [NSString stringWithFormat:@"%@-%@", _title, selectValue];
//    }else if ([_saveKeyName isEqualToString:DPSAVESELECTHOMETWONKEY]) {
//        [DPUserInfoModel sharedInstance].city = [NSString stringWithFormat:@"%@-%@", _title, selectValue];
//    }
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:selectValue forKey:_saveKeyName];
//    [defaults synchronize];

    // dismiss self
    [self fadeOut];
    
    //send a message to do Someting
    if (_controller) {
        [_controller.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
       
    // dismiss self
    [self fadeOut];
}

#pragma mark - DrawDrawDraw
- (void)drawRect:(CGRect)rect
{
    CGRect bgRect = CGRectInset(rect, POPLISTVIEW_SCREENINSET, POPLISTVIEW_SCREENINSET);
    CGRect titleRect = CGRectMake(POPLISTVIEW_SCREENINSET + 10, POPLISTVIEW_SCREENINSET + 10 + 5,
                                  rect.size.width -  2 * (POPLISTVIEW_SCREENINSET + 10), 30);
    CGRect separatorRect = CGRectMake(POPLISTVIEW_SCREENINSET, POPLISTVIEW_SCREENINSET + POPLISTVIEW_HEADER_HEIGHT - 2,
                                      rect.size.width - 2 * POPLISTVIEW_SCREENINSET, 1.5);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:.75].CGColor);
    [[UIColor colorWithWhite:1 alpha:1] setFill];
    
    
    float x = POPLISTVIEW_SCREENINSET;
    float y = POPLISTVIEW_SCREENINSET;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, x, y + RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
	CGPathCloseSubpath(path);
	CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the title and the separator with shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor whiteColor].CGColor);
//    [[UIColor colorWithRed:238/255.0f green:115.0f/255.0f blue:29.0f/255.0f alpha:1.] setFill];
    [[UIColor colorWithWhite:0 alpha:1] setFill];
    [_title drawInRect:titleRect withFont:[UIFont systemFontOfSize:16.]];
    [[UIColor colorWithRed:238/255.0f green:115.0f/255.0f blue:29.0f/255.0f alpha:1.] setFill];
    CGContextFillRect(ctx, separatorRect);
}

@end
