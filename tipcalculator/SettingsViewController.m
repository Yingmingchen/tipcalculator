//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Yingming Chen on 1/3/15.
//  Copyright (c) 2015 Yingming Chen. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;

- (IBAction)onTipControl:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self.title = @"Settings";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger defaultTipControlIndex = [defaults integerForKey:@"default_tip_control_index"];
    self.defaultTipControl.selectedSegmentIndex = defaultTipControlIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTipControl:(id)sender {
    NSInteger defaultTipControlIndex = self.defaultTipControl.selectedSegmentIndex;
    // Save the default tip control settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:defaultTipControlIndex forKey:@"default_tip_control_index"];
    [defaults synchronize];
}

@end
