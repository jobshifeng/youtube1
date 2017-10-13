//
//  ASYoutubePlayer.m
//  szutube
//
//  Created by shifeng on 10/12/17.
//  Copyright © 2017 com.ossly. All rights reserved.
//

#import "ASYoutubePlayerViewController.h"

#import <ionicons/IonIcons.h>
#import "YTPlayerView.h"
#import "ASDisplayResult.h"

@interface ASYoutubePlayerViewController ()

@end

@implementation ASYoutubePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *icon = [IonIcons imageWithIcon:ion_close_circled iconColor:[UIColor blackColor]
                                   iconSize:40.0f
                                  imageSize:CGSizeMake(40.0f, 40.0f)];
    [self.btnClose setImage:icon forState:UIControlStateNormal];
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

-(IBAction) onClick_btnClose
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.dr)
    {
        [self.vPlayer loadWithVideoId:self.dr.videoId];
    }
}



@end
