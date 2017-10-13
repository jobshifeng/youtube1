//
//  ASSearchViewController.h
//  szutube
//
//  Created by shifeng on 10/11/17.
//  Copyright © 2017 com.ossly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface ASSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UITableView *tvResult;

@property (weak, nonatomic) ViewController* caller;



-(IBAction)onClick_back:(id)sender;

@end
