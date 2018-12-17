//
//  BaseViewController.m
//  NooPhuocThinh
//
//  Created by Thuy Dao on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "InviteFriendViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize myAccount, delegateBaseController;
@synthesize notice,noticeSuccess, arrCommentData;
@synthesize timerRequest,timerRequestErrorNetwork;

NSInteger countRequestErrorNetwork = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

/*
 * Method Bottom Bar
 */

-(void) addBottomBarBaseViewController {
    
//    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    [dataCenter addBottomBar];
}

-(void) removeBottomBarBaseViewController {
    
//    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    [dataCenter removeBottomBar];
}

-(BOOL) checkBottomBarExistBaseViewController {
    
//    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    [dataCenter checkExistBottomBar];
}

/*
 * Method SlideBar Bottom
 */

-(void) addSlideBarBaseViewController {
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [dataCenter addSlideBarBottom];
}

-(void) removeSlideBarBaseViewController {
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [dataCenter removeSlideBarBottom];
}


/*
 * Method setTitle (override)
 */

- (void)setTitle:(NSString *)title
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    
    if(![title isEqualToString: @"LD"])
    {
        if (!titleView) {
            titleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 500.0f, 40.0f)];
            
            [titleView setBackgroundColor:[UIColor clearColor]];
            
            titleView.font = [UIFont systemFontOfSize:18.0];
            titleView.textColor = [UIColor whiteColor];
            titleView.textAlignment = UITextAlignmentLeft;
            self.navigationItem.titleView = titleView;
        }
        strTitle = title;
        titleView.text = title;
        [titleView sizeToFit];
        
        [self.navigationController.navigationBar setBackgroundImage:nil
                                                      forBarMetrics:UIBarMetricsDefault];
        
        UIImage *navBackgroundImage = [self imageWithColor:[UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0]];
        [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else if([title isEqualToString: @"LD"])
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.opaque = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad
{
    //    NSLog(@"%s", __func__);
    [super viewDidLoad];
    
    checkTabValue = 0;
    //    self.navigationController.navigationBarHidden = NO;
    //    [self.navigationController setToolbarHidden:YES animated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //    NSLog(@"%s", __func__);
    [super viewWillAppear:animated];
    
    // ThuyDao : setbackground navigation bar
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"imgNavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    //
    //    // ThuyDao : setbackground
    //    UIImage *imgage = [UIImage imageNamed:@"background.png"];
    //    [imvBackgorund setImage:imgage];
    //     imvBackgorund.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 * Method setupBackButton
 */

- (void)setupBackButton
{
    UIButton *btnLeft= [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(0, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
}


#pragma mark - Error Notice Network
-(void) showConnectionError {
    notice = [WBErrorNoticeView errorNoticeInView:self.view title:TITLE_NETWORK_ERROR message:TITLE_CHECK_NETWORK_ERROR];
    notice.sticky = NO;
    [notice showNoticeWithOffset:-1];
}

//-- show alert Check Network
-(BOOL) checkAndShowErrorNoticeNetwork {
    
    notice = [WBErrorNoticeView errorNoticeInView:self.view title:TITLE_NETWORK_ERROR message:TITLE_CHECK_NETWORK_ERROR];
    
    NSUserDefaults *defaultNotice = [NSUserDefaults standardUserDefaults];
    BOOL isShowNotice = [defaultNotice boolForKey:@"ShowNoticeNooPhuocThinh"];
    
    //-- alloc+init and start an NSURLConnection; release on completion/failure
    if (![Utility checkNetWork]) {
        
        if (!isShowNotice) {
            
            //-- show alert Check Network
            notice.sticky = NO;
            [notice showNoticeWithOffset:-1];
        }
        
        return NO;
        
    }else {
        
        //-- dismiss alert Check Network
        [notice dismissNotice];
        
        return YES;
    }
}


//-- show notification Failed
-(void) showNotificationFailed {
    
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork)
    {
        NSUserDefaults *defaultNotice = [NSUserDefaults standardUserDefaults];
        BOOL isShowNotice = [defaultNotice boolForKey:@"ShowNoticeNooPhuocThinh"];
        
        if (!isShowNotice) {
            
            noticeSuccess = [WBSuccessNoticeView successNoticeInView:self.view title:@"Bài hát đã bị lỗi không thể thực hiện."];
            [noticeSuccess show];
        }
    }
}

//-- play song again when error network
-(void) callRequestErrorNetwork {
    
    if (countRequestErrorNetwork == 0) {
        
        countRequestErrorNetwork ++;
        
        if (![Utility checkNetWork]) {
            
            [timerRequestErrorNetwork invalidate];
            totalTimerRequestErrorNetwork = 0;
            
            timerRequestErrorNetwork = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(callPlaySongAgainWhenErrorNetwork) userInfo:nil repeats:YES];
        }
    }
}

-(void) callPlaySongAgainWhenErrorNetwork {
    
    totalTimerRequestErrorNetwork += [timerRequestErrorNetwork timeInterval];
    
    if (totalTimerRequestErrorNetwork <= 36.0) {
        
        if (![[AudioPlayer sharedAudioPlayerMusic] streamer] && [Utility checkNetWork]) {
            
            [[AudioPlayer sharedAudioPlayerMusic] play];
            
            //-- stop timer
            [timerRequestErrorNetwork invalidate];
            totalTimerRequestErrorNetwork = 0;
            countRequestErrorNetwork = 0;
        }
        
    }else {
        
        [timerRequestErrorNetwork invalidate];
        totalTimerRequestErrorNetwork = 0;
        countRequestErrorNetwork = 0;
    }
}

//-- show lable no data
-(void) addLableNoDataTo:(UIScrollView *)scrollview withIndex:(NSInteger) index withFrame:(CGRect) frameLable {
    
    UILabel *lblNodata = [[UILabel alloc] initWithFrame:frameLable];
    lblNodata.tag = index;
    lblNodata.backgroundColor = [UIColor clearColor];
    lblNodata.textColor = [UIColor blackColor];
    lblNodata.textAlignment = UITextAlignmentCenter;
    lblNodata.lineBreakMode = NSLineBreakByWordWrapping;
    lblNodata.numberOfLines = 0;
    lblNodata.text = TITLE_NoData_Default;
    
    [scrollview addSubview:lblNodata];
}

//-- show lable no shoutbox
-(void) addLableNoShoutboxTo:(UIScrollView *)scrollview withIndex:(NSInteger) index withFrame:(CGRect) frameLable {
    
    UILabel *lblNodata = [[UILabel alloc] initWithFrame:frameLable];
    lblNodata.tag = index;
    lblNodata.backgroundColor = [UIColor clearColor];
    lblNodata.textColor = [UIColor whiteColor];
    lblNodata.textAlignment = UITextAlignmentCenter;
    lblNodata.lineBreakMode = NSLineBreakByWordWrapping;
    lblNodata.numberOfLines = 0;
    lblNodata.text = TITLE_NoCommentFanZone_Default;
    
    [scrollview addSubview:lblNodata];
}

//-- remove lable no data
-(void) removeLableNoDataFrom:(UIScrollView *)scrollview withIndex:(NSInteger) index {
    
    for (UIView *lblNadata in scrollview.subviews) {
        
        if ([lblNadata isKindOfClass:[UILabel class]] && lblNadata.tag == index) {
            
            [lblNadata removeFromSuperview];
            break;
        }
    }
}

//-- show lable no data
-(void) addLableNoDataToTableView:(UITableView *)tableview withIndex:(NSInteger) index withFrame:(CGRect) frameLable byTitle:(NSString *) titleData {
    
    UILabel *lblNodata = [[UILabel alloc] initWithFrame:frameLable];
    lblNodata.tag = index;
    lblNodata.backgroundColor = [UIColor clearColor];
    lblNodata.textColor = [UIColor whiteColor];
    lblNodata.textAlignment = UITextAlignmentCenter;
    lblNodata.lineBreakMode = NSLineBreakByWordWrapping;
    lblNodata.numberOfLines = 0;
    lblNodata.text = titleData;
    
    [tableview addSubview:lblNodata];
}

//-- remove lable no data
-(void) removeLableNoDataFromTableView:(UITableView *)tableview withIndex:(NSInteger) index {
    
    for (UIView *lblNadata in tableview.subviews) {
        
        if ([lblNadata isKindOfClass:[UILabel class]] && lblNadata.tag == index) {
            
            [lblNadata removeFromSuperview];
            break;
        }
    }
}


#pragma mark - layout comment + share + like

/*
 * Method createViewCSL
 */

- (UIView*)createViewCSL:(CGRect)frame
{
    CGFloat y = 3;
    CGFloat w = 24;
    CGFloat h = 24;
    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
    view.userInteractionEnabled = YES;
    [view setImage:[UIImage imageNamed:@"bg_green.png"]];
    
    UIButton *btnComment = [[UIButton alloc] initWithFrame:CGRectMake(10, y, w, h)];
    [btnComment setImage:[UIImage imageNamed:@"icon_comments.png"] forState:UIControlStateNormal];
    [btnComment addTarget:self action:@selector(clickCommentCSL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(97, y, w, h)];
    [btnShare setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(clickShareCSL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnLike = [[UIButton alloc] initWithFrame:CGRectMake(290, y, w, h)];
    [btnLike setImage:[UIImage imageNamed:@"icon_like.png"] forState:UIControlStateNormal];
    [btnLike addTarget:self action:@selector(clickLikeCSL:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview:btnComment];
    [view addSubview:btnLike];
    [view addSubview:btnShare];
    
    return view;
}

- (void)clickCommentCSL:(id)sender
{
    DLog(@"");
}

- (void)clickShareCSL:(id)sender
{
    DLog(@"");
}

- (void)clickLikeCSL:(id)sender
{
    DLog(@"");
}

- (void)back:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}

/*
 * Method addViewCSLWithFrame:frame
 */

- (void)addViewCSLWithFrame:(CGRect)frame
{
    UIView *view = [self createViewCSL:frame];
    [imvBackgorund addSubview:view];
}


#pragma mark - Share Facebook

- (void) shareFacebookWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)urlLink imagePath:(NSString *)imagePath contentId:(NSString*)contentId contentTypeId:(NSString*)contentTypeId
{
    NSLog(@"%s", __func__);
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    FBShareDialogParams *params =[FBShareDialogParams new];
    params.link = [NSURL URLWithString:urlLink];
    params.picture = [NSURL URLWithString:imagePath];
    params.name = title;
    params.caption = nil;
    //    params.description = content;
    
    if ([FBDialogs canPresentShareDialogWithParams:params])
    {
        [FBDialogs presentShareDialogWithParams:params
                                    clientState:nil
                                        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                            if (error)
                                            {
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lỗi" message:[NSString stringWithFormat:@"Không thể chia sẻ Facebook. Do \"%@\"",[error localizedDescription] ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [alert show];
                                            }else{
                                                if (userId)
                                                    [self callAPISyncData:kTypeShare text:nil contentId:contentId contentTypeId:contentTypeId commentId:nil];
                                            }
                                            
                                            // call Facebook 's iOS 6 integration
                                            if (call == nil)
                                            {
                                                [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                                         initialText:title
                                                                                               image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]]
                                                                                                 url:[NSURL URLWithString:urlLink]
                                                                                             handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                                                                                                 
                                                                                                 if (result == FBOSIntegratedShareDialogResultError) {
                                                                                                     if (error!=nil) {
                                                                                                         NSLog(@"[Facebook 's iOS 6 integration] the dialog could not be shown - %@", [error localizedDescription]);
                                                                                                     }
                                                                                                 }
                                                                                                 else if (result ==FBOSIntegratedShareDialogResultCancelled)
                                                                                                 {
                                                                                                     NSLog(@"[Facebook 's iOS 6 integration] dialog action was cancelled");
                                                                                                 }
                                                                                                 else
                                                                                                 {
                                                                                                     NSLog(@"the dialog action completed successfully");
                                                                                                     
                                                                                                 }
                                                                                                 
                                                                                                 
                                                                                             }];
                                                
                                                
                                            }
                                            
                                            
                                        }];
        
        
    }
    else
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       KEY_FB_APP_ID, @"app_id",
                                       title, @"name",
                                       content,@"description",
                                       urlLink, @"link",
                                       imagePath,@"picture",
                                       nil];
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      // handle response or error
                                                      if (error)
                                                      {
                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lỗi" message:[NSString stringWithFormat:@"Lỗi do: %@", [error localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                          [alert show];
                                                      }else{
                                                          //NSLog(@"Share FB Success!");
                                                          if (userId)
                                                              [self callAPISyncData:kTypeShare text:nil contentId:contentId contentTypeId:contentTypeId commentId:nil];
                                                      }
                                                      
                                                      if (result==FBWebDialogResultDialogNotCompleted)
                                                      {
                                                          // NSLog(@"User canceled story publishing");
                                                      }
                                                      else
                                                      {
                                                          // Handle the puslish feed callback
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          if (![urlParams valueForKey:@"post_id"])
                                                          {
                                                              // User clicked the Cancel button
                                                              //NSLog(@"User canceled story publishing.");
                                                          }
                                                          else
                                                          {
                                                              // User clicked the Share button
                                                              NSString *msg = [NSString stringWithFormat:
                                                                               @"Posted story, id: %@",
                                                                               [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"%@", msg);
                                                              
                                                          }
                                                      }
                                                      
                                                  }];
        
        
    }
}

#pragma mark - Api data view

- (void) apiDataView:(NSString *)contentId contentTypeId:(NSString *)contentTypeId
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        [self callAPISyncData:kTypeView text:nil contentId:contentId contentTypeId:contentTypeId commentId:nil];
    }
}


/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


#pragma mark - WebViewPurview

//-- show webview Dieu Le
-(void) addWebviewPurview {
    
    NSArray *objectLevelTop = [[NSBundle mainBundle] loadNibNamed:@"BaseViewController" owner:nil options:nil];
    
    viewPurview = [objectLevelTop objectAtIndex:1];
    viewPurview.frame = CGRectMake(0, 0, 320, 568);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *messageUpgradeUser = [userDefaults valueForKey:TITLE_Message_Trailer_Info];
    
    //-- validate content
    NSString *tempMessage = [messageUpgradeUser stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereAreJustSpaces = [tempMessage isEqualToString:@""];
    
    if(thereAreJustSpaces || [messageUpgradeUser length] == 0)
        messageUpgradeUser = TITLE_UpdateUserVip;
    
    
    //-- show meesage feedback
    viewPurview.lblTitle.text = kTitleMessageApp;
    viewPurview.txtMessage.text = messageUpgradeUser;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        //-- set Strikethrough for Label
        NSDictionary* attributes = @{ NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
        
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:@"Tôi đồng ý mọi điều khoản sử dụng dịch vụ." attributes:attributes];
        viewPurview.lblToiDongY.attributedText = attrText;
    }
    
    //-- set action to button
    [viewPurview.btnDongY addTarget:self action:@selector(CreateSMSRegister) forControlEvents:UIControlEventTouchUpInside];
    [viewPurview.btnHuy addTarget:self action:@selector(cancelSMSRegister) forControlEvents:UIControlEventTouchUpInside];
    [viewPurview.btnCheckBox addTarget:self action:@selector(selectedButtonCheckBox:) forControlEvents:UIControlEventTouchUpInside];
    [viewPurview.btnlinkWebview addTarget:self action:@selector(selectedButtonOpenWebview:) forControlEvents:UIControlEventTouchUpInside];
    
    //-- enable/disable button Dong y
    [self checkValidatePurview];
    
    CGRect frameViewDK = [viewPurview.viewDieuKhoan frame];
    CGRect frameBtnDY = [viewPurview.btnDongY frame];
    CGRect frameBtnHuy = [viewPurview.btnHuy frame];
    
    if ([self checkFreeAppAndCreateAccount] == YES) {
        
        viewPurview.lblToiDongY.text = @"";
        viewPurview.btnCheckBox.hidden = YES;
        viewPurview.btnlinkWebview.hidden = YES;
        
        frameViewDK.size.height = 185;
        [viewPurview.viewDieuKhoan setFrame:frameViewDK];
        
        frameBtnDY.origin.y = 147;
        [viewPurview.btnDongY setFrame:frameBtnDY];
        
        frameBtnHuy.origin.y = 147;
        [viewPurview.btnHuy setFrame:frameBtnHuy];
        
    }else {
        
        viewPurview.btnCheckBox.hidden = NO;
        viewPurview.btnlinkWebview.hidden = NO;
        
        frameViewDK.size.height = 247;
        [viewPurview.viewDieuKhoan setFrame:frameViewDK];
        
        frameBtnDY.origin.y = 208;
        [viewPurview.btnDongY setFrame:frameBtnDY];
        
        frameBtnHuy.origin.y = 208;
        [viewPurview.btnHuy setFrame:frameBtnHuy];
    }
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSUserDefaults *defaultCenter = [NSUserDefaults standardUserDefaults];
    [defaultCenter setBool:YES forKey:@"SetShowPopupUpdateLevel"];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [dataCenter.window addSubview:viewPurview];
                     }
                     completion:^(BOOL finished)
     {
         
     }];
    
    [defaultCenter synchronize];
}

-(void) checkValidatePurview {
    
    if (viewPurview.btnCheckBox.currentImage == [UIImage imageNamed:@"generic_chkbox_no.png"]) {
        
        //-- disable when not checkbox
        [viewPurview.btnDongY setEnabled:NO];
        viewPurview.btnDongY.titleLabel.textColor = [UIColor grayColor];
    }else {
        
        //-- disable when not checkbox
        [viewPurview.btnDongY setEnabled:YES];
        viewPurview.btnDongY.titleLabel.textColor = [UIColor whiteColor];
    }
}

-(IBAction)selectedButtonCheckBox:(id)sender {
    
    if (viewPurview.btnCheckBox.currentImage == [UIImage imageNamed:@"generic_chkbox_no.png"]) {
        
        [viewPurview.btnCheckBox setImage:[UIImage imageNamed:@"generic_chkbox_yes.png"] forState:UIControlStateNormal];
    }else {
        
        [viewPurview.btnCheckBox setImage:[UIImage imageNamed:@"generic_chkbox_no.png"] forState:UIControlStateNormal];
    }
    
    //-- enable/disable button Dong y
    [self checkValidatePurview];
}

-(IBAction)selectedButtonOpenWebview:(id)sender {
    
    NSURL *urlDieuLe = [NSURL URLWithString:URL_DieuKhoan];
    [[UIApplication sharedApplication] openURL:urlDieuLe];
}


-(void)cancelSMSRegister {
    
    NSUserDefaults *defaultCenter = [NSUserDefaults standardUserDefaults];
    [defaultCenter setBool:NO forKey:@"SetShowPopupUpdateLevel"];
    [defaultCenter synchronize];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [viewPurview removeFromSuperview];
                     }
                     completion:^(BOOL finished)
     {
         
     }
     ];
}

-(void)CreateSMSRegister {
    
    //-- remove webview Purview
    [self cancelSMSRegister];
    
    //-- nâng cấp user
    [self createAccount];
}


#pragma mark - post comments

-(void)showDialogComments:(CGPoint)point title:(NSString *)title
{
    NSArray *objectLevelTop = [[NSBundle mainBundle] loadNibNamed:@"BaseViewController" owner:nil options:nil];
    
    _viewComments = [objectLevelTop objectAtIndex:0];
    _viewComments.frame = CGRectMake(0, 0, 320, 350);
    
    _viewComments.titleComment.text = title;
    [_viewComments.btnCancelComment addTarget:self action:@selector(cancelComment) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewComments.btnPostComment addTarget:self action:@selector(postComment) forControlEvents:UIControlEventTouchUpInside];
    
    _viewComments.viewContainerComment.layer.borderColor     = [UIColor whiteColor].CGColor;
    _viewComments.viewContainerComment.layer.borderWidth     = 1;
    _viewComments.viewContainerComment.layer.cornerRadius     = 10;
    
    //--
    _txtComment = _viewComments.textComment;
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_txtComment becomeFirstResponder];
                         [self.navigationController setNavigationBarHidden:YES];
                         [self.view addSubview:_viewComments];
                     }
                     completion:^(BOOL finished)
     {
         
     }];
}

-(void)cancelComment
{
    [_txtComment resignFirstResponder];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.navigationController setNavigationBarHidden:NO];
                         [_viewComments removeFromSuperview];
                     }
                     completion:^(BOOL finished)
     {
         
     }
     ];
    
    DLog(@"Cancel comments");
}

-(void)postComment
{
    [_txtComment resignFirstResponder];
    
    //[self api]
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.navigationController setNavigationBarHidden:NO];
                         [_viewComments removeFromSuperview];
                     }
                     completion:^(BOOL finished)
     {
         
     }];
    DLog(@"Post comments");
    
    //longnh add
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"post_comment"  // Event action (required)
                                                           label:nil
                                                           value:nil] build]];
    
    
}

-(NSString *)getContentOfComment
{
    NSString *content = @"";
    
    if ([self checkContentOfComment:_txtComment.text] == NO) {
        content = @"";
    }else{
        content = _txtComment.text;
    }
    
    
    return content;
}

//-- validate MusicPath
- (BOOL)checkContentOfComment:(NSString *)contentComment
{
    //-- validate content
    NSString *tempComment = [contentComment stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereAreJustSpaces = [tempComment isEqualToString:@""];
    
    if(!thereAreJustSpaces)
        return YES;
    else
        return NO;
}

-(void)setDelagateForTextComment:(id)delegate
{
    if (delegate)
        _txtComment.delegate = delegate;
}



#pragma mark - Sync Like Comment

- (bool)callAPISyncData:(NSInteger)typeSync text:(NSString*)text contentId:(NSString *)contentId contentTypeId:(NSString *)contentTypeId commentId:(NSString*)commentId
{
    NSLog(@"%s", __func__);
    //-- check Network
    //[self loadHTMLString:newsInfo.body forWebView:newViewMain.webViewNewsDetail];
    NSUserDefaults *defaultNotice = [NSUserDefaults standardUserDefaults];
    [defaultNotice setBool:NO forKey:@"ShowNoticeNooPhuocThinh"];
    [defaultNotice synchronize];
    
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) {
        [[SHKActivityIndicator currentIndicator] hide];
        return false;
    }
    //-- create JSON
    NSString *jSonData = @"";
    
    //-- Make all note of items
    NSMutableArray *paraKeyItem = [self getListParaKeyOfItem:typeSync];
    NSMutableArray *paraArrItem = [[NSMutableArray alloc]init];

    NSMutableArray *paraTempArrItem = [self getListParaArray:typeSync text:text contentId:contentId contentTypeId:contentTypeId commentId:commentId];
    paraArrItem = paraTempArrItem;
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjects:paraArrItem forKeys:paraKeyItem];
    
    jSonData = [jSonData stringByAppendingString:[NSString stringWithFormat:@"%@",[paraDict JSONFragment]]];
    
    NSString *dataTypeString = @"";
    
    if (typeSync == kTypeComment) {
        dataTypeString = @"data_comment";
    }
    
    if (typeSync == kTypeLike) {
        dataTypeString = @"data_like";
    }
    
    if (typeSync == kTypeUnLike) {
        dataTypeString = @"data_unlike";
    }
    
    if (typeSync == kTypeView) {
        dataTypeString = @"data_view";
    }
    
    if (typeSync == kTypeShare) {
        dataTypeString = @"data_share";
    }
    
    if (typeSync == kTypeFeed) {
        dataTypeString = @"data_comment_feed";
    }
    
    jSonData = [NSString stringWithFormat:@"[%@]",jSonData];
    
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userIdStr) {
        //[[SHKActivityIndicator currentIndicator] hide];
        //return;
        [API syncData:userIdStr
               pageId:SINGER_ID
             dataSync:jSonData
             dataType:dataTypeString
         productionId:PRODUCTION_ID
    productionVersion:PRODUCTION_VERSION
            completed:^(NSDictionary *responseDictionary, NSError *error) {
                
                bool isSuccess = false;
                NSString *errorCode = [[[responseDictionary objectForKey:@"error"] objectForKey:@"error_code"] stringValue];
                if (error || (errorCode && (![errorCode isEqualToString:@"200"]))) {
                    NSLog(@"Loi synData %@", (error ? [error description] : errorCode));
                }
                else {
                    if (![errorCode isEqualToString:@"200"]) {
                        //-- set id for comment at local
                        NSDictionary   *dictData          = [responseDictionary objectForKey:@"data"];
                        NSString *userPoint = [dictData objectForKey:@"user_point"];
                        
                        //-- save user_point
                        [Profile sharedProfile].point = userPoint;
                        
                        //--  delegate
                        if (self.delegateBaseController && [self.delegateBaseController respondsToSelector:@selector(syncDataSuccessDelegate:)]) {
                            
                            [self.delegateBaseController syncDataSuccessDelegate:responseDictionary];
                        }
                        isSuccess = true;
                    }else{
                        
                        if (typeSync == kTypeLike) {
                            
                            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"Nội dung này đã được bạn like từ trước" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alertview show];
                        }
                        
                        if ([contentTypeId isEqualToString:TYPE_ID_FANPAGE]) {
                            
                            //--  delegate
                            if (self.delegateBaseController && [self.delegateBaseController respondsToSelector:@selector(syncDataSuccessDelegate:)]) {
                                
                                [self.delegateBaseController syncDataSuccessDelegate:responseDictionary];
                            }
                        }
                    }
                }
                [[SHKActivityIndicator currentIndicator] hide];
                if (self.delegateBaseController && [self.delegateBaseController respondsToSelector:@selector(notifyReceiveSyncAPIResponse:)])
                    [self.delegateBaseController notifyReceiveSyncAPIResponse:isSuccess];
                
                [self checkAndShowErrorNoticeNetwork];
            }];
        
    }else{
        [[SHKActivityIndicator currentIndicator] hide];
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
        return false;
    }
    return true;
}


- (NSMutableArray *)getListParaKeyOfItem:(NSInteger)typeSync
{
    NSLog(@"%s", __func__);
    NSMutableArray *paraKey = [[NSMutableArray alloc] init];
    
    if (typeSync == kTypeComment)
    {
        [paraKey addObject:@"content_id"];
        [paraKey addObject:@"content_type_id"];
        [paraKey addObject:@"comment_id"];
        [paraKey addObject:@"text"];
        [paraKey addObject:@"time_stamp"];
    }
    else if (typeSync == kTypeFeed)
    {
        [paraKey addObject:@"comment_id"];
        [paraKey addObject:@"item_id"];
        [paraKey addObject:@"content_type_id"];
        [paraKey addObject:@"content"];
        [paraKey addObject:@"parent_user_id"];
        [paraKey addObject:@"owner_user_id"];
        [paraKey addObject:@"time"];
    }
    else
    {
        [paraKey addObject:@"content_id"];
        [paraKey addObject:@"content_type_id"];;
        [paraKey addObject:@"time_stamp"];
    }
    
    return paraKey;
}


- (NSMutableArray *)getListParaArray:(NSInteger)typeSync text:(NSString *)text contentId:(NSString*)contentId contentTypeId:(NSString *)contentTypeId commentId:(NSString *)commentId
{
    NSLog(@"%s", __func__);
    NSMutableArray *paraArr = [[NSMutableArray alloc] init];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (userId==nil)
        userId=@"";
    else {
        if ([userId isKindOfClass:[NSString class]]) {
            if ([userId length] == 0)
                userId = @"";
        }
        else {
            userId = @"";
        }
    }
    
    if ([contentTypeId isEqualToString:TYPE_ID_NEWS])
    {
        contentTypeId = @"blog";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_PHOTO])
    {
        contentTypeId = @"photo";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_PHOTO_ALBUM])
    {
        contentTypeId = @"photo_album";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_MUSIC_SONG])
    {
        contentTypeId = @"music_song";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_MUSIC_ALBUM])
    {
        contentTypeId = @"music_album";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_EVENT])
    {
        contentTypeId = @"event";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_VIDEO])
    {
        contentTypeId = @"video";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_FEED_PAGE])
    {
        contentTypeId = @"pages_comment";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_FEED_LINK])
    {
        contentTypeId = @"link";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_FEED_PHOTO])
    {
        contentTypeId = @"photo";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_VIDEO])
    {
        contentTypeId = @"video";
    }
    
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%ld",(long)timeStamp];
    
    if (typeSync == kTypeComment)
    {
        [paraArr addObject:contentId];
        [paraArr addObject:contentTypeId];
        [paraArr addObject:commentId];
        [paraArr addObject:text];
        [paraArr addObject:timeString];
    }
    else if (typeSync == kTypeFeed)
    {
        [paraArr addObject:@""];
        [paraArr addObject:contentId];
        [paraArr addObject:contentTypeId];
        [paraArr addObject:text];
        [paraArr addObject:@"1"];
        [paraArr addObject:userId];
        [paraArr addObject:timeString];
    }
    else
    {
        [paraArr addObject:contentId];
        [paraArr addObject:contentTypeId];
        [paraArr addObject:timeString];
    }
    
    return paraArr;
}

#pragma mark - Get data Comment

- (void)callApiGetDataComment:(NSString*)singerId contentId:(NSString*)contentId contentTypeId:(NSString*)contentTypeId commentId:(NSString*)commentId getCommentOfComment:(NSString*)getCommentOfComment
{
    NSLog(@"%s", __func__);
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) return;
    
    [API getCommentData:singerId
              contentId:contentId
          contentTypeId:contentTypeId
              commentId:commentId
    getCommentOfComment:getCommentOfComment
           productionId:PRODUCTION_ID
      productionVersion:PRODUCTION_VERSION
              completed:^(NSDictionary *responseDictionary, NSError *error)
    {
                  NSLog(@"getCommentData: %@", responseDictionary);
                  
                  [self createDataSourceDataComment:responseDictionary];
              }];
}

- (void)callApiGetFeedDataComment:(NSString*)singerId contentId:(NSString*)contentId contentTypeId:(NSString*)contentTypeId commentId:(NSString*)commentId getCommentOfComment:(NSString*)getCommentOfComment
{
    NSLog(@"%s", __func__);
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) return;

    [API getCommentDataFeed:singerId
               productionId:PRODUCTION_ID
          productionVersion:PRODUCTION_VERSION
              contentTypeId:contentTypeId
                  contentId:contentId
                  commentId:commentId
               isGetComment:getCommentOfComment
                     isFeed:@"1"
                  completed:^(NSDictionary *responseDictionary, NSError *error)
    {
        NSLog(@"getCommentData: %@", responseDictionary);
        [self createDataSourceFeedComment:responseDictionary];
    }];
}

-(void)createDataSourceFeedComment:(NSDictionary *)aDictionary
{
    NSLog(@"%s", __func__);
    NSMutableArray *arrComment = [aDictionary objectForKey:@"data"];

    self.arrCommentData = [[NSMutableArray alloc] init];

    if (arrComment.count > 0)
    {
        for (NSInteger i = 0; i < [arrComment count]; i++)
        {
            Comment *comment = [[Comment alloc] init];

            Profile *profile = [[Profile alloc] init];

            profile.userId = [[arrComment objectAtIndex:i] objectForKey:@"user_id"];
            profile.fullName = [[arrComment objectAtIndex:i] objectForKey:@"full_name"];
            profile.point = [NSString stringWithFormat:@"%@",[[arrComment objectAtIndex:i] objectForKey:@"user_point"]];;
            profile.userImage = [[arrComment objectAtIndex:i] objectForKey:@"user_image"];
            profile.facebookURL = [[arrComment objectAtIndex:i] objectForKey:@"facebook_url"];
            profile.facebookId = [[arrComment objectAtIndex:i] objectForKey:@"facebook_id"];

            comment.commentId = [[arrComment objectAtIndex:i] objectForKey:@"comment_id"];
            comment.numberOfSubcommments = [[arrComment objectAtIndex:i] objectForKey:@"child_total"];
            comment.content = [[arrComment objectAtIndex:i] objectForKey:@"text"];
            comment.timeStamp = [[arrComment objectAtIndex:i] objectForKey:@"time_stamp"];
            comment.profileUser = profile;
            comment.arrSubComments = [NSMutableArray new];

            [self.arrCommentData addObject:comment];
        }
    }


    //--  delegate
    if (self.delegateBaseController && [self.delegateBaseController respondsToSelector:@selector(passCommentsDelegate:)])
    {
        [self.delegateBaseController passCommentsDelegate:self.arrCommentData];
    }
}

- (void)createDataSourceDataComment:(NSDictionary *)dictComment
{
    NSLog(@"%s", __func__);
    NSMutableArray *arrComment = [dictComment objectForKey:@"data"];
    
    self.arrCommentData = [[NSMutableArray alloc] init];
    
    if (arrComment.count > 0) {
        for (NSInteger i = 0; i < [arrComment count]; i++) {
            Comment *comment = [[Comment alloc] init];
            
            Profile *profile = [[Profile alloc] init];
            
            profile.userId = [[arrComment objectAtIndex:i] objectForKey:@"user_id"];
            profile.fullName = [[arrComment objectAtIndex:i] objectForKey:@"full_name"];
            profile.point = [NSString stringWithFormat:@"%@",[[arrComment objectAtIndex:i] objectForKey:@"user_point"]];;
            profile.userImage = [[arrComment objectAtIndex:i] objectForKey:@"user_image"];
            profile.facebookURL = [[arrComment objectAtIndex:i] objectForKey:@"facebook_url"];
            profile.facebookId = [[arrComment objectAtIndex:i] objectForKey:@"facebook_id"];
            
            comment.commentId = [[arrComment objectAtIndex:i] objectForKey:@"comment_id"];
            comment.numberOfSubcommments = [[arrComment objectAtIndex:i] objectForKey:@"child_total"];
            comment.content = [[arrComment objectAtIndex:i] objectForKey:@"text"];
            comment.timeStamp = [[arrComment objectAtIndex:i] objectForKey:@"time_stamp"];
            comment.profileUser = profile;
            comment.arrSubComments = [NSMutableArray new];
            
            [arrCommentData addObject:comment];
        }
    }
    
    
    //--  delegate
    if (self.delegateBaseController && [self.delegateBaseController respondsToSelector:@selector(passCommentsDelegate:)]) {
        
        [self.delegateBaseController passCommentsDelegate:arrCommentData];
    }
}



#pragma mark - Facebook

/*
 * create account with infomations from Facebook, include 4 steps
 */

-(void) createAccount
{
    NSLog(@"%s", __func__);
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    
    if (isErrorNetWork) {
        
        //-- create new session of Facebook to call api
        [self createSession];
    }
}

/*
 * step 1: create session
 */

-(void)createSession
{
    NSLog(@"%s", __func__);
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
    
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"basic_info", @"user_birthday", @"email"];
    [AppDelegate addLocalLogWithFloat:@"LG1" n:[[NSDate date] timeIntervalSince1970]];
    
    //-- if session is not open.
    if (FBSession.activeSession.state != FBSessionStateCreatedTokenLoaded)
    {
        [FBSession openActiveSessionWithReadPermissions:permissionsNeeded
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          
                                          //-- hidden loading
                                          [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                                          
                                          if (!error) {
                                              
                                              if (status==FBSessionStateOpen) {
                                                  
                                                  //-- save token access
                                                  NSString *token = session.accessTokenData.accessToken;
                                                  [[NSUserDefaults standardUserDefaults] setObject:token forKey:MY_ACCOUNT_ACCESS_TOKEN_FB];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                  
                                                  //-- check Network
                                                  BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
                                                  
                                                  if (isErrorNetWork)
                                                      [self createPermissions];
                                              }
                                              
                                          }else {
                                              
                                              [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_Facebook_Error withFriendName:nil needDelegate:NO withTag:6];
                                          }
                                      }];
    }
    else if (FBSession.activeSession.state == FBSessionStateOpen)  //-- if session opened
        [self createPermissions];
}

/*
 *  step 2: create permission to read user data
 */

- (void)createPermissions
{
    NSLog(@"%s", __func__);
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
    [AppDelegate addLocalLog:@"LG2"];
    
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"basic_info", @"user_birthday",@"email"];
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error){
                                  
                                  // These are the current permissions the user has
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           
                                           if (!error) {
                                               
                                               // Permission granted, we can request the user information
                                               [AppDelegate addLocalLog:@"LG3"];
                                               [self makeRequestForUserData];
                                               
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               
                                               //-- hidden loading
                                               [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                                               
                                               [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_Facebook_Error withFriendName:nil needDelegate:NO withTag:6];
                                           }
                                       }];
                                      
                                  }else {
                                      
                                      // Permissions are present
                                      // We can request the user information
                                      [AppDelegate addLocalLog:@"LG4"];
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  
                                  //-- hidden loading
                                  [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                                  
                                  [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_Facebook_Error withFriendName:nil needDelegate:NO withTag:6];
                              }
                          }];
}


/*
 * step 3: call api to fetching data from facebook
 */
- (void)makeRequestForUserData
{
    NSLog(@"%s", __func__);
    [FBRequestConnection
     startWithGraphPath:@"me"
     parameters:[NSDictionary dictionaryWithObject:@"picture.type(large),id,birthday,email,name, gender" forKey:@"fields"]
     HTTPMethod:@"GET"
     completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         
         //-- hidden loading
         [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
         [AppDelegate addLocalLog:@"LG5"];
         
         if (!error) {
             
             NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
             [defaultFacebookResult setValue:result forKey:@"FacebookResult"];
             [defaultFacebookResult synchronize];
             
             NSString *fbUserId = [result objectForKey:@"id"];
             
             //-- check Network
             BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
             
             if (isErrorNetWork) {
                 
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 
                 //----- Check charg facebook info ------//
                 
                 NSString *isChargFacebookOn = [userDefaults valueForKey:Key_ChargFacebook_IsChargFacebookOn];
                 
                 if ([isChargFacebookOn integerValue]==1) { //-- Nhanh moi
                     [AppDelegate addLocalLog:@"LG6"];
                     
                     //-- check exist user by facebook
                     [self checkUserExistByFacebookWithResult:result FacebookId:fbUserId];
                     
                 }else { //-- Nhanh Cu
                     [AppDelegate addLocalLog:@"LG7"];
                     [self callBranchOldWithResult:result WithFacebookId:fbUserId];
                 }
             }
             
         } else {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             
             [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_Facebook_Error withFriendName:nil needDelegate:NO withTag:6];
         }
     }];
}


/*
 * Check if check_uer_exist_by_FB = YES => Dang Nhap
 * Check if check_uer_exist_by_FB = NO => Tao Moi khong co nut Dang nhap
 */
-(void) checkUserExistByFacebookWithResult:(NSDictionary *)result FacebookId:(NSString *) fbUserId {
    
    NSLog(@"%s", __func__);
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Checking..."];
    [AppDelegate addLocalLog:@"LG8"];
    
    [API getUserExistByFBTypeRequest:@"Facebook" mobile:@"" fb_user_id:fbUserId completed:^(NSDictionary *responseDictionary, NSError *error) {
        
        /* code: 0: chưa tồn tại user
         * code: 1: tồn tại user
         * current_time:
         * request_name:
         */
        
        //-- hidden loading
        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
        [AppDelegate addLocalLog:@"LG9"];
        
        if (!error) {
            
            NSInteger code = [[responseDictionary valueForKey:@"code"] integerValue];
            [AppDelegate addLocalLogWithInteger:@"LG10-" n:code];
            
            if (code == 1) {
                
                NSDictionary *userInfo = [responseDictionary valueForKey:@"user_info"];
                NSString *userIDInfo = [userInfo valueForKey:@"user_id"];
                
                //-- get user info by FB id
                [API getUserInfoByFaceBookID:fbUserId withUserId:userIDInfo
                                productionId:PRODUCTION_ID
                           productionVersion:PRODUCTION_VERSION
                                  avatarSize:@"200"
                                   completed:^(NSDictionary *responseDictionary, NSError *error) {
                                       
                                       //-- hidden loading
                                       [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                                       
                                       if (!error) {
                                           
                                           //-- fetching
                                           [self createDataSourceUserInfo:responseDictionary withFacebookID:fbUserId];
                                           
                                       }else {
                                           [AppDelegate addLocalLog:@"LG15"];
                                           
                                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                           NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
                                           
                                           [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
                                       }
                                   }];
                
            }else {
                
                //-- khoi xu ly cu
                [self callBranchOldWithResult:result WithFacebookId:fbUserId];
            }
            
        }else {
            
            //-- hidden loading
            [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
            
            [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
        }
        
    }];
}

//-- Goi Nhanh Cu
-(void) callBranchOldWithResult:(NSDictionary *) result WithFacebookId:(NSString *) fbUserId {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG16"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [userDefaults valueForKey:MY_PhonNumber_ID];
    
    if (phoneNumber && [phoneNumber length] > 5) {
        
        //-- Request server với số điện thoại nhận đc ở bước trên đã charged hay chưa?
        [self callServiceCheckChargedByPhonNumberDefault:phoneNumber];
        
    }else {
        
        //---------- Tạm thời check Free ở đây trong khi Telco chưa mở -----------//
        //---------- Lấy facebookID làm số điện thoại ----------------------------//
        if ([self checkFreeAppAndCreateAccount] == YES) {
            
            //-- is free
            [userDefaults setValue:fbUserId forKey:MY_PhonNumber_ID];
            [userDefaults synchronize];
            
            //-- API gửi FacebookId và Số ĐT để đăng ký user.
            [self apiCreateAccount:result];
            
        }else {
            
            //-- check get Phone number
            [self apiGetPhoneNumber:fbUserId];
        }
    }
}

/*
 * Check Free App
 * Get setting if is free then create account
 */
-(BOOL) checkFreeAppAndCreateAccount {
    NSLog(@"%s", __func__);
    return NO;
    //-- free app
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *is_free = [userDefaults valueForKey:Key_Is_Free];
    
    if ([is_free integerValue] == 1)
        return YES;
    else
        return NO;
}


/*
 * step 4: check charged PhonNumber Default
 * Request server với số điện thoại nhận đc ở bước trên đã charged hay chưa?
 */

-(void) callServiceCheckChargedByPhonNumberDefault:(NSString *) phoneNumber {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG17"];
    
    if ([self checkFreeAppAndCreateAccount] == YES) {
        
        //-- is free
        [self getOrUpdateUserWithPhoneNumber:phoneNumber];
        
    }else {
        
        //-- show loading
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Checking..."];
        
        NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
        NSDictionary *result = [defaultFacebookResult valueForKey:@"FacebookResult"];
        NSString *fbUserId = [result objectForKey:@"id"];
        [AppDelegate addLocalLogWithString:@"LG19" info:fbUserId];
        
        [API getUserExistByPhoneNumberTypeRequest:@"charged" mobile:phoneNumber completed:^(NSDictionary *responseDictionary, NSError *error) {
            
            /* --- user nạp tiền ---
             * status: 1: số điện thoại đã nạp tiền nhưng chưa kích hoạt
             * status: 2: số điện thoại chưa nạp tiền
             */
            
            if (!error) {
                
                int status = [[responseDictionary objectForKey:@"status"] intValue];
                [AppDelegate addLocalLogWithInteger:@"LG20" n:status];
                
                if (status == 1) {
                    
                    //-- call when is charged = 1 or Free app
                    [self getOrUpdateUserWithPhoneNumber:phoneNumber];
                    
                }else {
                    
                    //-- check get Phone number
                    [self apiGetPhoneNumber:fbUserId];
                }
                
            }else {
                
                //-- hidden loading
                [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
                
                [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
            }
            
        }];
    }
}

//-- call when is charged = 1 or Free app
-(void) getOrUpdateUserWithPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG18"];
    
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Getting..."];
    
    NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
    NSDictionary *result = [defaultFacebookResult valueForKey:@"FacebookResult"];
    NSString *fbUserId = [result objectForKey:@"id"];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:MY_ACCOUNT_ACCESS_TOKEN_FB];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:TEMP_MY_ACCOUNT_ID];
    NSString *myFacebookId = [userDefaults valueForKey:MY_Facebook_ID];
    NSString *myAccessToken = [userDefaults valueForKey:MY_Facebook_AccToken];
    
    if (userId==nil) { //lan truoc dk loi (da charging)
        //-- API gửi FacebookId và Số ĐT để đăng ký user.
        [self apiCreateAccount:result];
    }
    else {
        if ([myFacebookId isEqualToString:fbUserId] && ![myAccessToken isEqualToString:accessToken]) {
            
            [userDefaults setObject:fbUserId forKey:MY_Facebook_ID];
            [userDefaults setObject:accessToken forKey:MY_Facebook_AccToken];
            
            //-- call api update User by facebookId, accessToken
            [self callApiUpdateUserByFacebookIDandAccessTokenWithUserId:userId withFBUserId:fbUserId withPhone:phoneNumber withAccessToken:accessToken];
            
        }else if ([myFacebookId isEqualToString:fbUserId] && [myAccessToken isEqualToString:accessToken]) {
            
            //-- get user info by FB id
            [API getUserInfoByFaceBookID:fbUserId withUserId:userId
                            productionId:PRODUCTION_ID
                       productionVersion:PRODUCTION_VERSION
                              avatarSize:@"200"
                               completed:^(NSDictionary *responseDictionary, NSError *error) {
                                   
                                   //-- hidden loading
                                   [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                                   
                                   if (!error) {
                                       
                                       //-- fetching
                                       [self createDataSourceUserInfo:responseDictionary withFacebookID:fbUserId];
                                       
                                   }else {
                                       
                                       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                       NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
                                       
                                       [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
                                   }
                               }];
        }else {
            
            //-- API gửi FacebookId và Số ĐT để đăng ký user.
            [self apiCreateAccount:result];
        }
    }
}

//-- update facebook Info
-(void) callApiUpdateUserByFacebookIDandAccessTokenWithUserId:(NSString *) userId withFBUserId:(NSString *) fbUserId withPhone:(NSString *) phoneNumber withAccessToken:(NSString *) accesstoken {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG30"];
    
    [API updateUserInfo:userId fbUserId:fbUserId mobile:phoneNumber accessToken:accesstoken completed:^(NSDictionary *responseDictionary, NSError *error) {
        
        //-- hidden loading
        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
        
        if (!error) {
            [AppDelegate addLocalLog:@"LG31"];
            
            //-- fetching
            [self createDataSourceUserInfo:responseDictionary withFacebookID:fbUserId];
            
        }else {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
            
            [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
        }
    }];
}


/*
 * step 5: call api Lấy số điện thoại
 * http://mfilm.vn/site/GetPhoneNumber
 */

-(void) apiGetPhoneNumber:(NSString *)fbUserId {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG32"];
    
    //-- Get Carrier Info
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrieraa = [netinfo subscriberCellularProvider];
    
    if ([carrieraa.isoCountryCode isEqualToString:@""] && [carrieraa.carrierName isEqualToString:@"Carrier"]) {
        
        /*
         * Not exist Phome number : User just input phone number
         * Message + nhập SĐT + nhập Mã VRF + button VRF
         */
        
        [self callShowMessageInputPhoneNumber];
        
    }else {
        
        //-- show loading
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Getting..."];
        [AppDelegate addLocalLog:@"LG33"];
        
        [API getPhoneNumberAPICompleted:^(NSDictionary *responseDictionary, NSError *error) {
            
            if (!error) {
                
                NSString *phoneNumber = [responseDictionary valueForKey:@"msisdn"];
                [AppDelegate addLocalLogWithString:@"LG34" info:phoneNumber];
                //-- validate content
                NSString *tempPhoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                BOOL thereAreJustSpaces = [tempPhoneNumber isEqualToString:@""];
                
                //-- check PhoneNumber existed.
                if( (!thereAreJustSpaces || [phoneNumber length] > 0)) {
                    
                    //-- Request server với số điện thoại nhận đc ở bước trên đã charged hay chưa?
                    [self callServiceCheckChargedByPhonNumberFrom3G:phoneNumber];
                    
                }else {
                    
                    /*
                     * Not exist Phome number : User just input phone number
                     * Message + nhập SĐT + nhập Mã VRF + button VRF
                     */
                    
                    [self callShowMessageInputPhoneNumber];
                }
                
            }else {
                
                //-- hidden loading
                [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
                
                [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
            }
            
        }];
    }
}

/*
 * step 6: check charged PhonNumber 3G
 * Request server với số điện thoại nhận đc nhánh 3G đã charged hay chưa?
 */

-(void) callServiceCheckChargedByPhonNumberFrom3G:(NSString *) phoneNumber {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG35"];
    if ([self checkFreeAppAndCreateAccount] == YES) {
        
        //-- is free
        NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
        NSDictionary *result = [defaultFacebookResult valueForKey:@"FacebookResult"];
        [AppDelegate addLocalLog:@"LG36"];
        //-- API gửi FacebookId và Số ĐT để đăng ký user.
        [self apiCreateAccount:result];
        
    }else {
        
        //-- show loading
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Checking..."];
        
        NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
        NSDictionary *result = [defaultFacebookResult valueForKey:@"FacebookResult"];
        
        [API getUserExistByPhoneNumberTypeRequest:@"charged" mobile:phoneNumber completed:^(NSDictionary *responseDictionary, NSError *error) {
            
            /* --- user nạp tiền ---
             * status: 1: số điện thoại đã nạp tiền nhưng chưa kích hoạt
             * status: 2: số điện thoại chưa nạp tiền
             */
            
            if (!error) {
                NSUserDefaults *defaultPhoneNumber = [NSUserDefaults standardUserDefaults];
                [defaultPhoneNumber setValue:phoneNumber forKey:MY_PhonNumber_ID];
                [defaultPhoneNumber synchronize];
                [AppDelegate addLocalLogWithString:@"LG37" info:phoneNumber];
                int status = [[responseDictionary objectForKey:@"status"] intValue];
                [AppDelegate addLocalLogWithInteger:@"LG37-" n:status];
                if (status == 1) {
                    
                    //-- API gửi FacebookId và Số ĐT để đăng ký user.
                    [self apiCreateAccount:result];
                    
                }else {
                    
                    //-- Exist Phome number : check payment_type for Phone Number
                    [self checkPaymentTypeForPhoneNumber:phoneNumber];
                }
                
            }else {
                
                //-- hidden loading
                [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
                
                [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
            }
            
        }];
    }
}

/*
 * step 7: Show wifi login view
 * Request server với số điện thoại nhận đc nhánh 3G đã charged hay chưa?
 */

-(void) callShowMessageInputPhoneNumber {
    NSLog(@"%s", __func__);
    
    //-- hidden loading
    [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *messageString = @"";
    
    //-- Get Carrier Info
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrieraa = [netinfo subscriberCellularProvider];
    
    if ([carrieraa.isoCountryCode isEqualToString:@""] && [carrieraa.carrierName isEqualToString:@"Carrier"]) {
        
        /*
         * Not exist Phome number : User just input phone number
         * Không có Sim
         */
        
        messageString = [userDefaults valueForKey:Key_wifi_nosim_DKCT_message];
        
    }else {
        
        /*
         * Not exist Phome number
         * Co Sim
         */
        
        //-- check 3G or wifi
        NSString *payment_typeDefaults = @"";
        if ([Utility checkNetWorkStatus] == 2)
            payment_typeDefaults = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_mobile_network_payment_type]];
        else
            payment_typeDefaults = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_wifi_payment_type]];
        
        //-- save Defaults payment_type
        [userDefaults setObject:payment_typeDefaults forKey:Key_payment_type];
        [userDefaults synchronize];
        
        bool isFound = false;
        
        NSInteger payment_type = [[userDefaults valueForKey:Key_payment_type] integerValue];
        
        switch (payment_type) {
                
                /*
                 * payment_type: 1 - Đăng ký qua wapcharging (bỏ qua)
                 * payment_type: 2 - Đăng ký qua SMS (theo cú pháp gửi tin và verify số điện thoại)
                 * payment_type: 3 - Đăng ký qua Sub SMS (theo cú pháp gửi tin)
                 * payment_type: 4 - Không đăng ký qua gì (call api API GSoapTest.php)
                 * payment_type: 5 - ChargingSub (call API ChargingSub.php).
                 *
                 */
                
            case 1:
                //-- Bo qua
                break;
                
            case 2:
                isFound = true;
                messageString = [userDefaults valueForKey:Key_sms_DKCT_message];
                break;
                
            case 3:
                isFound = true;
                messageString = [userDefaults valueForKey:Key_subSms_DKCT_message];
                break;
                
            case 4:
                break;
                
            case 5:
                break;
                
            default:
                break;
        }
        
        if(!isFound) {
            //[self showIncorrectCarrier];
            messageString = @"Bạn hãy nhập số điện thoại đang sử dụng trên máy để đăng ký dịch vụ";
            
            //return;
        }
        
    }
    
    
    if ([self checkFreeAppAndCreateAccount] == YES) {
        
        //-- free app
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        messageString = [userDefaults valueForKey:Key_Free_Regist_Message];
    }
    
    //-- login wifi
    [self addWifiLoginViewWithMessage:messageString];
}


#pragma mark - View Login

//-- show login screen
-(void) addWifiLoginViewWithMessage:(NSString *) messageString {
    NSLog(@"%s", __func__);
    
    NSArray *objectLevelTop = [[NSBundle mainBundle] loadNibNamed:@"BaseViewController" owner:nil options:nil];
    
    viewWifiLogin = [objectLevelTop objectAtIndex:2];
    viewWifiLogin.frame = CGRectMake(0, 0, 320, 568);
    [AppDelegate addLocalLog:@"LG39"];
    //-- set content
    viewWifiLogin.txtMessageLogin.text = messageString;
    viewWifiLogin.lblForgotPassword.text = @"Click vào đây để lấy mật khẩu qua SMS.";
    
    viewWifiLogin.txtPhoneNumber.delegate = self;
    viewWifiLogin.txtPassWord.delegate = self;
    
    //longnh
    UITapGestureRecognizer *tapSelectAvt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHiddenKeyboard:)];
    [viewWifiLogin addGestureRecognizer:tapSelectAvt];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           //                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    viewWifiLogin.txtPhoneNumber.inputAccessoryView = numberToolbar;
    [viewWifiLogin.txtPhoneNumber addTarget:self action:@selector(tapOnPhoneNumberTextField:) forControlEvents:UIControlEventTouchDown];
    
    
    [viewWifiLogin.txtPassWord setValue:[UIColor darkGrayColor]
                             forKeyPath:@"_placeholderLabel.textColor"];
    [viewWifiLogin.txtPhoneNumber setValue:[UIColor darkGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    
    //-- set action to button
    [viewWifiLogin.btnExist addTarget:self action:@selector(selectedButtonExist:) forControlEvents:UIControlEventTouchUpInside];
    [viewWifiLogin.btnLogin addTarget:self action:@selector(selectedButtonLogin:) forControlEvents:UIControlEventTouchUpInside];
    [viewWifiLogin.btnCreateAccount addTarget:self action:@selector(selectedButtonCreateAccount:) forControlEvents:UIControlEventTouchUpInside];
    [viewWifiLogin.btnForgotPassword addTarget:self action:@selector(selectedButtonForgotPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    //-- Get Carrier Info check NO sim
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrieraa = [netinfo subscriberCellularProvider];
    
    if ([carrieraa.isoCountryCode isEqualToString:@""] && [carrieraa.carrierName isEqualToString:@"Carrier"]) {
        
        /*
         * Không có Sim Unvalidate phone number
         */
        
        viewWifiLogin.btnCreateAccount.enabled = NO;
        viewWifiLogin.btnCreateAccount.userInteractionEnabled = NO;
        
    }else {
        
        /*
         * Co Sim validate Phone number.
         */
        
        viewWifiLogin.btnCreateAccount.enabled = YES;
        viewWifiLogin.btnCreateAccount.userInteractionEnabled = YES;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isChargFacebookOn = [userDefaults valueForKey:Key_ChargFacebook_IsChargFacebookOn];
    
    if ([isChargFacebookOn integerValue]==1) { //-- Nhanh moi
        
        viewWifiLogin.txtPassWord.hidden = YES;
        viewWifiLogin.btnLogin.hidden = YES;
        viewWifiLogin.lblForgotPassword.hidden = YES;
        viewWifiLogin.btnForgotPassword.hidden = YES;
        
        [viewWifiLogin.btnCreateAccount setFrame:CGRectMake(5, 250, 308, 34)];
    }
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [dataCenter.window addSubview:viewWifiLogin];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
//longnh
-(void)doneWithNumberPad{
    NSLog(@"%s", __func__);
    [viewWifiLogin.txtPhoneNumber resignFirstResponder];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rect = viewWifiLogin.frame;
                         viewWifiLogin.frame = CGRectMake(0,0,rect.size.width,rect.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}
- (void)tapToHiddenKeyboard:(UIGestureRecognizer *)sender
{
    NSLog(@"%s", __func__);
    [viewWifiLogin.txtPhoneNumber resignFirstResponder];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rect = viewWifiLogin.frame;
                         viewWifiLogin.frame = CGRectMake(0,0,rect.size.width,rect.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(IBAction)selectedButtonExist:(id)sender {
    NSLog(@"%s", __func__);
    
    //-- change frame
    [self changeFrameWhenHiddenKeyboard];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [viewWifiLogin removeFromSuperview];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(IBAction)selectedButtonLogin:(id)sender {
    NSLog(@"%s", __func__);
    
    NSString *phoneNumberInput = viewWifiLogin.txtPhoneNumber.text;
    NSString *passwordInput = viewWifiLogin.txtPassWord.text;
    [AppDelegate addLocalLogWithString:@"LG41-" info:phoneNumberInput];
    //-- validate content
    [self validateContentInputAlertView:phoneNumberInput withPassword:passwordInput];
}
//longnh
-(IBAction)tapOnPhoneNumberTextField:(id)sender {
    NSLog(@"%s", __func__);
    [UIView animateWithDuration:0.35 delay:0.4 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rect = viewWifiLogin.frame;
                         viewWifiLogin.frame = CGRectMake(0,-100,rect.size.width,rect.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

-(IBAction)selectedButtonCreateAccount:(id)sender {
    NSLog(@"%s", __func__);
    
    NSString *passwordInput = viewWifiLogin.txtPassWord.text;
    [AppDelegate addLocalLogWithString:@"LG43" info:passwordInput];
    [AppDelegate addLocalLogWithFloat:@"LG43t" n:[[NSDate date] timeIntervalSince1970]];
    NSString *tempVerifyInput = [passwordInput stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL verifyInputSpaces = [tempVerifyInput isEqualToString:@""];
    
    if (!verifyInputSpaces && [tempVerifyInput length] > 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:passwordInput forKey:@"PasswordInputDefault"];
        [userDefaults synchronize];
    }
    
    //-- Register by Payment_type
    [self registerWithPaymentType];
    
    //    if ([self checkFreeAppAndCreateAccount] == YES) {
    //
    //        //-- Register Free App
    //        [self registerFreeApp];
    //
    //    }else {
    //
    //        //-- Register by Payment_type
    //        [self registerWithPaymentType];
    //    }
}

//-- Register Free App
-(void) registerFreeApp {
    NSLog(@"%s", __func__);
    
    NSString *passwordInput = viewWifiLogin.txtPassWord.text;
    [AppDelegate addLocalLog:@"LG45"];
    NSString *tempVerifyInput = [passwordInput stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL verifyInputSpaces = [tempVerifyInput isEqualToString:@""];
    
    if (!verifyInputSpaces && [tempVerifyInput length] > 0) {
        
        NSString *phoneNumberInput = viewWifiLogin.txtPhoneNumber.text;
        NSString *tempPhoneNumber = [phoneNumberInput stringByReplacingOccurrencesOfString:@" " withString:@""];
        BOOL thereAreJustSpaces = [tempPhoneNumber isEqualToString:@""];
        
        //-- check PhoneNumber existed.
        if( (!thereAreJustSpaces && [phoneNumberInput length] > 5)) {
            
            //-- validate phone number
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *telcoPhoneNumberStr = [userDefaults valueForKey:Key_telco_phone_number_list];
            
            if (telcoPhoneNumberStr && [telcoPhoneNumberStr length] > 1) {
                
                BOOL isNextStep = NO;
                
                NSArray *listURL = [telcoPhoneNumberStr componentsSeparatedByString:@","];
                
                if (listURL.count >0) {
                    
                    for (int i = 0; i < listURL.count; i++) {
                        
                        NSString *phoneNameStr = [listURL objectAtIndex:i];
                        phoneNameStr = [phoneNameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                        
                        NSString *firstPhoneTelco = [Utility getFirstPhoneNumberTelco:phoneNameStr];
                        NSString *numberOfCharPhoneTelco = [Utility getNumberOfCharPhoneNumberTelco:phoneNameStr];
                        
                        NSString *firstPhoneInput = [phoneNumberInput substringToIndex:[firstPhoneTelco length]];
                        
                        if ([firstPhoneTelco isEqualToString:firstPhoneInput]) {
                            
                            if ([phoneNumberInput length] == [numberOfCharPhoneTelco intValue]) {
                                
                                isNextStep = YES;
                                break;
                                
                            }else {
                                //-- Số ký tự nhập vào không đúng
                                isNextStep = NO;
                            }
                            
                        }else {
                            //-- Đầu số không tồn tại
                            isNextStep = NO;
                        }
                    }
                }
                
                if (isNextStep == YES) {
                    
                    //-- create account free
                    [self registerAccountFreeAppByPhoneNumberInput:phoneNumberInput];
                    
                }else {
                    
                    //-- Thông báo số điện thoại nhập vào không đúng.
                    [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_FailPhoneNumber withFriendName:nil needDelegate:NO withTag:6];
                }
                
            }else {
                
                //-- create account free
                [self registerAccountFreeAppByPhoneNumberInput:phoneNumberInput];
            }
            
        }else {
            
            //-- Thông báo số điện thoại nhập vào không đúng.
            [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_EmptyPhoneNumber withFriendName:nil needDelegate:NO withTag:6];
        }
        
    }else {
        
        //-- Thông báo chưa nhập vào mã xác nhận.
        [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_FailVerify withFriendName:nil needDelegate:NO withTag:6];
    }
}

-(void) registerAccountFreeAppByPhoneNumberInput:(NSString *) phoneNumberInput {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG46"];
    //-- change frame
    [self changeFrameWhenHiddenKeyboard];
    
    NSUserDefaults *defaultPhoneNumber = [NSUserDefaults standardUserDefaults];
    [defaultPhoneNumber setValue:phoneNumberInput forKey:MY_PhonNumber_ID];
    [defaultPhoneNumber synchronize];
    
    //-- is free
    NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
    NSDictionary *result = [defaultFacebookResult valueForKey:@"FacebookResult"];
    
    //-- API gửi FacebookId và Số ĐT để đăng ký user.
    [self apiCreateAccount:result];
}

//-- Register by Payment_type
-(void) registerWithPaymentType {
    NSLog(@"%s", __func__);
    
    NSString *phoneNumberInput = viewWifiLogin.txtPhoneNumber.text;
    [AppDelegate addLocalLogWithString:@"LG47" info:phoneNumberInput];
    NSString *tempPhoneNumber = [phoneNumberInput stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereAreJustSpaces = [tempPhoneNumber isEqualToString:@""];
    
    //-- check PhoneNumber existed.
    if( (!thereAreJustSpaces && [phoneNumberInput length] > 5)) {
        
        //-- validate phone number
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *telcoPhoneNumberStr = [userDefaults valueForKey:Key_telco_phone_number_list];
        
        if (telcoPhoneNumberStr && [telcoPhoneNumberStr length] > 1) {
            
            BOOL isNextStep = NO;
            
            NSArray *listURL = [telcoPhoneNumberStr componentsSeparatedByString:@","];
            
            if (listURL.count >0) {
                
                for (int i = 0; i < listURL.count; i++) {
                    
                    NSString *phoneNameStr = [listURL objectAtIndex:i];
                    phoneNameStr = [phoneNameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    NSString *firstPhoneTelco = [Utility getFirstPhoneNumberTelco:phoneNameStr];
                    NSString *numberOfCharPhoneTelco = [Utility getNumberOfCharPhoneNumberTelco:phoneNameStr];
                    
                    NSString *firstPhoneInput = [phoneNumberInput substringToIndex:[firstPhoneTelco length]];
                    
                    if ([firstPhoneTelco isEqualToString:firstPhoneInput]) {
                        
                        if ([phoneNumberInput length] == [numberOfCharPhoneTelco intValue]) {
                            
                            isNextStep = YES;
                            break;
                            
                        }else {
                            //-- Số ký tự nhập vào không đúng
                            isNextStep = NO;
                        }
                        
                    }else {
                        //-- Đầu số không tồn tại
                        isNextStep = NO;
                    }
                }
            }
            
            if (isNextStep == YES) {
                
                //-- change frame
                [self changeFrameWhenHiddenKeyboard];
                
                //-- register account
                [self callRegisterAccountWithPayMentTypeForPhoneNumber:phoneNumberInput];
                
            }else {
                
                //-- Thông báo số điện thoại nhập vào không đúng.
                [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_FailPhoneNumber withFriendName:nil needDelegate:NO withTag:6];
            }
            
        }else {
            
            //-- change frame
            [self changeFrameWhenHiddenKeyboard];
            
            //-- register account
            [self callRegisterAccountWithPayMentTypeForPhoneNumber:phoneNumberInput];
        }
        
    }else {
        
        //-- Thông báo số điện thoại nhập vào không đúng.
        [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_EmptyPhoneNumber withFriendName:nil needDelegate:NO withTag:6];
    }
}

//-- register account
-(void) callRegisterAccountWithPayMentTypeForPhoneNumber:(NSString *)phoneNumberInput {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLogWithString:@"LG50" info:phoneNumberInput];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isChargFacebookOn = [userDefaults valueForKey:Key_ChargFacebook_IsChargFacebookOn];
    
    if ([isChargFacebookOn integerValue]==1) { //-- Nhanh moi
        [AppDelegate addLocalLog:@"LG51"];
        //-- check user exist by mobile
        [self checkUserExistByMobile:phoneNumberInput];
        
    }else {
        
        //-- Exist Phome number : check payment_type for Phone Number
        [self checkPaymentTypeForPhoneNumber:phoneNumberInput];
    }
}


/*
 * Check if check_user_exist_by_mobile = YES =>  Đã tồn tại user thông báo lỗi
 * Check if check_user_exist_by_mobile = NO => tạo user như nhành cũ
 */

-(void) checkUserExistByMobile:(NSString *) phoneNumberInput {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLogWithString:@"LG52" info:phoneNumberInput];
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Checking..."];
    
    [API getUserExistByFBTypeRequest:@"Mobile" mobile:phoneNumberInput fb_user_id:@"" completed:^(NSDictionary *responseDictionary, NSError *error) {
        
        /* code: 0: chưa tồn tại user
         * code: 1: tồn tại user
         * current_time:
         * request_name:
         */
        
        //-- hidden loading
        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
        
        if (!error) {
            
            NSInteger code = [[responseDictionary valueForKey:@"code"] integerValue];
            [AppDelegate addLocalLogWithInteger:@"LG53" n:code];
            
            if (code == 1) {
                
                //-- User Exist By Phome number
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *messageUpdateUserInfo = [userDefaults valueForKey:Key_ChargFacebook_MessageUpdateUserInfo];
                
                [self showMessageWithType:VMTypeMessageOk withMessage:messageUpdateUserInfo withFriendName:nil needDelegate:NO withTag:6];
                
            }else {
                
                //-- Exist Phome number : check payment_type for Phone Number
                [self checkPaymentTypeForPhoneNumber:phoneNumberInput];
            }
            
        }else {
            
            //-- hidden loading
            [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
            
            [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
        }
        
    }];
}

-(IBAction)selectedButtonForgotPassword:(id)sender {
    NSLog(@"%s", __func__);
    
    //-- change frame
    [self changeFrameWhenHiddenKeyboard];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *gatewayReg = nil;
    NSString *bodyReg = nil;
    
    //-- Get Carrier Info check NO sim
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrieraa = [netinfo subscriberCellularProvider];
    
    if ([carrieraa.isoCountryCode isEqualToString:@""] && [carrieraa.carrierName isEqualToString:@"Carrier"]) {
        
        /*
         * Không có Sim Unvalidate phone number
         */
        
        gatewayReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_wifi_nosim_command_gateway_get_password]];
        bodyReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_wifi_nosim_command_body_get_password]];
        
    }else {
        
        /*
         * Co Sim validate Phone number.
         */
        
        NSString *payment_type = [userDefaults valueForKey:Key_payment_type];
        if ([payment_type isEqualToString:@"2"]) {
            
            gatewayReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_sms_DKCT_command_gateway]];
            bodyReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_sms_DKCT_command_body]];
            
        }else {
            
            gatewayReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_subSms_DKCT_command_gateway]];
            bodyReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_subSms_DKCT_command_body]];
        }
    }
    
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyReg;
        controller.recipients = @[gatewayReg];
        controller.messageComposeDelegate = self;
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
            [self presentModalViewController:controller animated:YES];
        else
            [self presentViewController:controller animated:YES completion:Nil];
        
        viewWifiLogin.hidden = YES;
    }
}

//************************************************************************//
#pragma mark - TextField

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isChargFacebookOn = [userDefaults valueForKey:Key_ChargFacebook_IsChargFacebookOn];
    
    if (textField == viewWifiLogin.txtPhoneNumber || textField == viewWifiLogin.txtPassWord) {
        
        CGRect frameViewBottom = [viewWifiLogin.viewBottom frame];
        
        if (![isChargFacebookOn integerValue]==1)
            frameViewBottom.origin.y = -90;
        
        [viewWifiLogin.viewBottom setFrame:frameViewBottom];
        
        CGRect frameImgBg = [viewWifiLogin.imgBackground frame];
        if (![isChargFacebookOn integerValue]==1)
            frameImgBg.origin.y = -150;
        
        [viewWifiLogin.imgBackground setFrame:frameImgBg];
    }
}


//--fired when user return a textfield
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isChargFacebookOn = [userDefaults valueForKey:Key_ChargFacebook_IsChargFacebookOn];
    
    if ([isChargFacebookOn integerValue]==1) {
        
        //--txtPhoneNumber
        if (textField == viewWifiLogin.txtPhoneNumber)
        {
            //-- change frame
            [self changeFrameWhenHiddenKeyboard];
            
            [viewWifiLogin.txtPhoneNumber resignFirstResponder];
            return NO;
        }
        
    }else {
        
        //--txtFullname
        if (textField == viewWifiLogin.txtPhoneNumber)
        {
            [viewWifiLogin.txtPassWord becomeFirstResponder];
            return NO;
        }
        
        //--txtEmail
        if (textField == viewWifiLogin.txtPassWord)
        {
            //-- change frame
            [self changeFrameWhenHiddenKeyboard];
            
            [viewWifiLogin.txtPassWord resignFirstResponder];
            return NO;
        }
    }
    
    
    return YES;
}

-(void) changeFrameWhenHiddenKeyboard {
    
    CGRect frameViewBottom = [viewWifiLogin.viewBottom frame];
    frameViewBottom.origin.y = 60 ;
    [viewWifiLogin.viewBottom setFrame:frameViewBottom];
    
    CGRect frameImgBg = [viewWifiLogin.imgBackground frame];
    frameImgBg.origin.y = 0;
    [viewWifiLogin.imgBackground setFrame:frameImgBg];
}

/*
 * step 8: call api Verify
 */

-(void) apiVerifyLoginWithPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLogWithString:@"LG55" info:phoneNumber];
    
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Checking..."];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:phoneNumber forKey:MOBILE_NUMBER];
    [userDefaults synchronize];
    
    NSString *passwordInput = [userDefaults valueForKey:@"PasswordInputDefault"];
    
    //-- get singer info default
    NSString *singerCodeStr = [userDefaults objectForKey:Key_Singer_Telco_code];
    if ([singerCodeStr length] == 0)
        singerCodeStr = KEY_SINGER_NAME;
    
    NSString *singerSecret_key = [userDefaults objectForKey:Key_Singer_Secret_key];
    if ([singerSecret_key length] == 0)
        singerSecret_key = KEY_secretKey;
    
    NSString *singerAgency_id = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:Key_Singer_Agency_id]];
    
    if ([singerAgency_id length] == 0)
        singerAgency_id = KEY_agency_id;
    
    
    //-- get date format YYYYMMDDHHMMSS
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    NSString *reqIdStr = [NSString stringWithFormat:@"%@_%@",singerAgency_id,dateString];
    NSString *passwordStr = [NSString stringWithFormat:@"%@",passwordInput];
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@%@",reqIdStr,phoneNumber,singerCodeStr,passwordStr,singerSecret_key];
    NSString *signFormatMd5 = [self md5:signStr];
    
    [API apiVerifyLoginWithPhoneNumberReqId:reqIdStr mobileNumber:phoneNumber singerCode:singerCodeStr password:passwordStr sign:signFormatMd5 completed:^(NSDictionary *responseDictionary, NSError *error) {
        
        /* return_code:
         * 0 --> thành công
         * sign = md5(client_sign + return_code + "MYIDOL” + secretKey). Cần phải check sign trong trường hợp thành công trước khi xử lý  để tránh giả mạo thông tin
         *
         * các giá trị khác --> hiện message
         */
        [AppDelegate addLocalLog:@"LG57"];
        
        if (!error) {
            
            int return_code = [[responseDictionary valueForKey:@"return_code"] intValue];
            NSString *server_signRP = [responseDictionary valueForKey:@"server_sign"];
            
            if (return_code == 0) {
                
                NSString *signStringValue = [NSString stringWithFormat:@"%@%d%@%@",signFormatMd5,return_code,@"MYIDOL",singerSecret_key];
                NSString *signFormatMd5ServerRP = [self md5:signStringValue];
                
                if ([server_signRP isEqualToString:signFormatMd5ServerRP]) {
                    
                    //-- while () Request server với số điện thoại nhận đc ở bước trên đã charged hay chưa? Time Out = ?
                    [self apiCheckChargedTimeOutByPhoneNumber:phoneNumber];
                    
                }else {
                    
                    //-- hidden loading
                    [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                    
                    //-- show message: Đăng ký thất bại
                    [self showMessageWithType:VMTypeMessageOk withMessage:[responseDictionary valueForKey:@"message"] withFriendName:nil needDelegate:NO withTag:3];
                }
                
            }else {
                
                //-- hidden loading
                [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                
                //-- show message: Đăng ký thất bại
                [self showMessageWithType:VMTypeMessageOk withMessage:[responseDictionary valueForKey:@"message"] withFriendName:nil needDelegate:NO withTag:3];
            }
            
        }else {
            
            //-- hidden loading
            [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
            
            [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
        }
    }];
    
    //    if ([self checkFreeAppAndCreateAccount] == YES) {
    //
    //        NSString *passwordStr = [NSString stringWithFormat:@"%@",passwordInput];
    //
    //        //-- call api login Free App
    //        [API apiVerifyLoginFreeAppWithPhoneNumber:phoneNumber password:passwordStr completed:^(NSDictionary *responseDictionary, NSError *error) {
    //
    //            //-- hidden loading
    //            [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
    //
    //            if (!error) {
    //
    //                int return_code = [[responseDictionary valueForKey:@"is_login"] intValue];
    //
    //                if (return_code == 1) {
    //
    //                    NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
    //                    NSDictionary *result = [defaultFacebookResult valueForKey:@"FacebookResult"];
    //                    NSString *fbUserId = [result objectForKey:@"id"];
    //
    //                    //-- login
    //                    [self createDataSourceUserInfo:responseDictionary withFacebookID:fbUserId];
    //
    //                }else {
    //
    //                    NSDictionary *errorMessage = [responseDictionary valueForKey:@"error"];
    //
    //                    //-- show message: Login fail
    //                    [self showMessageWithType:VMTypeMessageOk withMessage:[errorMessage valueForKey:@"error_message"] withFriendName:nil needDelegate:NO withTag:3];
    //                }
    //
    //            }else {
    //
    //                //-- show message
    //                [self showMessageWithType:VMTypeMessageOk withMessage:error.description withFriendName:nil needDelegate:NO withTag:6];
    //            }
    //        }];
    //
    //    }else {
    //
    //        //-- get singer info default
    //        NSString *singerCodeStr = [userDefaults objectForKey:Key_Singer_Telco_code];
    //        if ([singerCodeStr length] == 0)
    //            singerCodeStr = KEY_NOOPHUOCTHINH;
    //
    //        NSString *singerSecret_key = [userDefaults objectForKey:Key_Singer_Secret_key];
    //        if ([singerSecret_key length] == 0)
    //            singerSecret_key = KEY_secretKey;
    //
    //        NSString *singerAgency_id = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:Key_Singer_Agency_id]];
    //
    //        if ([singerAgency_id length] == 0)
    //            singerAgency_id = KEY_agency_id;
    //
    //
    //        //-- get date format YYYYMMDDHHMMSS
    //        NSDate *date = [NSDate date];
    //        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //        [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    //        NSString *dateString = [dateFormat stringFromDate:date];
    //
    //        NSString *reqIdStr = [NSString stringWithFormat:@"%@_%@",singerAgency_id,dateString];
    //        NSString *passwordStr = [NSString stringWithFormat:@"%@",passwordInput];
    //        NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@%@",reqIdStr,phoneNumber,singerCodeStr,passwordStr,singerSecret_key];
    //        NSString *signFormatMd5 = [self md5:signStr];
    //
    //        [API apiVerifyLoginWithPhoneNumberReqId:reqIdStr mobileNumber:phoneNumber singerCode:singerCodeStr password:passwordStr sign:signFormatMd5 completed:^(NSDictionary *responseDictionary, NSError *error) {
    //
    //            /* return_code:
    //             * 0 --> thành công
    //             * sign = md5(client_sign + return_code + "MYIDOL” + secretKey). Cần phải check sign trong trường hợp thành công trước khi xử lý  để tránh giả mạo thông tin
    //             *
    //             * các giá trị khác --> hiện message
    //             */
    //
    //            if (!error) {
    //
    //                int return_code = [[responseDictionary valueForKey:@"return_code"] intValue];
    //                NSString *server_signRP = [responseDictionary valueForKey:@"server_sign"];
    //
    //                if (return_code == 0) {
    //
    //                    NSString *signStringValue = [NSString stringWithFormat:@"%@%d%@%@",signFormatMd5,return_code,@"MYIDOL",singerSecret_key];
    //                    NSString *signFormatMd5ServerRP = [self md5:signStringValue];
    //
    //                    if ([server_signRP isEqualToString:signFormatMd5ServerRP]) {
    //
    //                        //-- while () Request server với số điện thoại nhận đc ở bước trên đã charged hay chưa? Time Out = ?
    //                        [self apiCheckChargedTimeOutByPhoneNumber:phoneNumber];
    //
    //                    }else {
    //
    //                        //-- hidden loading
    //                        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
    //
    //                        //-- show message: Đăng ký thất bại
    //                        [self showMessageWithType:VMTypeMessageOk withMessage:[responseDictionary valueForKey:@"message"] withFriendName:nil needDelegate:NO withTag:3];
    //                    }
    //
    //                }else {
    //
    //                    //-- hidden loading
    //                    [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
    //
    //                    //-- show message: Đăng ký thất bại
    //                    [self showMessageWithType:VMTypeMessageOk withMessage:[responseDictionary valueForKey:@"message"] withFriendName:nil needDelegate:NO withTag:3];
    //                }
    //
    //            }else {
    //
    //                //-- hidden loading
    //                [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
    //
    //                [self showMessageWithType:VMTypeMessageOk withMessage:error.description withFriendName:nil needDelegate:NO withTag:6];
    //            }
    //        }];
    //    }
}


-(bool) simulateGenerateTelcoGlobalCodeByPhonenumber:(NSString *)phonenumber
{
    //lay telcocode tu so dien thoai nha mang
    NSString *telcoGlobalCode = [AppDelegate getTelcoGlobalCodeByPhoneNumber:phonenumber];
    if (telcoGlobalCode==nil)
        return false;
    //save
    [AppDelegate addLocalLogWithString:@"Simulate telcoGlobalCode:" info:telcoGlobalCode];
    //reprocess
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:telcoGlobalCode forKey:@"TelcoGlobalCode"];
    [userDefaults synchronize];
    
    [AppDelegate processTelcoSetting:false];
    return true;
}

/*
 * step 9: Check payment_type from Setting
 */

-(bool) checkPaymentTypeForPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLogWithString:@"LG57" info:phoneNumber];
    
    //-- hidden loading
    [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:phoneNumber forKey:MOBILE_NUMBER];
    [userDefaults synchronize];
    
    //TuanNM add @20140924
    //sua cho nha mang lock
    NSString *isLockDevice = [userDefaults valueForKey:Key_is_lock_device];
    if ([isLockDevice isEqualToString:@"1"]) {
        [AppDelegate addLocalLog:@"process lockdevice"];
        bool rs = [self simulateGenerateTelcoGlobalCodeByPhonenumber:phoneNumber];
        if (!rs) {
            return false;
        }
    }
    
    //
    
    //-- check 3G or wifi
    NSString *payment_typeDefaults = @"";
    if ([Utility checkNetWorkStatus] == 2)
        payment_typeDefaults = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_mobile_network_payment_type]];
    else
        payment_typeDefaults = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_wifi_payment_type]];
    
    //-- save Defaults payment_type
    [userDefaults setObject:payment_typeDefaults forKey:Key_payment_type];
    [userDefaults synchronize];
    
    
    NSInteger payment_type = [[userDefaults valueForKey:Key_payment_type] integerValue];
    bool isFound = false;
    switch (payment_type) {
            
            /*
             * payment_type: 1 - Đăng ký qua wapcharging (bỏ qua)
             * payment_type: 2 - Đăng ký qua SMS (theo cú pháp gửi tin và verify số điện thoại)
             * payment_type: 3 - Đăng ký qua Sub SMS (theo cú pháp gửi tin)
             * payment_type: 4 - Không đăng ký qua gì (call api API GSoapTest.php)
             * payment_type: 5 - ChargingSub (call API ChargingSub.php).
             *
             */
            
        case 1:
            //-- Bo qua
            break;
            
        case 2:
            //-- bắt Charged: Gửi tin nhắn (Thông báo cho user nếu đã đăng ký rồi thì mà gửi tin nhắn thì vẫn không bị trừ tiền)
            isFound = true;
            [self sendSMSChargedRecipientList:nil];
            break;
            
        case 3:
            //-- bắt Charged: Gửi tin nhắn (Thông báo cho user nếu đã đăng ký rồi thì mà gửi tin nhắn thì vẫn không bị trừ tiền)
            isFound = true;
            [self sendSMSChargedRecipientList:nil];
            break;
            
        case 4:
            //-- không bắt Charged: gọi Request GSoapTest
            isFound = true;
            [self apiRequestGSoapTest:phoneNumber];
            break;
            
        case 5:
            //-- API gửi lên server để trừ tiền số điện thoại
            isFound = true;
            [self apiCashPhoneNumber:phoneNumber];
            break;
            
        default:
            break;
    }
    if(!isFound) {
        [self showIncorrectCarrier];
        return false;
    }
    return true;
    
}

- (void)showIncorrectCarrier
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *telcoGlobalCodeDefault = [userDefaults valueForKey:@"TelcoGlobalCode"];
    
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrieraa = [netinfo subscriberCellularProvider];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lỗi" message:[NSString stringWithFormat:@"Không tìm thấy thông tin nhà mạng mà bạn đang sử dụng (mã %@ - %@)",telcoGlobalCodeDefault, carrieraa.carrierName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

//-- result send Message
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"%s", __func__);
    viewWifiLogin.hidden = NO;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self dismissModalViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:Nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isSendCharged = [userDefaults boolForKey:@"isSendSMSCharged"];
    
    if (result == MessageComposeResultSent && isSendCharged == YES) {
        
        //-- sended SMS
        [userDefaults setBool:NO forKey:@"isSendSMSCharged"];
        [userDefaults synchronize];
        
        NSString *phoneNumber = [userDefaults valueForKey:MOBILE_NUMBER];
        
        [AppDelegate addLocalLogWithString:@"LG58" info:phoneNumber];
        
        //-- while () Request server với số điện thoại nhận đc ở bước trên đã charged hay chưa? Time Out = ?
        [self apiCheckChargedTimeOutByPhoneNumber:phoneNumber];
    }
}


//-- title & content of SMS
- (void)sendSMSChargedRecipientList:(NSArray *)recipients
{
    NSLog(@"%s", __func__);
    [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
    [AppDelegate addLocalLog:@"LG59"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"isSendSMSCharged"];
    [userDefaults synchronize];
    
    NSString *gatewayReg = nil;
    NSString *bodyReg = nil;
    
    NSString *payment_type = [userDefaults valueForKey:Key_payment_type];
    if ([payment_type isEqualToString:@"2"]) {
        
        gatewayReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_sms_DK_command_gateway]];
        bodyReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_sms_DK_command_body]];
        
    }else {
        
        gatewayReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_subSms_DK_command_gateway]];
        bodyReg = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_subSms_DK_command_body]];
    }
    
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyReg;
        controller.recipients = @[gatewayReg];
        controller.messageComposeDelegate = self;
        [AppDelegate addLocalLog:@"LG159"];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
            [self presentModalViewController:controller animated:YES];
        else
            [self presentViewController:controller animated:YES completion:Nil];
        
        viewWifiLogin.hidden = YES;
    }
}


/*
 * step 10: call api gửi lên server để trừ tiền số điện thoại
 *
 * http://27.118.23.11/GSoapClientTest/src/framework/base/GSoapTest.php?mobile=<mobileNumber>&code=<HUY hoac DK>&singer=<DONGNHI,...>&sign=<signature>
 *
 */

-(void) apiRequestGSoapTest:(NSString *)phoneNumber {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG60"];
    
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
    
    NSString *singerTelco_code = [[NSUserDefaults standardUserDefaults] objectForKey:Key_Singer_Telco_code];
    if ([singerTelco_code length] == 0)
        singerTelco_code = KEY_SINGER_NAME;
    
    NSString *singerSecret_key = [[NSUserDefaults standardUserDefaults] objectForKey:Key_Singer_Secret_key];
    if ([singerSecret_key length] == 0)
        singerSecret_key = KEY_secretKey;
    
    NSString *signStringValue = [NSString stringWithFormat:@"%@%@%@%@%@",phoneNumber,@"DK",singerTelco_code,@"MYIDOL",singerSecret_key];
    NSString *signFormatMd5ServerRP = [self md5:signStringValue];
    
    [API callAPIGSoapTestPhoneNumber:phoneNumber code:@"DK" singer:singerTelco_code sign:signFormatMd5ServerRP completed:^(NSString *responseString, NSError *error) {
        
        /*
         * Response: 1 – thành công
         * signature = md5(mobileNumber + code + singer + "MYIDOL” + secretKey);
         * Khác 1 – Có  lỗi
         */
        
        if (!error) {
            
            NSDictionary *responseDic = [responseString JSONValue];
            
            int soapTestValue = [[responseDic valueForKey:@"return_code"] intValue];
            NSString *server_signRP = [NSString stringWithFormat:@"%@",[responseDic valueForKey:@"server_sign"]];
            
            if ([server_signRP isEqualToString:signFormatMd5ServerRP]) {
                
                if (soapTestValue == 1) {
                    
                    //-- while () Request server với số điện thoại nhận đc ở bước trên đã charged hay chưa? Time Out = ?
                    [self apiCheckChargedTimeOutByPhoneNumber:phoneNumber];
                    
                }else {
                    
                    [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                    
                    //-- show message: Đăng ký thất bại
                    [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_Registed_Error withFriendName:nil needDelegate:NO withTag:2];
                }
                
            }else {
                
                [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                
                //-- show message: Đăng ký thất bại
                [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_Registed_Error withFriendName:nil needDelegate:NO withTag:2];
            }
            
        }else {
            
            //-- hidden loading
            [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
            
            [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
        }
        
    }];
}



/*
 * step 11: call api gửi lên server để trừ tiền số điện thoại
 *
 * http://core.vteen.vn/SMSBIllingSystem/Application/Server/MPlus/ChargingSub.php?id=12_20140122154602&m=0901823245&c=DK+DONGNHI&s=000a2ae515f9e39cbf25d657f1c5945
 *
 */

-(void) apiCashPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG61"];
    
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
    
    //-- get singer info default
    NSString *singerTelco_code = [[NSUserDefaults standardUserDefaults] objectForKey:Key_Singer_Telco_code];
    if ([singerTelco_code length] == 0)
        singerTelco_code = KEY_SINGER_NAME;
    
    NSString *singerSecret_key = [[NSUserDefaults standardUserDefaults] objectForKey:Key_Singer_Secret_key];
    if ([singerSecret_key length] == 0)
        singerSecret_key = KEY_secretKey;
    
    NSString *singerAgency_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:Key_Singer_Agency_id]];
    
    if ([singerAgency_id length] == 0)
        singerAgency_id = KEY_agency_id;
    
    
    //-- get date format YYYYMMDDHHMMSS
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    NSString *reqIdStr = [NSString stringWithFormat:@"%@_%@",singerAgency_id,dateString];
    NSString *smsContentStr = [NSString stringWithFormat:@"DK %@",singerTelco_code];
    
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@",reqIdStr,phoneNumber,smsContentStr,singerSecret_key];
    NSString *signFormatMd5 = [self md5:signStr];
    
    [API callCashPhoneNumberReqId:reqIdStr mobileNumber:phoneNumber smsContent:smsContentStr sign:signFormatMd5 completed:^(NSDictionary *responseDictionary, NSError *error) {
        
        /* return_code:
         * 0 --> thành công
         * 5 --> đã đăng ký trước đó, ko phải đăng ký lại và ko bị trừ tiền nữa
         * sign = md5(reqId + return_code + mobileNumber + "MYIDOL” + secretKey). Cần phải check sign trong trường hợp thành công (return_code=0 hoặc 5) trước khi xử lý  để tránh giả mạo thông tin
         *
         * các giá trị khác --> hiện message
         */
        
        if (!error) {
            [AppDelegate addLocalLog:@"LG62"];
            
            int return_code = [[responseDictionary valueForKey:@"return_code"] intValue];
            NSString *server_signRP = [responseDictionary valueForKey:@"server_sign"];
            
            if (return_code == 0 || return_code == 5) {
                
                NSString *signStringValue = [NSString stringWithFormat:@"%@%d%@%@%@",reqIdStr,return_code,phoneNumber,@"MYIDOL",singerSecret_key];
                NSString *signFormatMd5ServerRP = [self md5:signStringValue];
                
                if ([server_signRP isEqualToString:signFormatMd5ServerRP]) {
                    
                    //-- while () Request server với số điện thoại nhận đc ở bước trên đã charged hay chưa? Time Out = ?
                    [self apiCheckChargedTimeOutByPhoneNumber:phoneNumber];
                    
                }else {
                    
                    [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                    
                    //-- show message: Đăng ký thất bại
                    [self showMessageWithType:VMTypeMessageOk withMessage:[responseDictionary valueForKey:@"message"] withFriendName:nil needDelegate:NO withTag:3];
                }
                
            }else {
                
                [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
                
                //-- show message: Đăng ký thất bại
                [self showMessageWithType:VMTypeMessageOk withMessage:[responseDictionary valueForKey:@"message"] withFriendName:nil needDelegate:NO withTag:3];
            }
            
        }else {
            
            //-- hidden loading
            [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
            
            [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
        }
        
    }];
}

//-- convert md5
- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


/*
 * step 12: call api gửi lên server check Charged for Phone number
 * while () Request server với số điện thoại nhận đc ở bước trên đã charged hay chưa? Time Out = ?
 */

-(void) apiCheckChargedTimeOutByPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"%s", __func__);
    [AppDelegate addLocalLog:@"LG63"];
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    
    if (isErrorNetWork) {
        
        //-- show loading
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
        
        NSUserDefaults *defaultPhoneNumber = [NSUserDefaults standardUserDefaults];
        [defaultPhoneNumber setValue:phoneNumber forKey:MY_PhonNumber_ID];
        [defaultPhoneNumber synchronize];
        [AppDelegate addLocalLogWithString:@"LG65" info:phoneNumber];
        
        if ([self checkFreeAppAndCreateAccount] == YES) {
            
            //-- is free
            NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
            NSDictionary *result = [defaultFacebookResult valueForKey:@"FacebookResult"];
            [AppDelegate addLocalLog:@"LG66"];
            
            //-- API gửi FacebookId và Số ĐT để đăng ký user.
            [self apiCreateAccount:result];
            
        }else {
            
            [timerRequest invalidate];
            totalTimeRequest = 0;
            [AppDelegate addLocalLog:@"LG67"];
            isProcessAPI = false;
            timerRequest = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                            target:self
                                                          selector:@selector(checkChargedAgainByPhoneNumber:)
                                                          userInfo:nil
                                                           repeats:YES];
        }
        
    }else {
        [AppDelegate addLocalLog:@"LG64"];
        
        //-- hidden loading
        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
    }
}


-(void) checkChargedAgainByPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"%s", __func__);
    
    NSUserDefaults *defaultPhoneNumber = [NSUserDefaults standardUserDefaults];
    phoneNumber = [defaultPhoneNumber valueForKey:MY_PhonNumber_ID];
    
    totalTimeRequest += timerRequest.timeInterval;
    
    if (totalTimeRequest <= 60*2) {
        [[SHKActivityIndicator currentIndicator] displayActivity:[NSString stringWithFormat:@"Đang xử lý ... %ld%%", lroundf(totalTimeRequest*100/(60*2))]];
        
        NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
        if (!isProcessAPI) {
            isProcessAPI = true;
            [API getUserExistByPhoneNumberTypeRequest:@"charged" mobile:phoneNumber completed:^(NSDictionary *responseDictionary, NSError *error) {
                
                /* --- user nạp tiền ---
                 * status: 1: số điện thoại đã nạp tiền nhưng chưa kích hoạt
                 * status: 2: số điện thoại chưa nạp tiền
                 */
                [AppDelegate addLocalLog:@"LG68"];
                
                if (!error) {
                    
                    int status = [[responseDictionary objectForKey:@"status"] intValue];
                    
                    if (status == 1) {
                        
                        [timerRequest invalidate];
                        
                        NSDictionary *result = [defaultFacebookResult valueForKey:@"FacebookResult"];
                        [AppDelegate addLocalLog:@"LG80"];
                        
                        //-- API gửi FacebookId và Số ĐT để đăng ký user.
                        [self apiCreateAccount:result];
                    }
                    else {
                        [AppDelegate addLocalLog:@"LG81"];
                        isProcessAPI = false;
                    }
                }
                else
                    isProcessAPI = false;
                
            }];
        }
        
    }else {
        [AppDelegate addLocalLog:@"LG69"];
        
        [defaultPhoneNumber removeObjectForKey:MY_PhonNumber_ID];
        
        [timerRequest invalidate];
        
        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
        isProcessAPI = false;
        //-- show message: Đăng ký thất bại
        [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_Registed_Error withFriendName:nil needDelegate:NO withTag:4];
    }
}

/*
 * step Last: call api to Noo' server
 */

- (void)apiCreateAccount:(NSDictionary *)result
{
    NSLog(@"%s", __func__);
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    [AppDelegate addLocalLog:@"LG90 createA"];
    
    if (isErrorNetWork) {
        
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Sending..."];
        
        NSUserDefaults *defaultPhoneNumber = [NSUserDefaults standardUserDefaults];
        NSString *phoneNumber = [defaultPhoneNumber valueForKey:MY_PhonNumber_ID];
        NSString *passwordInput = [defaultPhoneNumber valueForKey:@"PasswordInputDefault"];
        if (!passwordInput && [passwordInput length] == 0) {
            passwordInput = @"xxxxxx";
        }
        
        NSString *userName          = [result objectForKey:@"name"];
        NSString *fullName          = [result objectForKey:@"name"];
        NSString *password          = passwordInput;
        NSString *email             = [result objectForKey:@"email"];
        
        NSString *gender            = nil;
        NSString *genderTmp         = [result objectForKey:@"gender"];
        
        if ([[genderTmp lowercaseString] isEqualToString:@"male"])
            gender = @"1";
        else
            gender = @"2";
        
        NSString *birthdayTmp        = [result objectForKey:@"birthday"];
        NSArray *componnentsBirthday = [birthdayTmp componentsSeparatedByString:@"/"];
        NSString *birthday           = [NSString stringWithFormat:@"%@%@%@",componnentsBirthday[2], componnentsBirthday[0], componnentsBirthday[1]];
        
        NSString *countryIso         = @"VN";
        NSString *fbUserId           = [result objectForKey:@"id"];
        NSString *accessToken        = [[NSUserDefaults standardUserDefaults] valueForKey:MY_ACCOUNT_ACCESS_TOKEN_FB];
        NSString *mobile             = phoneNumber;
        
        NSString *userImage = @"";
        NSString *isAvatarDefault = [[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"is_silhouette"] stringValue];
        
        if (![isAvatarDefault isEqualToString:@"1"])
            userImage = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        
        NSString *coverPhoto         = @"";
        
        //-- using api create account
        [API createAccount:userName
                  fullName:fullName
                 passwordd:password
                     email:email
                    gender:gender
                  birthday:birthday
                countryIso:countryIso
                  fbUserId:fbUserId
               accessToken:accessToken
                    mobile:mobile
                 userImage:userImage
                     appID:PRODUCTION_ID
                appVersion:PRODUCTION_VERSION
                coverPhoto:coverPhoto
                 completed:^(NSDictionary *responseDictionary, NSError *error) {
                     
                     //-- hidden loading
                     [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.5f];
                     
                     if (!error) {
                         
                         //-- fetching
                         [self createDataSourceUserInfo:responseDictionary withFacebookID:fbUserId];
                         
                     }else {
                         [defaultPhoneNumber removeObjectForKey:MY_PhonNumber_ID];
                         
                         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                         NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
                         
                         [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
                     }
                     isProcessAPI = false;
                     
                 }];
    }else {
        isProcessAPI = false;
        //-- hidden loading
        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
    }
}


- (void)createDataSourceUserInfo:(NSDictionary *)aDict withFacebookID:(NSString *) fbUserId
{
    NSLog(@"%s", __func__);
    NSDictionary *dictData  =  [aDict objectForKey:@"data"];
    [AppDelegate addLocalLog:@"LG11"];
    
    if (dictData)
    {
        //-- get user's info
        self.myAccount = [Profile new];
        self.myAccount.userId         =  [dictData objectForKey:@"user_id"];
        self.myAccount.userType       =  [dictData objectForKey:@"user_type"];
        self.myAccount.fullName       =  [dictData objectForKey:@"full_name"];
        self.myAccount.userImage      =  [dictData objectForKey:@"user_image"];
        self.myAccount.point          =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"point"]];
        self.myAccount.rankPosition   =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"rank_position"]];
        self.myAccount.userStatusImage=  [dictData objectForKey:@"user_status_image"];
        self.myAccount.totalShare     =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"total_share"]];
        self.myAccount.totalChat      =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"total_chat"]];
        self.myAccount.totalLike      =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"total_like"]];
        self.myAccount.audioView      =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"audio_view"]];
        self.myAccount.videoView      =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"video_view"]];
        self.myAccount.status         =  [dictData objectForKey:@"status"];
        self.myAccount.userPremiumUpgrade = [ NSString stringWithFormat:@"%@",[dictData objectForKey:@"user_premium_upgrade"]];
        self.myAccount.registerTime      = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"register_time"]];
        
        NSInteger totalCommentLevel1 = [[dictData objectForKey:@"total_comment"] integerValue];
        NSInteger totalCommentLevel2 = [[dictData objectForKey:@"total_comment_level_2"] integerValue];
        NSInteger totalSuperComment = totalCommentLevel1 + totalCommentLevel2;
        
        self.myAccount.totalComment = [NSString stringWithFormat:@"%d",totalSuperComment];
        
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:MY_ACCOUNT_ACCESS_TOKEN_FB];
        
        //-- cache my account's info
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:fbUserId forKey:MY_Facebook_ID];
        [userDefaults setObject:accessToken forKey:MY_Facebook_AccToken];
        [userDefaults setObject:self.myAccount.userId forKey:MY_ACCOUNT_ID];
        [userDefaults setObject:self.myAccount.userId forKey:TEMP_MY_ACCOUNT_ID];
        
        if ([self checkFreeAppAndCreateAccount] == YES) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if (![userDefaults valueForKey:@"FreeTimeSinger"]) {
                
                NSDate* currentdate = [NSDate date];
                [userDefaults setValue:currentdate forKey:@"FreeTimeSinger"];
            }
            
        }else {
            
            [userDefaults removeObjectForKey:@"FreeTimeSinger"];
        }
        
        [Profile setProfile:self.myAccount];
        
        //        NSData *dataMyAccount = [NSKeyedArchiver archivedDataWithRootObject:self.myAccount];
        //        [userDefaults setObject:dataMyAccount forKey:MY_ACCOUNT_INFO];
        
        [userDefaults setBool:YES forKey:CREATE_ACCOUNT_SUCCESS];
        [userDefaults synchronize];
        
        //-- remove view
        [self selectedButtonExist:viewWifiLogin.btnExist];
        
        //-- shoot delegate
        [AppDelegate addLocalLogWithString:@"call delegrate" info:[[self delegateBaseController] debugDescription]];
        if (self.delegateBaseController && [self.delegateBaseController respondsToSelector:@selector(baseViewController:didCreateAccountSuscessful:)]) {
            [AppDelegate addLocalLog:@"LG12"];
            
            [self.delegateBaseController baseViewController:self didCreateAccountSuscessful:self.myAccount];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:[NSString stringWithFormat:@"Bạn đã đăng ký dịch vụ thành công"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
        
        [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
    }
}


//-- Thông báo nâng cấp user
-(void) showMessageUpdateLevelOfUser {
    NSLog(@"%s", __func__);
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *defaultCenter = [NSUserDefaults standardUserDefaults];
    BOOL isShowUpdateLevel = [defaultCenter boolForKey:@"SetShowPopupUpdateLevel"];
    
    if (isShowUpdateLevel == NO && [dataCenter checkExistWifiLoginView] == NO) {
        
        //-- Call notification reload data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload_MusicAlbumVC" object:nil];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //        NSString *phoneNumber = [userDefaults valueForKey:MY_PhonNumber_ID]; //longnh fix
        NSString *phoneNumber = [userDefaults valueForKey:MOBILE_NUMBER]; //longnh fix
        
        if (phoneNumber && [phoneNumber length] > 5) {
            
            //-- nâng cấp user
            [self createAccount];
            
        }else {
            
            //-- show alert Dieu le
            [self addWebviewPurview];
        }
    }
}


//************************************************************************//
#pragma mark - ShowMessage

-(void) showMessageWithType:(VMTypeMessage) typeMessage withMessage:(NSString *) messageStr withFriendName:(NSString *)friendName needDelegate:(BOOL) needDelegate withTag:(NSInteger) tag
{
    UIAlertView *alertview = nil;
    
    switch (typeMessage) {
        case VMTypeMessageOk:
            alertview = [[UIAlertView alloc] initWithTitle:kTitleMessageApp message:messageStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            if (needDelegate == YES)
                [alertview setDelegate:self];
            break;
        case VMTypeMessageYesNo:
            alertview = [[UIAlertView alloc] initWithTitle:kTitleMessageApp message:messageStr delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            if (needDelegate == YES)
                [alertview setDelegate:self];
            break;
            
        default:
            break;
    }
    
    [alertview setTag:tag];
    [alertview show];
}


//--Alertview Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    int tag = alertView.tag;
    switch (tag) {
            
        case 1:
            break;
            
        case 999:{
            
            if (buttonIndex == 1) {
                UIDevice *device = [UIDevice currentDevice];
                if ([[device model] isEqualToString:@"iPhone"] ) {
                    
                    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",dataCenter.schedulePhone]]];
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                }
                
            }else return;
            
            break;
        }
            
        default:
            break;
    }
}

//-- validate content
-(void) validateContentInputAlertView:(NSString *) phoneNumberInput withPassword:(NSString *) passwordInput {
    NSLog(@"%s", __func__);
    
    NSString *tempVerifyInput = [passwordInput stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL verifyInputSpaces = [tempVerifyInput isEqualToString:@""];
    
    if (!verifyInputSpaces && [tempVerifyInput length] > 0) {
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:passwordInput forKey:@"PasswordInputDefault"];
        [userDefaults synchronize];
        
        NSString *tempPhoneNumber = [phoneNumberInput stringByReplacingOccurrencesOfString:@" " withString:@""];
        BOOL thereAreJustSpaces = [tempPhoneNumber isEqualToString:@""];
        
        //-- check PhoneNumber existed.
        if( (!thereAreJustSpaces && [phoneNumberInput length] > 5)) {
            
            //-- Get Carrier Info
            CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
            CTCarrier *carrieraa = [netinfo subscriberCellularProvider];
            
            if ([carrieraa.isoCountryCode isEqualToString:@""] && [carrieraa.carrierName isEqualToString:@"Carrier"]) {
                
                /*
                 * Không có Sim Unvalidate phone number
                 */
                
                //-- call api verify
                [self apiVerifyLoginWithPhoneNumber:phoneNumberInput];
                
            }else {
                
                /*
                 * Co Sim validate Phone number.
                 */
                
                //-- validate phone number
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *telcoPhoneNumberStr = [userDefaults valueForKey:Key_telco_phone_number_list];
                
                if (telcoPhoneNumberStr && [telcoPhoneNumberStr length] > 1) {
                    
                    BOOL isNextStep = NO;
                    
                    NSArray *listURL = [telcoPhoneNumberStr componentsSeparatedByString:@","];
                    
                    if (listURL.count >0) {
                        
                        for (int i = 0; i < listURL.count; i++) {
                            
                            NSString *phoneNameStr = [listURL objectAtIndex:i];
                            phoneNameStr = [phoneNameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                            
                            NSString *firstPhoneTelco = [Utility getFirstPhoneNumberTelco:phoneNameStr];
                            NSString *numberOfCharPhoneTelco = [Utility getNumberOfCharPhoneNumberTelco:phoneNameStr];
                            
                            NSString *firstPhoneInput = [phoneNumberInput substringToIndex:[firstPhoneTelco length]];
                            
                            if ([firstPhoneTelco isEqualToString:firstPhoneInput]) {
                                
                                if ([phoneNumberInput length] == [numberOfCharPhoneTelco intValue]) {
                                    
                                    isNextStep = YES;
                                    break;
                                    
                                }else {
                                    //-- Số ký tự nhập vào không đúng
                                    isNextStep = NO;
                                }
                                
                            }else {
                                //-- Đầu số không tồn tại
                                isNextStep = NO;
                            }
                        }
                    }
                    
                    if (isNextStep == YES) {
                        
                        //-- call api verify
                        [self apiVerifyLoginWithPhoneNumber:phoneNumberInput];
                        
                    }else {
                        
                        //-- Thông báo số điện thoại nhập vào không đúng.
                        [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_FailPhoneNumber withFriendName:nil needDelegate:NO withTag:6];
                    }
                    
                }else {
                    
                    //-- call api verify
                    [self apiVerifyLoginWithPhoneNumber:phoneNumberInput];
                }
                
            }
            
        }else {
            
            //-- Thông báo số điện thoại nhập vào không đúng.
            [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_EmptyPhoneNumber withFriendName:nil needDelegate:NO withTag:6];
        }
        
    }else {
        
        //-- Thông báo chưa nhập vào mã xác nhận.
        [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_FailVerify withFriendName:nil needDelegate:NO withTag:6];
    }
}


//*******************************************************************************************//
#pragma mark - Share and Invite Friend

//-- add view share and invite
-(void) addViewShareInviteWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)urlLink imagePath:(NSString *)imagePath contentId:(NSString*)contentId contentTypeId:(NSString*)contentTypeId {
    NSLog(@"%s", __func__);
    
    //-- set data share default
    NSUserDefaults *dataShareDefault = [NSUserDefaults standardUserDefaults];
    [dataShareDefault setValue:title forKey:@"titleShareDefault"];
    [dataShareDefault setValue:content forKey:@"contentShareDefault"];
    [dataShareDefault setValue:urlLink forKey:@"urlLinkShareDefault"];
    [dataShareDefault setValue:imagePath forKey:@"imagePathShareDefault"];
    [dataShareDefault setValue:contentId forKey:@"contentIdShareDefault"];
    [dataShareDefault setValue:contentTypeId forKey:@"contentTypeIdShareDefault"];
    [dataShareDefault synchronize];
    
    
    NSArray *objectLevelTop = [[NSBundle mainBundle] loadNibNamed:@"ShareInviteFriendView" owner:nil options:nil];
    
    shareInviteFriend = [objectLevelTop objectAtIndex:0];
    shareInviteFriend.frame = CGRectMake(0, 0, 320, 568);
    //add round corner
    shareInviteFriend.viewShareInvite.layer.cornerRadius = 5;
    shareInviteFriend.viewShareInvite.layer.masksToBounds = YES;
    
    //-- set action to button
    [shareInviteFriend.btnHiddenView addTarget:self action:@selector(hiddenViewShareInviteAnimation) forControlEvents:UIControlEventTouchUpInside];
    [shareInviteFriend.btnFacebook addTarget:self action:@selector(selectedButtonShareWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [shareInviteFriend.btnSMS addTarget:self action:@selector(selectedButtonInviteFriendSMS) forControlEvents:UIControlEventTouchUpInside];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [dataCenter.window addSubview:shareInviteFriend];
    
    shareInviteFriend.viewShareInvite.alpha = 0;
    
    //-- now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:0.45 animations:^{
        
        //--show view animation
        shareInviteFriend.viewShareInvite.alpha = 1.0;
        
        // first reduce the view to 1/100th of its original dimension
        CGAffineTransform trans = CGAffineTransformTranslate(shareInviteFriend.viewShareInvite.transform, 0.5, 0.5);
//        CGAffineTransform trans = CGAffineTransformScale(shareInviteFriend.viewShareInvite.transform, 0.01, 0.01);
        shareInviteFriend.viewShareInvite.transform = trans;	// do it instantly, no animation
        [shareInviteFriend.viewShareInvite setTransform:CGAffineTransformMakeScale(1,1)];
        
    }];
}

-(void) selectedButtonShareWithFacebook {
    NSLog(@"%s", __func__);
    
    //-- removeShareInviteFriendView
    [self hiddenViewShareInviteAnimation];
    
    //-- share facebook
    NSUserDefaults *dataShareDefault = [NSUserDefaults standardUserDefaults];
    NSString *titleShare = [dataShareDefault valueForKey:@"titleShareDefault"];
    NSString *contentShare = [dataShareDefault valueForKey:@"contentShareDefault"];
    NSString *urlLinkShare = [dataShareDefault valueForKey:@"urlLinkShareDefault"];
    NSString *imagePathShare = [dataShareDefault valueForKey:@"imagePathShareDefault"];
    NSString *contentIdShare = [dataShareDefault valueForKey:@"contentIdShareDefault"];
    NSString *contentTypeIdShare = [dataShareDefault valueForKey:@"contentTypeIdShareDefault"];
    
    [self shareFacebookWithTitle:titleShare content:contentShare url:urlLinkShare imagePath:imagePathShare contentId:contentIdShare contentTypeId:contentTypeIdShare];
}

-(void) selectedButtonInviteFriendSMS {
    NSLog(@"%s", __func__);
    
    //-- removeShareInviteFriendView
    [self hiddenViewShareInviteAnimation];
    
    //-- invite SMS
    InviteFriendViewController *inviteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbIDInviteFriendViewController"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:inviteVC animated:YES];
    else
        [self.navigationController pushViewController:inviteVC animated:NO];
}

- (void) hiddenViewShareInviteAnimation
{
    NSLog(@"%s", __func__);
    [UIView beginAnimations:@"MoveAnimation" context:nil];
    [UIView setAnimationDuration:0.45];
    [shareInviteFriend.viewShareInvite setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
    [shareInviteFriend.viewShareInvite setAlpha:0.0];
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeShareInviteFriendView) withObject:nil afterDelay:0.45];
}

- (void) removeShareInviteFriendView
{
    [shareInviteFriend removeFromSuperview];
}


//*******************************************************************************************//
#pragma mark - Private Download

-(BOOL) checkUserDownloadWithDateByType:(DownloadType) downloadType {
    NSLog(@"%s", __func__);
    
    BOOL isDownload = NO;
    
    switch (downloadType) {
        case DownloadTypeMusic:
            isDownload = [self checkDownloadMusicLimit];
            break;
            
        case DownloadTypeVideo:
            isDownload = [self checkDownloadVideoLimit];
            break;
            
        case DownloadTypePhoto:
            isDownload = [self checkDownloadPhotoLimit];
            break;
            
        default:
            isDownload = NO;
            break;
    }
    
    return isDownload;
}


//-- check download Music limit
-(BOOL) checkDownloadMusicLimit {
    NSLog(@"%s", __func__);
    
    NSUserDefaults *defaultDownload = [NSUserDefaults standardUserDefaults];
    NSInteger downloadable_music_nubmer = [[defaultDownload valueForKey:@"Key_downloadable_music_nubmer"] integerValue];
    //    NSInteger downloadable_music_start_time = [[defaultDownload valueForKey:@"Key_downloadable_music_start_time"] integerValue];
    NSInteger downloadable_music_period_time = [[defaultDownload valueForKey:@"Key_downloadable_music_period_time"] integerValue];
    NSString *downloadable_music_message_wranning = [defaultDownload valueForKey:@"Key_downloadable_music_message_wranning"];
    
    if (downloadable_music_nubmer == 0) {
        
        //-- show message download warning
        [self showMessageWithType:VMTypeMessageOk withMessage:downloadable_music_message_wranning withFriendName:nil needDelegate:NO withTag:6];
        return NO;
        
    }else {
        
        //-- check Refresh Download Private By Date
        NSDate *enddate = [[NSUserDefaults standardUserDefaults] valueForKey:@"DownloadPrivateByDate"];
        NSDate* currentdate = [NSDate date];
        
        NSTimeInterval distanceBetweenDates = [currentdate timeIntervalSinceDate:enddate];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates >= downloadable_music_period_time){
            
            //-- open Refresh Download Private By Date
            [defaultDownload setValue:currentdate forKey:@"DownloadPrivateByDate"];
            
            //-- set number of download limit
            [defaultDownload setValue:@"0" forKey:@"NumberOfDownloadPrivateMusic"];
            [defaultDownload synchronize];
            
            return YES;
            
        }else {
            
            //-- check number of Downloaded
            NSInteger numberOfDownloadPrivateMusic = [[defaultDownload valueForKey:@"NumberOfDownloadPrivateMusic"] integerValue];
            
            if (numberOfDownloadPrivateMusic >= downloadable_music_nubmer) {
                
                //-- show message download warning
                [self showMessageWithType:VMTypeMessageOk withMessage:downloadable_music_message_wranning withFriendName:nil needDelegate:NO withTag:6];
                return NO;
                
            }else {
                
                return YES;
            }
        }
    }
}


//-- check download Video limit
-(BOOL) checkDownloadVideoLimit {
    NSLog(@"%s", __func__);
    
    NSUserDefaults *defaultDownload = [NSUserDefaults standardUserDefaults];
    NSInteger downloadable_video_nubmer = [[defaultDownload valueForKey:@"Key_downloadable_video_nubmer"] integerValue];
    //    NSInteger downloadable_video_start_time = [[defaultDownload valueForKey:@"Key_downloadable_video_start_time"] integerValue];
    NSInteger downloadable_video_period_time = [[defaultDownload valueForKey:@"Key_downloadable_video_period_time"] integerValue];
    NSString *downloadable_video_message_wranning = [defaultDownload valueForKey:@"Key_downloadable_video_message_wranning"];
    
    if (downloadable_video_nubmer == 0) {
        
        //-- show message download warning
        [self showMessageWithType:VMTypeMessageOk withMessage:downloadable_video_message_wranning withFriendName:nil needDelegate:NO withTag:6];
        return NO;
        
    }else {
        
        //-- check Refresh Download Private By Date
        NSDate *enddate = [[NSUserDefaults standardUserDefaults] valueForKey:@"DownloadPrivateByDate"];
        NSDate* currentdate = [NSDate date];
        
        NSTimeInterval distanceBetweenDates = [currentdate timeIntervalSinceDate:enddate];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates >= downloadable_video_period_time){
            
            //-- open Refresh Download Private By Date
            [defaultDownload setValue:currentdate forKey:@"DownloadPrivateByDate"];
            
            //-- set number of download limit
            [defaultDownload setValue:@"0" forKey:@"NumberOfDownloadPrivateVideo"];
            [defaultDownload synchronize];
            
            return YES;
            
        }else {
            
            //-- check number of Downloaded
            NSInteger numberOfDownloadPrivateVideo = [[defaultDownload valueForKey:@"NumberOfDownloadPrivateVideo"] integerValue];
            
            if (numberOfDownloadPrivateVideo >= downloadable_video_nubmer) {
                
                //-- show message download warning
                [self showMessageWithType:VMTypeMessageOk withMessage:downloadable_video_message_wranning withFriendName:nil needDelegate:NO withTag:6];
                return NO;
                
            }else {
                
                return YES;
            }
        }
    }
}

//-- check download Photo limit
-(BOOL) checkDownloadPhotoLimit {
    NSLog(@"%s", __func__);
    
    NSUserDefaults *defaultDownload = [NSUserDefaults standardUserDefaults];
    NSInteger downloadable_photo_number = [[defaultDownload valueForKey:@"Key_downloadable_photo_number"] integerValue];
    //    NSInteger downloadable_photo_start_time = [[defaultDownload valueForKey:@"Key_downloadable_photo_start_time"] integerValue];
    NSInteger downloadable_photo_period_time = [[defaultDownload valueForKey:@"Key_downloadable_photo_period_time"] integerValue];
    NSString *downloadable_photo_message_wranning = [defaultDownload valueForKey:@"Key_downloadable_photo_message_wranning"];
    
    if (downloadable_photo_number == 0) {
        
        //-- show message download warning
        [self showMessageWithType:VMTypeMessageOk withMessage:downloadable_photo_message_wranning withFriendName:nil needDelegate:NO withTag:6];
        return NO;
        
    }else {
        
        //-- check Refresh Download Private By Date
        NSDate *enddate = [[NSUserDefaults standardUserDefaults] valueForKey:@"DownloadPrivateByDate"];
        NSDate* currentdate = [NSDate date];
        
        NSTimeInterval distanceBetweenDates = [currentdate timeIntervalSinceDate:enddate];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates >= downloadable_photo_period_time){
            
            //-- open Refresh Download Private By Date
            [defaultDownload setValue:currentdate forKey:@"DownloadPrivateByDate"];
            
            //-- set number of download limit
            [defaultDownload setValue:@"0" forKey:@"NumberOfDownloadPrivatePhoto"];
            [defaultDownload synchronize];
            
            return YES;
            
        }else {
            
            //-- check number of Downloaded
            NSInteger numberOfDownloadPrivatePhoto = [[defaultDownload valueForKey:@"NumberOfDownloadPrivatePhoto"] integerValue];
            
            if (numberOfDownloadPrivatePhoto >= downloadable_photo_number) {
                
                //-- show message download warning
                [self showMessageWithType:VMTypeMessageOk withMessage:downloadable_photo_message_wranning withFriendName:nil needDelegate:NO withTag:6];
                return NO;
                
            }else {
                
                return YES;
            }
        }
    }
}

@end
