//
//  MainViewController.h
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/9/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentNavigationController.h"
#import "SlideoutViewController.h"

@interface MainViewController : UIViewController <ContentNavigationControllerDelegate, SlideoutViewControllerDelegate>

- (id)initWithContentViewController:(UIViewController *)contentViewController;
- (void)setContentViewController:(UIViewController *)contentViewController;

@end
