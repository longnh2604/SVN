//
//  BaseCommentsTableViewController.h
//  NooPhuocThinh
//
//  Created by longnh on 1/5/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicTrackNew.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "DetailsCommentViewController.h"

@protocol BaseCommentsTableViewControllerDelegate<NSObject>

@optional

-(void) goToCommentsScreenViewControllerWithListData:(NSMutableArray *) listDataComments withIndexRow:(int) indexRow;
-(void) goToProfileScreenViewControllerByComment:(Comment *) aComment;

@end


@interface BaseCommentsTableViewController : UITableViewController
{
    NSMutableArray *listDataComments;
    NSMutableArray *avtArray;
    
    id<BaseCommentsTableViewControllerDelegate> delegateComments;
}

@property (nonatomic,retain) NSMutableArray *listDataComments;
@property (nonatomic,retain) NSMutableArray *avtArray;
@property (nonatomic,retain) NSString       *nodeId;

@property (nonatomic, assign) id <BaseCommentsTableViewControllerDelegate> delegateComments;

@end
