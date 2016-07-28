//
//  HistoryViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/25/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "HistoryViewController.h"
@import Firebase;
@import FirebaseDatabase;

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) NSMutableArray *historyOfCheckinRestaurantArray;
@end

@implementation HistoryViewController{}

- (void)viewDidLoad {
    [self getHistoryFromDatabase];
    [super viewDidLoad];
    
    // Trigger hamburger menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getHistoryFromDatabase{
    NSLog(@"**********GET HISTORY FROM DATABASE");
    _historyOfCheckinRestaurantArray = [[NSMutableArray alloc]init];
    FIRDatabaseReference *ref = [[FIRDatabase database]reference];
    FIRDatabaseReference *historyRef = [ref child:@"history"];
    [historyRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot){
        History *newHistory = [[History alloc]init];
        for (FIRDataSnapshot *child in snapshot.children) {
            newHistory.uid = snapshot.key;
            if([child.key isEqualToString:@"checkedIn_restaurant_name"]){
                newHistory.checkinRestaurantName = child.value;
            }
            if([child.key isEqualToString:@"checkedIn_restaurant_amountSpend"]){
                newHistory.checkinRestaurantAmountSpend = child.value;
            }
            
           
        }
        [_historyOfCheckinRestaurantArray addObject:newHistory];
        [self.historyTableView reloadData];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_historyOfCheckinRestaurantArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.historyTableView.contentInset = UIEdgeInsetsMake(0,-15,0,-30) ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    History *historyInCell = [_historyOfCheckinRestaurantArray objectAtIndex:indexPath.row];
    tableView.rowHeight = 60;
    cell.textLabel.text = historyInCell.checkinRestaurantName;
    NSString *amt= historyInCell.checkinRestaurantAmountSpend;
    if ([amt  isEqual: @" "] || [amt isEqual:@""]) {
        cell.detailTextLabel.text = @"$0.00";
    }
    else{
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Amount Spend = $%@", historyInCell.checkinRestaurantAmountSpend];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"history.png"];
    [cell layoutIfNeeded];
    return cell;
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
