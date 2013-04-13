//
// Created by BlueBerry on 12-11-15.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPButton.h"

@interface DPButton(private)
-(void) handleLongPress:(UILongPressGestureRecognizer*) sender;
@end

@implementation DPButton
@synthesize userInfo = _userInfo;
@synthesize delegate = _delegate;


-(id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame withBackgroundImage:nil withTitle:nil];
    if (self) {

    }
    return self;
}

-(id) initWithFrame:(CGRect) frame withBackgroundImage:(UIImage *) image withTitle:(NSString *) title
{
    self = [super initWithFrame:frame];
    if (self) {
        if(image)
            [self setBackgroundImage:image forState:UIControlStateNormal];
        if (title)
            [self setTitle:title forState:UIControlStateNormal];
        if(!_userInfo)
            _userInfo = [[NSMutableDictionary alloc] init];

        UILongPressGestureRecognizer *recognizer =
                [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [recognizer setMinimumPressDuration:.3f];
        [self addGestureRecognizer:recognizer];
        [recognizer release];

    }
    return self;
}

-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action
{
    _actionBlock = Block_copy(action);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

-(void) callActionBlock:(id)sender{
    _actionBlock();
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate longPressEventEnd:self.userInfo];
    }else if(sender.state == UIGestureRecognizerStateBegan)
    {
        [self.delegate longPressEventBegin:self.userInfo];
    }

}

- (void)dealloc {
    Block_release(_actionBlock);
    [_userInfo release];
    [super dealloc];
}


@end