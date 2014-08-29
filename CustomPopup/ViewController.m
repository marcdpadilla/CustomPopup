//
//  ViewController.m
//  CustomPopup
//
//  Created by Marc Padilla on 8/28/14.
//  Copyright (c) 2014 Yondu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *icon = [UIImage imageNamed:@"icon.png"];
    iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconButton setImage:icon forState:UIControlStateNormal];
//    iconButton.frame = CGRectMake((self.view.frame.size.width/2)-(icon.size.width/2), (self.view.frame.size.height/2)-(icon.size.height/2)-[UIApplication sharedApplication].statusBarFrame.size.height, icon.size.width, icon.size.height);
    iconButton.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 0.0, 0.0);
    iconButton.hidden = YES;
    [iconButton addTarget:self action:@selector(iconButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [iconButton addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [iconButton addTarget:self action:@selector(dragEnded:withEvent:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside];
    
    [self.view addSubview:iconButton];
    shown = NO;
    
    container = [[UIView alloc] initWithFrame:CGRectZero];
    container.backgroundColor = [UIColor lightGrayColor];
    container.frame = CGRectMake(iconButton.center.x, iconButton.center.y, 0.0, 0.0);
    container.clipsToBounds = YES;
    container.layer.cornerRadius = 8.0;
    [self.view insertSubview:container belowSubview:iconButton];
    
    content = [[UIWebView alloc] initWithFrame:CGRectZero];
    content.delegate = self;
    content.scrollView.scrollEnabled = NO;
    content.backgroundColor = [UIColor clearColor];
    content.opaque = NO;
    [content setDataDetectorTypes:UIDataDetectorTypeLink];
    [container addSubview:content];
    
    UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, self.view.frame.size.width-40, 30)];
    input.delegate = self;
    [input setReturnKeyType:UIReturnKeySend];
    input.placeholder  = @"Type something";
    [self.view addSubview:input];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [content loadHTMLString:[NSString stringWithFormat:@"<span style=\"font-family:Helvetica;font-size:11pt;color:#000000;\">%@ <a href=\"http://www.google.com\">Click here</a></span><br \\><br \\><center><img src=\"https://cdn0.iconfinder.com/data/icons/star-wars/512/death_star-512.png\" width=\"100px\" height=\"100px\"\\></center>", [textField.text length] ? textField.text : @"test content"]  baseURL:nil];
    textField.text = @"";
    
    [self showIcon];
    [self.view endEditing:YES];
    
    return YES;
}

- (void) showIcon {
    if (!iconShown) {
        UIImage *icon = [iconButton.imageView image];
        iconButton.hidden = NO;
        [UIView animateWithDuration:.500 delay:1.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            iconButton.frame = CGRectMake((self.view.frame.size.width/2)-(icon.size.width/2), (self.view.frame.size.height/2)-(icon.size.height/2)-[UIApplication sharedApplication].statusBarFrame.size.height, icon.size.width, icon.size.height);
            container.center = iconButton.center;
        } completion:^(BOOL finished) {
            iconShown = YES;
        }];
    }
}

- (void) iconButtonAction {
    
    if (wasDragged) {
//        wasDragged = NO;
        return;
    }
    
    if (shown) {
        [UIView animateWithDuration:0.500 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            CGRect f = iconButton.frame;
            f.origin.x = (self.view.frame.size.width/2)-(f.size.width/2);
            f.origin.y = (self.view.frame.size.height/2)-(f.size.height/2)-[UIApplication sharedApplication].statusBarFrame.size.height;
            iconButton.frame = f;
            
            container.frame = CGRectMake(iconButton.center.x, iconButton.center.y, 0.0, 0.0);
            
        } completion:^(BOOL finished) {
            shown = NO;
        }];
    } else {
        
        [UIView animateWithDuration:0.500 delay:0.0 usingSpringWithDamping:0.5  initialSpringVelocity:0.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            CGRect f = iconButton.frame;
            f.origin.x = 0;
            f.origin.y = self.view.frame.size.height/2;
            iconButton.frame = f;
            
            container.frame = CGRectMake(iconButton.frame.origin.x+10, iconButton.frame.size.height+iconButton.frame.origin.y, self.view.frame.size.width-(iconButton.frame.origin.x+20), 150.0);
            
        } completion:^(BOOL finished) {
            shown = YES;
            content.frame = container.bounds;
        }];
        
    }
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    if (shown)
        return;
    
    wasDragged = YES;
	
	UITouch *touch = [[event touchesForView:button] anyObject];
    
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_x = location.x - previousLocation.x;
	CGFloat delta_y = location.y - previousLocation.y;
    
	[UIView animateWithDuration:.250 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        button.center = CGPointMake(button.center.x + delta_x,
                                    button.center.y + delta_y);
        container.center = button.center;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) dragEnded:(UIButton *)button withEvent:(UIEvent *)event {
    
    if (!wasDragged)
        return;
    
    wasDragged = NO;
    
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_x = location.x - previousLocation.x;
	CGFloat delta_y = location.y - previousLocation.y;
    
    
//	[UIView animateWithDuration:.250 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        button.center = CGPointMake(delta_x+button.center.x, delta_y+button.center.y);
        container.center = button.center;
//    } completion:^(BOOL finished) {
        CGFloat x = 0.0;
        CGFloat y = 0.0;
        if (self.view.frame.size.width/2 > button.center.x) {
            x = button.frame.size.width/2;
        } else {
            x = self.view.frame.size.width-(button.frame.size.width/2);
        }
        
        if (self.view.frame.size.height/2 > button.center.y) {
            y = button.frame.size.height/2;
        } else {
            y = self.view.frame.size.height-(button.frame.size.height/2);
        }
        
        [UIView animateWithDuration:.700 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            button.center = CGPointMake(x, y);
            container.center = button.center;
        } completion:^(BOOL finished) {
            
        }];
//    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if (![[[request URL] absoluteString] isEqualToString:@"about:blank"]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
