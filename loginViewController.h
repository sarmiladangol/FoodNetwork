//
//  loginViewController.h
//  FoodNetwork
//
//  Created by Sarmila on 7/11/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "ViewController.h"

@interface loginViewController : ViewController
@property (weak, nonatomic) IBOutlet UITextField *emailLogin;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogin;
@property (weak, nonatomic) IBOutlet UILabel *invalidLogin;

@end
