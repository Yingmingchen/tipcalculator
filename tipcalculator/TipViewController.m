//
//  TipViewController.m
//  tipcalculator
//
//  Created by Yingming Chen on 12/30/14.
//  Copyright (c) 2014 Yingming Chen. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billInputField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UILabel *splitValueLabel;
@property (weak, nonatomic) IBOutlet UIStepper *splitControlStepper;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountField;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountField;
@property (weak, nonatomic) IBOutlet UILabel *perPersonAmountField;

// Event handlers
- (IBAction)onTap:(id)sender;
- (void)onSettingsButton;

// Helper functions
- (void)updateValues;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self.title = @"Tip Calulator";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the default values
    [self updateValues];
    
    // Setup navigation button for settings view
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // Retrieve the default tip control settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger defaultTipControlIndex = [defaults integerForKey:@"default_tip_control_index"];
    
    // Update the tip control index
    self.tipControl.selectedSegmentIndex = defaultTipControlIndex;
    
    self.splitControlStepper.minimumValue = 1;
    self.splitControlStepper.stepValue = 1;
    
    [self updateValues];
    
    // Put the focus on the bill input filed
    [self.billInputField becomeFirstResponder];
}

- (IBAction)onTap:(id)sender {
    [self updateValues];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)updateValues {
    // Get user input value for the bill
    float billAmount = [self.billInputField.text floatValue];
    
    // Calculate the tip count based on tip %
    NSArray *tipValues = @[@(0.1), @(0.15), @(0.2)];
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    
    // Calculate the total ammount
    float totalAmount = tipAmount + billAmount;
    
    // Get the # of persons for split
    long splitCount = (long)self.splitControlStepper.value;
    // Calculate the split amount per person
    float perPersonAmount = totalAmount / splitCount;
    
    // Update the UI fields with the calculated values
    self.tipAmountField.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalAmountField.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
    self.perPersonAmountField.text = [NSString stringWithFormat:@"$%0.2f", perPersonAmount];
    self.splitValueLabel.text = [NSString stringWithFormat:@"%ld", splitCount];
}

@end
