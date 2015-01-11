//
//  TipViewController.m
//  tipcalculator
//
//  Created by Yingming Chen on 12/30/14.
//  Copyright (c) 2014 Yingming Chen. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"
#import "LastBillViewController.h"

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
- (void)onLastBillsButton;
- (IBAction)onSaveBill:(id)sender;

// Helper functions
- (void)updateValues;

@end

@implementation TipViewController

CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;
NSDateFormatter *dateFormatter;
NSString *billAddress;

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
    
    // Setup navigation button for settings view
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Last Bill" style:UIBarButtonItemStylePlain target:self action:@selector(onLastBillsButton)];

    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    billAddress = @"N/A";
    dateFormatter = [[NSDateFormatter alloc] init];
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

    // Init location related stuff
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

    // Request permission for get user location
    [locationManager requestAlwaysAuthorization];
}

- (IBAction)onTap:(id)sender {
    [self updateValues];
}

- (IBAction)onSaveBill:(id)sender {
    NSDate *now = [NSDate date];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSString *billDate = [dateFormatter stringFromDate:now];

    // Save the last bill info
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:billAddress forKey:@"last_bill_address"];
    [defaults setObject:billDate forKey:@"last_bill_date"];
    [defaults setObject:self.tipAmountField.text forKey:@"last_bill_tip"];
    [defaults setObject:self.totalAmountField.text forKey:@"last_bill_total"];
    [defaults setObject:self.perPersonAmountField.text forKey:@"last_bill_per_person"];
    long splitCount = (long)self.splitControlStepper.value;
    [defaults setInteger:splitCount forKey:@"last_bill_split_count"];

    [defaults synchronize];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)onLastBillsButton {
    [self.navigationController pushViewController:[[LastBillViewController alloc] init] animated:YES];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;

    if (currentLocation != nil) {
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                // Save bill address
                billAddress = [NSString stringWithFormat:@"%@ %@\n%@\n%@  %@\n%@",
                                     placemark.subThoroughfare, placemark.thoroughfare,
                                     placemark.locality,
                                     placemark.administrativeArea, placemark.postalCode,
                                     placemark.country];
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
    }

    [locationManager stopUpdatingLocation];
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
