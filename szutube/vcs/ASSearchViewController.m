//
//  ASSearchViewController.m
//  szutube
//
//  Created by shifeng on 10/11/17.
//  Copyright © 2017 com.ossly. All rights reserved.
//

#import "ASSearchViewController.h"
#import "ViewController.h"

#import <ionicons/IonIcons.h>

//http://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=Query
//http://suggestqueries.google.com/complete/search?ds=yt&q=Query

#define SuggestionURL_Format @"http://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=%@"

@interface ASSearchViewController ()

@property (nonatomic, copy) NSArray<NSString*>* suggestionList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, copy) NSString* keyword;

@end

@implementation ASSearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImage *icon = [IonIcons imageWithIcon:ion_arrow_left_c iconColor:[UIColor blackColor]
                                   iconSize:40.0f
                                  imageSize:CGSizeMake(40.0f, 40.0f)];
    [self.btnBack setImage:icon forState:UIControlStateNormal];
    
    self.tfSearch.delegate = self;
    [self.tfSearch addTarget:self
                  action:@selector(searchFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    self.keyword = nil;
}



- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    self.bottomConstraint.constant = height+20;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = 20;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)searchFieldDidChange:(id)sender
{
    static int searchCount = 0;
    ++searchCount;
    
    int currentSearchCount = searchCount;
    NSString* curString = [self.tfSearch.text copy];
    __weak ASSearchViewController* wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong ASSearchViewController* sSelf = nil;
        if (wSelf)
        {
            sSelf = wSelf;
        }
        if (!sSelf) return;
        
        if ([curString length] != 0 && currentSearchCount == searchCount)
        {
            NSString* urlString = [NSString stringWithFormat:SuggestionURL_Format, curString];
            NSURL* url = [NSURL URLWithString:urlString];
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    NSArray* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if (result && [result count] == 2) {
                        sSelf.suggestionList = result[1];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [sSelf.tvResult reloadData];
                        });
                    }
                }
            }];
            [task resume];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.tfSearch becomeFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(IBAction)onClick_back:(id)sender
{
    [self backToCaller:nil]; 
}

-(void) backToCaller:(NSString*) aKeyWord;
{
    if (aKeyWord)
    {
        self.caller.keyword = aKeyWord;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.tvResult dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = self.suggestionList[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.suggestionList count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [self backToCaller:cell.textLabel.text]; 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{

}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self backToCaller:self.tfSearch.text]; 
    
    return YES;
}


@end
