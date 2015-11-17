//
//  SlideoutViewController.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/10/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "SlideoutViewController.h"
#import "SlideoutHeaderTableViewCell.h"

@interface SlideoutViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SlideoutHeaderTableViewCell *prototypeHeaderCell;

@end

@implementation SlideoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *headerCellNib = [UINib nibWithNibName:@"SlideoutHeaderTableViewCell" bundle:nil];
    [self.tableView registerNib:headerCellNib forCellReuseIdentifier:@"slideoutHeaderTableViewCell"];
    self.prototypeHeaderCell = [self.tableView dequeueReusableCellWithIdentifier:@"slideoutHeaderTableViewCell"];
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 100;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SlideoutHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slideoutHeaderTableViewCell"];
    cell.user = [User currentUser];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Profile";
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"Timeline";
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"Mentions";
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"Logout";
            break;
        }
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid item" userInfo:nil];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate slideoutViewController:self didSelectItem:indexPath.row];
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
