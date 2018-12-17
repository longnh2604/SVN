//
//  SearchViewController.m
//  NooPhuocThinh
//
//  Created by longnh on 4/14/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "SearchViewController.h"
#import "VideoDetailViewController.h"
#import "DNewsViewController.h"
#import "DetailsScheduleViewController.h"
#import "StoreDetailViewController.h"

#define CATEGORY_ID_STORE_ALL @"category_id_store_all"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize searchtype;
@synthesize listDataSource;

@synthesize tableviewMusic,tableviewNews,tableviewSchedule,tableviewStore,tableviewTopUser;
@synthesize tableviewVideo;
@synthesize videoTypeId;
@synthesize viewSearchBar,searchBar;
@synthesize gestureTapRecognizer;

//********************************************************************************//
#pragma mark - Main

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //-- set title
    [self setTitle:@"Search"];
    
    //-- custom NavigationBar
    [self AddBarButtonItemToNavigationBar];
    
    //-- add view and get data
    [self setDataWhenViewDidLoad];
    
    currentPageLoadMore = 0;
    
    //---Search
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [UIView view:viewSearchBar setY:64];
        self.searchBar.barTintColor = [UIColor colorWithRed:15/255.0f green:85/255.0f blue:109/255.0f alpha:1];
    }
    
    for(UIView *subView in [searchBar subviews]) {
        
        if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subView setReturnKeyType: UIReturnKeyDone];
        } else {
            for(UIView *subSubView in [subView subviews]) {
                if([subSubView conformsToProtocol:@protocol(UITextInputTraits)]) {
                    [(UITextField *)subSubView setReturnKeyType: UIReturnKeyDone];
                }
            }      
        }
    }
    
    searchResult = [[NSMutableArray alloc] init];
    
    //--- show the keyboard search
    [self.searchBar becomeFirstResponder];
    
    isSearchOn = YES;
    canSelectRow = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.screenName = @"Search Screen";
    
    //-- check user and going to Fanzone screen
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataTableView) name:@"Reload_MusicAlbumVC" object:nil];
    
    //-- reload tableview music
    if (tableviewMusic)
        [tableviewMusic.tableView reloadData];
}

-(void) reloadDataTableView {
        
    //-- reload tableview music
    if (tableviewMusic)
        [tableviewMusic.tableView reloadData];
    
    NSUserDefaults *defaultSelectedSong = [NSUserDefaults standardUserDefaults];
    [defaultSelectedSong setBool:NO forKey:@"Selected_ButtonNextSlideBar"];
    [defaultSelectedSong synchronize];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationItem.hidesBackButton = YES;
}

//-- add BarButton to navigationBar
-(void) AddBarButtonItemToNavigationBar
{
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    //-- Back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(selectedBackButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- search button
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(searchAPI:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = barItemRight;
}

//-- setup view and get data
-(void) setDataWhenViewDidLoad {
    
    CGRect frameView = [self.view frame];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        frameView.origin.y = 44;
        frameView.size.height -= 84;
        
    }else {
        
        frameView.origin.y = 108;
        frameView.size.height -= 148;
    }
    
    switch (searchtype) {
            
        case searchMusicType:
            //-- insert Music table
            [self insertMusicTableViewWithFrame:frameView];
            break;
            
        case searchNewsType:
            //-- insert News table
            [self insertNewsTableViewWithFrame:frameView];
            break;
            
        case searchVideoType:
            //-- insert Video table
            [self insertVideoTableViewWithFrame:frameView];
            break;
            
        case searchScheduleType:
            //-- insert Schedule table
            [self insertScheduleTableViewWithFrame:frameView];
            break;
            
        case searchStoreType:
            //-- insert Store table
            [self insertStoreTableViewWithFrame:frameView];
            break;
            
        case searchTopUsersType:
            //-- insert TopUser table
            [self insertTopUserTableViewWithFrame:frameView];
            break;
            
        default:
            break;
    }
}

//********************************************************************************//
#pragma mark - Function

//-- insert Music tableview
-(void) insertMusicTableViewWithFrame:(CGRect) frameView {
    
    if (!listDataSource)
        listDataSource = [[NSMutableArray alloc] init];
    else
        [listDataSource removeAllObjects];
    
    //-- get all music
    listDataSource = [VMDataBase getAllTrackByAlbumId:nil];
    
    //-- create tableview music
    tableviewMusic = [[BaseTableMusicViewController alloc] init];
    tableviewMusic.delegate = self;
    tableviewMusic.view.backgroundColor = [UIColor clearColor];
    [tableviewMusic.view setFrame:frameView];
    [tableviewMusic.view setTag:searchMusicType];
    
    tableviewMusic.listData  = listDataSource;
    
    //-- load more from bottom
    __weak SearchViewController *myself = self;
    [tableviewMusic.tableView addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreDataWithSearchtype:searchMusicType];
    }];
    
    //-- add view
    [self.view addSubview:tableviewMusic.view];
}

//-- insert News tableview
-(void) insertNewsTableViewWithFrame:(CGRect) frameView {
    
    if (!listDataSource)
        listDataSource = [[NSMutableArray alloc] init];
    else
        [listDataSource removeAllObjects];
    
    //-- get all News
    listDataSource = [VMDataBase getAllNews];
    
    //-- create tableview News
    tableviewNews = [[TableNewsViewController alloc] init];
    tableviewNews.delegate = self;
    tableviewNews.isShowLableNodata = NO;
    tableviewNews.view.backgroundColor = [UIColor clearColor];
    [tableviewNews.view setFrame:frameView];
    [tableviewNews.view setTag:searchNewsType];
    
    tableviewNews.listNews  = listDataSource;
    
    //-- load more from bottom
    __weak SearchViewController *myself = self;
    [tableviewNews.tableView addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreDataWithSearchtype:searchNewsType];
    }];
    
    //-- add view
    [self.view addSubview:tableviewNews.view];
}

//-- insert Video table
-(void) insertVideoTableViewWithFrame:(CGRect) frameView {
    
    if (!listDataSource)
        listDataSource = [[NSMutableArray alloc] init];
    else
        [listDataSource removeAllObjects];
    
    //-- get videos from DB
    NSString *contentTypeStr = [NSString stringWithFormat:@"%d",videoTypeId];
    
    if (videoTypeId == ContentTypeIDAllVideo)
        listDataSource = [VMDataBase getAllVideos];
    else if (videoTypeId == ContentTypeIDVideo)
        listDataSource = [VMDataBase getAllVideosOffiCialByCategoryId:contentTypeStr];
    else
        listDataSource = [VMDataBase getAllVideosUnOffiCialByCategoryId:contentTypeStr];
    
    //-- create tableview video
    tableviewVideo = [[BaseTableVideoViewController alloc] init];
    tableviewVideo.delegateVideo = self;
    tableviewVideo.videoTypeId = videoTypeId;
    
    tableviewVideo.view.backgroundColor = [UIColor clearColor];
    [tableviewVideo.view setFrame:frameView];
    [tableviewVideo.view setTag:searchVideoType];
    
    //-- load data
    tableviewVideo.listData  = listDataSource;
    
    //-- load more from bottom
    __weak SearchViewController *myself = self;
    [tableviewVideo.tableView addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreDataWithSearchtype:searchVideoType];
    }];
    
    //-- add view
    [self.view addSubview:tableviewVideo.view];
}

//-- insert Schedule table
-(void) insertScheduleTableViewWithFrame:(CGRect) frameView {
    
    if (!listDataSource)
        listDataSource = [[NSMutableArray alloc] init];
    else
        [listDataSource removeAllObjects];
    
    //-- get all Schedule
    listDataSource = [VMDataBase getAllScheduleByCategoryid:nil];
    
    //-- create tableview schedule
    tableviewSchedule = [[TableScheduleViewController alloc] init];
    tableviewSchedule.delegate = self;
    tableviewSchedule.view.backgroundColor = [UIColor clearColor];
    [tableviewSchedule.view setFrame:frameView];
    [tableviewSchedule.view setTag:searchScheduleType];
    
    tableviewSchedule.listSchedule  = listDataSource;
    
    //-- load more from bottom
    __weak SearchViewController *myself = self;
    [tableviewSchedule.tableView addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreDataWithSearchtype:searchScheduleType];
    }];
    
    //-- add view
    [self.view addSubview:tableviewSchedule.view];
}

//-- insert Store table
-(void) insertStoreTableViewWithFrame:(CGRect) frameView {
    
    if (!listDataSource)
        listDataSource = [[NSMutableArray alloc] init];
    else
        [listDataSource removeAllObjects];
    
    //-- get all Store
    listDataSource = [VMDataBase getAllStoreWithCategoryID:CATEGORY_ID_STORE_ALL];
    
    //-- create table store
    tableviewStore = [[TableStoreViewController alloc] init];
    tableviewStore.delegate = self;
    tableviewStore.view.backgroundColor = [UIColor clearColor];
    [tableviewStore.view setFrame:frameView];
    [tableviewStore.view setTag:searchScheduleType];
    
    tableviewStore.listStore  = listDataSource;
    
    //-- load more from bottom
    __weak SearchViewController *myself = self;
    [tableviewStore.tableView addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreDataWithSearchtype:searchStoreType];
    }];
    
    //-- add view
    [self.view addSubview:tableviewStore.view];
}

//-- insert TopUser table
-(void) insertTopUserTableViewWithFrame:(CGRect) frameView {
    
    if (!listDataSource)
        listDataSource = [[NSMutableArray alloc] init];
    else
        [listDataSource removeAllObjects];
    
    //-- get all TopUser
    listDataSource = [VMDataBase getAllTopUserByCategoryid:@"0"];
    
    //-- create table top user
    tableviewTopUser = [[TableTopUserViewController alloc] init];
    tableviewTopUser.delegate = self;
    tableviewTopUser.view.backgroundColor = [UIColor clearColor];
    [tableviewTopUser.view setFrame:frameView];
    [tableviewTopUser.view setTag:searchScheduleType];
    
    tableviewTopUser.listTopUser  = listDataSource;
    
    //-- load more from bottom
    __weak SearchViewController *myself = self;
    [tableviewTopUser.tableView addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreDataWithSearchtype:searchTopUsersType];
    }];
    
    //-- add view
    [self.view addSubview:tableviewTopUser.view];
}


//-- load more data
-(void)loadMoreDataWithSearchtype:(SearchTypes) searchtypeloadmore
{
    if (listDataSource.count %10 == 0) {
        
        isLoadmore = YES;
        
        currentPageLoadMore ++;
        
        switch (searchtypeloadmore) {
                
            case searchMusicType:
                //-- call api fetching Data Music
                [self callSearchAPIFetchingDataByContentTypeId:ContentTypeIDMusic];
                break;
                
            case searchNewsType:
                //-- call api fetching Data News
                [self callSearchAPIFetchingDataByContentTypeId:ContentTypeIDNews];
                break;
                
            case searchVideoType:
                //-- call api fetching Data Video
                [self callSearchAPIFetchingDataByContentTypeId:videoTypeId];
                break;
                
            case searchScheduleType:
                //-- call api fetching Data Schedule
                [self callSearchAPIFetchingDataByContentTypeId:ContentTypeIDSchedule];
                break;
                
            case searchStoreType:
                //-- call api fetching Data Store
                [self callSearchAPIFetchingDataByContentTypeId:ContentTypeIDStore];
                break;
                
            case searchTopUsersType:
                //-- call api fetching Data TopUser
                [self callAPISearchUser];
                break;
                
            default:
                break;
        }
        
    }else {
        
        isLoadmore = NO;
        
        //-- handle data response = nil
        [self handleDataSearchWithResponse:nil];
    }
}


//*******************************************************************************//
#pragma mark - Music delegate

//-- Music delegate
-(void) goToMusicPlayViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    //-- done action search
    [self doneSearchingByisRefresh:NO];
    
    MusicPlayViewController *mpVC = (MusicPlayViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"idMusicPlayViewControllerSb"];
    
    mpVC.arrTrack = listData;
    mpVC.indexOfSong = indexRow;
    mpVC.title = [[listData objectAtIndex:indexRow] valueForKey:@"albumName"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:mpVC animated:YES];
    else
        [self.navigationController pushViewController:mpVC animated:NO];
    
    //longnh add
    MusicTrackNew *selectTrack = (MusicTrackNew*)[listData objectAtIndex:indexRow];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"play_song"  // Event action (required)
                                                           label:selectTrack.name
                                                           value:nil] build]];
    

    
}

//-- delegate Ringback and DownLoad
-(void) passDelegateGoToMusicAlbumViewController:(NSMutableArray *) listData withIndexRow:(int) indexRow ByDelegateType:(delegateTypes) delegateType {
    
    //-- done action search
    [self doneSearchingByisRefresh:NO];
    
    MusicTrackNew *msTrack = [listData objectAtIndex:indexRow];
    
    if (delegateType == delegateRingBackType) {
        
        //-- request get SongRingBackToneId
        [self callApiGetSongRingBackToneIdByMusicID:msTrack];
        
    }else {
        
        //-- BaseTableMusic pass Delegate thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}

//-- request get SONG_RINGBACKTONE_ID
-(void) callApiGetSongRingBackToneIdByMusicID:(MusicTrackNew *) msTrack {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *telcoCode = [userDefaults valueForKey:Key_telco_global_code];
    
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Getting..."];
    
    //-- request SONG_RINGBACKTONE_ID
    [API apiGetSongRingBackToneIDByMusicID:msTrack.nodeId distributorChannelId:DISTRIBUTOR_CHANNEL_ID telcoCode:telcoCode appID:PRODUCTION_ID appVersion:PRODUCTION_VERSION completed:^(NSDictionary *responseDictionary, NSError *error) {
        
        //-- hidden loading
        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
        
        NSDictionary *data = [responseDictionary valueForKey:@"data"];
        
        //-- fetching
        if (!error && data) {
            
            NSString *ringback_tone_code = [data valueForKey:@"ringback_tone_code"];
            
            if (ringback_tone_code && [ringback_tone_code length]>0) {
                
                //-- save ringback_tone_code
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:ringback_tone_code forKey:@"SONG_RINGBACKTONEID_DEFAULT"];
                [userDefaults synchronize];
                
                NSString *message = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_ringbackMessage]];
                NSString *tempMessage = [message stringByReplacingOccurrencesOfString:@"SONG_NAME" withString:msTrack.name];
                
                //-- Send SMS Nhac Cho
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:kTitleMessageApp message:tempMessage delegate:nil cancelButtonTitle:@"Đồng ý" otherButtonTitles:@"Huỷ", nil];
                [alertview setDelegate:self];
                [alertview setTag:100];
                [alertview show];
                
            }else {
                
                //-- show error
                [self showMessageSystemError];
            }
            
        }else {
            
            //-- show error
            [self showMessageSystemError];
        }
        
    }];
}

//-- show error
-(void) showMessageSystemError {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
    
    [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
}


//--Alertview Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int tag = alertView.tag;
    switch (tag) {
            
        case 100: {
            if (buttonIndex == 0) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *command_gateway = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_ringbackCommand_gateway]];
                
                NSString *songRingbacktoneId = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"SONG_RINGBACKTONEID_DEFAULT"]];
                
                NSString *tempBody = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_ringbackCommand_body]];
                NSString *command_body = [tempBody stringByReplacingOccurrencesOfString:@"SONG_RINGBACKTONE_ID" withString:songRingbacktoneId];
                
                [self sendSMSRingback:command_body recipientList:@[command_gateway]];
                
            }else return;
        }
            break;
            
        default:
            break;
    }
}

//-- result send Message
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"%s", __func__);
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
}

//-- title & content of SMS
- (void)sendSMSRingback:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        {
            [self presentModalViewController:controller animated:YES];
        }
        else
        {
            [self presentViewController:controller animated:YES completion:Nil];
        }
    }
}


//*******************************************************************************//
#pragma mark - Video delegate

//-- Video delegate
-(void) goToVideoPlayViewControllerWithListData:(NSMutableArray *)listData withVideoTypeId:(NSInteger)valueVideoTypeId withIndexRow:(int)indexRow
{
    //-- done action search
    [self doneSearchingByisRefresh:NO];
    
    VideoDetailViewController *videoDetailVC = (VideoDetailViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetailViewControllerIdentifier"];
    
    //-- pass Data
    videoDetailVC.contentVideoTypeId = valueVideoTypeId;
    
    if (valueVideoTypeId == ContentTypeIDVideo || valueVideoTypeId == ContentTypeIDAllVideo) {
        
        if (valueVideoTypeId == ContentTypeIDAllVideo) {
            
            //-- Official Video info
            VideoAllModel *aVideo = [listData objectAtIndex:indexRow];
            videoDetailVC.videoAllModelInfo = aVideo;
            
        }else {
            
            //-- Official Video info
            VideoForAll *aVideo = [listData objectAtIndex:indexRow];
            videoDetailVC.videoForAllInfo = aVideo;
        }
        
    }else {
        
        //-- Unofficial Video info
        VideoForCategory *aVideo = [listData objectAtIndex:indexRow];
        videoDetailVC.videoForCategoryInfo = aVideo;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:videoDetailVC animated:YES];
    else
        [self.navigationController pushViewController:videoDetailVC animated:NO];
}


//*******************************************************************************//
#pragma mark - News delegate

//-- News delegate
-(void)goToDetailNewsViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    //-- done action search
    [self doneSearchingByisRefresh:NO];
    
    DNewsViewController *detailNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbDNewsViewControllerId"];
    
    News *newsInfo = (News *)[listData objectAtIndex:indexRow];
    
    detailNewsVC.news = newsInfo;
    detailNewsVC.arrNews = listData;
    detailNewsVC.numberOfNews = listData.count;
    detailNewsVC.indexOfNews = [listData indexOfObject:newsInfo];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:detailNewsVC animated:YES];
    else
        [self.navigationController pushViewController:detailNewsVC animated:NO];
}


//*******************************************************************************//
#pragma mark - Schedule delegate

//-- Schedule delegate
-(void) goToDetailScheduleViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    //-- done action search
    [self doneSearchingByisRefresh:NO];
    
    DetailsScheduleViewController *dsVC = (DetailsScheduleViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailsScheduleViewControllerId"];
    
    NSInteger indexOfSchedule;
    NSMutableArray *urlSongArr = [[NSMutableArray alloc] init];
    
    Schedule *schedule = [listData objectAtIndex:indexRow];
    indexOfSchedule = [listData indexOfObject:schedule];
    
    if ([listData count]>0) {
        for (NSInteger i=0; i<[listData count]; i++) {
            Schedule *mTr = [listData objectAtIndex:i];
            NSString *urlStr = mTr.imageFilePath;
            
            [urlSongArr addObject:urlStr];
        }
    }
    
    dsVC.schedule = schedule;
    dsVC.dataSourceSchedule = listData;
    dsVC.indexOfSchedule = indexOfSchedule;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:dsVC animated:YES];
    else
        [self.navigationController pushViewController:dsVC animated:NO];
}


//*******************************************************************************//
#pragma mark - Store delegate

//-- Store delegate
-(void)goToDetailStoreViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    //-- done action search
    [self doneSearchingByisRefresh:NO];
    
    StoreDetailViewController *detailStoreVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbStoreDetailViewControllerId"];
    
    Store *aStore = (Store *)[listData objectAtIndex:indexRow];
    NSInteger currentIndex = [listData indexOfObject:aStore];
    
    detailStoreVC.store             = aStore;
    detailStoreVC.currentIndex      = currentIndex;
    detailStoreVC.arrStore          = listData;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:detailStoreVC animated:YES];
    else
        [self.navigationController pushViewController:detailStoreVC animated:NO];
}


//*******************************************************************************//
#pragma mark - Top User delegate

-(void)goToDetailProfileViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    //-- done action search
    [self doneSearchingByisRefresh:NO];
    
    ProfileViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idProfileViewControllerSb"];
    
    NSString *userId = ((TopUser *)[listData objectAtIndex:indexRow]).userId;
    NSString *myUserId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:MY_ACCOUNT_ID]];
    
    if ([userId isEqualToString:myUserId])
        pVC.profileType = ProfileTypeMyAccount;
    else
        pVC.profileType = ProfileTypeGuess;
    
    pVC.userId = userId;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:pVC animated:YES];
    else
        [self.navigationController pushViewController:pVC animated:NO];
}


//********************************************************************************//
#pragma mark - ACTION


-(void)selectedBackButton:(id)sender
{
    [self doneSearchingByisRefresh:YES];
    
    [UIView animateWithDuration:0.55
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    
    [self.navigationController popViewControllerAnimated:NO];
}


//********************************************************************************//
#pragma mark - Search Local

//-- fired when the user taps on the searchbar --//
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    isSearchOn = YES;
    canSelectRow = NO;
    
    //-- setup tableView contentsize
    [self setContentSizeForTablviewByisShowKeyBoard:YES];
    
    //-- setup hidden keyboad
    self.gestureTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    self.gestureTapRecognizer.delegate = self;
    [self.view.superview addGestureRecognizer:self.gestureTapRecognizer];
}

//-- fired when the user types something into the searchbar --//
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //-- if there is something to search for
    if ([searchText length] > 0) {
        
        isSearchOn = YES;
        canSelectRow = YES;
        
        //----- search in listDataSource -----//
        //-- get data result
        [self filterDataBySearchType];
    }
    else {
        
        //-- nothing to search
        isSearchOn = NO;
        canSelectRow = NO;
        
        //-- refresh the tableview
        [self setReloadDataTableViewByisRefresh:YES];
    }
}

//-- setup tableView contentsize
-(void) setContentSizeForTablviewByisShowKeyBoard:(BOOL) isShowKeyBoard {
    
    switch (searchtype) {
            
        case searchMusicType: {
            
            //-- tableviewMusic
            CGRect frameTB = tableviewMusic.view.frame;
            if (isShowKeyBoard == YES)
                frameTB.size.height -= 176;
            else
                frameTB.size.height += 176;
            
            [UIView animateWithDuration:0.3 animations:^{
                [tableviewMusic.view setFrame:frameTB];
            }];
        }
            break;
            
        case searchNewsType: {
            
            //-- tableviewNews
            CGRect frameTB = tableviewNews.view.frame;
            if (isShowKeyBoard == YES)
                frameTB.size.height -= 176;
            else
                frameTB.size.height += 176;
            
            [UIView animateWithDuration:0.3 animations:^{
                [tableviewNews.view setFrame:frameTB];
            }];
        }
            break;
            
        case searchVideoType: {
            
            //-- tableviewVideo
            CGRect frameTB = tableviewVideo.view.frame;
            if (isShowKeyBoard == YES)
                frameTB.size.height -= 176;
            else
                frameTB.size.height += 176;
            
            [UIView animateWithDuration:0.3 animations:^{
                [tableviewVideo.view setFrame:frameTB];
            }];
        }
            break;
            
        case searchScheduleType: {
            
            //-- tableviewSchedule
            CGRect frameTB = tableviewSchedule.view.frame;
            if (isShowKeyBoard == YES)
                frameTB.size.height -= 176;
            else
                frameTB.size.height += 176;
            
            [UIView animateWithDuration:0.3 animations:^{
                [tableviewSchedule.view setFrame:frameTB];
            }];
        }
            break;
            
        case searchStoreType: {
            
            //-- tableviewStore
            CGRect frameTB = tableviewStore.view.frame;
            if (isShowKeyBoard == YES)
                frameTB.size.height -= 176;
            else
                frameTB.size.height += 176;
            
            [UIView animateWithDuration:0.3 animations:^{
                [tableviewStore.view setFrame:frameTB];
            }];
        }
            break;
            
        case searchTopUsersType: {
            
            //-- tableviewTopUser
            CGRect frameTB = tableviewTopUser.view.frame;
            if (isShowKeyBoard == YES)
                frameTB.size.height -= 176;
            else
                frameTB.size.height += 176;
            
            [UIView animateWithDuration:0.3 animations:^{
                [tableviewTopUser.view setFrame:frameTB];
            }];
        }
            break;
            
        default:
            break;
    }
}

//---fired when the user taps the Search button on the keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //-- done action search
    [self doneSearchingByisRefresh:NO];
}

//-- done with the searching --//
- (void) doneSearchingByisRefresh:(BOOL) isRefresh {
    
    [self.view.superview removeGestureRecognizer:self.gestureTapRecognizer];
    
    isSearchOn = NO;
    canSelectRow = YES;
    
    //-- hides the keyboard
    [self.searchBar resignFirstResponder];
    
    //-- setup tableView contentsize
    [self setContentSizeForTablviewByisShowKeyBoard:NO];
    
    //-- refresh the tableview
    [self setReloadDataTableViewByisRefresh:isRefresh];
}

-(void) setReloadDataTableViewByisRefresh:(BOOL) isRefresh {
    
    switch (searchtype) {
            
        case searchMusicType: {
            //-- reload tableview Music
            if (isRefresh == YES)
                tableviewMusic.listData = listDataSource;
            
            [self.tableviewMusic.tableView reloadData];
        }
            break;
            
        case searchNewsType: {
            //-- reload tableview News
            if (isRefresh == YES)
                tableviewNews.listNews = listDataSource;
            
            [self.tableviewNews.tableView reloadData];
        }
            break;
            
        case searchVideoType: {
            //-- reload tableview Video
            if (isRefresh == YES)
                tableviewVideo.listData = listDataSource;
            
            [self.tableviewVideo.tableView reloadData];
        }
            break;
            
        case searchScheduleType: {
            //-- reload tableview Schedule
            if (isRefresh == YES)
                tableviewSchedule.listSchedule = listDataSource;
            
            [self.tableviewSchedule.tableView reloadData];
        }
            break;
            
        case searchStoreType: {
            //-- reload tableview Store
            if (isRefresh == YES)
                tableviewStore.listStore = listDataSource;
            
            [self.tableviewStore.tableView reloadData];
        }
            break;
            
        case searchTopUsersType: {
            //-- reload tableview TopUser
            if (isRefresh == YES)
                tableviewTopUser.listTopUser = listDataSource;
            
            [self.tableviewTopUser.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}

//-- check searchType and filter data
-(void) filterDataBySearchType {
    
    //-- clears the search result
    [searchResult removeAllObjects];
    
    switch (searchtype) {
            
        case searchMusicType:
            //-- get Music data
            [self filterMusicData];
            break;
            
        case searchNewsType:
            //-- get News data
            [self filterNewsData];
            break;
            
        case searchVideoType:
            //-- get Video data
            [self filterVideoData];
            break;
            
        case searchScheduleType:
            //-- get Schedule data
            [self filterScheduleData];
            break;
            
        case searchStoreType:
            //-- get Store data
            [self filterStoreData];
            break;
            
        case searchTopUsersType:
            //-- get TopUser data
            [self filterTopUserData];
            break;
            
        default:
            break;
    }
}

-(void) filterMusicData {
    
    for (int i= 0; i<[listDataSource count]; i++) {
        
        MusicTrackNew *msTrack = [listDataSource objectAtIndex:i];
        
        NSString *filterString = [NSString stringWithFormat:@"%@",msTrack.name];
        
        NSRange titleResultsRange = [filterString rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if (titleResultsRange.length > 0) [searchResult addObject:[listDataSource objectAtIndex:i]];
    }
    
    tableviewMusic.listData  = searchResult;
    [self.tableviewMusic.tableView reloadData];
}

-(void) filterNewsData {
    
    for (int i= 0; i<[listDataSource count]; i++) {
        
        News *news =  (News*)[listDataSource objectAtIndex:i];
        
        NSString *filterString = [NSString stringWithFormat:@"%@",news.title];
        
        NSRange titleResultsRange = [filterString rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if (titleResultsRange.length > 0) [searchResult addObject:[listDataSource objectAtIndex:i]];
    }
    
    tableviewNews.listNews  = searchResult;
    [self.tableviewNews.tableView reloadData];
}

-(void) filterVideoData {
    
    if (videoTypeId == ContentTypeIDAllVideo) {
        
        for (int i= 0; i<[listDataSource count]; i++) {
            
            VideoAllModel *videoInfo = [listDataSource objectAtIndex:i];
            
            NSString *filterString = [NSString stringWithFormat:@"%@",videoInfo.name];
            
            NSRange titleResultsRange = [filterString rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResultsRange.length > 0) [searchResult addObject:[listDataSource objectAtIndex:i]];
        }
        
    }else if (videoTypeId == ContentTypeIDVideo) {
        
        for (int i= 0; i<[listDataSource count]; i++) {
            
            VideoForAll *videoInfo = [listDataSource objectAtIndex:i];
            
            NSString *filterString = [NSString stringWithFormat:@"%@",videoInfo.name];
            
            NSRange titleResultsRange = [filterString rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResultsRange.length > 0) [searchResult addObject:[listDataSource objectAtIndex:i]];
        }
        
    }else {
        
        for (int i= 0; i<[listDataSource count]; i++) {
            
            VideoForCategory *videoInfo = [listDataSource objectAtIndex:i];
            
            NSString *filterString = [NSString stringWithFormat:@"%@",videoInfo.title];
            
            NSRange titleResultsRange = [filterString rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResultsRange.length > 0) [searchResult addObject:[listDataSource objectAtIndex:i]];
        }
    }

    tableviewVideo.listData  = searchResult;
    [self.tableviewVideo.tableView reloadData];
}

-(void) filterScheduleData {
    
    for (int i= 0; i<[listDataSource count]; i++) {
        
        Schedule *schedule = (Schedule*)[listDataSource objectAtIndex:i];
        
        NSString *filterString = [NSString stringWithFormat:@"%@",schedule.name];
        
        NSRange titleResultsRange = [filterString rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if (titleResultsRange.length > 0) [searchResult addObject:[listDataSource objectAtIndex:i]];
    }
    
    tableviewSchedule.listSchedule  = searchResult;
    [self.tableviewSchedule.tableView reloadData];
}

-(void) filterStoreData {
    
    for (int i= 0; i<[listDataSource count]; i++) {
        
        Store *aStore = (Store *)[listDataSource objectAtIndex:i];
        
        NSString *filterString = [NSString stringWithFormat:@"%@",aStore.name];
        
        NSRange titleResultsRange = [filterString rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if (titleResultsRange.length > 0) [searchResult addObject:[listDataSource objectAtIndex:i]];
    }
    
    tableviewStore.listStore  = searchResult;
    [self.tableviewStore.tableView reloadData];
}

-(void) filterTopUserData {
    
    for (int i= 0; i<[listDataSource count]; i++) {
        
        TopUser *topUser = (TopUser*)[listDataSource objectAtIndex:i];
        
        NSString *filterString = [NSString stringWithFormat:@"%@%@",topUser.fullName,topUser.userName];
        
        NSRange titleResultsRange = [filterString rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if (titleResultsRange.length > 0) [searchResult addObject:[listDataSource objectAtIndex:i]];
    }
    
    tableviewTopUser.listTopUser  = searchResult;
    [self.tableviewTopUser.tableView reloadData];
}

- (void) hideKeyboard:(UIGestureRecognizer *) recognizer{
    
    //-- done search
    [self doneSearchingByisRefresh:NO];
}


//********************************************************************************//
#pragma mark - Search API

//-- search api by searchType
-(IBAction)searchAPI:(id)sender {
    
    isLoadmore = NO;
    currentPageLoadMore = 0;
    
    switch (searchtype) {
            
        case searchMusicType:
            //-- call api fetching Data Music
            [self callSearchAPIFetchingDataByContentTypeId:ContentTypeIDMusic];
            break;
            
        case searchNewsType:
            //-- call api fetching Data News
            [self callSearchAPIFetchingDataByContentTypeId:ContentTypeIDNews];
            break;
            
        case searchVideoType:
            //-- call api fetching Data Video
            [self callSearchAPIFetchingDataByContentTypeId:videoTypeId];
            break;
            
        case searchScheduleType:
            //-- call api fetching Data Schedule
            [self callSearchAPIFetchingDataByContentTypeId:ContentTypeIDSchedule];
            break;
            
        case searchStoreType:
            //-- call api fetching Data Store
            [self callSearchAPIFetchingDataByContentTypeId:ContentTypeIDStore];
            break;
            
        case searchTopUsersType:
            //-- call api fetching Data TopUser
            [self callAPISearchUser];
            break;
            
        default:
            break;
    }
}

//-- call API
- (void)callSearchAPIFetchingDataByContentTypeId:(ContentTypeID)contentTypeId {
    
    //-- validate content
    NSString *tempContent = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereAreJustSpaces = [tempContent isEqualToString:@""];
    
    if( ((!thereAreJustSpaces) || [tempContent length] > 0)) {
        
        [NetworkActivity show];
        
        //-- request search Music API
        [API searchAPIOfSinglerID:SINGER_ID contentTypeId:contentTypeId keyword:self.searchBar.text limit:@"10" page:[NSString stringWithFormat:@"%d",currentPageLoadMore] isGetBody:@"1" isGetHot:@"0" appID:PRODUCTION_ID appVersion:PRODUCTION_VERSION completed:^(NSDictionary *responseDictionary, NSError *error) {
            
            [NetworkActivity hide];
            
            if (!error) {
                
                //-- handle data response
                [self handleDataSearchWithResponse:responseDictionary];
                
            }else {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                NSString *messageError = nil;
                if ([userDefaults valueForKey:Key_Message_System_Error])
                    messageError = [userDefaults valueForKey:Key_Message_System_Error];
                else
                    messageError = TITLE_System_Error;
                
                [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
            }
        }];
    }
    else {
        
        //-- handle data response = nil
        [self handleDataSearchWithResponse:nil];
        
        if (isLoadmore == NO)
            [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_SearchEmtry withFriendName:nil needDelegate:NO withTag:6];
    }
}

//-- call API search users
-(void) callAPISearchUser {
    
    //-- validate content
    NSString *tempContent = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereAreJustSpaces = [tempContent isEqualToString:@""];
    
    if( ((!thereAreJustSpaces) || [tempContent length] > 0)) {
        
        [NetworkActivity show];
        
        //-- request search User API
        [API searchUserOfSinglerID:SINGER_ID keyword:self.searchBar.text limit:@"10" page:[NSString stringWithFormat:@"%d",currentPageLoadMore] appID:PRODUCTION_ID appVersion:PRODUCTION_VERSION completed:^(NSDictionary *responseDictionary, NSError *error) {
            
            [NetworkActivity hide];
            
            if (!error) {
                
                //-- handle data response
                [self handleDataSearchWithResponse:responseDictionary];
                
            }else {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                NSString *messageError = nil;
                if ([userDefaults valueForKey:Key_Message_System_Error])
                    messageError = [userDefaults valueForKey:Key_Message_System_Error];
                else
                    messageError = TITLE_System_Error;
                
                [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
            }
        }];
    }
    else {
        
        //-- handle data response = nil
        [self handleDataSearchWithResponse:nil];
        
        if (isLoadmore == NO)
            [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_SearchEmtry withFriendName:nil needDelegate:NO withTag:6];
    }
}

//-- handle data response
-(void) handleDataSearchWithResponse:(NSDictionary *) responseDictionary {
    
    switch (searchtype) {
            
        case searchMusicType: {
            
            if (responseDictionary)
                //-- handle Music data
                [self createDataSourceAllSongFrom:responseDictionary];
            else
                //-- hidden loading
                [tableviewMusic.tableView.infiniteScrollingView stopAnimating];
        }
            break;
            
        case searchNewsType: {
            if (responseDictionary)
                //-- handle News data
                [self createDataSourceForNewsFrom:responseDictionary];
            else
                //-- hidden loading
                [tableviewNews.tableView.infiniteScrollingView stopAnimating];
        }
            break;
            
        case searchVideoType: {
            if (responseDictionary)
                //-- handle Video data
                [self createDataSourceForVideoFrom:responseDictionary];
            else
                //-- hidden loading
                [tableviewVideo.tableView.infiniteScrollingView stopAnimating];
        }
            break;
            
        case searchScheduleType: {
            if (responseDictionary)
                //-- handle Schedule data
                [self createDataSourceForScheduleFrom:responseDictionary];
            else
                //-- hidden loading
                [tableviewSchedule.tableView.infiniteScrollingView stopAnimating];
        }
            break;
            
        case searchStoreType: {
            if (responseDictionary)
                //-- handle Store data
                [self createDataSourceForStoreFrom:responseDictionary];
            else
                //-- hidden loading
                [tableviewStore.tableView.infiniteScrollingView stopAnimating];
        }
            break;
            
        case searchTopUsersType: {
            if (responseDictionary)
                //-- handle TopUsers data
                [self createDataSourceForTopUserFrom:responseDictionary];
            else
                //-- hidden loading
                [tableviewStore.tableView.infiniteScrollingView stopAnimating];
        }
            break;
            
        default:
            break;
    }
}

//********************************************************************************//
#pragma mark -- Handle Music API

-(void)createDataSourceAllSongFrom:(NSDictionary *)aDictionary
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *nodeList = [dictData objectForKey:@"node_list"];
    
    if ([nodeList count] > 0) {
        
        //-- add objects
        for (NSInteger i = 0; i < [nodeList count]; i++)
        {
            MusicTrackNew *mTrack = [[MusicTrackNew alloc] init];
            
            mTrack.songRingbacktoneId = [[nodeList objectAtIndex:i] objectForKey:@"is_ringback_tone"];
            mTrack.nodeId = [[nodeList objectAtIndex:i] objectForKey:@"node_id"];
            mTrack.albumAuthorMusicId = [[nodeList objectAtIndex:i] objectForKey:@"album_author_music_id"];
            mTrack.albumDescription = [[nodeList objectAtIndex:i] objectForKey:@"album_description"];
            mTrack.albumEngName = [[nodeList objectAtIndex:i] objectForKey:@"album_english_name"];
            mTrack.albumId = [[nodeList objectAtIndex:i] objectForKey:@"album_id"];
            mTrack.albumIsHot = [[nodeList objectAtIndex:i] objectForKey:@"album_is_hot"];
            mTrack.albumMusicPublisherId = [[nodeList objectAtIndex:i] objectForKey:@"album_music_publisher_id"];
            mTrack.albumMusicType = [[nodeList objectAtIndex:i] objectForKey:@"album_music_type"];
            mTrack.albumName = [[nodeList objectAtIndex:i] objectForKey:@"album_name"];
            mTrack.albumPublishedYear = [[nodeList objectAtIndex:i] objectForKey:@"album_published_year"];
            mTrack.albumSetingTotalRating= [[nodeList objectAtIndex:i] objectForKey:@"setting_total_rating"];
            mTrack.albumSettingTotalView = [[nodeList objectAtIndex:i] objectForKey:@"album_setting_total_view"];
            mTrack.albumThumbImagePath = [[nodeList objectAtIndex:i] objectForKey:@"album_thumbnail_image_file_path"];
            mTrack.albumTotalTrack = [[nodeList objectAtIndex:i] objectForKey:@"album_total_track"];
            mTrack.albumTrueTotalRating = [[nodeList objectAtIndex:i] objectForKey:@"album_true_total_rating"];
            mTrack.albumTrueTotalView = [[nodeList objectAtIndex:i] objectForKey:@"album_true_total_view"];
            mTrack.content = [[nodeList objectAtIndex:i] objectForKey:@"content"];
            mTrack.countryId = [[nodeList objectAtIndex:i] objectForKey:@"country_id"];
            mTrack.engName = [[nodeList objectAtIndex:i] objectForKey:@"english_name"];
            mTrack.isHot = [[nodeList objectAtIndex:i] objectForKey:@"is_hot"];
            mTrack.musicPath = [[nodeList objectAtIndex:i] objectForKey:@"music_path"];
            mTrack.musicType = [[nodeList objectAtIndex:i] objectForKey:@"music_type"];
            mTrack.name = [[nodeList objectAtIndex:i] objectForKey:@"name"];
            mTrack.nodeId = [[nodeList objectAtIndex:i] objectForKey:@"node_id"];
            mTrack.numberOfTrack = [[nodeList objectAtIndex:i] objectForKey:@"number_of_track"];
            mTrack.settingTotalRating = [[nodeList objectAtIndex:i] objectForKey:@"setting_total_rating"];
            mTrack.settingTotalView = [[nodeList objectAtIndex:i] objectForKey:@"setting_total_view"];
            mTrack.thumbImagePath = [[nodeList objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
            mTrack.thumbImageType = [[nodeList objectAtIndex:i] objectForKey:@"thumbnail_image_type"];
            mTrack.translateContent = [[nodeList objectAtIndex:i] objectForKey:@"translated_content"];
            mTrack.trueTotalRating = [[nodeList objectAtIndex:i] objectForKey:@"true_total_rating"];
            mTrack.trueTotalView = [[nodeList objectAtIndex:i] objectForKey:@"true_total_view"];
            
            NSString *numberComment = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"sns_total_comment"]];
            NSString *numberLike = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"sns_total_like"]];
            NSString *isLiked = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"is_liked"]];
            mTrack.snsTotalDisLike = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_dislike"];
            mTrack.snsTotalShare = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_share"];
            mTrack.snsTotalView = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_view"];
            mTrack.snsTotalComment = numberComment;
            mTrack.snsTotalLike = numberLike;
            mTrack.isLiked = isLiked;
            
            MusicTrackNew *mTrackFromDB = [VMDataBase getATrackByNodeId:mTrack.nodeId];
            if (mTrackFromDB.nodeId) {
                
                //-- neu mTrackFromDB.snsTotalComment < mTrack.snsTotalComment thi update vao Db
                if ([mTrackFromDB.snsTotalComment integerValue] > [mTrack.snsTotalComment integerValue]) {
                    
                    mTrack.snsTotalComment = mTrackFromDB.snsTotalComment;
                }
                
                //-- neu mTrackFromDB.snsTotalLike < mTrack.snsTotalLike thi update vao Db
                if ([mTrackFromDB.snsTotalLike integerValue] > [mTrack.snsTotalLike integerValue]) {
                    
                    mTrack.snsTotalLike = mTrackFromDB.snsTotalLike;
                }
                
                //-- update a Track by nodeId
                [VMDataBase updateTrackByAlbum:mTrack];
                
            }else {
                
                //-- insert into DB
                [VMDataBase insertTrackByAlbum:mTrack];
            }
        }
        
        //-- reload tablview Music
        if (!listDataSource)
            listDataSource = [[NSMutableArray alloc] init];
        else
            [listDataSource removeAllObjects];
        
        //-- get all music
        listDataSource = [VMDataBase getAllTrackByAlbumId:nil];
        
        //-- get data result
        [self filterDataBySearchType];
    }
    
    //-- hidden loading
    [tableviewMusic.tableView.infiniteScrollingView stopAnimating];
}


//********************************************************************************//
#pragma mark -- Handle News API

-(void)createDataSourceForNewsFrom:(NSDictionary *)aDictionary
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrNews = [dictData objectForKey:@"node_list"];
    
    if ([arrNews count] > 0)
    {
        for (NSInteger i = 0; i < [arrNews count]; i++)
        {
            News *aNews                = [[News alloc] init];
            aNews.body                 = [[arrNews objectAtIndex:i] objectForKey:@"body"];
            aNews.createdDate          = [[arrNews objectAtIndex:i] objectForKey:@"created_date"];
            aNews.imageList            = [[arrNews objectAtIndex:i] objectForKey:@"image_list"];
            aNews.isHot                = [[[arrNews objectAtIndex:i] objectForKey:@"is_hot"] integerValue];
            aNews.lastUpdate           = [[arrNews objectAtIndex:i] objectForKey:@"last_update"];
            aNews.nodeId               = [[arrNews objectAtIndex:i] objectForKey:@"node_id"];
            aNews.order                = [[[arrNews objectAtIndex:i] objectForKey:@"order"] integerValue];
            aNews.settingTotalView     = [[[arrNews objectAtIndex:i] objectForKey:@"setting_total_view"] integerValue];
            aNews.shortBody            = [[arrNews objectAtIndex:i] objectForKey:@"short_body"];
            aNews.thumbnailImagePath   = [[arrNews objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
            aNews.thumbnailImageType   = [[arrNews objectAtIndex:i] objectForKey:@"thumbnail_image_type"];
            aNews.title                = [[arrNews objectAtIndex:i] objectForKey:@"title"];
            aNews.trueTotalView        = [[[arrNews objectAtIndex:i] objectForKey:@"true_total_view"] integerValue];
            aNews.snsTotalComment      = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_comment"] integerValue];
            aNews.snsTotalDislike      = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_dislike"] integerValue];
            aNews.snsTotalLike         = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_like"] integerValue];
            aNews.snsTotalShare        = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_share"] integerValue];
            aNews.snsTotalView         = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_view"] integerValue];
            aNews.isLiked              = [[[arrNews objectAtIndex:i] objectForKey:@"is_liked"] integerValue];
            
            //-- properties additional
            aNews.arrComments = [NSMutableArray new];
            aNews.url = @"";
            
            NSMutableArray *category_list = [[arrNews objectAtIndex:i] objectForKey:@"category_list"];
            if (category_list.count > 0) {
                aNews.categoryID = [category_list objectAtIndex:0];
            }
            
            //-- check existing
            News *newsFromDB = [VMDataBase getANewsByCategoryId:aNews.nodeId];
            
            if (newsFromDB.nodeId) {
                
                //-- neu mTrackFromDB.snsTotalComment < mTrack.snsTotalComment thi update vao Db
                if (newsFromDB.snsTotalComment > aNews.snsTotalComment) {
                    
                    aNews.snsTotalComment = newsFromDB.snsTotalComment;
                }
                
                //-- neu mTrackFromDB.snsTotalLike < mTrack.snsTotalLike thi update vao Db
                if (newsFromDB.snsTotalLike > aNews.snsTotalLike) {
                    
                    aNews.snsTotalLike = newsFromDB.snsTotalLike;
                }
                
                //-- update a Track by nodeId
                [VMDataBase updateWithNews:aNews];
                
            }else {
                //-- insert news into db
                [VMDataBase insertWithNews:aNews];
            }
        }
        
        //-- reload tablview News
        if (!listDataSource)
            listDataSource = [[NSMutableArray alloc] init];
        else
            [listDataSource removeAllObjects];
        
        //-- get all News
        listDataSource = [VMDataBase getAllNews];
        
        //-- get data result
        [self filterDataBySearchType];
    }
    
    //-- hidden loading
    [tableviewNews.tableView.infiniteScrollingView stopAnimating];
}


//********************************************************************************//
#pragma mark -- Handle Video API

-(void)createDataSourceForVideoFrom:(NSDictionary *)aDictionary
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrCategory = [dictData objectForKey:@"singer_list"];
    if ([arrCategory count] > 0)
    {
        NSDictionary *dictSinger = [arrCategory objectAtIndex:0];
        NSString *categoryId = [dictSinger objectForKey:@"category_id"];
        NSMutableArray *arrVideos = [dictSinger objectForKey:@"node_list"];
        
        if (videoTypeId == ContentTypeIDAllVideo) {
            
            //-- handle ContentTypeIDAllVideo
            [self handleContentTypeIDAllVideoWithListData:arrVideos];
            
        }else if (videoTypeId == ContentTypeIDVideo) {
            
            //-- handle ContentTypeIDVideo
            [self handleContentTypeIDVideoWithListData:arrVideos categoryId:categoryId];
            
        }else {
            
            //-- handle ContentTypeIDUnofficialVideo
            [self handleContentTypeIDUnofficialVideoWithListData:arrVideos categoryId:categoryId];
        }
    }
    
    //-- hidden loading
    [tableviewVideo.tableView.infiniteScrollingView stopAnimating];
}

//-- handle ContentTypeIDAllVideo
-(void) handleContentTypeIDAllVideoWithListData:(NSMutableArray *) arrVideos {
    
    if (arrVideos.count > 0) {
        
        for (NSInteger i = 0; i < [arrVideos count]; i++)
        {
            VideoAllModel *aVideo = [VideoAllModel new];
            
            aVideo.body = [[arrVideos objectAtIndex:i] objectForKey:@"body"];
            aVideo.cms_user_id = [[arrVideos objectAtIndex:i] objectForKey:@"cms_user_id"];
            aVideo.content_type_id = [[arrVideos objectAtIndex:i] objectForKey:@"content_type_id"];
            aVideo.created_date = [[arrVideos objectAtIndex:i] objectForKey:@"created_date"];
            aVideo.description = [[arrVideos objectAtIndex:i] objectForKey:@"description"];
            aVideo.last_update = [[arrVideos objectAtIndex:i] objectForKey:@"last_update"];
            aVideo.name = [[arrVideos objectAtIndex:i] objectForKey:@"name"];
            aVideo.node_id = [[arrVideos objectAtIndex:i] objectForKey:@"node_id"];
            aVideo.isHot = [[arrVideos objectAtIndex:i] objectForKey:@"isHot"];
            
            NSString *numberComment = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_comment"]];
            NSString *numberLike = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_like"]];
            NSString *numberView = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_view"]];
            NSString *isLiked = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"is_liked"]];
            aVideo.snsTotalDisLike = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_dislike"];
            aVideo.snsTotalShare = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_share"];
            aVideo.snsTotalComment = numberComment;
            aVideo.snsTotalLike = numberLike;
            aVideo.snsTotalView = numberView;
            aVideo.isLiked = isLiked;
            
            aVideo.thumbnail_image_file_path = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_file_path"];
            aVideo.thumbnail_image_file_type = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_file_type"];
            aVideo.video_file_path = [[arrVideos objectAtIndex:i] objectForKey:@"video_file_path"];
            aVideo.video_order = [[arrVideos objectAtIndex:i] objectForKey:@"video_order"];
            aVideo.youtube_url = [[arrVideos objectAtIndex:i] objectForKey:@"youtube_url"];
            
            //-- properties additional
            aVideo.numberOfLike = 0;
            aVideo.arrComments = [NSMutableArray new];
            aVideo.url = @"";
            
            VideoAllModel *aVideoFromDB = [VMDataBase getAVideosBynodeID:aVideo.node_id];
            if (aVideoFromDB.node_id) {
                
                //-- check update snsTotalComment to DB
                if ([aVideoFromDB.snsTotalComment integerValue] > [aVideo.snsTotalComment integerValue]) {
                    
                    aVideo.snsTotalComment = aVideoFromDB.snsTotalComment;
                }
                
                //-- check update snsTotalLike to DB
                if ([aVideoFromDB.snsTotalLike integerValue] > [aVideo.snsTotalLike integerValue]) {
                    
                    aVideo.snsTotalLike = aVideoFromDB.snsTotalLike;
                }
                
                //-- update video Official to DB
                [VMDataBase updateVideosOfTBVideoAll:aVideo];
                
            }else {
                
                //-- insert video Official to DB
                [VMDataBase insertVideosOfTBVideoAll:aVideo];
            }
        }
        
        //-- reload data
        if (!listDataSource)
            listDataSource = [[NSMutableArray alloc] init];
        else
            [listDataSource removeAllObjects];
        
        //-- get videos from DB
        NSString *contentTypeStr = [NSString stringWithFormat:@"%d",videoTypeId];
        
        if (videoTypeId == ContentTypeIDAllVideo)
            listDataSource = [VMDataBase getAllVideos];
        else if (videoTypeId == ContentTypeIDVideo)
            listDataSource = [VMDataBase getAllVideosOffiCialByCategoryId:contentTypeStr];
        else
            listDataSource = [VMDataBase getAllVideosUnOffiCialByCategoryId:contentTypeStr];
        
        //-- get data result
        [self filterDataBySearchType];
    }
}

//-- handle ContentTypeIDVideo
-(void) handleContentTypeIDVideoWithListData:(NSMutableArray *) arrVideos categoryId:(NSString *)categoryId {
    
    if (arrVideos.count > 0) {
        
        NSString *contentTypeStr = [NSString stringWithFormat:@"%d",videoTypeId];
        
        for (NSInteger i = 0; i < [arrVideos count]; i++)
        {
            VideoForAll *aVideo = [VideoForAll new];
            
            aVideo.categoryID = categoryId;
            aVideo.albumAuthorMusicId = [[arrVideos objectAtIndex:i] objectForKey:@"album_author_music_id"];
            aVideo.albumDescription = [[arrVideos objectAtIndex:i] objectForKey:@"album_description"];
            aVideo.albumEngName = [[arrVideos objectAtIndex:i] objectForKey:@"album_english_name"];
            aVideo.albumId = [[arrVideos objectAtIndex:i] objectForKey:@"album_id"];
            aVideo.albumIsHot = [[arrVideos objectAtIndex:i] objectForKey:@"album_is_hot"];
            aVideo.albumMusicPublisherId = [[arrVideos objectAtIndex:i] objectForKey:@"album_music_publisher_id"];
            aVideo.albumMusicType = [[arrVideos objectAtIndex:i] objectForKey:@"album_music_type"];
            aVideo.albumName = [[arrVideos objectAtIndex:i] objectForKey:@"album_name"];
            aVideo.albumPublishedYear = [[arrVideos objectAtIndex:i] objectForKey:@"album_published_year"];
            aVideo.albumSetingTotalRating = [[arrVideos objectAtIndex:i] objectForKey:@"album_setting_total_rating"];
            aVideo.albumSettingTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"album_setting_total_view"];
            aVideo.albumThumbImagePath = [[arrVideos objectAtIndex:i] objectForKey:@"album_thumbnail_image_file_path"];
            aVideo.albumTotalTrack = [[arrVideos objectAtIndex:i] objectForKey:@"album_total_track"];
            aVideo.albumTrueTotalRating = [[arrVideos objectAtIndex:i] objectForKey:@"album_true_total_rating"];
            aVideo.albumTrueTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"album_true_total_view"];
            aVideo.categoryList = [[arrVideos objectAtIndex:i] objectForKey:@"category_list"];
            aVideo.content = [[arrVideos objectAtIndex:i] objectForKey:@"content"];
            aVideo.countryId = [[arrVideos objectAtIndex:i] objectForKey:@"country_id"];
            aVideo.engName = [[arrVideos objectAtIndex:i] objectForKey:@"english_name"];
            aVideo.isHot = [[arrVideos objectAtIndex:i] objectForKey:@"is_hot"];
            aVideo.musicPath = [[arrVideos objectAtIndex:i] objectForKey:@"music_path"];
            aVideo.musicType = [[arrVideos objectAtIndex:i] objectForKey:@"music_type"];
            aVideo.name = [[arrVideos objectAtIndex:i] objectForKey:@"name"];
            aVideo.nodeId = [[arrVideos objectAtIndex:i] objectForKey:@"node_id"];
            aVideo.numberOfTrack = [[arrVideos objectAtIndex:i] objectForKey:@"number_of_track"];
            aVideo.settingTotalRating = [[arrVideos objectAtIndex:i] objectForKey:@"setting_total_rating"];
            aVideo.settingTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"setting_total_view"];
            aVideo.thumbImagePath = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
            aVideo.thumbImageType = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_type"];
            aVideo.translateContent = [[arrVideos objectAtIndex:i] objectForKey:@"translated_content"];
            aVideo.trueTotalRating = [[arrVideos objectAtIndex:i] objectForKey:@"true_total_rating"];
            aVideo.trueTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"true_total_view"];
            aVideo.youtubeUrl = [[arrVideos objectAtIndex:i] objectForKey:@"youtube_url"];
            
            NSString *numberComment = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_comment"]];
            NSString *numberLike = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_like"]];
            NSString *numberView = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_view"]];
            NSString *isLiked = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"is_liked"]];
            aVideo.snsTotalDisLike = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_dislike"];
            aVideo.snsTotalShare = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_share"];
            aVideo.snsTotalComment = numberComment;
            aVideo.snsTotalLike = numberLike;
            aVideo.snsTotalView = numberView;
            aVideo.isLiked = isLiked;
            
            //-- properties additional
            aVideo.numberOfLike = 0;
            aVideo.arrComments = [NSMutableArray new];
            aVideo.url = @"";
            
            
            VideoForAll *aVideoFromDB = [VMDataBase getAVideosOffiCialByNodeId:aVideo.nodeId categoryId:categoryId];
            if (aVideoFromDB.nodeId) {
                
                //-- check update snsTotalComment to DB
                if ([aVideoFromDB.snsTotalComment integerValue] > [aVideo.snsTotalComment integerValue]) {
                    
                    aVideo.snsTotalComment = aVideoFromDB.snsTotalComment;
                }
                
                //-- check update snsTotalLike to DB
                if ([aVideoFromDB.snsTotalLike integerValue] > [aVideo.snsTotalLike integerValue]) {
                    
                    aVideo.snsTotalLike = aVideoFromDB.snsTotalLike;
                }
                
                //-- update video Official to DB
                [VMDataBase updateVideosOffiCial:aVideo];
                
            }else {
                
                //-- insert video Official to DB
                [VMDataBase insertVideosOffiCial:aVideo];
            }
        }
        
        //-- reload data
        if (!listDataSource)
            listDataSource = [[NSMutableArray alloc] init];
        else
            [listDataSource removeAllObjects];
        
        //-- get videos from DB
        if (videoTypeId == ContentTypeIDAllVideo)
            listDataSource = [VMDataBase getAllVideos];
        else if (videoTypeId == ContentTypeIDVideo)
            listDataSource = [VMDataBase getAllVideosOffiCialByCategoryId:contentTypeStr];
        else
            listDataSource = [VMDataBase getAllVideosUnOffiCialByCategoryId:contentTypeStr];
        
        //-- get data result
        [self filterDataBySearchType];
    }
}

//-- handle ContentTypeIDUnofficialVideo
-(void) handleContentTypeIDUnofficialVideoWithListData:(NSMutableArray *) arrVideos categoryId:(NSString *)categoryId {
    
    if (arrVideos.count > 0) {
        
        NSString *contentTypeStr = [NSString stringWithFormat:@"%d",videoTypeId];
        
        for (NSInteger i = 0; i < [arrVideos count]; i++)
        {
            VideoForCategory *aVideo = [VideoForCategory new];
            
            aVideo.categoryID = categoryId;
            aVideo.body = [[arrVideos objectAtIndex:i] objectForKey:@"body"];
            aVideo.countryID = [[arrVideos objectAtIndex:i] objectForKey:@"country_id"];
            aVideo.isHot = [[arrVideos objectAtIndex:i] objectForKey:@"is_hot"];
            aVideo.nodeID = [[arrVideos objectAtIndex:i] objectForKey:@"node_id"];
            aVideo.orderVideo = [[arrVideos objectAtIndex:i] objectForKey:@"order"];
            aVideo.settingTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"setting_total_view"];
            aVideo.shortBody = [[arrVideos objectAtIndex:i] objectForKey:@"short_body"];
            aVideo.thumbnailImagePath = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
            aVideo.title = [[arrVideos objectAtIndex:i] objectForKey:@"title"];
            aVideo.trueTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"true_total_view"];
            aVideo.videoFacebookPath = [[arrVideos objectAtIndex:i] objectForKey:@"video_facebook_path"];
            aVideo.videoFilePath = [[arrVideos objectAtIndex:i] objectForKey:@"video_file_path"];
            aVideo.videoYoutubePath = [[arrVideos objectAtIndex:i] objectForKey:@"video_youtube_path"];
            aVideo.youtubeUrl = [[arrVideos objectAtIndex:i] objectForKey:@"youtube_url"];
            
            NSString *numberComment = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_comment"]];
            NSString *numberLike = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_like"]];
            NSString *numberView = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_view"]];
            NSString *isLiked = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"is_liked"]];
            aVideo.snsTotalDisLike = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_dislike"];
            aVideo.snsTotalShare = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_share"];
            aVideo.snsTotalView = numberView;
            aVideo.snsTotalComment = numberComment;
            aVideo.snsTotalLike = numberLike;
            aVideo.isLiked = isLiked;
            
            //-- properties additional
            aVideo.numberOfLike = 0;
            aVideo.arrComments = [NSMutableArray new];
            aVideo.url = @"";
            
            VideoForCategory *aVideoFromDB = [VMDataBase getAVideosUnOffiCialBynodeID:aVideo.nodeID categoryId:categoryId];
            if (aVideoFromDB.nodeID) {
                
                //-- check update snsTotalComment to DB
                if ([aVideoFromDB.snsTotalComment integerValue] > [aVideo.snsTotalComment integerValue]) {
                    
                    aVideo.snsTotalComment = aVideoFromDB.snsTotalComment;
                }
                
                //-- check update snsTotalLike to DB
                if ([aVideoFromDB.snsTotalLike integerValue] > [aVideo.snsTotalLike integerValue]) {
                    
                    aVideo.snsTotalLike = aVideoFromDB.snsTotalLike;
                }
                
                //-- update video UnOfficial to DB
                [VMDataBase updateVideosUnOffiCial:aVideo];
                
            }else {
                
                //-- insert video Official to DB
                [VMDataBase insertVideosUnOffiCial:aVideo];
            }
        }
        
        //-- reload data
        if (!listDataSource)
            listDataSource = [[NSMutableArray alloc] init];
        else
            [listDataSource removeAllObjects];
        
        //-- get videos from DB
        if (videoTypeId == ContentTypeIDAllVideo)
            listDataSource = [VMDataBase getAllVideos];
        else if (videoTypeId == ContentTypeIDVideo)
            listDataSource = [VMDataBase getAllVideosOffiCialByCategoryId:contentTypeStr];
        else
            listDataSource = [VMDataBase getAllVideosUnOffiCialByCategoryId:contentTypeStr];
        
        //-- get data result
        [self filterDataBySearchType];
    }
}

//********************************************************************************//
#pragma mark -- Handle Schedule API

-(void)createDataSourceForScheduleFrom:(NSDictionary *)aDictionary
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *nodeList = [dictData objectForKey:@"node_list"];
    
    if ([nodeList count] > 0) {
        
        //-- add objects
        for (NSInteger i = 0; i < [nodeList count]; i++)
        {
            Schedule *schedule = [[Schedule alloc] init];
            
            schedule.categoryId = @"1";
            schedule.nodeId = [[nodeList objectAtIndex:i] objectForKey:@"node_id"];
            schedule.name = [[nodeList objectAtIndex:i] objectForKey:@"name"];
            schedule.imageFilePath = [[nodeList objectAtIndex:i] objectForKey:@"image_file_path"];
            schedule.videoFilePath = [[nodeList objectAtIndex:i] objectForKey:@"video_file_path"];
            schedule.startDate = [[nodeList objectAtIndex:i] objectForKey:@"start_date"];
            schedule.endDate = [[nodeList objectAtIndex:i] objectForKey:@"end_date"];
            schedule.desciption = [[nodeList objectAtIndex:i] objectForKey:@"description"];
            schedule.price = [[nodeList objectAtIndex:i] objectForKey:@"price"];
            schedule.phone = [[nodeList objectAtIndex:i] objectForKey:@"phone"];
            schedule.orderSchedule = [[nodeList objectAtIndex:i] objectForKey:@"order"];
            schedule.organizationUnitName = [[nodeList objectAtIndex:i] objectForKey:@"organization_unit_name"];
            schedule.countryId = [[nodeList objectAtIndex:i] objectForKey:@"country_id"];
            schedule.countryName= [[nodeList objectAtIndex:i] objectForKey:@"country_name"];
            schedule.cityId = [[nodeList objectAtIndex:i] objectForKey:@"city_id"];
            schedule.cityName = [[nodeList objectAtIndex:i] objectForKey:@"city_name"];
            schedule.cityLogoFilePath = [[nodeList objectAtIndex:i] objectForKey:@"city_logo_file_path"];
            schedule.cityDescription = [[nodeList objectAtIndex:i] objectForKey:@"city_description"];
            schedule.locationEventId = [[nodeList objectAtIndex:i] objectForKey:@"location_event_id"];
            schedule.locationEventName = [[nodeList objectAtIndex:i] objectForKey:@"location_event_name"];
            schedule.locationEventAddress = [[nodeList objectAtIndex:i] objectForKey:@"location_event_address"];
            schedule.locationEventPhone = [[nodeList objectAtIndex:i] objectForKey:@"location_event_phone"];
            schedule.locationEventEmail = [[nodeList objectAtIndex:i] objectForKey:@"location_event_name_email"];
            schedule.locationEventWebsite = [[nodeList objectAtIndex:i] objectForKey:@"location_event_website"];
            schedule.listSinger = [[nodeList objectAtIndex:i] objectForKey:@"list_singer"];
            schedule.snsTotalDisLike = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_dislike"];
            schedule.snsTotalShare = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_share"];
            schedule.snsTotalView = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_view"];
            
            NSString *numberComment = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"sns_total_comment"]];
            NSString *numberLike = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"sns_total_like"]];
            NSString *isLiked = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"is_liked"]];
            schedule.snsTotalComment = numberComment;
            schedule.snsTotalLike = numberLike;
            schedule.isLiked = isLiked;
            
            //-- get list singer nick_name
            NSMutableArray *listSinger = [[NSMutableArray alloc] init];
            NSMutableArray *listData = [[nodeList objectAtIndex:i] objectForKey:@"list_singer"];
            
            for (NSInteger j=0; j<[listData count]; j++) {
                NSString *nameSinger = [[listData objectAtIndex:j] objectForKey:@"nick_name"];
                
                [listSinger addObject:nameSinger];
            }
            
            NSArray *arrSinger = [listSinger mutableCopy];
            schedule.listSinger = [arrSinger componentsJoinedByString:@", "];
            
            Schedule *aSchel = [VMDataBase getAScheduleByNodeId:schedule.nodeId];
            
            if (aSchel.nodeId) {
                
                //-- neu mTrackFromDB.snsTotalComment > mTrack.snsTotalComment thi update vao Db
                if ([aSchel.snsTotalComment integerValue] > [schedule.snsTotalComment integerValue]) {
                    
                    schedule.snsTotalComment = aSchel.snsTotalComment;
                }
                
                //-- neu mTrackFromDB.snsTotalLike > mTrack.snsTotalLike thi update vao Db
                if ([aSchel.snsTotalLike integerValue] > [schedule.snsTotalLike integerValue]) {
                    
                    schedule.snsTotalLike = aSchel.snsTotalLike;
                }
                
                //-- update a Schedule
                [VMDataBase updateSchedule:schedule];
                
            }else {
                //-- insert into DB
                [VMDataBase insertSchedule:schedule];
            }
        }
        
        //-- reload tablview News
        if (!listDataSource)
            listDataSource = [[NSMutableArray alloc] init];
        else
            [listDataSource removeAllObjects];
        
        //-- get all Schedule
        listDataSource = [VMDataBase getAllScheduleByCategoryid:nil];
        
        //-- get data result
        [self filterDataBySearchType];
    }
    
    //-- hidden loading
    [tableviewSchedule.tableView.infiniteScrollingView stopAnimating];
}


//********************************************************************************//
#pragma mark -- Handle Store API

-(void)createDataSourceForStoreFrom:(NSDictionary *)aDictionary
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrStore = [dictData objectForKey:@"node_list"];
    
    if ([arrStore count] > 0)
    {
        for (NSInteger i = 0; i < [arrStore count]; i++)
        {
            Store *aStore = [Store new];
            
            aStore.body                 = [[arrStore objectAtIndex:i] objectForKey:@"body"];
            aStore.cmsUserId            = [[arrStore objectAtIndex:i] objectForKey:@"cms_user_id"];
            aStore.code                 = [[arrStore objectAtIndex:i] objectForKey:@"code"];
            aStore.contentProviderId    = [[arrStore objectAtIndex:i] objectForKey:@"content_provider_id"];
            aStore.createdDate          = [[arrStore objectAtIndex:i] objectForKey:@"created_date"];
            aStore.idStore              = [[arrStore objectAtIndex:i] objectForKey:@"id"];
            aStore.isHot                = [[arrStore objectAtIndex:i] objectForKey:@"is_hot"];
            aStore.lastUpdate           = [[arrStore objectAtIndex:i] objectForKey:@"last_update"];
            aStore.name                 = [[arrStore objectAtIndex:i] objectForKey:@"name"];
            aStore.orderStore           = [[arrStore objectAtIndex:i] objectForKey:@"order"];
            aStore.phone                = [[arrStore objectAtIndex:i] objectForKey:@"phone"];
            aStore.priceUnit            = [[arrStore objectAtIndex:i] objectForKey:@"price_unit"];
            aStore.settingTotalView     = [[arrStore objectAtIndex:i] objectForKey:@"setting_total_view"];
            aStore.shortBody            = [[arrStore objectAtIndex:i] objectForKey:@"short_body"];
            aStore.snsTotalComment      = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_comment"];
            aStore.snsTotalDislike      = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_dislike"];
            aStore.snsTotalLike         = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_like"];
            aStore.snsTotalShare        = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_share"];
            aStore.snsTotalView         = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_view"];
            aStore.thumbnailImagePath   = [[arrStore objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
            aStore.thumbnailImageType   = [[arrStore objectAtIndex:i] objectForKey:@"thumbnail_image_type"];
            aStore.trueTotalView        = [[arrStore objectAtIndex:i] objectForKey:@"true_total_view"];
            aStore.categoryID           = CATEGORY_ID_STORE_ALL;
            
            //-- insert into db
            [VMDataBase insertWithStore:aStore];
        }
        
        //-- reload tablview News
        if (!listDataSource)
            listDataSource = [[NSMutableArray alloc] init];
        else
            [listDataSource removeAllObjects];
        
        //-- get all Store
        listDataSource = [VMDataBase getAllStoreWithCategoryID:CATEGORY_ID_STORE_ALL];
        
        //-- get data result
        [self filterDataBySearchType];
    }
    
    //-- hidden loading
    [tableviewStore.tableView.infiniteScrollingView stopAnimating];
}


//********************************************************************************//
#pragma mark -- Handle TopUser API

-(void)createDataSourceForTopUserFrom:(NSDictionary *)aDictionary
{
    NSMutableArray *arrayTopUser = [aDictionary objectForKey:@"user_list"];
    
    if (arrayTopUser.count > 0) {
        
        //-- remove all user
        if (!listDataSource)
            listDataSource = [[NSMutableArray alloc] init];
        else
            [listDataSource removeAllObjects];
        
        for (NSInteger i = 0; i < [arrayTopUser count]; i++)
        {
            TopUser *topUser = [[TopUser alloc] init];
            
            topUser.birthday = [[arrayTopUser objectAtIndex:i] objectForKey:@"birthday"];
            topUser.birthdaySearch = [[arrayTopUser objectAtIndex:i] objectForKey:@"birthday_search"];
            topUser.countryIso = [[arrayTopUser objectAtIndex:i] objectForKey:@"country_iso"];
            topUser.dstCheck = [[arrayTopUser objectAtIndex:i] objectForKey:@"dst_check"];
            topUser.email = [[arrayTopUser objectAtIndex:i] objectForKey:@"email"];
            topUser.feedSort = [[arrayTopUser objectAtIndex:i] objectForKey:@"feed_sort"];
            topUser.footerBar = [[arrayTopUser objectAtIndex:i] objectForKey:@"footer_bar"];
            topUser.fullName = [[arrayTopUser objectAtIndex:i] objectForKey:@"full_name"];
            topUser.gender = [[arrayTopUser objectAtIndex:i] objectForKey:@"gender"];
            topUser.hideTip = [[arrayTopUser objectAtIndex:i] objectForKey:@"hide_tip"];
            topUser.imBeep = [[arrayTopUser objectAtIndex:i] objectForKey:@"im_beep"];
            topUser.imHide = [[arrayTopUser objectAtIndex:i] objectForKey:@"im_hide"];
            topUser.inviteUserId= [[arrayTopUser objectAtIndex:i] objectForKey:@"invite_user_id"];
            topUser.isInvisible = [[arrayTopUser objectAtIndex:i] objectForKey:@"is_invisible"];
            topUser.joined = [[arrayTopUser objectAtIndex:i] objectForKey:@"joined"];
            topUser.languageId = [[arrayTopUser objectAtIndex:i] objectForKey:@"language_id"];
            topUser.lastActivity = [[arrayTopUser objectAtIndex:i] objectForKey:@"last_activity"];
            topUser.lastIpAddress = [[arrayTopUser objectAtIndex:i] objectForKey:@"last_ip_address"];
            topUser.lastLogin = [[arrayTopUser objectAtIndex:i] objectForKey:@"last_login"];
            topUser.point = [[arrayTopUser objectAtIndex:i] objectForKey:@"point"];
            topUser.profilePageId = [[arrayTopUser objectAtIndex:i] objectForKey:@"profile_page_id"];
            topUser.serverId = [[arrayTopUser objectAtIndex:i] objectForKey:@"server_id"];
            topUser.status = [[arrayTopUser objectAtIndex:i] objectForKey:@"status"];
            topUser.statusId = [[arrayTopUser objectAtIndex:i] objectForKey:@"status_id"];
            topUser.styleId = [[arrayTopUser objectAtIndex:i] objectForKey:@"style_id"];
            topUser.timeZone = [[arrayTopUser objectAtIndex:i] objectForKey:@"time_zone"];
            topUser.totalSpam = [[arrayTopUser objectAtIndex:i] objectForKey:@"total_spam"];
            topUser.userGroupId = [[arrayTopUser objectAtIndex:i] objectForKey:@"user_group_id"];
            topUser.userId = [[arrayTopUser objectAtIndex:i] objectForKey:@"user_id"];
            topUser.userImage = [[arrayTopUser objectAtIndex:i] objectForKey:@"user_image"];
            topUser.userName = [[arrayTopUser objectAtIndex:i] objectForKey:@"user_name"];
            topUser.viewId = [[arrayTopUser objectAtIndex:i] objectForKey:@"view_id"];
            topUser.categoryId = [NSString stringWithFormat:@"0"];
            
            //-- add object
            [listDataSource addObject:topUser];
        }
        
        //-- get data result
        [self filterDataBySearchType];
    }
    
    //-- hidden loading
    [tableviewTopUser.tableView.infiniteScrollingView stopAnimating];
}

@end
