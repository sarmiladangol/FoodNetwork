//
//  HistoryViewController.h
//  FoodNetwork
//
//  Created by Sarmila on 7/25/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DLPieChart.h"

@interface HistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, retain)IBOutlet DLPieChart *pieChartView;


@end
