//
//  BudgetPlan.h
//  FoodNetwork
//
//  Created by Sarmila on 7/31/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BudgetPlan : NSObject
@property (nonatomic,strong) NSString *targetBudgetAmount;
@property (nonatomic, strong) NSString *totalDollarSpend;
@property (nonatomic, strong) NSString *remainingBalance;
@end
