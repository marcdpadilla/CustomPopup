//
//  ViewController.h
//  CustomPopup
//
//  Created by Marc Padilla on 8/28/14.
//  Copyright (c) 2014 Yondu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate> {
    UIButton *iconButton;
    UIView *container;
    UIWebView *content;
    UIImageView *closeIcon;
    BOOL iconShown;
    BOOL shown;
    BOOL wasDragged;
    BOOL closeIconShown;
}

@end
