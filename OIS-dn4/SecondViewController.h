//
//  SecondViewController.h
//  OIS-dn4
//
//  Created by Klemen Kosir on 11. 12. 14.
//  Copyright (c) 2014 Lonely Cappuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

@interface SecondViewController : UIViewController <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ehrIdField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UISwitch *heightSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *weightSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tempSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pressSysSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pressDiaSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *heartRateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *oxySatSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stepsSwitch;

@end

