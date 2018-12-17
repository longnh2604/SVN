//
//  AppDelegate.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/3/13.
//  Copyright MAC_OSX 2013. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "OpenUDID.h"

@implementation AppDelegate

@synthesize isMusicAlbum, isMusicAll, selectSong, isFanzone, isPhotoAlbum, isPhotoAll, isMusic;
@synthesize slideBarController, linkDownApp;
@synthesize schedulePhone;
@synthesize mainNavController;
@synthesize bottomBarController;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    return wasHandled;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s", __func__);
    _timeTest = [[NSDate date]timeIntervalSince1970];
    
    [AppDelegate addLocalLogWithFloat:@"startApp IOS @" n:[[NSDate date] timeIntervalSince1970]];
    [AppDelegate addLocalLogWithString:@"singer:" info:SINGER_ID];
    [AppDelegate addLocalLogWithString:@"distrchannel:" info:DISTRIBUTOR_CHANNEL_ID];
    
    //longnh: add 2 line nay vao de dang ky push notification
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];

    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    mainNavController = [storyboard instantiateInitialViewController];
    NSLog(@"x:%f y:%f",[[UIScreen mainScreen] bounds].origin.x,[[UIScreen mainScreen] bounds].origin.y);
    NSLog(@"w:%f h:%f",[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);

    UIViewController *splashViewController = [[UIViewController alloc] init];
    splashViewController.view.frame = [[UIScreen mainScreen] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        [imageView setImage:[UIImage imageNamed:@"Default@2x.png"]];
    } else {
        [imageView setImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        imageView.center = CGPointMake(imageView.center.x, imageView.center.y - 20);
    }
    [splashViewController.view addSubview:imageView];
    
    [mainNavController addChildViewController:splashViewController];
    
    [self.mainNavController setNavigationBarHidden:YES];
    self.window.rootViewController = mainNavController;

    [self.window makeKeyAndVisible];
    [mainNavController popToRootViewControllerAnimated:NO];
    
    NSLog(@"PRODUCTION_ID :%@ , DISTRIBUTOR_ID  :%@ , DISTRIBUTOR_CHANNEL_ID :%@ , CONTENT_PROVIDER_ID :%@",PRODUCTION_ID , DISTRIBUTOR_ID ,DISTRIBUTOR_CHANNEL_ID , CONTENT_PROVIDER_ID);

    [API getSettingWithProductionId:PRODUCTION_ID
                      distributorId:DISTRIBUTOR_ID
               distributorChannelId:DISTRIBUTOR_CHANNEL_ID
                         platformId:PlatformIOS
                  contentProviderId:CONTENT_PROVIDER_ID
                          completed:^(NSDictionary *responseDictionary, NSError *error) {
                              
                              [self parseSetting:responseDictionary];
                              
                          }];

    return YES;
}
- (void)startApp {
    NSLog(@"%s", __func__);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if(![[AVAudioSession sharedInstance] setActive:YES error:nil]) {
        NSLog(@"Failed to set up a session.");
    }
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    //-- check free app
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:@"FreeTimeSinger"])
    {
        
        NSDate *enddate = [[NSUserDefaults standardUserDefaults] valueForKey:@"FreeTimeSinger"];
        
        NSDate* currentdate = [NSDate date];
        NSTimeInterval distanceBetweenDates = [currentdate timeIntervalSinceDate:enddate];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        //-- update level user to Nomarl
        NSInteger freeTime = 1;
        
        if ([userDefaults valueForKey:Key_Free_Time])
            freeTime = [[userDefaults valueForKey:Key_Free_Time] integerValue];
        
        if (secondsBetweenDates >= 60*freeTime){
            
            [userDefaults removeObjectForKey:@"FreeTimeSinger"];
            [userDefaults removeObjectForKey:MY_ACCOUNT_ID];
            [userDefaults removeObjectForKey:MY_PhonNumber_ID];
            [userDefaults synchronize];
        }
    }
    
    //-- setup download limit
    if (![userDefaults objectForKey:@"FirstRunProject"]) {
        
        NSDate* currentdate = [NSDate date];
        [userDefaults setValue:currentdate forKey:@"DownloadPrivateByDate"];
        
        [userDefaults setValue:@"1strunProcedure" forKey:@"FirstRunProject"];
        
        //-- set number of download limit
        [userDefaults setValue:@"0" forKey:@"NumberOfDownloadPrivateMusic"];
        [userDefaults setValue:@"0" forKey:@"NumberOfDownloadPrivateVideo"];
        [userDefaults setValue:@"0" forKey:@"NumberOfDownloadPrivatePhoto"];
        [userDefaults synchronize];
    }
    
    
    isResumePlayer = NO;
    
    //-- Get Carrier Info
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrieraa = [netinfo subscriberCellularProvider];
    NSString *telcoGlobalCode = [NSString stringWithFormat:@"%@%@",carrieraa.mobileCountryCode,carrieraa.mobileNetworkCode];
    
    //-- remove data Default
    NSUserDefaults *defaultCenter = [NSUserDefaults standardUserDefaults];
    [defaultCenter setBool:NO forKey:@"Selected_ButtonNextSlideBar"];
    [defaultCenter setBool:NO forKey:@"isEditSlider"];
    [defaultCenter setObject:@"0" forKey:Key_Is_Free];
    
//    [defaultCenter setObject:@"837" forKey:MY_ACCOUNT_ID]; //longnh test
//    [defaultCenter synchronize]; //longnh test 
//    [defaultCenter setObject:@"0949583086" forKey:MOBILE_NUMBER]; //longnh test
//    [defaultCenter synchronize]; //longnh test
    
//    [defaultCenter removeObjectForKey:MY_ACCOUNT_ID];
    
    //[defaultCenter removeObjectForKey:MY_ACCOUNT_INFO];
    [defaultCenter removeObjectForKey:@"DefaultAlbumName"];
    [defaultCenter removeObjectForKey:@"DefaultAuthorMusicId"];
    [defaultCenter removeObjectForKey:@"DefaultNameSong"];
    [defaultCenter removeObjectForKey:@"DefaultAlbumThumbImagePath"];
    [defaultCenter removeObjectForKey:@"DefaultSongId"];
    
    //-- set default show update level
    [defaultCenter setBool:NO forKey:@"SetShowPopupUpdateLevel"];
    
    //-- set default Charging
    [defaultCenter setObject:@"1" forKey:@"isCharging"];
    
    //-- set default Telco Global Code
    [defaultCenter setObject:telcoGlobalCode forKey:@"TelcoGlobalCode"];
    
    [defaultCenter synchronize];
    
    //-- notification show full video
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillEnterFullscreenNotification:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreenNotification:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    
    /* Facebook: by Long Nguyen 30.12.2013 */
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_birthday"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }

    //-- create database
    [self createEditableCopyOfDatabaseIfNeeded];
    
    
    //-- get setting
//    [API getSettingWithProductionId:PRODUCTION_ID
//                      distributorId:DISTRIBUTOR_ID
//               distributorChannelId:DISTRIBUTOR_CHANNEL_ID
//                         platformId:PlatformIOS
//                  contentProviderId:CONTENT_PROVIDER_ID
//                          completed:^(NSDictionary *responseDictionary, NSError *error) {
//                              
//                              [self parseSetting:responseDictionary];
//                              
//     }];
    
    //-- get feed first
    [API getFeedofSingerID:PRODUCTION_ID
         productionVersion:PRODUCTION_VERSION
                  singerId:SINGER_ID completed:^(NSDictionary *responseDictionary, NSError *error)
     {
         //-- fetching
         [self getDatasourceFeedsWith:responseDictionary];
     }];
    
    //------- Google Analytics  -------//
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 30;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    
    // Initialize tracker.
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    mainNavController = [storyboard instantiateInitialViewController];
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"ID_MainViewController"];
    
    [self.mainNavController addChildViewController:mainViewController]; //[[UINavigationController alloc] initWithRootViewController:mainViewController];
    [self.mainNavController setNavigationBarHidden:YES];
    self.window.rootViewController = mainNavController;
    //    [self.window makeKeyAndVisible];
    [mainNavController popToRootViewControllerAnimated:NO];
    
    playWelcomeMusic = [[PlayWelcomeMusic alloc] init];
    [playWelcomeMusic getMusicOnServer];
    
    //-- add SildeBar Center
//    [self addSlideBarBottom];
    
    //-- add Bottom Bar
//    [self addBottomBar];
}

-(void) getDatasourceFeedsWith:(NSDictionary *)aDictionary
{
    NSMutableArray *arrNewsFeed = [aDictionary objectForKey:@"data"];
    
    if ([arrNewsFeed count] > 0)
    {
        [VMDataBase deleteAllFeedsFromDB];
        [VMDataBase deleteAllPhotoFeedsFromDB];
        
        for (NSInteger i = 0; i < [arrNewsFeed count]; i++)
        {
            ListFeedData *aFeeds = [ListFeedData new];
            
            aFeeds.feedType = [[arrNewsFeed objectAtIndex:i] objectForKey:@"type_id"];
            aFeeds.feedUserName = [[arrNewsFeed objectAtIndex:i] objectForKey:@"full_name"];
            aFeeds.feedUserImage = [[arrNewsFeed objectAtIndex:i] objectForKey:@"user_image"];
            aFeeds.feedTitle = [[arrNewsFeed objectAtIndex:i] objectForKey:@"title"];
            aFeeds.feedParentId = [[arrNewsFeed objectAtIndex:i] objectForKey:@"parent_user_id"];
            aFeeds.feedTimeStamp = [[arrNewsFeed objectAtIndex:i] objectForKey:@"time_stamp"];
            aFeeds.feedTimeUpdate = [[arrNewsFeed objectAtIndex:i] objectForKey:@"time_update"];
            
            NSDictionary *arrFeedData = [[arrNewsFeed objectAtIndex:i] objectForKey:@"feed_data"];
            //--Type of feed data content
            
            //page comment
            if ([aFeeds.feedType  isEqual: @"pages_comment"])
            {
                aFeeds.feedId = [arrFeedData objectForKey:@"feed_comment_id"];
                aFeeds.snsTotalComment = [arrFeedData objectForKey:@"total_comment"];
                aFeeds.snsTotalLike = [arrFeedData objectForKey:@"total_like"];
                aFeeds.snsTotalShare = [arrFeedData objectForKey:@"total_share"];
                aFeeds.snsTotalView = [arrFeedData objectForKey:@"total_view"];
            }
            
            //link
            if ([aFeeds.feedType  isEqual: @"link"])
            {
                aFeeds.feedId = [arrFeedData objectForKey:@"link_id"];
                aFeeds.feedLink = [arrFeedData objectForKey:@"link"];
                aFeeds.feedImage = [arrFeedData objectForKey:@"image"];
                aFeeds.feedDescription = [arrFeedData objectForKey:@"description"];
                aFeeds.snsTotalComment = [arrFeedData objectForKey:@"total_comment"];
                aFeeds.snsTotalLike = [arrFeedData objectForKey:@"total_like"];
                aFeeds.snsTotalShare = [arrFeedData objectForKey:@"total_share"];
                aFeeds.snsTotalView = [arrFeedData objectForKey:@"total_view"];
            }
            
            //video
            if ([aFeeds.feedType  isEqual: @"video"])
            {
                aFeeds.feedId = [arrFeedData objectForKey:@"video_id"];
                aFeeds.feedLink = [arrFeedData objectForKey:@"link"];
                aFeeds.feedImage = [arrFeedData objectForKey:@"thumbnail"];
                aFeeds.videoURL = [arrFeedData objectForKey:@"youtube_url"];
                aFeeds.snsTotalComment = [arrFeedData objectForKey:@"total_comment"];
                aFeeds.snsTotalLike = [arrFeedData objectForKey:@"total_like"];
                aFeeds.snsTotalShare = [arrFeedData objectForKey:@"total_share"];
                aFeeds.snsTotalView = [arrFeedData objectForKey:@"total_view"];
            }
            
            //photo
            if ([aFeeds.feedType isEqual: @"photo"])
            {
                aFeeds.feedId = [arrFeedData objectForKey:@"album_id"];
                aFeeds.photoList = [arrFeedData objectForKey:@"photo_list"];
                aFeeds.NoPhoto = [aFeeds.photoList count];
                aFeeds.albumId = [arrFeedData objectForKey:@"album_id"];
                
                for (NSInteger j=0; j<[aFeeds.photoList count]; j++)
                {
                    PhotoListFeedData *pListData = [[PhotoListFeedData alloc]init];
                    pListData.albumId = aFeeds.albumId;
                    pListData.photoId = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"photo_id"];
                    pListData.photoTitle = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"title"];
                    pListData.imagePath = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"destination"];
                    pListData.photoDescription = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"description"];
                    pListData.snsTotalLike = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_like"];
                    pListData.snsTotalComment = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_comment"];
                    pListData.snsTotalShare = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_share"];
                    pListData.snsTotalView = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_view"];
                    pListData.indexcell = [NSString stringWithFormat:@"%ld",(long)i];
                    
                    if ([aFeeds.albumId isEqual:@"0"])
                    {
                        aFeeds.snsTotalComment = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_comment"];
                        aFeeds.snsTotalLike = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_like"];
                        aFeeds.snsTotalShare = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_share"];
                        aFeeds.snsTotalView = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_view"];
                    }
                    else
                    {
                        aFeeds.snsTotalComment = [arrFeedData objectForKey:@"total_comment"];
                        aFeeds.snsTotalLike = [arrFeedData objectForKey:@"total_like"];
                        aFeeds.snsTotalShare = [arrFeedData objectForKey:@"total_share"];
                        aFeeds.snsTotalView = [arrFeedData objectForKey:@"total_view"];
                    }
                    
                    //-- insert into DB
                    [VMDataBase insertPhotoListFeedBySinger:pListData];
                }
            }
            
            //is like
            aFeeds.isLiked = [arrFeedData objectForKey:@"is_liked"];
            
            //-- insert into DB
            [VMDataBase insertFeedBySinger:aFeeds];
        }
    }
}

- (void) moviePlayerWillEnterFullscreenNotification:(NSNotification *)notification
{
	isShowFullScreen = YES;
}

- (void) moviePlayerWillExitFullscreenNotification:(NSNotification *)notification
{
	isShowFullScreen = NO;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (isShowFullScreen) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

-(void) addSlideBarBottom {
    NSLog(@"%s", __func__);
    
    //-- init slidebar
    slideBarController = [SlideBarCenterViewController sharedSlideBarCenter];
    
    CGFloat verticalLocation = self.window.frame.size.height - slideBarController.view.frame.size.height;
    slideBarController.view.frame = CGRectMake(0, verticalLocation, 320, 39);
    
    [self.window addSubview:slideBarController.view];
}

-(void) removeSlideBarBottom {
    NSLog(@"%s", __func__);
    
    [slideBarController.view removeFromSuperview];
}

-(BOOL) checkExistSlideBarBottom {
    NSLog(@"%s", __func__);
   
    if ([self.window.subviews containsObject:slideBarController.view])
        return YES;
    
    return NO;
}

//-- add bottom bar
-(void)addBottomBar
{
    NSLog(@"%s", __func__);
    
    //-- init slidebar
    bottomBarController = [MenuBottomBarViewController sharedBottomBarCenter];
    
    CGFloat verticalLocation = self.window.frame.size.height - bottomBarController.view.frame.size.height;
    bottomBarController.view.frame = CGRectMake(0, verticalLocation, 320, 60);
    
    [self.window addSubview:bottomBarController.view];
}

-(void)removeBottomBar
{
    NSLog(@"%s", __func__);
    
    [bottomBarController.view removeFromSuperview];
}

-(BOOL)checkExistBottomBar
{
    NSLog(@"%s", __func__);
    
    if ([self.window.subviews containsObject:bottomBarController.view])
        return YES;
    
    return NO;
}

-(BOOL) checkExistWifiLoginView {
    
    for (UIView *viewLogin in self.window.subviews) {
        
        if ([viewLogin isKindOfClass:[WifiLoginView class]]) {
            
            return YES;
        }
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"%s", __func__);
    BOOL isCall = [self isOnPhoneCall];
    
    if (isCall == YES) {
        
        //-- play again when call back
        if ([[AudioPlayer sharedAudioPlayerMusic] isPlayingSong]) {
            
            isResumePlayer = YES;
            
            [[AudioPlayer sharedAudioPlayerMusic] pauseSong];
            
        }else {
            
            isResumePlayer = NO;
        }
    }
    
}

-(bool)isOnPhoneCall {
    
    /*
     * Returns TRUE/YES if the user is currently on a phone call
     */
    
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    for (CTCall *call in callCenter.currentCalls)  {
        if (call.callState == CTCallStateIncoming) {
            return YES;
        }
    }
    
    return NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%s", __func__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%s", __func__);
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
    if (token) {
        [self sendPushToken:token];
    }
    //longnh add
    if (isResumePlayer == YES) {
        //truong hop nay chi xuat hien khi co cuoc goi den luc dang nghe nhac trong app.
        isResumePlayer = NO;
        if ([[AudioPlayer sharedAudioPlayerMusic] isPausedSong]) {
            [[AudioPlayer sharedAudioPlayerMusic] play];
        }
    } else {
        //Modified by TuanNM@20140828
        //Chi play song o che do pause neu dang choi nhac welcome
        if ([[AudioPlayer sharedAudioPlayerMusic] isPlayWelcomeMusic]) {
        //end modified
            if (![[AudioPlayer sharedAudioPlayerMusic] isPlayingSong]) {
                if ([[AudioPlayer sharedAudioPlayerMusic] isPausedSong]) {
                    [[AudioPlayer sharedAudioPlayerMusic] stop];
                }
            }
            //phai update lai
            playWelcomeMusic = [[PlayWelcomeMusic alloc] init];
            [playWelcomeMusic getMusicOnServer];
        }
    }


}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%s", __func__);
    [FBAppEvents activateApp];
    
    /* Facebook: by Long Nguyen 30.12.2013 */
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [[FBSession activeSession] handleDidBecomeActive];
    //-- play again when call back
//    if (isResumePlayer == YES) {
//        //truong hop nay chi xuat hien khi co cuoc goi den luc dang nghe nhac trong app.
//        isResumePlayer = NO;
//        if ([[AudioPlayer sharedAudioPlayerMusic] isPausedSong]) {
//                [[AudioPlayer sharedAudioPlayerMusic] play];
//        }
//    } else {
//        if (![[AudioPlayer sharedAudioPlayerMusic] isPlayingSong]) {
//            if ([[AudioPlayer sharedAudioPlayerMusic] isPausedSong]) {
//                [[AudioPlayer sharedAudioPlayerMusic] stop];
//            }
//            playWelcomeMusic = [[PlayWelcomeMusic alloc] init];
//            [playWelcomeMusic getMusicOnServer];        
//        }
//    }

    
    //longnh: tien hanh kiem tra user id co ton tai va enable tren server hay khong?
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    NSString *fbUserId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_Facebook_ID];
    if (fbUserId)
    {
        NSLog(@"Check user id:%@",fbUserId);
        //Gui len server kiem tra account co van de gi khong
//        [[SHKActivityIndicator currentIndicator] displayActivity:@"Checking..."];
        [API getUserExistByFBTypeRequest:@"Facebook" mobile:@"" fb_user_id:fbUserId completed:^(NSDictionary *responseDictionary, NSError *error) {
//            [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
            if (!error) {
                NSLog(@"response:%@",responseDictionary.description);
                NSInteger code = [[responseDictionary valueForKey:@"code"] integerValue];
                if (code == 1) {
                    NSLog(@"FB ID van ok");
                    [AppDelegate addLocalLogWithString:@"userexit" info:userId];
                    if (!userId) {
                        NSString *newUserID = [[responseDictionary valueForKey:@"user_info"] valueForKey:@"user_id"];
                        if (newUserID) {
                            if ([userId isKindOfClass:[NSString class]])
                                [AppDelegate addLocalLogWithString:@"save string" info:newUserID];
                            else
                                [AppDelegate addLocalLogWithString:@"save ?" info:[newUserID debugDescription]];
                            [[NSUserDefaults standardUserDefaults] setObject:newUserID forKey:MY_ACCOUNT_ID];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                        }
                    }
                }else {
                    NSLog(@"error: FB ID co van de tren server");
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MY_ACCOUNT_ID];
                }
                
            }
        }];
    }

    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //-- [[FacebookUtils facebookSession] close];
    
    [[FBSession activeSession] close];
}

#pragma mark - Push Notification


-(void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%s", __func__);
    //bundleid:myidol.noophuocthinh
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
	token = [token substringWithRange:NSMakeRange(1, [token length]-2)];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
 	NSLog(@"Push Token:%@", token);
    
    //Luu token vao NSUserDefault de gui lai moi khi back app background
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"push_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self sendPushToken:token];
}

-(void)application:(UIApplication *) application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%s", __func__);
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    NSLog(@"%s", __func__);
    //longnh: cho nay khong can xu ly, chi quan tam khi su dung local notification.
    [[UIApplication sharedApplication] cancelLocalNotification:notif];
}

-(void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%s", __func__);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)sendPushToken:(NSString*)pushToken {
    NSLog(@"%s", __func__);
    NSString *uuid = [OpenUDID value];
    NSString *singerID = SINGER_ID;//No Phuoc Thinh
    
    NSString *requestURL = @"http://acmservice.vteen.vn/index/token_push";
	NSString *postString;
	NSMutableURLRequest *request;
	
    postString = [NSString stringWithFormat:@"device_id=%@&os=1&token=%@&singer_id=%@", uuid, pushToken, singerID];
    
	// url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:requestURL]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setTimeoutInterval:30];
	[request setHTTPShouldHandleCookies:FALSE];
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         if ([data length] > 0 && error == nil) {
             NSLog(@"Send token push successful");
             NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"response:%@", str);
         } else {
             NSLog(@"Failed to send token push notification");
         }
         
     }];
}

#pragma mark - facebook

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        
        // Session opened
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // Show the user the logged-in UI
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        
        // If the session is closed
        // Session closed
        
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // Show the user the logged-out UI
    }
    
    // Handle errors
    if (error){
        
        NSString *alertText;
        NSString *alertTitle;
        
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            // [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                // [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                // [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // Show the user the logged-out UI
    }
}



#pragma mark - database

- (void)createEditableCopyOfDatabaseIfNeeded {
    NSLog(@"%s", __func__);
    
    NSLog(@"Creating editable copy of database");
    // First, test for existence.
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    if (success) return;
    
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
    
    NSLog(@"Default path: %@ - system path: %@", defaultDBPath, writableDBPath);
    
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message ‘%@’.", [error localizedDescription]);
    }
    
}


#pragma mark - setting

- (void)parseSetting:(NSDictionary *)aDictionary
{
    NSLog(@"%s", __func__);
    //NSLog(@"aDictionary:%@",[aDictionary description]);
    
    NSDictionary *dictSetting           = [aDictionary objectForKey:@"data"];
    NSString *isUpdateVersion           = [dictSetting objectForKey:@"is_update_version"];
    NSString *titleMessage              = [dictSetting objectForKey:@"update_version_message_title"];
    NSString *message                   = [dictSetting objectForKey:@"update_version_message"];
    NSString *linkDownAppStore          = [dictSetting objectForKey:@"update_version_store_id"];
    NSString *linkDownWeb               = [dictSetting objectForKey:@"update_version_link"];
    NSString *versionWantUpgrader       = [dictSetting objectForKey:@"production_version"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *checkAppRunFirst   = [userDefaults objectForKey:APP_RUN_FIRST];
    
    //longnh add
    if ([[aDictionary objectForKey:@"data"] objectForKey:API_DEF])
    {
        [AppDelegate addLocalLog:@"getSet1"];
        //luu cau hinh de truong hop o lay dc setting thi lay lai setting cu
        [userDefaults setObject:dictSetting forKey:API_CONF];
        [userDefaults synchronize];
        
        
        NSDictionary *linkDic = [[[aDictionary objectForKey:@"data"] objectForKey:API_DEF] JSONValue];
        NSLog(@"linkDic:%@",linkDic);
        if (linkDic) {
            [userDefaults setObject:linkDic forKey:API_DEF];
            [userDefaults synchronize];
        }
    }
    else
    {
        NSLog(@"Lay setting loi --> dung setting cu");
        [AppDelegate addLocalLog:@"getSet0"];
        if (checkAppRunFirst==nil || [checkAppRunFirst isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lỗi"
                                                            message:@"Ứng dụng không thể kết nối được đến máy chủ dịch vụ. Bạn hãy kiểm tra đường truyền internet rồi chạy lại ứng dụng."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Đóng App", nil];
            alert.tag = 11;
            [alert show];
        }
        else {
            dictSetting = [userDefaults objectForKey:API_CONF];
            NSLog(@"prevous setting: %@", dictSetting.description);
        }
    }
    
    //[[[NSUserDefaults standardUserDefaults] objectForKey:API_DEF] objectForKey:@""]
    NSLog(@"HOST_FOR_CONTENT:%@",HOST_FOR_CONTENT);
    NSLog(@"HOST_FOR_USER:%@",HOST_FOR_USER);
    
    
    if ([userDefaults objectForKey:API_DEF]) {
        [self startApp];
    } else {
        [AppDelegate addLocalLog:@"lk0"];
        NSLog(@"Loi khong lay duoc link server");
    }
    
    
    //-- for sms register (reg_usr_sms_info)
    if (![dictSetting objectForKey:@"is_charging"]) {
        [userDefaults setObject:@"1" forKey:@"isCharging"];
    }else {
        
        [userDefaults setObject:[dictSetting objectForKey:@"is_charging"] forKey:@"isCharging"];
    }
    
    
    //-- for singer content type list
    NSString *singerContentTypeList     = [dictSetting objectForKey:@"singer_content_type_list"];
    NSDictionary *contentTypeDict = [singerContentTypeList JSONValue];
    
    NSArray *dataArr = [contentTypeDict objectForKey:@"data"];
    NSMutableArray *sssss = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < dataArr.count; i ++) {
        SingerContentTypeList *contentTypeList = [[SingerContentTypeList alloc] init];
        
        contentTypeList.contentTypeKey = [[dataArr objectAtIndex:i] objectForKey:@"content_type_key"];
        contentTypeList.contentTypeId = [[[dataArr objectAtIndex:i] objectForKey:@"content_type_id"] stringValue];
        contentTypeList.contentTypeName = [[dataArr objectAtIndex:i] objectForKey:@"content_type_name"];
        contentTypeList.contentTypeRevision = [[[dataArr objectAtIndex:i] objectForKey:@"content_type_revison"] stringValue];
        
        [sssss addObject:contentTypeList];
    }
    
    
    //---------- for trailer_info ----------//
    NSString *trailerInfoString = [dictSetting objectForKey:@"trailer_info"];
    NSDictionary *trailerInfo = [trailerInfoString JSONValue];
    
    if (trailerInfo) {
        
        NSDictionary *trailerData = [trailerInfo objectForKey:@"data"];
        NSString *trailerVideo = [trailerData objectForKey:@"video"];
        NSString *trailerMusic = [trailerData objectForKey:@"music"];
        NSString *trailerMessage = [trailerData objectForKey:@"message_notice_upgrade_user"];
        
        //-- save info trailer NSUserDefaults
        [userDefaults setObject:trailerVideo forKey:Key_Trailer_Info_Video];
        [userDefaults setObject:trailerMusic forKey:Key_Trailer_Info_Music];
        [userDefaults setObject:trailerMessage forKey:TITLE_Message_Trailer_Info];
    }
    
    [userDefaults synchronize];
    
    //---------- get charg_facebook_info ----------//
    NSString *chargFacebookInfo = [dictSetting objectForKey:@"charg_facebook_info"];
    NSDictionary *chargFacebookDataDic = [chargFacebookInfo JSONValue];
    NSString *isChargFacebookOn = [chargFacebookDataDic objectForKey:@"is_charg_facebook_on"];
    NSString *messageUpdateUserInfo = [chargFacebookDataDic objectForKey:@"error_message_update_user_info"];
    
    //-- save charg facebook info
    [userDefaults setObject:isChargFacebookOn forKey:Key_ChargFacebook_IsChargFacebookOn];
    [userDefaults setObject:messageUpdateUserInfo forKey:Key_ChargFacebook_MessageUpdateUserInfo];
    [userDefaults synchronize];
    
    
    //---------- get Singer info ----------//
    NSString *singerData = [dictSetting objectForKey:@"singer_data"];
    NSDictionary *singerDataDic = [singerData JSONValue];
    NSDictionary *singerDataSetting = [singerDataDic objectForKey:@"data"];
    NSLog(@"check for setting");
    if (singerDataSetting)
    {
        //longnh clear cache by commant from server
        NSString *clear_cache = [singerDataSetting objectForKey:@"clear_cache"];
        NSString *clear_cache_restart = [singerDataSetting objectForKey:@"clear_cache_restart"];
        NSString *clear_cache_title = [singerDataSetting objectForKey:@"clear_cache_title"];
        NSString *clear_cache_message = [singerDataSetting objectForKey:@"clear_cache_message"];
        NSLog(@"update setting");

//        [userDefaults setObject:@"1" forKey:CLEAR_CACHE_VERSION];//longnh test
//        [userDefaults synchronize];//longnh test
        
        if ([userDefaults objectForKey:CLEAR_CACHE_VERSION])
        {
            if ([clear_cache intValue] > [[userDefaults objectForKey:CLEAR_CACHE_VERSION] intValue])
            {
                if ([clear_cache_restart intValue]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clear_cache_title
                                                                    message:clear_cache_message
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Đóng App", nil];
                    alert.tag = 11;
                    [alert show];
                }
                [self clearAllCacheAndDB];
                [userDefaults setObject:clear_cache forKey:CLEAR_CACHE_VERSION];
                [userDefaults synchronize];
            }
        } else {
            [userDefaults setObject:clear_cache forKey:CLEAR_CACHE_VERSION];
            [userDefaults synchronize];
            
        }
        
        //longnh add
        NSString *facebook_link_share = [singerDataSetting objectForKey:@"facebook_link_share"];
        [userDefaults setObject:facebook_link_share forKey:@"facebook_link_share"];
        [userDefaults synchronize];
        
        //-- telco data
        NSString *telco_code = [singerDataSetting objectForKey:@"telco_code"];
        NSString *secret_key = [singerDataSetting objectForKey:@"secret_key"];
        NSString *agency_id = [singerDataSetting objectForKey:@"agency_id"];
        
        //-- singer info
        NSString *singerId = [singerDataSetting objectForKey:@"id"];
        NSString *singerName = [singerDataSetting objectForKey:@"name"];
        NSString *singerNoticeDefault = [singerDataSetting objectForKey:@"notice_default"];
        
        
        //-- free app
        NSString *is_free = [singerDataSetting objectForKey:@"is_free"];
        NSString *free_time = [singerDataSetting objectForKey:@"free_time"];
        NSString *free_regist_message = [singerDataSetting objectForKey:@"free_regist_message"];
        NSString *free_login_api = [singerDataSetting objectForKey:@"free_login_api"];
        
        [userDefaults setObject:is_free forKey:Key_Is_Free];
        [userDefaults setObject:free_time forKey:Key_Free_Time];
        [userDefaults setObject:free_regist_message forKey:Key_Free_Regist_Message];
        [userDefaults setObject:free_login_api forKey:Key_Free_Login_Api];
        
        if ([is_free integerValue] == 0)
            [userDefaults removeObjectForKey:@"FreeTimeSinger"];
        
        //-- message system error
        NSString *system_error = [singerDataSetting objectForKey:@"system_error"];
        if ([system_error length] == 0) {
            system_error = TITLE_System_Error;
        }
        
        [userDefaults setObject:system_error forKey:Key_Message_System_Error];
        
        
        //-- message + api verify
        NSString *wifi_nosim_verify_message = [singerDataSetting objectForKey:@"wifi_nosim_login_message"];
        NSString *wifi_nosim_verify_api = [singerDataSetting objectForKey:@"wifi_nosim_login_api"];
        NSString *wifi_nosim_command_gateway_get_password = [singerDataSetting objectForKey:@"wifi_nosim_command_gateway_get_password"];
        NSString *wifi_nosim_command_body_get_password = [singerDataSetting objectForKey:@"wifi_nosim_command_body_get_password"];
        
        [userDefaults setObject:wifi_nosim_verify_message forKey:Key_wifi_nosim_DKCT_message];
        [userDefaults setObject:wifi_nosim_verify_api forKey:Key_wifi_nosim_DKCT_api];
        [userDefaults setObject:wifi_nosim_command_gateway_get_password forKey:Key_wifi_nosim_command_gateway_get_password];
        [userDefaults setObject:wifi_nosim_command_body_get_password forKey:Key_wifi_nosim_command_body_get_password];
        
        [userDefaults setObject:telco_code forKey:Key_Singer_Telco_code];
        [userDefaults setObject:secret_key forKey:Key_Singer_Secret_key];
        [userDefaults setObject:agency_id forKey:Key_Singer_Agency_id];
        
        [userDefaults setObject:singerId forKey:Key_Singer_Id];
        [userDefaults setObject:singerName forKey:Key_Singer_Name];
        [userDefaults setObject:singerNoticeDefault forKey:Key_Singer_Notice_Default];
        
        //-- invite
        NSString *invite_message = [singerDataSetting objectForKey:@"invite_message"];
        [userDefaults setObject:invite_message forKey:Key_Invite_Message_Default];
        
        [userDefaults synchronize];
        
        
        //-- download Photo
        NSString *downloadable_photo_number = [singerDataSetting objectForKey:@"downloadable_photo_number"];
        NSString *downloadable_photo_start_time = [singerDataSetting objectForKey:@"downloadable_photo_start_time"];
        NSString *downloadable_photo_period_time = [singerDataSetting objectForKey:@"downloadable_photo_period_time"];
        NSString *downloadable_photo_message_wranning = [singerDataSetting objectForKey:@"downloadable_photo_message_wranning"];
        
        [userDefaults setObject:downloadable_photo_number forKey:Key_downloadable_photo_number];
        [userDefaults setObject:downloadable_photo_start_time forKey:Key_downloadable_photo_start_time];
        [userDefaults setObject:downloadable_photo_period_time forKey:Key_downloadable_photo_period_time];
        [userDefaults setObject:downloadable_photo_message_wranning forKey:Key_downloadable_photo_message_wranning];
        
        
        //-- download Video
        NSString *downloadable_video_nubmer = [singerDataSetting objectForKey:@"downloadable_video_nubmer"];
        NSString *downloadable_video_start_time = [singerDataSetting objectForKey:@"downloadable_video_start_time"];
        NSString *downloadable_video_period_time = [singerDataSetting objectForKey:@"downloadable_video_period_time"];
        NSString *downloadable_video_message_wranning = [singerDataSetting objectForKey:@"downloadable_video_message_wranning"];
        
        [userDefaults setObject:downloadable_video_nubmer forKey:Key_downloadable_video_nubmer];
        [userDefaults setObject:downloadable_video_start_time forKey:Key_downloadable_video_start_time];
        [userDefaults setObject:downloadable_video_period_time forKey:Key_downloadable_video_period_time];
        [userDefaults setObject:downloadable_video_message_wranning forKey:Key_downloadable_video_message_wranning];
        
        
        //-- download Music
        NSString *downloadable_music_nubmer = [singerDataSetting objectForKey:@"downloadable_music_nubmer"];
        NSString *downloadable_music_start_time = [singerDataSetting objectForKey:@"downloadable_music_start_time"];
        NSString *downloadable_music_period_time = [singerDataSetting objectForKey:@"downloadable_music_period_time"];
        NSString *downloadable_music_message_wranning = [singerDataSetting objectForKey:@"downloadable_music_message_wranning"];
        
        [userDefaults setObject:downloadable_music_nubmer forKey:Key_downloadable_music_nubmer];
        [userDefaults setObject:downloadable_music_start_time forKey:Key_downloadable_music_start_time];
        [userDefaults setObject:downloadable_music_period_time forKey:Key_downloadable_music_period_time];
        [userDefaults setObject:downloadable_music_message_wranning forKey:Key_downloadable_music_message_wranning];
        [userDefaults synchronize];
        
        //--refresh time
        CGFloat news_refresh_time             = [[singerDataSetting valueForKey:Key_news_refresh_time] floatValue];
        CGFloat news_list_refresh_time        = [[singerDataSetting valueForKey:Key_news_list_refresh_time] floatValue];
        CGFloat news_category_refresh_time    = [[singerDataSetting valueForKey:Key_news_category_refresh_time] floatValue];
        CGFloat music_refresh_time            = [[singerDataSetting valueForKey:Key_music_refresh_time] floatValue];
        CGFloat music_album_refresh_time      = [[singerDataSetting valueForKey:Key_music_album_refresh_time] floatValue];
        CGFloat video_refresh_time            = [[singerDataSetting valueForKey:Key_video_refresh_time] floatValue];
        CGFloat video_category_refresh_time   = [[singerDataSetting valueForKey:Key_video_category_refresh_time] floatValue];
        CGFloat store_refresh_time            = [[singerDataSetting valueForKey:Key_store_refresh_time] floatValue];
        CGFloat store_category_refresh_time   = [[singerDataSetting valueForKey:Key_store_category_refresh_time] floatValue];
        CGFloat event_refresh_time            = [[singerDataSetting valueForKey:Key_event_refresh_time] floatValue];
        CGFloat event_category_refresh_time   = [[singerDataSetting valueForKey:Key_event_category_refresh_time] floatValue];
        CGFloat image_refresh_time            = [[singerDataSetting valueForKey:Key_image_refresh_time] floatValue];
        CGFloat image_album_refresh_time      = [[singerDataSetting valueForKey:Key_image_album_refresh_time] floatValue];
        CGFloat top_user_refresh_time         = [[singerDataSetting valueForKey:Key_top_user_refresh_time] floatValue];
        CGFloat singer_info_refresh_time         = [[singerDataSetting valueForKey:Key_singer_info_refresh_time] floatValue];
        
        [Setting sharedSetting].newRefreshTime              = news_refresh_time;
        [Setting sharedSetting].newListRefreshTime          = news_list_refresh_time;
        [Setting sharedSetting].newsCategoryRefreshTime     = news_category_refresh_time;
        [Setting sharedSetting].musicRefreshTime            = music_refresh_time;
        [Setting sharedSetting].musicAlbumRefreshTime       = music_album_refresh_time;
        [Setting sharedSetting].videoRefreshTime            = video_refresh_time;
        [Setting sharedSetting].videoCategoryRefreshTime    = video_category_refresh_time;
        [Setting sharedSetting].storeRefreshTime            = store_refresh_time;
        [Setting sharedSetting].storeCategoryRefreshTime    = store_category_refresh_time;
        [Setting sharedSetting].eventRefreshTime            = event_refresh_time;
        [Setting sharedSetting].eventCategoryRefreshTime    = event_category_refresh_time;
        [Setting sharedSetting].imageRefreshTime            = image_refresh_time;
        [Setting sharedSetting].imageAlbumRefreshTime       = image_album_refresh_time;
        [Setting sharedSetting].topUserRefreshTime          = top_user_refresh_time;
        [Setting sharedSetting].singerInfoRefreshTime       = singer_info_refresh_time;
        
    }
    
    //---------- singer_fanzone -------------------------------//
    NSString *singerFanzone = [dictSetting objectForKey:@"singer_fanzone"];
    NSDictionary *singerFanzoneDic = [singerFanzone JSONValue];
    NSDictionary *singerFanzoneSetting = [singerFanzoneDic objectForKey:@"data"];
    
    NSString *default_message = [singerFanzoneSetting objectForKey:@"default_message"];
    NSString *refresh_time = [singerFanzoneSetting objectForKey:@"refresh_time"];
    
    [userDefaults setObject:default_message forKey:Key_Default_Message];
    [userDefaults setObject:refresh_time forKey:Key_Refresh_Time];
    [userDefaults synchronize];
    
    
    //---------- get telco data for reg_usr_sms_info ----------//
    [AppDelegate processTelcoSetting:true];

    
    //longnh check version
    NSString *versionCurrent = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"version in app:%f version on server:%f",[versionCurrent floatValue],[versionWantUpgrader floatValue]);
    [AppDelegate addLocalLogWithFloat:@"appv" n:[versionCurrent floatValue]];

    if ([versionWantUpgrader floatValue] > [versionCurrent floatValue])
    {
        if ([isUpdateVersion isEqualToString:@"1"])  //-- update via website
            [self showMessageUpdateWithTitle:titleMessage withMessage:message linkDown:linkDownWeb updateSource:UpdateSourceViaWeb];
        
        if ([isUpdateVersion isEqualToString:@"2"]) //-- update via app store
            [self showMessageUpdateWithTitle:titleMessage withMessage:message linkDown:linkDownAppStore updateSource:UpdateSourceViaAppStore];
    }

    
    if (!checkAppRunFirst) { //-- app run first
        
        [userDefaults setObject:@"app_run_first" forKey:APP_RUN_FIRST];
        [userDefaults setObject:versionWantUpgrader forKey:APP_VERSION];
        [userDefaults synchronize];
        return;
    }
    else
    {
        NSString *versionCurrent = [userDefaults objectForKey:APP_VERSION];
        
        if ([versionCurrent isEqualToString:versionWantUpgrader]) //-- same version
        {
            [self showMessageUpdateWithTitle:@"Thông báo" withMessage:@"Bạn đã cập nhật phiên bản mới nhất!"];
            return;
        }
        else
        {
            //-- save version
            [userDefaults setObject:versionWantUpgrader forKey:APP_VERSION];
            [userDefaults synchronize];
            
            if ([isUpdateVersion isEqualToString:@"1"])  //-- update via website
            {
                [self showMessageUpdateWithTitle:titleMessage withMessage:message linkDown:linkDownWeb updateSource:UpdateSourceViaWeb];
            }
            
            if ([isUpdateVersion isEqualToString:@"2"]) //-- update via app store
            {
                [self showMessageUpdateWithTitle:titleMessage withMessage:message linkDown:linkDownAppStore updateSource:UpdateSourceViaAppStore];
            }
        }
    }
}

+(NSString *) getTelcoGlobalCodeByPhoneNumber:(NSString *)phoneNumberS
{
    NSString *phoneNumber;
    //bo 84
    if ([[phoneNumberS substringToIndex:2] isEqualToString:@"84"]) {
        phoneNumber = [NSString stringWithFormat:@"0%@", [phoneNumberS substringFromIndex:2]];
    }
    else
        phoneNumber = [NSString stringWithFormat:@"%@", phoneNumberS];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictSetting = [userDefaults objectForKey:API_CONF];
    NSString *telcoData = [dictSetting objectForKey:@"telco_data"];
    NSDictionary *telcoDataDic = [telcoData JSONValue];
    NSMutableArray *telcoDataArr = [telcoDataDic objectForKey:@"data"];
    for (NSInteger i=0; i< telcoDataArr.count; i++) {
        NSDictionary *dataDic = [telcoDataArr objectAtIndex:i];
        NSString *telcoGlobalCode = [dataDic valueForKey:@"telco_global_code"];
        NSString *telcoPhoneNumberStr = [dataDic objectForKey:@"telco_phone_number_list"];
        
        if (telcoPhoneNumberStr && [telcoPhoneNumberStr length] > 1) {
            BOOL isNextStep = NO;
            NSArray *listURL = [telcoPhoneNumberStr componentsSeparatedByString:@","];
            if (listURL.count >0) {
                for (int i = 0; i < listURL.count; i++) {
                    
                    NSString *phoneNameStr = [listURL objectAtIndex:i];
                    phoneNameStr = [phoneNameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    NSString *firstPhoneTelco = [Utility getFirstPhoneNumberTelco:phoneNameStr];
                    NSString *numberOfCharPhoneTelco = [Utility getNumberOfCharPhoneNumberTelco:phoneNameStr];
                    
                    NSString *firstPhoneInput = [phoneNumber substringToIndex:[firstPhoneTelco length]];
                    
                    if ([firstPhoneTelco isEqualToString:firstPhoneInput]) {
                        
                        if ([phoneNumber length] == [numberOfCharPhoneTelco intValue]) {
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
                //ok
                return telcoGlobalCode;
                
            }else {
                
                //-- Thông báo số điện thoại nhập vào không đúng.

            }
        }
    }
    return nil;
}

+(void) processTelcoSetting:(bool)checkLockDevice
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictSetting = [userDefaults objectForKey:API_CONF];
    NSString *telcoData = [dictSetting objectForKey:@"telco_data"];
    //---------- get telco data for reg_usr_sms_info ----------//
    NSDictionary *telcoDataDic = [telcoData JSONValue];
    NSMutableArray *telcoDataArr = [telcoDataDic objectForKey:@"data"];
    
    NSString *telcoGlobalCodeDefault = [userDefaults valueForKey:@"TelcoGlobalCode"];
    [AppDelegate addLocalLogWithString:@"telco:" info:telcoGlobalCodeDefault];
    for (NSInteger i=0; i< telcoDataArr.count; i++) {
        
        NSDictionary *dataDic = [telcoDataArr objectAtIndex:i];
        NSString *telcoGlobalCode = [dataDic valueForKey:@"telco_global_code"];
        
        if ([telcoGlobalCode isEqualToString:telcoGlobalCodeDefault]) {
            
            NSString *telco_id = [dataDic objectForKey:@"telco_id"];
            NSString *telco_global_code = [dataDic objectForKey:@"telco_global_code"];
            NSString *telco_key = [dataDic objectForKey:@"telco_key"];
            NSString *telco_name = [dataDic objectForKey:@"telco_name"];
            NSString *telco_phone_number_list = [dataDic objectForKey:@"telco_phone_number_list"];
            NSString *get_phone_number = [dataDic objectForKey:@"get_phone_number"];
            NSString *check_active_account = [dataDic objectForKey:@"check_active_account"];
            
            
            //-- save info SMS NSUserDefaults
            [userDefaults setObject:telco_id forKey:Key_telco_id];
            [userDefaults setObject:telco_global_code forKey:Key_telco_global_code];
            [userDefaults setObject:telco_key forKey:Key_telco_key];
            [userDefaults setObject:telco_name forKey:Key_telco_name];
            [userDefaults setObject:telco_phone_number_list forKey:Key_telco_phone_number_list];
            [userDefaults setObject:get_phone_number forKey:Key_get_phone_number_service_api];
            [userDefaults setObject:check_active_account forKey:Key_check_active_account];
            [userDefaults synchronize];
            
            //----- ringback_tone -----//
            NSDictionary *ringbackTone = [dataDic objectForKey:@"ringback_tone"];
            
            NSString *ringbackCode = [ringbackTone objectForKey:@"code"];
            NSString *ringbackName = [ringbackTone objectForKey:@"name"];
            NSString *ringbackMessage = [ringbackTone objectForKey:@"message"];
            NSString *ringbackCommand_gateway = [ringbackTone objectForKey:@"command_gateway"];
            NSString *ringbackCommand_body = [ringbackTone objectForKey:@"command_body"];
            NSString *ringbackApi = [ringbackTone objectForKey:@"api"];
            
            [userDefaults setObject:ringbackCode forKey:Key_ringbackCode];
            [userDefaults setObject:ringbackName forKey:Key_ringbackName];
            [userDefaults setObject:ringbackMessage forKey:Key_ringbackMessage];
            [userDefaults setObject:ringbackCommand_gateway forKey:Key_ringbackCommand_gateway];
            [userDefaults setObject:ringbackCommand_body forKey:Key_ringbackCommand_body];
            [userDefaults setObject:ringbackApi forKey:Key_ringbackApi];
            [userDefaults synchronize];
            
            
            //----- SMS Action -----//
            NSMutableArray *arrSMSAction = [dataDic objectForKey:@"sms_action"];
            [AppDelegate handleJsonSMSActionSaveToNSUserDefaultsWithArrayData:arrSMSAction];
            
            
            //----- SUB SMS Action -----//
            NSMutableArray *arrSUBSMSAction = [dataDic objectForKey:@"sub_sms_action"];
            [AppDelegate handleJsonSUBSMSActionSaveToNSUserDefaultsWithArrayData:arrSUBSMSAction];
            
            
            //----- WAP SUB Action -----//
            NSMutableArray *arrWAPSUBAction = [dataDic objectForKey:@"wapsub_action"];
            [AppDelegate handleJsonWAPSUBActionSaveToNSUserDefaultsWithArrayData:arrWAPSUBAction];
            
            //----- WAP Charging Action -----//
            NSMutableArray *arrWAPChargingAction = [dataDic objectForKey:@"wapcharging_action"];
            [AppDelegate handleJsonWAPChargingActionSaveToNSUserDefaultsWithArrayData:arrWAPChargingAction];
            
            //----- WAP SUB Action -----//
            NSMutableArray *arrNoChargingAction = [dataDic objectForKey:@"no_charging_action"];
            [AppDelegate handleJsonNoChargingActionSaveToNSUserDefaultsWithArrayData:arrNoChargingAction];
            
        }
    }
    
    
    //---------- kind of user: normal, vip, supper vip... ----------//
    NSString *jsonUserListSetting = [dictSetting objectForKey:@"user_list_setting"];
    [AppDelegate parseUserListSetting:jsonUserListSetting checkLockDevice:checkLockDevice];
    
}

+(void) handleJsonSMSActionSaveToNSUserDefaultsWithArrayData:(NSMutableArray *) arrSMSAction {
    NSLog(@"%s", __func__);
   
    if (arrSMSAction.count > 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        for (NSInteger j=0; j< arrSMSAction.count; j++) {
            
            NSDictionary *dicDataSMSAction = [arrSMSAction objectAtIndex:j];
            if (dicDataSMSAction) {
                
                NSInteger idSMSAction = [[dicDataSMSAction valueForKey:@"id"] integerValue];
                
                if (idSMSAction == 1) { //-- SMS Dang ky
                    
                    NSString *smsDK_id = [dicDataSMSAction objectForKey:@"id"];
                    NSString *smsDK_body = [dicDataSMSAction objectForKey:@"code"];
                    NSString *smsDK_name = [dicDataSMSAction objectForKey:@"name"];
                    NSString *smsDK_command_gateway = [dicDataSMSAction objectForKey:@"command_gateway"];
                    NSString *smsDK_command_body = [dicDataSMSAction objectForKey:@"command_body"];
                    NSString *smsDK_message = [dicDataSMSAction objectForKey:@"message"];
                    NSString *smsDK_message_verify = [dicDataSMSAction objectForKey:@"message_verify"];
                    NSString *smsDK_success_message = [dicDataSMSAction objectForKey:@"success_message"];
                    NSString *smsDK_fail_message = [dicDataSMSAction objectForKey:@"fail_message"];
                    
                    //-- save info SMS DK NSUserDefaults
                    [userDefaults setObject:smsDK_id forKey:Key_sms_DK_id];
                    [userDefaults setObject:smsDK_body forKey:Key_sms_DK_body];
                    [userDefaults setObject:smsDK_name forKey:Key_sms_DK_name];
                    [userDefaults setObject:smsDK_command_gateway forKey:Key_sms_DK_command_gateway];
                    [userDefaults setObject:smsDK_command_body forKey:Key_sms_DK_command_body];
                    [userDefaults setObject:smsDK_message forKey:Key_sms_DK_message];
                    [userDefaults setObject:smsDK_message_verify forKey:Key_sms_DK_message_verify];
                    [userDefaults setObject:smsDK_success_message forKey:Key_sms_DK_success_message];
                    [userDefaults setObject:smsDK_fail_message forKey:Key_sms_DK_fail_message];
                    [userDefaults synchronize];
                    
                }else if (idSMSAction == 2) { //-- SMS Huy
                    
                    NSString *smsHuy_id = [dicDataSMSAction objectForKey:@"id"];
                    NSString *smsHuy_body = [dicDataSMSAction objectForKey:@"code"];
                    NSString *smsHuy_name = [dicDataSMSAction objectForKey:@"name"];
                    NSString *smsHuy_command_gateway = [dicDataSMSAction objectForKey:@"command_gateway"];
                    NSString *smsHuy_command_body = [dicDataSMSAction objectForKey:@"command_body"];
                    NSString *smsHuy_message = [dicDataSMSAction objectForKey:@"message"];
                    NSString *smsHuy_message_verify = [dicDataSMSAction objectForKey:@"message_verify"];
                    NSString *smsHuy_success_message = [dicDataSMSAction objectForKey:@"success_message"];
                    NSString *smsHuy_fail_message = [dicDataSMSAction objectForKey:@"fail_message"];
                    
                    //-- save info SMS Huy NSUserDefaults
                    [userDefaults setObject:smsHuy_id forKey:Key_sms_Huy_id];
                    [userDefaults setObject:smsHuy_body forKey:Key_sms_Huy_body];
                    [userDefaults setObject:smsHuy_name forKey:Key_sms_Huy_name];
                    [userDefaults setObject:smsHuy_command_gateway forKey:Key_sms_Huy_command_gateway];
                    [userDefaults setObject:smsHuy_command_body forKey:Key_sms_Huy_command_body];
                    [userDefaults setObject:smsHuy_message forKey:Key_sms_Huy_message];
                    [userDefaults setObject:smsHuy_message_verify forKey:Key_sms_Huy_message_verify];
                    [userDefaults setObject:smsHuy_success_message forKey:Key_sms_Huy_success_message];
                    [userDefaults setObject:smsHuy_fail_message forKey:Key_sms_Huy_fail_message];
                    [userDefaults synchronize];
                    
                }else if (idSMSAction == 3) { //-- SMS Nap Tien
                    
                    NSString *smsNap_id = [dicDataSMSAction objectForKey:@"id"];
                    NSString *smsNap_body = [dicDataSMSAction objectForKey:@"code"];
                    NSString *smsNap_name = [dicDataSMSAction objectForKey:@"name"];
                    NSString *smsNap_command_gateway = [dicDataSMSAction objectForKey:@"command_gateway"];
                    NSString *smsNap_command_body = [dicDataSMSAction objectForKey:@"command_body"];
                    NSString *smsNap_message = [dicDataSMSAction objectForKey:@"message"];
                    NSString *smsNap_message_verify = [dicDataSMSAction objectForKey:@"message_verify"];
                    NSString *smsNap_success_message = [dicDataSMSAction objectForKey:@"success_message"];
                    NSString *smsNap_fail_message = [dicDataSMSAction objectForKey:@"fail_message"];
                    
                    //-- save info SMS Nap Tien NSUserDefaults
                    [userDefaults setObject:smsNap_id forKey:Key_sms_Nap_id];
                    [userDefaults setObject:smsNap_body forKey:Key_sms_Nap_body];
                    [userDefaults setObject:smsNap_name forKey:Key_sms_Nap_name];
                    [userDefaults setObject:smsNap_command_gateway forKey:Key_sms_Nap_command_gateway];
                    [userDefaults setObject:smsNap_command_body forKey:Key_sms_Nap_command_body];
                    [userDefaults setObject:smsNap_message forKey:Key_sms_Nap_message];
                    [userDefaults setObject:smsNap_message_verify forKey:Key_sms_Nap_message_verify];
                    [userDefaults setObject:smsNap_success_message forKey:Key_sms_Nap_success_message];
                    [userDefaults setObject:smsNap_fail_message forKey:Key_sms_Nap_fail_message];
                    [userDefaults synchronize];
                    
                }else { //-- SMS dang_ky_chung_thuc
                    
                    NSString *smsDKCT_id = [dicDataSMSAction objectForKey:@"id"];
                    NSString *smsDKCT_body = [dicDataSMSAction objectForKey:@"code"];
                    NSString *smsDKCT_name = [dicDataSMSAction objectForKey:@"name"];
                    NSString *smsDKCT_command_gateway = [dicDataSMSAction objectForKey:@"command_gateway"];
                    NSString *smsDKCT_command_body = [dicDataSMSAction objectForKey:@"command_body"];
                    NSString *smsDKCT_api = [dicDataSMSAction objectForKey:@"api"];
                    NSString *smsDKCT_message = [dicDataSMSAction objectForKey:@"message"];
                    NSString *smsDKCT_message_verify = [dicDataSMSAction objectForKey:@"message_verify"];
                    NSString *smsDKCT_success_message = [dicDataSMSAction objectForKey:@"success_message"];
                    NSString *smsDKCT_fail_message = [dicDataSMSAction objectForKey:@"fail_message"];
                    
                    //-- save info SMS DKCT NSUserDefaults
                    [userDefaults setObject:smsDKCT_id forKey:Key_sms_DKCT_id];
                    [userDefaults setObject:smsDKCT_body forKey:Key_sms_DKCT_body];
                    [userDefaults setObject:smsDKCT_name forKey:Key_sms_DKCT_name];
                    [userDefaults setObject:smsDKCT_command_gateway forKey:Key_sms_DKCT_command_gateway];
                    [userDefaults setObject:smsDKCT_command_body forKey:Key_sms_DKCT_command_body];
                    [userDefaults setObject:smsDKCT_api forKey:Key_sms_DKCT_api];
                    [userDefaults setObject:smsDKCT_message forKey:Key_sms_DKCT_message];
                    [userDefaults setObject:smsDKCT_message_verify forKey:Key_sms_DKCT_message_verify];
                    [userDefaults setObject:smsDKCT_success_message forKey:Key_sms_DKCT_success_message];
                    [userDefaults setObject:smsDKCT_fail_message forKey:Key_sms_DKCT_fail_message];
                    [userDefaults synchronize];
                }
            }
        }
    }
}

+(void) handleJsonSUBSMSActionSaveToNSUserDefaultsWithArrayData:(NSMutableArray *) arrSUBSMSAction {
    NSLog(@"%s", __func__);
    
    if (arrSUBSMSAction.count > 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        for (NSInteger j=0; j< arrSUBSMSAction.count; j++) {
            
            NSDictionary *dicDataSUBSMSAction = [arrSUBSMSAction objectAtIndex:j];
            if (dicDataSUBSMSAction) {
                
                NSInteger idSUBSMSAction = [[dicDataSUBSMSAction valueForKey:@"id"] integerValue];
                
                if (idSUBSMSAction == 1) { //-- SUB SMS Dang ky
                    
                    NSString *subSmsDK_id = [dicDataSUBSMSAction objectForKey:@"id"];
                    NSString *subSmsDK_body = [dicDataSUBSMSAction objectForKey:@"code"];
                    NSString *subSmsDK_name = [dicDataSUBSMSAction objectForKey:@"name"];
                    NSString *subSmsDK_command_gateway = [dicDataSUBSMSAction objectForKey:@"command_gateway"];
                    NSString *subSmsDK_command_body = [dicDataSUBSMSAction objectForKey:@"command_body"];
                    NSString *subSmsDK_message = [dicDataSUBSMSAction objectForKey:@"message"];
                    NSString *subSmsDK_message_verify = [dicDataSUBSMSAction objectForKey:@"message_verify"];
                    NSString *subSmsDK_success_message = [dicDataSUBSMSAction objectForKey:@"success_message"];
                    NSString *subSmsDK_fail_message = [dicDataSUBSMSAction objectForKey:@"fail_message"];
                    
                    //-- save info SUB SMS DK NSUserDefaults
                    [userDefaults setObject:subSmsDK_id forKey:Key_subSms_DK_id];
                    [userDefaults setObject:subSmsDK_body forKey:Key_subSms_DK_body];
                    [userDefaults setObject:subSmsDK_name forKey:Key_subSms_DK_name];
                    [userDefaults setObject:subSmsDK_command_gateway forKey:Key_subSms_DK_command_gateway];
                    [userDefaults setObject:subSmsDK_command_body forKey:Key_subSms_DK_command_body];
                    [userDefaults setObject:subSmsDK_message forKey:Key_subSms_DK_message];
                    [userDefaults setObject:subSmsDK_message_verify forKey:Key_subSms_DK_message_verify];
                    [userDefaults setObject:subSmsDK_success_message forKey:Key_subSms_DK_success_message];
                    [userDefaults setObject:subSmsDK_fail_message forKey:Key_subSms_DK_fail_message];
                    [userDefaults synchronize];
                    
                }else if (idSUBSMSAction == 2) { //-- SUB SMS Huy
                    
                    NSString *subSmsHuy_id = [dicDataSUBSMSAction objectForKey:@"id"];
                    NSString *subSmsHuy_body = [dicDataSUBSMSAction objectForKey:@"code"];
                    NSString *subSmsHuy_name = [dicDataSUBSMSAction objectForKey:@"name"];
                    NSString *subSmsHuy_command_gateway = [dicDataSUBSMSAction objectForKey:@"command_gateway"];
                    NSString *subSmsHuy_command_body = [dicDataSUBSMSAction objectForKey:@"command_body"];
                    NSString *subSmsHuy_message = [dicDataSUBSMSAction objectForKey:@"message"];
                    NSString *subSmsHuy_message_verify = [dicDataSUBSMSAction objectForKey:@"message_verify"];
                    NSString *subSmsHuy_success_message = [dicDataSUBSMSAction objectForKey:@"success_message"];
                    NSString *subSmsHuy_fail_message = [dicDataSUBSMSAction objectForKey:@"fail_message"];
                    
                    //-- save info SUB SMS Huy NSUserDefaults
                    [userDefaults setObject:subSmsHuy_id forKey:Key_subSms_Huy_id];
                    [userDefaults setObject:subSmsHuy_body forKey:Key_subSms_Huy_body];
                    [userDefaults setObject:subSmsHuy_name forKey:Key_subSms_Huy_name];
                    [userDefaults setObject:subSmsHuy_command_gateway forKey:Key_subSms_Huy_command_gateway];
                    [userDefaults setObject:subSmsHuy_command_body forKey:Key_subSms_Huy_command_body];
                    [userDefaults setObject:subSmsHuy_message forKey:Key_subSms_Huy_message];
                    [userDefaults setObject:subSmsHuy_message_verify forKey:Key_subSms_Huy_message_verify];
                    [userDefaults setObject:subSmsHuy_success_message forKey:Key_subSms_Huy_success_message];
                    [userDefaults setObject:subSmsHuy_fail_message forKey:Key_subSms_Huy_fail_message];
                    [userDefaults synchronize];
                    
                }else if (idSUBSMSAction == 3) { //-- SUB SMS Nap Tien
                    
                    NSString *subSmsNap_id = [dicDataSUBSMSAction objectForKey:@"id"];
                    NSString *subSmsNap_body = [dicDataSUBSMSAction objectForKey:@"code"];
                    NSString *subSmsNap_name = [dicDataSUBSMSAction objectForKey:@"name"];
                    NSString *subSmsNap_command_gateway = [dicDataSUBSMSAction objectForKey:@"command_gateway"];
                    NSString *subSmsNap_command_body = [dicDataSUBSMSAction objectForKey:@"command_body"];
                    NSString *subSmsNap_message = [dicDataSUBSMSAction objectForKey:@"message"];
                    NSString *subSmsNap_message_verify = [dicDataSUBSMSAction objectForKey:@"message_verify"];
                    NSString *subSmsNap_success_message = [dicDataSUBSMSAction objectForKey:@"success_message"];
                    NSString *subSmsNap_fail_message = [dicDataSUBSMSAction objectForKey:@"fail_message"];
                    
                    //-- save info SUB SMS Nap Tien NSUserDefaults
                    [userDefaults setObject:subSmsNap_id forKey:Key_subSms_Nap_id];
                    [userDefaults setObject:subSmsNap_body forKey:Key_subSms_Nap_body];
                    [userDefaults setObject:subSmsNap_name forKey:Key_subSms_Nap_name];
                    [userDefaults setObject:subSmsNap_command_gateway forKey:Key_subSms_Nap_command_gateway];
                    [userDefaults setObject:subSmsNap_command_body forKey:Key_subSms_Nap_command_body];
                    [userDefaults setObject:subSmsNap_message forKey:Key_subSms_Nap_message];
                    [userDefaults setObject:subSmsNap_message_verify forKey:Key_subSms_Nap_message_verify];
                    [userDefaults setObject:subSmsNap_success_message forKey:Key_subSms_Nap_success_message];
                    [userDefaults setObject:subSmsNap_fail_message forKey:Key_subSms_Nap_fail_message];
                    [userDefaults synchronize];
                    
                }else { //-- SUB SMS dang_ky_chung_thuc
                    
                    NSString *subSmsDKCT_id = [dicDataSUBSMSAction objectForKey:@"id"];
                    NSString *subSmsDKCT_body = [dicDataSUBSMSAction objectForKey:@"code"];
                    NSString *subSmsDKCT_name = [dicDataSUBSMSAction objectForKey:@"name"];
                    NSString *subSmsDKCT_command_gateway = [dicDataSUBSMSAction objectForKey:@"command_gateway"];
                    NSString *subSmsDKCT_command_body = [dicDataSUBSMSAction objectForKey:@"command_body"];
                    NSString *subSmsDKCT_api = [dicDataSUBSMSAction objectForKey:@"api"];
                    NSString *subSmsDKCT_message = [dicDataSUBSMSAction objectForKey:@"message"];
                    NSString *subSmsDKCT_message_verify = [dicDataSUBSMSAction objectForKey:@"message_verify"];
                    NSString *subSmsDKCT_success_message = [dicDataSUBSMSAction objectForKey:@"success_message"];
                    NSString *subSmsDKCT_fail_message = [dicDataSUBSMSAction objectForKey:@"fail_message"];
                    
                    //-- save info SUB SMS DKCT NSUserDefaults
                    [userDefaults setObject:subSmsDKCT_id forKey:Key_subSms_DKCT_id];
                    [userDefaults setObject:subSmsDKCT_body forKey:Key_subSms_DKCT_body];
                    [userDefaults setObject:subSmsDKCT_name forKey:Key_subSms_DKCT_name];
                    [userDefaults setObject:subSmsDKCT_command_gateway forKey:Key_subSms_DKCT_command_gateway];
                    [userDefaults setObject:subSmsDKCT_command_body forKey:Key_subSms_DKCT_command_body];
                    [userDefaults setObject:subSmsDKCT_api forKey:Key_subSms_DKCT_api];
                    [userDefaults setObject:subSmsDKCT_message forKey:Key_subSms_DKCT_message];
                    [userDefaults setObject:subSmsDKCT_message_verify forKey:Key_subSms_DKCT_message_verify];
                    [userDefaults setObject:subSmsDKCT_success_message forKey:Key_subSms_DKCT_success_message];
                    [userDefaults setObject:subSmsDKCT_fail_message forKey:Key_subSms_DKCT_fail_message];
                    [userDefaults synchronize];
                }
                
            }
        }
    }
}

+(void) handleJsonWAPSUBActionSaveToNSUserDefaultsWithArrayData:(NSMutableArray *) arrWAPSUBAction {
    NSLog(@"%s", __func__);
    
    if (arrWAPSUBAction.count > 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        for (NSInteger j=0; j< arrWAPSUBAction.count; j++) {
            
            NSDictionary *dicDataWAPSUBAction = [arrWAPSUBAction objectAtIndex:j];
            if (dicDataWAPSUBAction) {
                
                NSInteger idWAPSUBAction = [[dicDataWAPSUBAction valueForKey:@"id"] integerValue];
                
                if (idWAPSUBAction == 1) { //-- WAPSUB Dang ky
                    
                    NSString *wapSubDK_id = [dicDataWAPSUBAction objectForKey:@"id"];
                    NSString *wapSubDK_body = [dicDataWAPSUBAction objectForKey:@"code"];
                    NSString *wapSubDK_api = [dicDataWAPSUBAction objectForKey:@"api"];
                    NSString *wapSubDK_message = [dicDataWAPSUBAction objectForKey:@"message"];
                    NSString *wapSubDK_message_verify = [dicDataWAPSUBAction objectForKey:@"message_verify"];
                    NSString *wapSubDK_success_message = [dicDataWAPSUBAction objectForKey:@"success_message"];
                    NSString *wapSubDK_fail_message = [dicDataWAPSUBAction objectForKey:@"fail_message"];
                    
                    //-- save info WAPSUB DK NSUserDefaults
                    [userDefaults setObject:wapSubDK_id forKey:Key_wapSub_DK_id];
                    [userDefaults setObject:wapSubDK_body forKey:Key_wapSub_DK_body];
                    [userDefaults setObject:wapSubDK_api forKey:Key_wapSub_DK_api];
                    [userDefaults setObject:wapSubDK_message forKey:Key_wapSub_DK_message];
                    [userDefaults setObject:wapSubDK_message_verify forKey:Key_wapSub_DK_message_verify];
                    [userDefaults setObject:wapSubDK_success_message forKey:Key_wapSub_DK_success_message];
                    [userDefaults setObject:wapSubDK_fail_message forKey:Key_wapSub_DK_fail_message];
                    [userDefaults synchronize];
                    
                }else { //-- WAPSUB Huy
                    
                    NSString *wapSubHuy_id = [dicDataWAPSUBAction objectForKey:@"id"];
                    NSString *wapSubHuy_body = [dicDataWAPSUBAction objectForKey:@"code"];
                    NSString *wapSubHuy_api = [dicDataWAPSUBAction objectForKey:@"api"];
                    NSString *wapSubHuy_message = [dicDataWAPSUBAction objectForKey:@"message"];
                    NSString *wapSubHuy_message_verify = [dicDataWAPSUBAction objectForKey:@"message_verify"];
                    NSString *wapSubHuy_success_message = [dicDataWAPSUBAction objectForKey:@"success_message"];
                    NSString *wapSubHuy_fail_message = [dicDataWAPSUBAction objectForKey:@"fail_message"];
                    
                    //-- save info WAPSUB Huy NSUserDefaults
                    [userDefaults setObject:wapSubHuy_id forKey:Key_wapSub_Huy_id];
                    [userDefaults setObject:wapSubHuy_body forKey:Key_wapSub_Huy_body];
                    [userDefaults setObject:wapSubHuy_api forKey:Key_wapSub_Huy_api];
                    [userDefaults setObject:wapSubHuy_message forKey:Key_wapSub_Huy_message];
                    [userDefaults setObject:wapSubHuy_message_verify forKey:Key_wapSub_Huy_message_verify];
                    [userDefaults setObject:wapSubHuy_success_message forKey:Key_wapSub_Huy_success_message];
                    [userDefaults setObject:wapSubHuy_fail_message forKey:Key_wapSub_Huy_fail_message];
                    [userDefaults synchronize];
                    
                }
                
            }
        }
    }
}

+(void) handleJsonWAPChargingActionSaveToNSUserDefaultsWithArrayData:(NSMutableArray *) arrWAPChargingAction {
    NSLog(@"%s", __func__);
    
    if (arrWAPChargingAction.count > 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        for (NSInteger j=0; j< arrWAPChargingAction.count; j++) {
            
            NSDictionary *dicDataWAPChargingAction = [arrWAPChargingAction objectAtIndex:j];
            if (dicDataWAPChargingAction) {
                
                NSInteger idWAPChargingAction = [[dicDataWAPChargingAction valueForKey:@"id"] integerValue];
                
                if (idWAPChargingAction == 1) { //-- WAPCharging Dang ky
                    
                    NSString *WAPChargingDK_id = [dicDataWAPChargingAction objectForKey:@"id"];
                    NSString *WAPChargingDK_body = [dicDataWAPChargingAction objectForKey:@"code"];
                    NSString *WAPChargingDK_api = [dicDataWAPChargingAction objectForKey:@"api"];
                    NSString *WAPChargingDK_message = [dicDataWAPChargingAction objectForKey:@"message"];
                    NSString *WAPChargingDK_message_verify = [dicDataWAPChargingAction objectForKey:@"message_verify"];
                    NSString *WAPChargingDK_success_message = [dicDataWAPChargingAction objectForKey:@"success_message"];
                    NSString *WAPChargingDK_fail_message = [dicDataWAPChargingAction objectForKey:@"fail_message"];
                    
                    //-- save info WAPCharging DK NSUserDefaults
                    [userDefaults setObject:WAPChargingDK_id forKey:Key_wapCharging_DK_id];
                    [userDefaults setObject:WAPChargingDK_body forKey:Key_wapCharging_DK_body];
                    [userDefaults setObject:WAPChargingDK_api forKey:Key_wapCharging_DK_api];
                    [userDefaults setObject:WAPChargingDK_message forKey:Key_wapCharging_DK_message];
                    [userDefaults setObject:WAPChargingDK_message_verify forKey:Key_wapCharging_DK_message_verify];
                    [userDefaults setObject:WAPChargingDK_success_message forKey:Key_wapCharging_DK_success_message];
                    [userDefaults setObject:WAPChargingDK_fail_message forKey:Key_wapCharging_DK_fail_message];
                    [userDefaults synchronize];
                    
                }else { //-- WAPCharging Huy
                    
                    NSString *WAPChargingHuy_id = [dicDataWAPChargingAction objectForKey:@"id"];
                    NSString *WAPChargingHuy_body = [dicDataWAPChargingAction objectForKey:@"code"];
                    NSString *WAPChargingHuy_api = [dicDataWAPChargingAction objectForKey:@"api"];
                    NSString *WAPChargingHuy_message = [dicDataWAPChargingAction objectForKey:@"message"];
                    NSString *WAPChargingHuy_message_verify = [dicDataWAPChargingAction objectForKey:@"message_verify"];
                    NSString *WAPChargingHuy_success_message = [dicDataWAPChargingAction objectForKey:@"success_message"];
                    NSString *WAPChargingHuy_fail_message = [dicDataWAPChargingAction objectForKey:@"fail_message"];
                    
                    //-- save info WAPCharging Huy NSUserDefaults
                    [userDefaults setObject:WAPChargingHuy_id forKey:Key_wapCharging_Huy_id];
                    [userDefaults setObject:WAPChargingHuy_body forKey:Key_wapCharging_Huy_body];
                    [userDefaults setObject:WAPChargingHuy_api forKey:Key_wapCharging_Huy_api];
                    [userDefaults setObject:WAPChargingHuy_message forKey:Key_wapCharging_Huy_message];
                    [userDefaults setObject:WAPChargingHuy_message_verify forKey:Key_wapCharging_Huy_message_verify];
                    [userDefaults setObject:WAPChargingHuy_success_message forKey:Key_wapCharging_Huy_success_message];
                    [userDefaults setObject:WAPChargingHuy_fail_message forKey:Key_wapCharging_Huy_fail_message];
                    [userDefaults synchronize];
                    
                }
                
            }
        }
    }
}

+(void) handleJsonNoChargingActionSaveToNSUserDefaultsWithArrayData:(NSMutableArray *) arrNoChargingAction {
    NSLog(@"%s", __func__);
    
    if (arrNoChargingAction.count > 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        for (NSInteger j=0; j< arrNoChargingAction.count; j++) {
            
            NSDictionary *dicDataNoChargingAction = [arrNoChargingAction objectAtIndex:j];
            if (dicDataNoChargingAction) {
                
                NSInteger idNoChargingAction = [[dicDataNoChargingAction valueForKey:@"id"] integerValue];
                
                if (idNoChargingAction == 1) { //-- WAPCharging Dang ky
                    
                    NSString *NoChargingDK_id = [dicDataNoChargingAction objectForKey:@"id"];
                    NSString *NoChargingDK_body = [dicDataNoChargingAction objectForKey:@"code"];
                    NSString *NoChargingDK_api = [dicDataNoChargingAction objectForKey:@"api"];
                    NSString *NoChargingDK_message = [dicDataNoChargingAction objectForKey:@"message"];
                    NSString *NoChargingDK_message_verify = [dicDataNoChargingAction objectForKey:@"message_verify"];
                    NSString *NoChargingDK_success_message = [dicDataNoChargingAction objectForKey:@"success_message"];
                    NSString *NoChargingDK_fail_message = [dicDataNoChargingAction objectForKey:@"fail_message"];
                    
                    //-- save info WAPCharging DK NSUserDefaults
                    [userDefaults setObject:NoChargingDK_id forKey:Key_noCharging_DK_id];
                    [userDefaults setObject:NoChargingDK_body forKey:Key_noCharging_DK_body];
                    [userDefaults setObject:NoChargingDK_api forKey:Key_noCharging_DK_api];
                    [userDefaults setObject:NoChargingDK_message forKey:Key_noCharging_DK_message];
                    [userDefaults setObject:NoChargingDK_message_verify forKey:Key_noCharging_DK_message_verify];
                    [userDefaults setObject:NoChargingDK_success_message forKey:Key_noCharging_DK_success_message];
                    [userDefaults setObject:NoChargingDK_fail_message forKey:Key_noCharging_DK_fail_message];
                    [userDefaults synchronize];
                    
                }else { //-- WAPCharging Huy
                    
                    NSString *NoChargingHuy_id = [dicDataNoChargingAction objectForKey:@"id"];
                    NSString *NoChargingHuy_body = [dicDataNoChargingAction objectForKey:@"code"];
                    NSString *NoChargingHuy_api = [dicDataNoChargingAction objectForKey:@"api"];
                    NSString *NoChargingHuy_message = [dicDataNoChargingAction objectForKey:@"message"];
                    NSString *NoChargingHuy_message_verify = [dicDataNoChargingAction objectForKey:@"message_verify"];
                    NSString *NoChargingHuy_success_message = [dicDataNoChargingAction objectForKey:@"success_message"];
                    NSString *NoChargingHuy_fail_message = [dicDataNoChargingAction objectForKey:@"fail_message"];
                    
                    //-- save info WAPCharging Huy NSUserDefaults
                    [userDefaults setObject:NoChargingHuy_id forKey:Key_noCharging_Huy_id];
                    [userDefaults setObject:NoChargingHuy_body forKey:Key_noCharging_Huy_body];
                    [userDefaults setObject:NoChargingHuy_api forKey:Key_noCharging_Huy_api];
                    [userDefaults setObject:NoChargingHuy_message forKey:Key_noCharging_Huy_message];
                    [userDefaults setObject:NoChargingHuy_message_verify forKey:Key_noCharging_Huy_message_verify];
                    [userDefaults setObject:NoChargingHuy_success_message forKey:Key_noCharging_Huy_success_message];
                    [userDefaults setObject:NoChargingHuy_fail_message forKey:Key_noCharging_Huy_fail_message];
                    [userDefaults synchronize];
                    
                }
                
            }
        }
    }
}

- (void) showMessageUpdateWithTitle:(NSString *)title withMessage:(NSString *)message
{
    NSLog(@"%s", __func__);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Đồng ý" otherButtonTitles:@"Bỏ qua", nil];
    [alert show];
}

- (void) showMessageUpdateWithTitle:(NSString *)title withMessage:(NSString *)message linkDown:(NSString *)linkDown updateSource:(UpdateSource)updateSource
{
    NSLog(@"%s", __func__);
    self.linkDownApp = linkDown;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Nâng cấp" otherButtonTitles:@"Bỏ qua", nil];
    alert.tag = 10;
    [alert show];
}

//-- update version

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        switch (buttonIndex) {
            
            case 0:{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkDownApp]];
                DLog(@"%@", self.linkDownApp);
                
                [self clearAllCacheAndDB];
                
                exit(0);
                break;
            }
                
            case 1:{
                break;
            }
                
            default:
                break;
        }
    }
    if (alertView.tag == 11) {
        exit(0);
    }
}
//longnh
- (void)clearAllCacheAndDB {
    NSLog(@"%s", __func__);
    //longnh: xoa file music start
    [AppDelegate addLocalLog:@"cache1"];
    NSUserDefaults *defaultMusic = [NSUserDefaults standardUserDefaults];
    [defaultMusic removeObjectForKey:@"startMusic"];
    [defaultMusic synchronize];
    
    //longnh: xoa file DB
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //            NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
    if ([fileManager fileExistsAtPath:writableDBPath]) {
        [fileManager removeItemAtPath:writableDBPath error:nil];
    }
    [AppDelegate addLocalLog:@"cache1"];
}

+(void) parseUserListSetting:(NSString *)aJson checkLockDevice:(bool)checkLockDevice
{
    NSLog(@"%s", __func__);
    NSDictionary *dictUserList = [aJson JSONValue];
    NSArray *arrData           = [dictUserList objectForKey:@"data"];
    
    NSMutableArray *arrUserType = [NSMutableArray new];
    
    if ([arrData count]>0) {
        
        for (NSInteger i = 0; i < [arrData count]; i++) {
            
            NSDictionary *dictUserType = [arrData objectAtIndex:i];
            
            NSString *user_type_id = [NSString stringWithFormat:@"%@",[dictUserType objectForKey:@"user_type_id"]];
            NSString *user_type_key = [NSString stringWithFormat:@"%@",[dictUserType objectForKey:@"user_type_key"]];
            
            if ([user_type_id isEqualToString:@"1"] || [user_type_key isEqualToString:@"normal_user"]) {
                
                NSMutableArray *telcoDataArr = [dictUserType objectForKey:@"user_register"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *telcoGlobalCodeDefault = [userDefaults valueForKey:@"TelcoGlobalCode"];
                bool isFound = false;

                for (NSInteger j=0; j< telcoDataArr.count; j++) {
                    
                    NSDictionary *dataDic = [telcoDataArr objectAtIndex:j];
                    NSString *telcoGlobalCode = [dataDic valueForKey:@"telco_global_code"];
                    
                    if ([telcoGlobalCode isEqualToString:telcoGlobalCodeDefault]) {
                        isFound = true;
                        //-- check 3G or wifi
                        NSString *payment_type = @"";
                        if ([Utility checkNetWorkStatus] == 2)
                            payment_type = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"mobile_network_payment_type"]];
                        else
                            payment_type = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"wifi_payment_type"]];
                        
                        //-- save Defaults payment_type
                        [userDefaults setObject:payment_type forKey:Key_wifi_payment_type];
                        [userDefaults setObject:payment_type forKey:Key_mobile_network_payment_type];
                        [userDefaults synchronize];
                    }
                }
                
                if (checkLockDevice) {
                    if (isFound) {
                        [AppDelegate addLocalLog:@"lockDevice"];
                        [userDefaults setObject:@"0" forKey:Key_is_lock_device];
                    }
                    else
                        [userDefaults setObject:@"1" forKey:Key_is_lock_device];
                }
            }
            
            
            UserType *usertType                     = [UserType new];
            usertType.upUserType                    = [NSMutableArray new];  //-- upgrade level user
            usertType.userContentTypeSetting        = [NSMutableArray new]; //-- rule for content type
            usertType.userRegister                  = [NSMutableArray new];
            usertType.userContentTypeSetting        = [dictUserType objectForKey:@"user_content_type_setting"];
            usertType.userMaxTotalPoint             = [dictUserType objectForKey:@"user_max_total_point"];
            usertType.userMinTotalPoint             = [dictUserType objectForKey:@"user_min_total_point"];
            usertType.userTypeDescription           = [dictUserType objectForKey:@"user_type_description"];
            usertType.userTypeId                    = [dictUserType objectForKey:@"user_type_id"];
            usertType.userTypeKey                   = [dictUserType objectForKey:@"user_type_key"];
            usertType.userTypeName                  = [dictUserType objectForKey:@"user_type_name"];
        
            [arrUserType addObject:usertType];
            
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *dataListUser = [NSKeyedArchiver archivedDataWithRootObject:arrUserType];
        [userDefaults setObject:dataListUser forKey:SETTING_USER_TYPE_LIST];
        [userDefaults  synchronize];
    }
    
    
}

+ (void) sendLog
{
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Đang gửi..."];
    NSString *crrLog = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    crrLog = [userDefaults objectForKey:LOCAL_LOG];
    [API sendLocalLog:crrLog
             completed:^(NSDictionary *responseDictionary, NSError *error) {
                 //-- fetching
                 if (error) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lỗi" message:[NSString stringWithFormat:@"Không thể gửi thông tin lỗi. Hãy kiểm tra kết nối mạng rồi thử lại."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
                 else {
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:[NSString stringWithFormat:@"Bạn đã gửi thông tin lỗi thành công"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
                 [[SHKActivityIndicator currentIndicator] hide];
             }];
}

+ (void) addLocalLog:(NSString *)content
{
    NSString *crrLog = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    crrLog = [userDefaults objectForKey:LOCAL_LOG];
    NSString *tmp;
    if ([crrLog length] <= LOG_SIZE)
        tmp = [NSString stringWithFormat:@"%@;%@", crrLog, content];
    else
        tmp = [NSString stringWithFormat:@"%@;%@", [crrLog substringFromIndex:([crrLog length]-LOG_SIZE)], content];
    [userDefaults setObject:tmp forKey:LOCAL_LOG];
    [userDefaults synchronize];
}

+ (void) addLocalLogWithInteger:(NSString *)content n:(int)n
{
    NSString *crrLog = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    crrLog = [userDefaults objectForKey:LOCAL_LOG];
    NSString *tmp;
    if ([crrLog length] <= LOG_SIZE)
        tmp = [NSString stringWithFormat:@"%@;%@ %d", crrLog, content, n];
    else
        tmp = [NSString stringWithFormat:@"%@;%@ %d", [crrLog substringFromIndex:([crrLog length]-LOG_SIZE)], content, n];
    [userDefaults setObject:tmp forKey:LOCAL_LOG];
    [userDefaults synchronize];
}

+ (void) addLocalLogWithFloat:(NSString *)content n:(float)n
{
    NSString *crrLog = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    crrLog = [userDefaults objectForKey:LOCAL_LOG];
    NSString *tmp;
    if ([crrLog length] <= LOG_SIZE)
        tmp = [NSString stringWithFormat:@"%@;%@ %f", crrLog, content, n];
    else
        tmp = [NSString stringWithFormat:@"%@;%@ %f", [crrLog substringFromIndex:([crrLog length]-LOG_SIZE)], content, n];
    [userDefaults setObject:tmp forKey:LOCAL_LOG];
    [userDefaults synchronize];
}

+ (void) addLocalLogWithString:(NSString *)content info:(NSString *)info
{
    NSString *crrLog = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    crrLog = [userDefaults objectForKey:LOCAL_LOG];
    NSString *tmp;
    if ([crrLog length] <= LOG_SIZE)
        tmp = [NSString stringWithFormat:@"%@;%@ %@", crrLog, content, info];
    else
        tmp = [NSString stringWithFormat:@"%@;%@ %@", [crrLog substringFromIndex:([crrLog length]-LOG_SIZE)], content, info];
    [userDefaults setObject:tmp forKey:LOCAL_LOG];
    [userDefaults synchronize];
}

@end
