//
//  TweetsViewController.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/4/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TweetDetailViewController.h"
#import "ComposeViewController.h"

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TweetCell *tweetCell;
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Signt Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    self.tableView.estimatedRowHeight = 200;
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    self.tweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefreshControl:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    //get data
    [self loadTweetsWithCompletionHandler:^{
        NSLog(@"loaded initial tweets");
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = (Tweet *)self.tweets[indexPath.row];
    cell.parentViewController = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onSignOutButton {
    [User logout];
}

- (void)onRefreshControl:(UIRefreshControl *)refreshControl
{
    [self loadTweetsWithCompletionHandler:^{
        [refreshControl endRefreshing];
    }];
}

- (void)loadTweetsWithCompletionHandler:(void (^)(void))completionHandler {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
        completionHandler();
    }];
    
}

- (void)onNewButton {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
//    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
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
