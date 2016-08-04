//
//  loginViewController.h
//  FoodNetwork
//
//  Created by Sarmila on 7/11/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "ViewController.h"
#import "FoodNetworkListTableViewController.h"

@interface loginViewController : ViewController
@property (weak, nonatomic) IBOutlet UITextField *emailLogin;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogin;
@property (weak, nonatomic) IBOutlet UILabel *invalidLogin;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
