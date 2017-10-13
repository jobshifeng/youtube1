//
//  ASVideoTableViewCell.h
//  szutube
//
//  Created by shifeng on 10/11/17.
//  Copyright © 2017 com.ossly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASDisplayResult;
@class YTPlayerView;

@interface ASVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet YTPlayerView *ivIntroduction;

@property (strong, nonatomic) ASDisplayResult* dr;
@property (nonatomic, assign) int searchIndex;

-(void) configure : (ASDisplayResult*) aDr;

@end
