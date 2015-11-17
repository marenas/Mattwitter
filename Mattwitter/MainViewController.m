//
//  MainViewController.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/9/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "MainViewController.h"
#import "ContentNavigationController.h"
#import "TweetsViewController.h"
#import "SlideoutViewController.h"
#import "User.h"
#import "ProfileViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) ContentNavigationController *contentNavigationController;
@property (nonatomic, strong) SlideoutViewController *slideoutViewController;

@end

@implementation MainViewController

- (id)initWithContentViewController:(UIViewController *)contentViewController {
    self = [super init];
    if (self) {
        [self setContentViewController:contentViewController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    self.contentNavigationController = [[ContentNavigationController alloc] initWithRootViewController:contentViewController];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    [self.contentNavigationController.view addGestureRecognizer:panGestureRecognizer];

    [self.contentNavigationController willMoveToParentViewController:self];
    
    for (UIView *view in self.view.subviews) {
        if (view.tag != 1) {
            [view removeFromSuperview];
        }
    }
    self.contentNavigationController.slideoutDelegate = self;
    [self.view addSubview:self.contentNavigationController.view];
    [self addChildViewController:self.contentNavigationController];
    self.contentNavigationController.view.frame = self.view.frame;    
    [self.contentNavigationController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *)getSlideoutView {
    if (self.slideoutViewController == nil) {
        self.slideoutViewController = [[SlideoutViewController alloc] init];
        self.slideoutViewController.delegate = self;
        
        self.slideoutViewController.view.tag = 1;
        [self.view addSubview:self.slideoutViewController.view];
        [self addChildViewController:self.slideoutViewController];
        [self.slideoutViewController didMoveToParentViewController:self];

        self.slideoutViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    UIView *view = self.slideoutViewController.view;
    return view;
}


- (void)onPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // translate the content view controller based on the pan
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        CGFloat newX = MAX(self.contentNavigationController.view.center.x + translation.x, self.view.center.x);
        self.contentNavigationController.view.center = CGPointMake(newX, self.contentNavigationController.view.center.y);
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // open or close the slideout based on whether it's halfway off the screen
        BOOL openSlideout = self.contentNavigationController.view.center.x - self.view.center.x > self.contentNavigationController.view.frame.size.width / 2;
        if (openSlideout) {
            [self animateSlideoutOpen];
        } else {
            [self animateSlideoutClosed];
        }
    }
}

- (void)showSlideout:(ContentNavigationController *)vc {
    [self animateSlideoutOpen];
}

- (void)hideSlideout:(ContentNavigationController *)vc {
    [self animateSlideoutClosed];
}

- (void)animateSlideoutOpen {
    NSLog(@"animate slideout open");
    UIView *childView = [self getSlideoutView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.contentNavigationController.view.frame = CGRectMake(self.view.frame.size.width - 100, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.contentNavigationController.slideoutVisible = YES;
                         }
                     }];
}

- (void)animateSlideoutClosed {
    NSLog(@"animate slideout closed");
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentNavigationController.view.frame = self.view.frame;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.contentNavigationController.slideoutVisible = NO;
                             [self resetMainView];
                         }
                     }];
}

- (void)resetMainView {
    if (self.slideoutViewController != nil) {
        [self.slideoutViewController willMoveToParentViewController:nil];
        [self.slideoutViewController.view removeFromSuperview];
        [self.slideoutViewController removeFromParentViewController];
        self.slideoutViewController = nil;
    }

}


- (void)slideoutViewController:(SlideoutViewController *)vc didSelectItem:(NSInteger)item {

    UIViewController *newViewController;
    switch (item) {
        case 0:
        {
            NSLog(@"case 0");
            ProfileViewController *pvc = [[ProfileViewController alloc] init];
            pvc.user = [User currentUser];
            newViewController = pvc;
            break;
        }
        case 1:
        {
            NSLog(@"case 1");
            TweetsViewController *tvc = [[TweetsViewController alloc] init];
            tvc.timelineType = HomeTimeline;;
            newViewController = tvc;
            break;
        }
        case 2:
        {
            NSLog(@"case 2");
            TweetsViewController *tvc = [[TweetsViewController alloc] init];
            tvc.timelineType = MentionsTimeline;
            newViewController = tvc;
            break;
        }
        case 3:
        {
            [User logout];
            return;
        }
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid item" userInfo:nil];
    }
    
    [self setContentViewController:newViewController];
    [self animateSlideoutClosed];
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
