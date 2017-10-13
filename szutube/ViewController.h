//
//  ViewController.h
//  szutube
//
//  Created by shifeng on 10/11/17.
//  Copyright © 2017 com.ossly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRYouTube.h>

@class ASDisplayResult;


@interface ViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) GTLRYouTubeService *service;

@property (nonatomic, copy) NSString* keyword; 

@property (weak, nonatomic) IBOutlet UITableView *tvVideos;
@property (nonatomic, strong) NSMutableArray<ASDisplayResult*>* displayResults;

@end
