//
//  ASVideoTableViewCell.m
//  szutube
//
//  Created by shifeng on 10/11/17.
//  Copyright © 2017 com.ossly. All rights reserved.
//

#import "ASVideoTableViewCell.h"

#import "ASDisplayResult.h"
#import "YTPlayerView.h"

@implementation ASVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.searchIndex = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configure : (ASDisplayResult*) aDr
{
    if (!aDr)
    {
        self.lblTitle.text = @"Coming soon";
        [self.ivIntroduction stopVideo];
        self.ivIntroduction.hidden = YES;
        return;
    }
    
    self.lblTitle.text = @"";
    self.ivIntroduction.hidden = YES;
    [self.ivIntroduction stopVideo];
    
    self.dr = aDr;
    self.lblTitle.text = [NSString stringWithFormat:@"%@ : %@", aDr.channelTitle, aDr.title];
    
    
    self.searchIndex ++;
    int currentSearchCount = self.searchIndex;

    __weak ASVideoTableViewCell* wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong ASVideoTableViewCell* sSelf = nil;
        if (wSelf)
        {
            sSelf = wSelf;
        }
        if (!sSelf) return;
        
        if (currentSearchCount == self.searchIndex)
        {
            /*
            NSString* urlString = self.dr.thumbnail;
            NSURL* url = [NSURL URLWithString:urlString];
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    UIImage* image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            sSelf.ivIntroduction.image = image;
                        });
                    }
                }
            }];
            [task resume];
             */
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.dr)
                {
                    [self.ivIntroduction loadWithVideoId:self.dr.videoId];
                }
            });
        }
    });
    
    self.ivIntroduction.hidden = NO; 
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.ivIntroduction.layer.borderWidth = 1.0f;
    self.ivIntroduction.layer.cornerRadius = 10;
    self.ivIntroduction.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ivIntroduction.clipsToBounds = YES;
}

@end
