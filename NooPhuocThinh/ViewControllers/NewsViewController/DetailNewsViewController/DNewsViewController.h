//
//  DNewsViewController.h
//  NooPhuocThinh
//
//  Created by longnh on 8/30/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "UIImageView+WebCache.h"
#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Utility.h"
#import "BaseViewController.h"
#import "Comment.h"
#import "Utility.h"
#import "CommentsNewsViewController.h"
#import "VMConstant.h"
#import "UIView+VMODEV.h"
#import "AppDelegate.h"
#import "OpenLinkViewController.h"
#import "ViewNewsDetail.h"

@interface DNewsViewController : BaseViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UIWebViewDelegate, CommentsNewsViewControllerDelegate,BaseViewControllerDelegate, UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    NSInteger                                   _currentTempIndex;
    NSInteger _currentFontSize; //-- text font into webview
    
//    __weak IBOutlet UIImageView                 *imgViewAvatar;
//    __weak IBOutlet UILabel                     *lblTitle;
//    __weak IBOutlet UILabel                     *lblDate;
//    __weak IBOutlet UILabel                     *lblShortContent;
//    __weak IBOutlet UILabel                     *lblCountComments;
//    __weak IBOutlet UIButton                    *btnShowComments;
    __weak IBOutlet UIWebView                   *webViewDetailNews;
    __weak IBOutlet UIToolbar                   *toolBarDetailNews;
    __weak IBOutlet UILabel                     *lblNumberOfLike;
    __weak IBOutlet UILabel                     *lblNumberOfComment;
    __weak IBOutlet UIButton                    *btnLikeNews;
    __weak IBOutlet UIView                      *viewToolBar;
//    __weak IBOutlet UIScrollView                *scrollViewDetailNews;
//    __weak IBOutlet UIScrollView                *scrollViewContainer;
    __weak IBOutlet UIView                      *viewShare;
    __weak IBOutlet UIView                      *viewBarShare; // container include: fb, sms, email ...
//    __weak IBOutlet UIView                      *viewHeader;
    __weak IBOutlet UIButton                    *btnHiddenViewShare;
    __weak IBOutlet ViewNewsDetail              *_viewNewsDetail;
//    ViewNewsDetail              *_currentNewsDetail;
    
    
    NSData                          *_cloneWebViewNewsDetail;   //-- copy webview
    BOOL                                        _isLike;
    BOOL                                        _isComment;
    BOOL                                        _isShare;
    BOOL                                        _isProcessSyncAPI;

}
@property (nonatomic, retain) UIPageViewController  *pageViewController;
@property (nonatomic, retain) News                  *news;
@property (nonatomic, retain) NSMutableArray        *arrNews;
@property (nonatomic, assign) NSInteger             indexOfNews;
@property (nonatomic, strong) NSMutableDictionary   *dictionaryLike;

//--Thoa add
@property (nonatomic, strong) NSMutableArray        *pageViews;
@property (nonatomic, assign) NSInteger             numberOfNews;

- (IBAction)clickBtnShowComments:(id)sender;
- (IBAction)clickBtnCommentForNews:(id)sender;
- (IBAction)clickBtnShareNews:(id)sender;
- (IBAction)clickBtnLikeNews:(id)sender;
- (IBAction)shareSMS:(id)sender;
- (IBAction)shareEmail:(id)sender;
- (IBAction)shareFacebook:(id)sender;
- (IBAction)hiddenViewShare:(id)sender;

@end
