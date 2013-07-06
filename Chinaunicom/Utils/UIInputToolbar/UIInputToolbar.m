/*
 *  UIInputToolbar.m
 *  
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "UIInputToolbar.h"

@implementation UIInputToolbar

@synthesize textView;
@synthesize inputButton;
@synthesize delegate;
@synthesize pressButton;
-(void)inputButtonPressed:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected) {
        [self bringSubviewToFront:pressButton];
        [self.textView resignFirstResponder];
        
    }else
    {
        [self bringSubviewToFront:self.textView];
    }

}

-(void)pressSound:(UIButton *)sender
{
    if ([delegate respondsToSelector:@selector(startSpeak)]) {
        [delegate startSpeak];
    }
}
-(void)upSound:(UIButton *)sender
{
    if ([delegate respondsToSelector:@selector(endSpeak)]) {
        [delegate endSpeak];
    }
}
-(void)setupToolbar:(NSString *)buttonLabel
{
    pressButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *newImage=[UIImage imageNamed:@"textbg.png"];
    newImage=[newImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
    [pressButton setBackgroundImage:newImage forState:UIControlStateNormal];
    [pressButton setTitle:@"按住说话" forState:UIControlStateNormal];
    pressButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [pressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pressButton addTarget:self action:@selector(pressSound:) forControlEvents:UIControlEventTouchDown];
    [pressButton addTarget:self action:@selector(upSound:) forControlEvents:UIControlEventTouchUpInside];
    pressButton.frame=CGRectMake(7, 9, 256, 26);
//    pressButton.contentMode    = UIViewContentModeScaleToFill;
//    pressButton.contentStretch = CGRectMake(0.5, 0.5, 0, 0);
    [self addSubview:pressButton];
    [self sendSubviewToBack:pressButton];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
//    self.tintColor = [UIColor lightGrayColor];
    
    /* Create custom send button*/
    UIImage *buttonImage = [UIImage imageNamed:@"record.png"];
//        buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
    UIButton *button               = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font         = [UIFont boldSystemFontOfSize:15.0f];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
//    button.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
//    button.contentMode             = UIViewContentModeScaleToFill;
    button.frame=CGRectMake(265, 0, 55, 40);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"recordedit.png"] forState:UIControlStateSelected];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:buttonLabel forState:UIControlStateNormal];
    [button addTarget:self action:@selector(inputButtonPressed:) forControlEvents:UIControlEventTouchDown];
//    [button sizeToFit];
    [self addSubview:button];
    self.inputButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.inputButton.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    /* Disable button initially */
//    self.inputButton.enabled = NO;

    /* Create UIExpandingTextView input */
    self.textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(7, 9, 256, 26)];
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    /* Right align the toolbar button */
//    UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
//    [self addSubview:button];
//    NSArray *items = [NSArray arrayWithObjects:flexItem, self.inputButton, nil];
//    [self setItems:items animated:NO];
}

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setupToolbar:@""];
    }
    return self;
}

-(id)init
{
    if ((self = [super init])) {
        [self setupToolbar:@""];
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    /* Draw custon toolbar background */
    UIImage *backgroundImage = [UIImage imageNamed:@"toolbarbg.png"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:floorf(backgroundImage.size.width/2) topCapHeight:floorf(backgroundImage.size.height/2)];
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
//    CGRect i = self.inputButton.customView.frame;
//    i.origin.x = 280;
//    self.inputButton.customView.frame = i;
}

- (void)dealloc
{
    [textView release];
    [inputButton release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIExpandingTextView delegate

-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
}

- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView
{
    if ([expandingTextView.text isEqualToString:@""]) {
        [MBHUDView hudWithBody:@"评论不能为空" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    }else
    {
        if ([delegate respondsToSelector:@selector(sendTheComment)]) {
            [delegate sendTheComment];
        }
    }
    [self.textView clearText];
    return YES;
}
@end
