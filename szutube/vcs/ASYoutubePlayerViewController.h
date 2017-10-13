//
//  ASYoutubePlayer.h
//  szutube
//
//  Created by shifeng on 10/12/17.
//  Copyright © 2017 com.ossly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@class YTPlayerView;
@class ASDisplayResult;

@interface ASYoutubePlayerViewController : UIViewController <YTPlayerViewDelegate>

@property (nonatomic, weak) IBOutlet YTPlayerView* vPlayer;
@property (nonatomic, weak) IBOutlet UIButton* btnClose;

@property (nonatomic, strong) ASDisplayResult* dr;

-(IBAction) onClick_btnClose;

@end
