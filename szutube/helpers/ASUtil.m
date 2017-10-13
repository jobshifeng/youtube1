//
//  ASUtil.m
//  szutube
//
//  Created by shifeng on 10/11/17.
//  Copyright © 2017 com.ossly. All rights reserved.
//

#import "ASUtil.h"

#define MinWidth 40
#define MinHeight 40

@implementation ASUtil

+(CGRect) checkTouchArea:(CGRect) rect
{
    if (rect.size.width < MinWidth || rect.size.height < MinHeight)
    {
        CGRect newRect = CGRectMake(rect.origin.x
                                    , rect.origin.y
                                    , MAX(rect.size.width, MinWidth)
                                    , MAX(rect.size.height, MinHeight));
        
        return newRect;
    }
    
    return rect;
}

@end
