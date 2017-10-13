//
//  ViewController.m
//  szutube
//
//  Created by shifeng on 10/11/17.
//  Copyright © 2017 com.ossly. All rights reserved.
//

#import "ViewController.h"

#import "ASUtil.h"

#import <ionicons/IonIcons.h>
#import <AVFoundation/AVFoundation.h>

#import "ASSearchViewController.h"
#import "ASVideoTableViewCell.h"
#import "ASDisplayResult.h"
#import "ASYoutubePlayerViewController.h"

#define MAX_Search_Result 10



@interface ViewController ()

@property (nonatomic, copy) NSString* nextToken;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure Google Sign-in.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeYouTubeReadonly, nil];
    [signIn signInSilently];
    
    
 
    // Add the sign-in button.
    self.signInButton = [[GIDSignInButton alloc] init];
    
    /*
    [self.view addSubview:self.signInButton];
    
    // Create a UITextView to display output.
    
    self.output = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.output.editable = false;
    self.output.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0);
    self.output.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.output.hidden = true;
    [self.view addSubview:self.output];
     */
    
    [self configureNavigationBar];
    
    // Initialize the service object.
    self.service = [[GTLRYouTubeService alloc] init];
    
    
    self.tvVideos.delegate = self;
    self.tvVideos.dataSource = self;
    
    [self addObserver:self forKeyPath:@"keyword" options:NSKeyValueObservingOptionNew context:nil];
}

-(void) dealloc
{
    [self removeObserver:self forKeyPath:@"keyword"];
}

-(void) configureNavigationBar
{
    // Add the sign-in button.
    
    UIBarButtonItem* loginItem = [[UIBarButtonItem alloc] initWithCustomView:self.signInButton];
    self.navigationItem.leftBarButtonItems = @[loginItem];
   
    UIImage *icon = [IonIcons imageWithIcon:ion_ios_search iconColor:[UIColor blackColor]
                                   iconSize:40.0f
                                  imageSize:CGSizeMake(40.0f, 40.0f)];
    self.navigationItem.rightBarButtonItem.image = icon;
    
    
}




- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        self.output.hidden = false;
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        [self fetchChannelResource];
    }
}

// Construct a query and retrieve the channel resource for the GoogleDevelopers
// YouTube channel. Display the channel title, description, and view count.
- (void)fetchChannelResource {
    /*
    GTLRYouTubeQuery_ChannelsList *query =
    [GTLRYouTubeQuery_ChannelsList queryWithPart:@"snippet,statistics"];
    //query.identifier = @"UC_x5XG1OV2P6uZZ5FSM9Ttw";
    // To retrieve data for the current user's channel, comment out the previous
    // line (query.identifier ...) and uncomment the next line (query.mine ...).
    query.mine = true;
     */
    
    GTLRYouTubeQuery_ChannelsList *query =
    [GTLRYouTubeQuery_ChannelsList queryWithPart:@"snippet,statistics"];
    query.identifier = @"UC_x5XG1OV2P6uZZ5FSM9Ttw";
    // To retrieve data for the current user's channel, comment out the previous
    // line (query.identifier ...) and uncomment the next line (query.mine ...).
    //query.mine = true;
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

// Process the response and display output
- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRYouTube_ChannelListResponse *)channels
                          error:(NSError *)error {
  
    if (error == nil) {
        NSMutableString *output = [[NSMutableString alloc] init];
        if (channels.items.count > 0) {
            [output appendString:@"Channel information:\n"];
            for (GTLRYouTube_Channel *channel in channels) {
                NSString *title = channel.snippet.title;
                NSString *description = channel.snippet.description;
                NSNumber *viewCount = channel.statistics.viewCount;
                [output appendFormat:@"Title: %@\nDescription: %@\nViewCount: %@\n", title, description, viewCount];
                NSLog(@"%@", output);
            }
        } else {
            [output appendString:@"Channel not found."];
        }
        self.output.text = output;
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}



// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"vc_to_search_by_searchbutton"])
    {
        ASSearchViewController *vc = [segue destinationViewController];
        vc.caller = self;
    }
    else if ([[segue identifier] isEqualToString:@"vc_to_player_by_cell"])
    {
        ASYoutubePlayerViewController *vc = [segue destinationViewController];
        ASVideoTableViewCell* cell = [self.tvVideos cellForRowAtIndexPath:[self.tvVideos indexPathForSelectedRow]];
        vc.dr = cell.dr;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.displayResults count] == 0) self.keyword = @"America";
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //id oldName = [change objectForKey:NSKeyValueChangeOldKey];
    //NSLog(@"oldName----------%@",oldName);
    //id newName = [change objectForKey:NSKeyValueChangeNewKey];
    //NSLog(@"newName-----------%@",newName);
    self.displayResults = [NSMutableArray<ASDisplayResult*> new];
    self.nextToken = nil;
    [self queryVideos];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

-(void) queryVideos
{
    GTLRYouTubeQuery_SearchList* query = [GTLRYouTubeQuery_SearchList queryWithPart:@"snippet"];
    query.maxResults = MAX_Search_Result;
    query.type = @"video";
    query.q = [self.keyword stringByReplacingOccurrencesOfString:@" " withString:@"+"];
   
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket_queryVideo:finishedWithObject:error:)];
    
   
}

-(void) queryVideos_nextToken
{
    GTLRYouTubeQuery_SearchList* query = [GTLRYouTubeQuery_SearchList queryWithPart:@"snippet"];
    query.maxResults = MAX_Search_Result;
    query.type = @"video";
    query.q = [self.keyword stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    query.pageToken = self.nextToken;
    
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket_nextToken:finishedWithObject:error:)];
    
    
}

- (void)displayResultWithTicket_nextToken:(GTLRServiceTicket *)ticket
              finishedWithObject:(GTLRYouTube_SearchListResponse *)searchLists
                           error:(NSError *)error {
    
    if (error == nil) {
        if (searchLists.items.count > 0) {
            for (GTLRYouTube_SearchResult* oneResult in searchLists.items)
            {
                [self appendWithOneSearchResult:oneResult];
            }
            
            self.nextToken = searchLists.nextPageToken;
            [self.tvVideos reloadData];
            
        } else {
            
        }
        
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}

-(void) appendWithOneSearchResult:(GTLRYouTube_SearchResult*) oneResult
{
    ASDisplayResult* dr = [ASDisplayResult new];
    dr.videoId = oneResult.JSON[@"id"][@"videoId"];
    dr.thumbnail = oneResult.JSON[@"snippet"][@"thumbnails"][@"high"][@"url"];
    dr.title = oneResult.JSON[@"snippet"][@"title"];
    dr.channelTitle = oneResult.JSON[@"snippet"][@"channelTitle"];
    [self.displayResults addObject:dr];
}

- (void)displayResultWithTicket_queryVideo:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRYouTube_SearchListResponse *)searchLists
                          error:(NSError *)error {
    
    if (error == nil) {
        if (searchLists.items.count > 0) {
            for (GTLRYouTube_SearchResult* oneResult in searchLists.items)
            {
                [self appendWithOneSearchResult:oneResult];
            }

            
            self.nextToken = searchLists.nextPageToken;
            [self.tvVideos reloadData];
            
            if ([self.displayResults count] != 0)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tvVideos scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
            [self.tvVideos layoutIfNeeded];
            
        } else {

        }

    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.displayResults count];
    //return INT_MAX;
    return 500;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASVideoTableViewCell* cell = [self.tvVideos dequeueReusableCellWithIdentifier:@"ASVideoTableViewCell"];
    if (!cell)
    {
        cell = [[ASVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ASVideoTableViewCell"];
    }
    
    ASDisplayResult* dr = nil;
    if ([self.displayResults count] - 1 >= indexPath.row)
    {
        dr = self.displayResults[indexPath.row];
    }
    [cell configure:dr];
    
    if (indexPath.row - 2 + MAX_Search_Result == [self.displayResults count])
    {
        [self queryVideos_nextToken];
    }
    
    return cell; 
}

@end






