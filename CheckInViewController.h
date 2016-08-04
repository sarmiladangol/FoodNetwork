//
//  CheckInViewController.h
//  FoodNetwork
//
//  Created by Sarmila on 7/27/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
@interface CheckInViewController : UIViewController

@property(strong,nonatomic) Restaurant *checkinRestaurant;
@property (weak, nonatomic) IBOutlet UILabel *checkinNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkinAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkinPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkinWebsiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkinDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkinAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountText;
@end
