//
//  LastBillViewController.m
//  tipcalculator
//
//  Created by Yingming Chen on 1/10/15.
//  Copyright (c) 2015 Yingming Chen. All rights reserved.
//

#import "LastBillViewController.h"

@interface LastBillViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lastBillTotal;
@property (weak, nonatomic) IBOutlet UILabel *lastBillTip;
@property (weak, nonatomic) IBOutlet UILabel *lastBillSplitCount;
@property (weak, nonatomic) IBOutlet UILabel *lastBillPerPerson;
@property (weak, nonatomic) IBOutlet UILabel *lastBillDate;
@property (weak, nonatomic) IBOutlet UILabel *lastBillAddress;

@end

@implementation LastBillViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self.title = @"Last Bill";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // Load data for last bill
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.lastBillAddress.text = [defaults objectForKey:@"last_bill_address"];
    self.lastBillDate.text = [defaults objectForKey:@"last_bill_date"];
    self.lastBillTip.text = [defaults objectForKey:@"last_bill_tip"];
    self.lastBillTotal.text = [defaults objectForKey:@"last_bill_total"];
    self.lastBillPerPerson.text = [defaults objectForKey:@"last_bill_per_person"];
    self.lastBillSplitCount.text = [NSString stringWithFormat:@"%ld", [defaults integerForKey:@"last_bill_split_count"]];
}

@end
