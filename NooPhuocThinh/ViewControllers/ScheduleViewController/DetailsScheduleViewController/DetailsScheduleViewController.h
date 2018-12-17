//
//  DetailsScheduleViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/30/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "HMSegmentedControlOriginal.h"
#import "UIImageView+WebCache.h"
#import "VMDataBase.h"
#import "CustomCellDetailSchedule.h"
#import "CustomCellCommentSchedule.h"
#import "ScheduleListSinger.h"
#import "OpenLinkViewController.h"
#import "CommentsNewsViewController.h"
#import "Comment.h"
#import "DetailCommentsViewController.h"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface DetailsScheduleViewController : BaseViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate,BaseViewControllerDelegate, DetailCommentsViewControllerDelegate>
{
    //--for header
    IBOutlet UIButton                   *btnLiked;
    IBOutlet UIButton                   *btnShare;
    IBOutlet UILabel                    *lblNumberLike;
    IBOutlet UILabel                    *lblNumberComment;
    IBOutlet UILabel                    *lblCity;
    IBOutlet UIImageView                *imgCover;
    IBOutlet UILabel                    *lblNumberShare;
    IBOutlet UILabel                    *lblNumberView;
    IBOutlet UILabel                    *lblLiked;
    IBOutlet UILabel                    *lblAddress;
    IBOutlet UILabel                    *lblPhone;
    IBOutlet UIButton                   *btnMap;
    IBOutlet UILabel                    *lblTime;
    IBOutlet UIButton                   *btnComment;
    IBOutlet UIView                     *viewSegment;
    IBOutlet UIScrollView               *bigScrollview;
    
    //-- for scroll
    IBOutlet UIScrollView               *_scrollContainer;
    NSInteger                           _currentIndex;
    
    //-- segment
    HMSegmentedControlOriginal          *segmentedDetailSchedule;
    NSMutableArray                      *segmentArray;
    
    BOOL                                isInfo;
    BOOL                                isComment;
    BOOL                                _isAutoScroll;
    BOOL                                _isLike;
    BOOL                                _isComment;
    BOOL                                _isCheckScroll;
    
    CGFloat                             heightWebview;
    
    NSMutableArray                      *listSingerData;
    NSMutableArray                      *_arrCommentData;
    
    IBOutlet UIActivityIndicatorView    *_indicatorComment;
    
@private
    NSMutableArray                      *_listData;
    NSMutableArray                      *_queueH;
    NSCondition                         *_condition;
    CGFloat                             *_heightRow;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView      *activityIndicator;
@property (nonatomic, retain) IBOutlet UITableView                  *tableviewDetail;
@property (nonatomic, retain) IBOutlet UITableView                  *tableviewComment;
@property (strong, nonatomic) IBOutlet UIWebView                    *tempWebView;
@property (nonatomic, retain) IBOutlet UIView                       *viewInfo;
@property (nonatomic, retain) IBOutlet UIView                       *viewComment;

@property (nonatomic, retain) NSMutableArray                        *dataSourceSchedule;
@property (nonatomic, retain) NSMutableArray                        *dataSourceCell;
@property (nonatomic, retain) Schedule                              *schedule;
@property (nonatomic, retain) Comment                               *superComment;
@property (nonatomic, assign) NSInteger                             indexOfSchedule;

//@property (nonatomic, assign) CGFloat                               lastContentOffset; //hiepph

//-- Action
- (IBAction)clickToBtnLike:(id)sender;
- (IBAction)clickToBtnShare:(id)sender;
- (IBAction)clickToBtnComment:(id)sender;

@end
