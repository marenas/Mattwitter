//
//  ContentNavigationController.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/10/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "ContentNavigationController.h"

@interface ContentNavigationController ()

@end

@implementation ContentNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        rootViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(onSlideoutButton)];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewControllers:(NSArray *)viewControllers {
    [super setViewControllers:viewControllers];
    self.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(onSlideoutButton)];
}


- (void)onSlideoutButton {
    if (self.slideoutVisible) {
        NSLog(@"on slide out button");
         [self.slideoutDelegate hideSlideout:self];
    } else {
        [self.slideoutDelegate showSlideout:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
