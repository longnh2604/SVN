//
//  AppDelegate.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/3/13.
//  Copyright MAC_OSX 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookUtils.h"
#import "VMConstant.h"
#import "FMDatabase.h"
#import "SlideBarCenterViewController.h"
#import  "API.h"
#import "UserType.h"
#import "SingerContentTypeList.h"
#import "GAI.h"
#import "Setting.h"
#import "PlayWelcomeMusic.h"
#import "MenuBottomBarViewController.h"

#define isIphone5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define appid @"539623596100993"

@class SlideBarCenterViewController;
@class MenuBottomBarViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    //
    BOOL isResumePlayer;
    
    BOOL isShowFullScreen;
    
    NSString *schedulePhone;
    PlayWelcomeMusic *playWelcomeMusic;
}

@property (strong, nonatomic) UIWindow          *window;
@property (nonatomic, retain) SlideBarCenterViewController *slideBarController;
@property (nonatomic, retain) MenuBottomBarViewController *bottomBarController;
@property (strong, nonatomic) UINavigationController *mainNavController;

@property (assign) BOOL                         isMusicAll;
@property (assign) BOOL                         isMusicAlbum;
@property (assign) BOOL                         isMusic;
@property (assign) BOOL                         isPhotoAll;
@property (assign) BOOL                         isPhotoAlbum;
@property (assign) BOOL                         isPhotoView;
@property (assign) BOOL                         isSchedule;
@property (assign) BOOL                         selectSong;
@property (assign) BOOL                         isFanzone;
@property (assign) BOOL                         isNews;
@property (assign) BOOL                         isVideo;
@property (assign) BOOL                         isPageFeed;
@property (assign) BOOL                         isLinkFeed;
@property (assign) BOOL                         isPhotoFeed;
@property (assign) BOOL                         isVideoFeed;
@property (nonatomic, retain) NSString          *nodeCommentId;
@property (assign) double                       timeTest;

@property (nonatomic, retain) NSString          *linkDownApp;
@property (nonatomic, retain) NSString          *schedulePhone;

@property(nonatomic, retain) id<GAITracker> tracker;

#pragma mark - database

- (void)createEditableCopyOfDatabaseIfNeeded;

-(void) addBottomBar;
-(void) removeBottomBar;
-(BOOL) checkExistBottomBar;

-(void) addSlideBarBottom;
-(void) removeSlideBarBottom;
-(BOOL) checkExistSlideBarBottom;

-(BOOL) checkExistWifiLoginView;
- (void)sendPushToken:(NSString*)pushToken;

+ (void) addLocalLogWithFloat:(NSString *)content n:(float)n;
+ (void) addLocalLogWithInteger:(NSString *)content n:(int)n;
+ (void) addLocalLog:(NSString *)content;
+ (void) sendLog;
+ (void) addLocalLogWithString:(NSString *)content info:(NSString *)info;
+(void) processTelcoSetting:(bool)checkLockDevice;
+(NSString *) getTelcoGlobalCodeByPhoneNumber:(NSString *)phoneNumber;


#pragma mark - facebook

/*
 * Handler error when session's state changed
 */
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
