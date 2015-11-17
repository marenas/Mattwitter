//
//  SlideoutViewController.h
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/10/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideoutViewController;

@protocol SlideoutViewControllerDelegate <NSObject>

- (void)slideoutViewController:(SlideoutViewController *)vc didSelectItem:(NSInteger)item;

@end


@interface SlideoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <SlideoutViewControllerDelegate> delegate;

@end
