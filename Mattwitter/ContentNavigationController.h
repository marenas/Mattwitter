//
//  ContentNavigationController.h
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/10/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentNavigationController;

@protocol ContentNavigationControllerDelegate <NSObject>

- (void)showSlideout:(ContentNavigationController *)vc;
- (void)hideSlideout:(ContentNavigationController *)vc;

@end

@interface ContentNavigationController : UINavigationController

@property (nonatomic, weak) id <ContentNavigationControllerDelegate> slideoutDelegate;
@property (nonatomic) BOOL slideoutVisible;

@end
