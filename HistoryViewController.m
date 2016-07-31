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
@import FirebaseAuth;
#import "History.h"
#import "BudgetPlan.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) NSMutableArray *historyOfCheckinRestaurantArray;
@property (weak, nonatomic) IBOutlet UITextField *budgetText;
@property (weak, nonatomic) IBOutlet UITextField *totalAmountSpend;
@property(weak, nonatomic) UILabel *budgetLabel;
@property(weak, nonatomic) UILabel *totalDollarLabel;

@end

@implementation HistoryViewController{}
@synthesize pieChartView;
NSInteger total;

- (void)viewDidLoad {
    [self getHistoryFromDatabase];
    [_budgetText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self drawPiechart];
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
}


-(void)drawPiechart{
    _totalAmountSpend.text = @"60";
    
    //draw pie chart
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    for (int i=0;i<1;i++) {
        //random number generator
        // NSNumber *number = [NSNumber numberWithInt:rand()%60+20];
        //add number to array
        [dataArray addObject:_budgetText.text];
        [dataArray addObject:_totalAmountSpend.text];
        NSLog(@"DATAARRAY Description = %@", dataArray.description);
        
        
    }
    //call DLPiechart to method
    [self.pieChartView renderInLayer:self.pieChartView dataArray:dataArray];
  //  [self.pieChartView reloadData];

}

-(void)textFieldDidChange :(UITextField *)theTextField{
    _budgetLabel.text = _budgetText.text;
    _totalDollarLabel.text = _totalAmountSpend.text;
    NSLog(@"_totalDollarLabel= %@", _totalDollarLabel.text);
    [self drawPiechart];
}


-(void)getHistoryFromDatabase{
    _historyOfCheckinRestaurantArray = [[NSMutableArray alloc]init];
    FIRDatabaseReference *ref = [[FIRDatabase database]reference];
    FIRDatabaseReference *historyRef = [ref child:@"history"];
   
    [historyRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        
        for (id key in snapshot.value){
            NSDictionary *restaurantCheckingDict = [snapshot.value objectForKey:key];
            NSString *counter = [restaurantCheckingDict valueForKey:@"checkedIn_restaurant_userID"];
            
            if ([counter isEqualToString:[FIRAuth auth].currentUser.uid]) {
                [_historyOfCheckinRestaurantArray addObject:restaurantCheckingDict];
                [self.historyTableView reloadData];
            }
            
        }
    }];
   
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //If not even a single restaurant is checked in then historyOfCheckinRestaurantArray will be empty and its count is zero. So, no data is available to display in table view cell
    
    NSInteger numOfSections = 0;
    if ([_historyOfCheckinRestaurantArray count] > 0)
    {
        self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections = 1;
        self.historyTableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.historyTableView.bounds.size.width, self.historyTableView.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor brownColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        noDataLabel.textColor = [UIColor brownColor];
        self.historyTableView.backgroundView = noDataLabel;
        self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [_historyOfCheckinRestaurantArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.historyTableView.contentInset = UIEdgeInsetsMake(0,-15,0,-30) ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    tableView.rowHeight = 60;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[_historyOfCheckinRestaurantArray objectAtIndex:indexPath.row] objectForKey:@"checkedIn_restaurant_name"]];
   
    NSString *amt = [NSString stringWithFormat:@"%@",[[_historyOfCheckinRestaurantArray objectAtIndex:indexPath.row] objectForKey:@"checkedIn_restaurant_amountSpend"]];
    if ([amt  isEqual: @" "] || [amt isEqual:@""]) {
                cell.detailTextLabel.text = @"$0.00";
            }
    else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Amount Spend = $%@.00", amt];
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
