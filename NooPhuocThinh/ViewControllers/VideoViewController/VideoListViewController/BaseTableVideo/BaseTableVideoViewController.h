//
//  BaseTableVideoViewController.h
//  NooPhuocThinh
//
//  Created by longnh on 1/3/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoAllModel.h"
#import "VideoForAll.h"
#import "VideoForCategory.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"

@protocol BaseTableVideoViewControllerDelegate<NSObject>

@optional

-(void) goToVideoPlayViewControllerWithListData:(NSMutableArray *) listData withVideoTypeId:(NSInteger) valueVideoTypeId withIndexRow:(int) indexRow;

@end

@interface BaseTableVideoViewController : UITableViewController
{
    NSMutableArray *listData;
    id<BaseTableVideoViewControllerDelegate> delegateVideo;
}

@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, assign) NSInteger     videoTypeId;

@property (nonatomic, assign) id <BaseTableVideoViewControllerDelegate> delegateVideo;

@end
