//
//  FanZoneViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "FanZoneViewController.h"

@interface FanZoneViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

static FanZoneViewController *sharedFanZoneViewController = nil;

@implementation FanZoneViewController

@synthesize shoutboxDataArray;
@synthesize delegateFanZone;
@synthesize pageViews = _pageViews;
@synthesize _currentIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Main

- (void)viewDidLoad
{
    NSLog(@"%s", __func__);
    [super viewDidLoad];
	//-- Do any additional setup after loading the view.
    
    //-- set delegate from BaseVC
    [self setDelegateBaseController:self];
    
    //-- set view when did load
    [self setViewWhenViewDidLoad];
    
    //-- set data when did load
    [self setDataWhenViewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
    
    self.screenName = @"Fanzone Screen";
}

- (void)setViewWhenViewDidLoad
{
    NSLog(@"%s", __func__);
    //-- custom navigation bar
    [self customNavigationBar];
    
    //-- set background for view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    //-- size for scroll
    if (isIphone5)
        [UIView view:_scrollViewHomeFanZone setHeight:417];
    else
        [UIView view:_scrollViewHomeFanZone setHeight:329];
}


- (void)setDataWhenViewDidLoad
{
    NSLog(@"%s", __func__);
    //--alloc
    self.shoutboxDataArray  = [[NSMutableArray alloc] init];
    _dataMessagesHistory    = [NSMutableArray new];
    
    _countMessageLocal = 0;
    _isReadCacheMessage = YES;
    _isAutoScroll = YES;
    _isCallApi = NO;
    _isClickComment = NO;
    _arrCategories = [[NSMutableArray alloc] initWithObjects:@"Hôm nay",@"Tuần trước", @"2 tuần trước", nil];
    _arrTableviews = [NSMutableArray new];
    
    if (!_currentIndex) {
        _currentIndex = 0;
    }
    
    //-- create segments
    [self setTopMenuWithTitles:_arrCategories];
    
    [self createPageScrollNews:_arrCategories.count];
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    [super viewDidAppear:animated];
    
    //-- refresh Fanzone
    [self callRefreshFanzoneByRefreshTimeSetting];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"%s", __func__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-- refresh Fanzone
-(void) callRefreshFanzoneByRefreshTimeSetting {
    NSLog(@"%s", __func__);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger refreshTime = 60;
    if ([userDefaults valueForKey:Key_Refresh_Time]) {
        refreshTime = [[userDefaults valueForKey:Key_Refresh_Time] integerValue];
    }
    //longnh
    if ([userDefaults valueForKey:Key_Refresh_Now]) {
        refreshTime = 0;
        [userDefaults removeObjectForKey:Key_Refresh_Now];
        [userDefaults synchronize];
    }
    
//    if (![_timer isValid])
    if (_timer && [_timer isValid])
        [_timer invalidate];

    _timer = [NSTimer scheduledTimerWithTimeInterval:refreshTime target:self selector:@selector(getListComments) userInfo:nil repeats:NO];
}

#pragma mark - Set up scrollview

//-- create page scroll
-(void) createPageScrollNews:(NSInteger)numberViews
{
    NSLog(@"%s", __func__);
    _scrollViewHomeFanZone.contentSize = CGSizeMake(_scrollViewHomeFanZone.frame.size.width * numberViews, _scrollViewHomeFanZone.frame.size.height);
    _scrollViewHomeFanZone.showsHorizontalScrollIndicator = NO;
    _scrollViewHomeFanZone.showsVerticalScrollIndicator = NO;
    _scrollViewHomeFanZone.alwaysBounceVertical = NO;
    _scrollViewHomeFanZone.pagingEnabled = YES;
    _scrollViewHomeFanZone.scrollsToTop = NO;
    
    //-- Set up the array to hold the views for each page
    _pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < numberViews; ++i) {
        
        [self.pageViews addObject:[NSNull null]];
    }
    
    //-- Set the scroll view's content size, autoscroll to the stating tableview
    [self setScrollViewContentSize:numberViews];
    
    [self setCurrentIndex:_currentIndex];
    
    [self scrollToIndex:_currentIndex];
}


-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = _scrollViewHomeFanZone.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [_scrollViewHomeFanZone scrollRectToVisible:frame animated:NO];
}


- (void)setScrollViewContentSize:(NSInteger)numberViews
{
    NSInteger pageCount = numberViews;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(_scrollViewHomeFanZone.frame.size.width * pageCount,
                             _scrollViewHomeFanZone.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [_scrollViewHomeFanZone setContentSize:size];
}


- (void)setCurrentIndex:(NSInteger)newIndex
{
    _currentIndex = newIndex;
    
    //-- change segmanet
    [_controlMenuTop setSelectedSegmentIndex:_currentIndex];
    
    //-- get data
    [self fetchingData];
}


#pragma  mark - UI

-(void)customNavigationBar
{
    NSLog(@"%s", __func__);
    [self setTitle:@"Fanzone"];
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    //-- back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(clickToBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- comment button
    UIButton *btnRComment= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRComment.frame= CGRectMake(15, 0, 30, 30);
    [btnRComment setImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
    [btnRComment addTarget:self action:@selector(clickToBtnCreateComment:) forControlEvents:UIControlEventTouchUpInside];
    
    //-- refresh button
    UIButton *btnRRefresh= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRRefresh.frame= CGRectMake(15, 0, 30, 30);
    [btnRRefresh setImage:[UIImage imageNamed:@"btn_refresh.png"] forState:UIControlStateNormal];
    [btnRRefresh addTarget:self action:@selector(clickToBtnRefresh:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItemComment = [[UIBarButtonItem alloc] initWithCustomView:btnRComment];
    UIBarButtonItem *barItemRefresh = [[UIBarButtonItem alloc] initWithCustomView:btnRRefresh];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barItemRefresh,barItemComment, nil];
}



#pragma mark - Action

- (void)clickToBtnBack:(id)sender
{
    //-- stop timer
    if (_timer && [_timer isValid])
        [_timer invalidate];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


- (void)clickToBtnRefresh:(id)sender
{
    if (_currentIndex == 0) { // tab home
        
        _isCallApi = YES;
        [self apiGetShoutboxData:[self unixTimeForStartTimeToday] endTime:[[NSDate date] timeIntervalSince1970] withIndex:0];
    }
}


-(void) refreshData:(ODRefreshControl *) refresh
{
    NSLog(@"%s", __func__);
    [refresh beginRefreshing];
    [self fetchingData];
    [refresh endRefreshing];
}


- (void) addRefreshAndLoadMoreForTableView:(UITableView *)aTableview withIndex:(NSInteger)index
{
    NSLog(@"%s", __func__);
    //-- refresh data
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:aTableview];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    
//    //-- load more from bottom
//    __weak FanZoneViewController *myself = self;
//    
//    //  -- setup infinite scrolling
//    [aTableview addInfiniteScrollingWithActionHandler:^{
//        
//        [myself loadMoreFanzoneAtIndex:0 atStartTime:startTime endTime:endTime];
//    }];
}


-(void)loadMoreFanzoneAtIndex:(NSInteger)index atStartTime:(NSInteger)startTime endTime:(NSInteger)endTime
{
    NSLog(@"%s", __func__);
    _isCallApi = YES;
    [self apiGetShoutboxData:startTime endTime:endTime withIndex:0];
}



#pragma mark - API

-(void)getListComments
{
    NSLog(@"%s", __func__);
    _isCallApi = YES;
    [self apiGetShoutboxData:[self unixTimeForStartTimeToday] endTime:[[NSDate date] timeIntervalSince1970] withIndex:0];
}

- (void)fetchingData
{
    NSLog(@"%s", __func__);
    //-- remove objects
    [_dataMessagesHistory removeAllObjects];
    
    switch (_currentIndex) {
        case 0: { // tab home
            
                    _isCallApi = YES;
                    [self apiGetShoutboxData:[self unixTimeForStartTimeToday] endTime:[[NSDate date] timeIntervalSince1970] withIndex:_currentIndex];
        }
            break;
            
        case 1: { //- ago 1 week
            
                //-- call api get data
                [self fetchingMessagesWithStartTime:[self unixTimeAgoWeek:1] endTime:[self unixTimeForStartTimeToday] withIndex:_currentIndex];
        }
            break;
            
        case 2:{ //-- ago 2 week
            
                //-- call api get data
                [self fetchingMessagesWithStartTime:[self unixTimeAgoWeek:2] endTime:[self unixTimeAgoWeek:1] withIndex:_currentIndex];
        }
            break;
            
        default:
            break;
    }
}


-(void) getDataMessagesHistoryByStartTime:(NSInteger)startTime endTime:(NSInteger)endTime withIndex:(NSInteger) byIndex
{
    NSLog(@"%s", __func__);
    //-- remove
    [_dataMessagesHistory removeAllObjects];
    
    _dataMessagesHistory = [VMDataBase getAllMessagesFanZoneWithStartTime:startTime endTime:endTime];
    
    if ([_dataMessagesHistory count] > 0)
    {
        //-- save time last
        Comment *sbInfo = (Comment *)[_dataMessagesHistory firstObject];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",[sbInfo.timeStamp integerValue]+1] forKey:kTimeStamp];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    id currentTableView = [self.pageViews objectAtIndex:byIndex];
    
    if (NO == [currentTableView isKindOfClass:[TableFanZoneViewController class]]) {
        
        //-- Load the photo view.
        CGRect frame = _scrollViewHomeFanZone.bounds;
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        self.tableviewFanzone = [[TableFanZoneViewController alloc] init];
        self.tableviewFanzone.delegate = self;
        self.tableviewFanzone.view.backgroundColor = [UIColor clearColor];
        [self.tableviewFanzone.view setFrame:frame];
        [self.tableviewFanzone.view setTag:byIndex];
        
        self.tableviewFanzone.listShoutbox  = _dataMessagesHistory;
        
        [_scrollViewHomeFanZone addSubview:self.tableviewFanzone.view];
        [self.pageViews replaceObjectAtIndex:byIndex withObject:self.tableviewFanzone];
        
        [self.tableviewFanzone.tableView scrollsToTop];
        
    }else {
        
        self.tableviewFanzone = (TableFanZoneViewController *) currentTableView;
        self.tableviewFanzone.listShoutbox  = _dataMessagesHistory;
        
        [self.tableviewFanzone.tableView reloadData];
        [self.tableviewFanzone.tableView scrollsToTop];
    }
    
    /*
     * Shoot latest message to music control. send total 5 messages
     * Pass data to Slidebar Bottom
     */
    [self shootLastestMessage];
}

- (void)apiGetShoutboxData:(NSInteger)startTime endTime:(NSInteger)endTime withIndex:(NSInteger) byIndex
{
    NSLog(@"%s", __func__);
    //-- fetching data
    if ([self.shoutboxDataArray count] == 0 && _isReadCacheMessage)
    {
        self.shoutboxDataArray = [VMDataBase getAllMessagesFanZoneWithStartTime:startTime endTime:endTime];
        
        if ([self.shoutboxDataArray count] > 0)
        {
            //-- save time last
            Comment *sbInfo = (Comment *)[self.shoutboxDataArray firstObject];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",[sbInfo.timeStamp integerValue]+1] forKey:kTimeStamp];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //-- check and add tableview fanzone
            id currentTableView = [self.pageViews objectAtIndex:byIndex];
            
            if (NO == [currentTableView isKindOfClass:[TableFanZoneViewController class]]) {
                
                //-- Load the photo view.
                CGRect frame = _scrollViewHomeFanZone.bounds;
                frame.origin.x = frame.size.width * byIndex;
                frame.origin.y = 0.0f;
                frame = CGRectInset(frame, 0.0f, 0.0f);
                
                self.tableviewFanzone = [[TableFanZoneViewController alloc] init];
                self.tableviewFanzone.delegate = self;
                self.tableviewFanzone.view.backgroundColor = [UIColor clearColor];
                [self.tableviewFanzone.view setFrame:frame];
                [self.tableviewFanzone.view setTag:byIndex];
                
                //-- add Refresh to tableview
                [self addRefreshAndLoadMoreForTableView:self.tableviewFanzone.tableView withIndex:byIndex];
                
                self.tableviewFanzone.listShoutbox  = self.shoutboxDataArray;
                
                [_scrollViewHomeFanZone addSubview:self.tableviewFanzone.view];
                [self.pageViews replaceObjectAtIndex:byIndex withObject:self.tableviewFanzone];
                
                [self.tableviewFanzone.tableView scrollsToTop];
                
            }else {
                
                self.tableviewFanzone = (TableFanZoneViewController *) currentTableView;
                self.tableviewFanzone.listShoutbox  = self.shoutboxDataArray;
                
                [self.tableviewFanzone.tableView reloadData];
                [self.tableviewFanzone.tableView scrollsToTop];
            }
            
             _isReadCacheMessage = NO;
        }
        
        /*
         * Shoot latest message to music control. send total 5 messages
         * Pass data to Slidebar Bottom
         */
        [self shootLastestMessage];
        
        //-- get tableview All Video in scrollview
        if (_scrollViewHomeFanZone.subviews.count > 0) {
            
            for (UITableView *viewTB in _scrollViewHomeFanZone.subviews) {
                
                if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                    
                    //-- hidden loading
                    [viewTB.infiniteScrollingView stopAnimating];
                    
                    break;
                }
            }
        }
    }
    
    if (([self.shoutboxDataArray count] == 0 || _isCallApi))
    {
        //-- check Network
        BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
        if (!isErrorNetWork) return;
        
        //-- show network activity
        [NetworkActivity show];
        [_activityIndicator startAnimating];
        
        NSString *timeS = @"";
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"firstRun"])//-- neu chay tu lan thu 2
            timeS = [[NSUserDefaults standardUserDefaults] valueForKey:kTimeStamp];
        else //-- chay lan dau
            timeS = [NSString stringWithFormat:@"%d",[self unixTimeForStartTimeToday]];
        
        
        [API getDataShoutBox:SINGER_ID
                       limit:@"100"
                   startTime:timeS
                     endTime:@""
                       appId:PRODUCTION_ID
                  appVersion:PRODUCTION_VERSION
                   completed:^(NSDictionary *responseDictionary, NSError *error) {
            
                       [self createDatasourceShoutData:responseDictionary withIndex:byIndex];
                       
                       //-- hidden network activity
                       [NetworkActivity hide];
                       [_activityIndicator stopAnimating];
        }];
    }
}


- (void)createDatasourceShoutData:(NSDictionary *)aDict withIndex:(NSInteger) byIndex
{
    NSLog(@"%s", __func__);
    NSMutableArray *arrTmp = [aDict objectForKey:@"data"];
    
    if ([arrTmp count] > 0) {
        
        NSMutableArray *arrData = [[[aDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"];
        
        //-- stop timer
        if ([arrData count] > 0 && [_timer isValid])
            [_timer invalidate];
        
        //-- delete message at local
        if (_countMessageLocal > 0 && arrData.count > 0)
        {
            for (NSInteger i = 1; i <= _countMessageLocal; i ++) {
                _countMessageLocal --;
                
                [self.shoutboxDataArray removeObjectAtIndex:0];
            }
        }
        
        if ([arrData count] > 0 && ![[NSUserDefaults standardUserDefaults] valueForKey:@"firstRun"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"firstRun"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (arrData.count > 0) {
            
            for (NSInteger i = (arrData.count - 1); i >= 0; i--) {
                
                NSDictionary *dict = [arrData objectAtIndex:i];
                
                NSString *shoutId = [dict objectForKey:@"shout_id"];
                
                if (![[self.shoutboxDataArray valueForKey:@"commentId"] containsObject:shoutId]) {
                    
                    Profile *profile    = [Profile new];
                    profile.userId      = [dict objectForKey:@"user_id"];
                    profile.userName    = [dict objectForKey:@"user_name"];
                    profile.fullName    = [dict objectForKey:@"full_name"];
                    profile.userImage   = [dict objectForKey:@"user_image"];
                    
                    Comment *comment                = [Comment new];
                    comment.commentId               = [dict objectForKey:@"shout_id"];
                    comment.commentSuperId          = @"";
                    comment.content                 = [dict objectForKey:@"text"];
                    comment.timeStamp               = [dict objectForKey:@"time_stamp"];
                    comment.numberOfSubcommments    = [dict objectForKey:@"number_of_subcomments"];
                    comment.arrSubComments          = [NSMutableArray new];
                    comment.profileUser             = profile;
                    
                    //-- insert into db
                    [VMDataBase insertShoutBoxData:comment];
                    
                    //-- add to datasource
                    [self.shoutboxDataArray insertObject:comment atIndex:0];
                    
                }
            }
            
            //-- check and add tableview music
            id currentTableView = [self.pageViews objectAtIndex:byIndex];
            
            if (NO == [currentTableView isKindOfClass:[TableFanZoneViewController class]]) {
                
                //-- Load the photo view.
                CGRect frame = _scrollViewHomeFanZone.bounds;
                frame.origin.x = frame.size.width * byIndex;
                frame.origin.y = 0.0f;
                frame = CGRectInset(frame, 0.0f, 0.0f);
                
                self.tableviewFanzone = [[TableFanZoneViewController alloc] init];
                self.tableviewFanzone.delegate = self;
                self.tableviewFanzone.view.backgroundColor = [UIColor clearColor];
                [self.tableviewFanzone.view setFrame:frame];
                [self.tableviewFanzone.view setTag:byIndex];
                
                //-- add Refresh to tableview
                [self addRefreshAndLoadMoreForTableView:self.tableviewFanzone.tableView withIndex:byIndex];
                
                self.tableviewFanzone.listShoutbox  = self.shoutboxDataArray;
                
                [_scrollViewHomeFanZone addSubview:self.tableviewFanzone.view];
                [self.pageViews replaceObjectAtIndex:byIndex withObject:self.tableviewFanzone];
                
                //-- auto scroll to top
                [self.tableviewFanzone.tableView scrollsToTop];
                
            }else {
                
                self.tableviewFanzone = (TableFanZoneViewController *) currentTableView;
                self.tableviewFanzone.listShoutbox  = self.shoutboxDataArray;
                [self.tableviewFanzone.tableView reloadData];
                
                //-- auto scroll to top
                [self.tableviewFanzone.tableView scrollsToTop];
            }
            
            Comment *sbInfo = (Comment *)[self.shoutboxDataArray firstObject];
            [[NSUserDefaults standardUserDefaults] setValue: [NSString stringWithFormat:@"%d",[sbInfo.timeStamp integerValue] +1] forKey:kTimeStamp];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //-- turn on timer
            
            _isCallApi = YES; //-- allows call api
            
            //-- refresh Fanzone
            [self callRefreshFanzoneByRefreshTimeSetting];
            
        }
    }
    
    /*
     * Shoot latest message to music control. send total 5 messages
     * Pass data to Slidebar Bottom
     */
    [self shootLastestMessage];
    
    
    //-- check and add tableview music
    id currentTableView = [self.pageViews objectAtIndex:byIndex];
    
    if (NO == [currentTableView isKindOfClass:[TableFanZoneViewController class]]) {
        
        //-- Load the photo view.
        CGRect frame = _scrollViewHomeFanZone.bounds;
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        self.tableviewFanzone = [[TableFanZoneViewController alloc] init];
        self.tableviewFanzone.delegate = self;
        self.tableviewFanzone.view.backgroundColor = [UIColor clearColor];
        [self.tableviewFanzone.view setFrame:frame];
        [self.tableviewFanzone.view setTag:byIndex];
        
        //-- add Refresh to tableview
        [self addRefreshAndLoadMoreForTableView:self.tableviewFanzone.tableView withIndex:byIndex];
        
        self.tableviewFanzone.listShoutbox  = self.shoutboxDataArray;
        
        [_scrollViewHomeFanZone addSubview:self.tableviewFanzone.view];
        [self.pageViews replaceObjectAtIndex:byIndex withObject:self.tableviewFanzone];
        
        //-- auto scroll to top
        [self.tableviewFanzone.tableView scrollsToTop];
        
    }else {
        
        self.tableviewFanzone = (TableFanZoneViewController *) currentTableView;
        self.tableviewFanzone.listShoutbox  = self.shoutboxDataArray;
        
        [self.tableviewFanzone.tableView reloadData];
        
        //-- auto scroll to top
        [self.tableviewFanzone.tableView scrollsToTop];
    }
    
    //-- get tableview All Video in scrollview
    if (_scrollViewHomeFanZone.subviews.count > 0) {
        
        for (UITableView *viewTB in _scrollViewHomeFanZone.subviews) {
            
            if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                
                //-- hidden loading
                [viewTB.infiniteScrollingView stopAnimating];
                
                break;
            }
        }
    }
}


- (void)fetchingMessagesWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime withIndex:(NSInteger) byIndex
{
    NSLog(@"%s", __func__);
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) {
        
        //-- get data fomr DB
        [self getDataMessagesHistoryByStartTime:startTime endTime:endTime withIndex:byIndex];
        
    }else {
        
        //-- show loading
        [NetworkActivity show];
        [_activityIndicator startAnimating];
        
        [API getDataShoutBox:SINGER_ID
                       limit:@"100"
                   startTime:[NSString stringWithFormat:@"%d", startTime]
                     endTime:[NSString stringWithFormat:@"%d", endTime]
                       appId:PRODUCTION_ID
                  appVersion:PRODUCTION_VERSION
                   completed:^(NSDictionary *responseDictionary, NSError *error) {
                       
                       [self parseListMessagesFrom:responseDictionary startTime:startTime endTime:endTime withIndex:byIndex];
                       
                       //-- hidden network activity
                       [NetworkActivity hide];
                       [_activityIndicator stopAnimating];
                       
                   }];
    }
}


- (void) parseListMessagesFrom:(NSDictionary*)aDict startTime:(NSInteger)startTime endTime:(NSInteger)endTime withIndex:(NSInteger) byIndex
{
    NSLog(@"%s", __func__);
    NSMutableArray *arrData = [[[aDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"];
    
    if (arrData.count > 0) {
        
        //-- delete objects from DB
        [_dataMessagesHistory removeAllObjects];
        [VMDataBase deleteMessagesFanZoneWithStartTime:startTime endTime:endTime];
        
        for (NSInteger i = (arrData.count - 1); i >= 0; i--) {
            
            NSDictionary *dict  = [arrData objectAtIndex:i];
            
            Profile *profile    = [Profile new];
            profile.userId      = [dict objectForKey:@"user_id"];
            profile.userName    = [dict objectForKey:@"user_name"];
            profile.fullName    = [dict objectForKey:@"full_name"];
            profile.userImage   = [dict objectForKey:@"user_image"];
            
            Comment *comment                = [Comment new];
            comment.commentId               = [dict objectForKey:@"shout_id"];
            comment.commentSuperId          = @"";
            comment.content                 = [dict objectForKey:@"text"];
            comment.timeStamp               = [dict objectForKey:@"time_stamp"];
            comment.numberOfSubcommments    = [dict objectForKey:@"number_of_subcomments"];
            comment.arrSubComments          = [NSMutableArray new];
            comment.profileUser             = profile;
            
            //-- insert into db
            [VMDataBase insertShoutBoxData:comment];
            
            //-- add to datasource
            [_dataMessagesHistory insertObject:comment atIndex:0];
        }
        
        //-- check and add tableview fanzone
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        
        if (NO == [currentTableView isKindOfClass:[TableFanZoneViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = _scrollViewHomeFanZone.bounds;
            frame.origin.x = frame.size.width * byIndex;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            self.tableviewFanzone = [[TableFanZoneViewController alloc] init];
            self.tableviewFanzone.delegate = self;
            self.tableviewFanzone.view.backgroundColor = [UIColor clearColor];
            [self.tableviewFanzone.view setFrame:frame];
            [self.tableviewFanzone.view setTag:byIndex];
            
            self.tableviewFanzone.listShoutbox  = _dataMessagesHistory;
            
            [_scrollViewHomeFanZone addSubview:self.tableviewFanzone.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:self.tableviewFanzone];
            
            //-- auto scroll to top
            [self.tableviewFanzone.tableView scrollsToTop];
            
        }else {
            
            self.tableviewFanzone = (TableFanZoneViewController *) currentTableView;
            self.tableviewFanzone.listShoutbox  = _dataMessagesHistory;
            
            [self.tableviewFanzone.tableView reloadData];
            
            //-- auto scroll to top
            [self.tableviewFanzone.tableView scrollsToTop];
        }
        
    }else {
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        
        if (NO == [currentTableView isKindOfClass:[TableFanZoneViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = _scrollViewHomeFanZone.bounds;
            frame.origin.x = frame.size.width * byIndex;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            self.tableviewFanzone = [[TableFanZoneViewController alloc] init];
            self.tableviewFanzone.delegate = self;
            self.tableviewFanzone.view.backgroundColor = [UIColor clearColor];
            [self.tableviewFanzone.view setFrame:frame];
            [self.tableviewFanzone.view setTag:byIndex];
            
            self.tableviewFanzone.listShoutbox  = _dataMessagesHistory;
            
            [_scrollViewHomeFanZone addSubview:self.tableviewFanzone.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:self.tableviewFanzone];
            
            //-- auto scroll to top
            [self.tableviewFanzone.tableView scrollsToTop];
            
        }else {
            
            self.tableviewFanzone = (TableFanZoneViewController *) currentTableView;
            self.tableviewFanzone.listShoutbox  = _dataMessagesHistory;
            
            [self.tableviewFanzone.tableView reloadData];
            
            //-- auto scroll to top
            [self.tableviewFanzone.tableView scrollsToTop];
        }
    }
    
    /*
     * Shoot latest message to music control. send total 5 messages
     * Pass data to Slidebar Bottom
     */
    [self shootLastestMessage];
}


- (void)apiAddShoutbox:(NSString *)textComment
{
    NSLog(@"%s", __func__);
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) return;
    
    //-- show loading
    [NetworkActivity show];
    // [_activityIndicator startAnimating];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Đang gửi..."];

    NSString *startT = @"";
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kTimeStamp])
        startT = [[NSUserDefaults standardUserDefaults] objectForKey:kTimeStamp];
    
    [API addShoutBox:SINGER_ID
              userId:userId
                text:textComment
               appId:PRODUCTION_ID
          appVersion:PRODUCTION_VERSION
           startTime:startT
    isGetNewShoutBox:@"1"
           completed:^(NSDictionary *responseDictionary, NSError *error) {
        
               [self createDatasourceAddShout:responseDictionary];
               
               //-- hidden loading
               //[_activityIndicator stopAnimating];
               [[SHKActivityIndicator currentIndicator] hide];
               [NetworkActivity hide];
    }];
}


- (void)createDatasourceAddShout:(NSDictionary *)aDict
{
    NSLog(@"%s", __func__);
    NSMutableArray *arrData = [[aDict objectForKey:@"data"] objectForKey:@"shoutbox_data"];
    
    if (arrData.count > 0) {
        
        for (NSInteger i=0; i<[arrData count]; i++) {
            
            NSString *shout_idStr = [[arrData objectAtIndex:i] objectForKey:@"shout_id"];
            
            if (![[self.shoutboxDataArray valueForKey:@"commentId"] containsObject:shout_idStr]) {
                
                NSDictionary *dict  = (NSDictionary *)[arrData objectAtIndex:i];
                Profile *profile    = [Profile new];
                profile.userId      = [dict objectForKey:@"user_id"];
                profile.userName    = [dict objectForKey:@"user_name"];
                profile.fullName    = [dict objectForKey:@"full_name"];
                profile.userImage   = [dict objectForKey:@"user_image"];
                
                Comment *comment                = [Comment new];
                comment.commentId               = [dict objectForKey:@"shout_id"];
                comment.commentSuperId          = @"";
                comment.content                 = [dict objectForKey:@"text"];
                comment.timeStamp               = [dict objectForKey:@"time_stamp"];
                comment.numberOfSubcommments    = [dict objectForKey:@"number_of_subcomments"];
                comment.arrSubComments          = [NSMutableArray new];
                comment.profileUser             = profile;
                
                [self.shoutboxDataArray insertObject:comment atIndex:0];
                
                //longnh add
                //-- reload data tableview
                _countMessageLocal++;

                id currentTableView = [self.pageViews objectAtIndex:0];
                if (currentTableView) {
                    
                    self.tableviewFanzone = (TableFanZoneViewController *) currentTableView;
                    self.tableviewFanzone.listShoutbox = self.shoutboxDataArray;
                    
                    [self.tableviewFanzone.tableView reloadData];
                    [self.tableviewFanzone.tableView scrollsToTop];
                }
                /*
                 * Shoot latest message to music control. send total 5 messages
                 * Pass data to Slidebar Bottom
                 */
                [self shootLastestMessage];
                //longnh <=

            }  
        }
    }
}


#pragma mark - Comments

- (void)clickToBtnCreateComment:(id)sender
{
    _isClickComment = YES;
    
    //-- if user have not account
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID]) {
        
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
    else
    {
        if (_isClickComment) {
            
            //-- switch to today tab
            _currentIndex = 0;
            _controlMenuTop.selectedSegmentIndex = 0;
            
            [self scrollToIndex:0];
            
            //-- stop timer
            if (_timer && [_timer isValid])
                [_timer invalidate];
            
            //-- post comment
            [self showDialogComments:CGPointZero title:@"Bình luận"];
        }
    }
}


//-- @override
-(void) postComment
{
    NSLog(@"%s", __func__);
    id currentTableView = [self.pageViews objectAtIndex:0];
    
    NSString *content = [self getContentOfComment];
    if ([content length]==0)
        return;

    [super postComment];
    
    //-- add api
    [self apiAddShoutbox:content];
    //longnh comment
//    _countMessageLocal++;
//    
//    Comment *commentForAComment = [Comment new];
//    commentForAComment.commentId = @"0";
//    commentForAComment.content = content;
//    commentForAComment.timeStamp = [Utility idFromTimeStamp];
//    commentForAComment.profileUser = [Profile sharedProfile];
//    commentForAComment.numberOfSubcommments = @"0";
//    commentForAComment.arrSubComments = [[NSMutableArray alloc] init];
//    
//    [self.shoutboxDataArray insertObject:commentForAComment atIndex:0];

    //longnh fix bug, reload o day som qua, phai chuyen den createDatasourceAddShout
    //-- reload data
//    if (currentTableView) {
//        
//        self.tableviewFanzone = (TableFanZoneViewController *) currentTableView;
//        self.tableviewFanzone.listShoutbox = self.shoutboxDataArray;
//        
//        [self.tableviewFanzone.tableView reloadData];
//        [self.tableviewFanzone.tableView scrollsToTop];
//    }
    
    /*
     * Shoot latest message to music control. send total 5 messages
     * Pass data to Slidebar Bottom
     */
//    [self shootLastestMessage];
    
    //-- turn on timer
    //-- refresh Fanzone
    [self callRefreshFanzoneByRefreshTimeSetting];
    
    _isClickComment = NO;
}


-(void)cancelComment
{
    NSLog(@"%s", __func__);
    [super cancelComment];
    
    //-- turn on timer
    //-- refresh Fanzone
    [self callRefreshFanzoneByRefreshTimeSetting];
    
    _isClickComment = NO;
}


#pragma mark - add titles and tableviews

-(void) setTopMenuWithTitles:(NSMutableArray *)categories
{
    NSLog(@"%s", __func__);
    //-- Segmented control with scrolling
    _controlMenuTop = [[HMSegmentedControlOriginal alloc] initWithSectionTitles:categories];
    _controlMenuTop.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _controlMenuTop.selectionStyle = HMSegmentedControlOriginalSelectionIndicatorLocationDown;
    _controlMenuTop.selectionIndicatorLocation = HMSegmentedControlOriginalSelectionIndicatorLocationDown;
    _controlMenuTop.scrollEnabled = YES;
    _controlMenuTop.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [_controlMenuTop setFrame:CGRectMake(0,  0 , 320, 45)];
    [_controlMenuTop addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [_controlMenuTop setFont:[UIFont systemFontOfSize:16]];
    _controlMenuTop.backgroundColor = COLOR_BG_MENU;
    _controlMenuTop.textColor = [UIColor grayColor];
    _controlMenuTop.selectedTextColor = [UIColor whiteColor];
    _controlMenuTop.selectionIndicatorHeight = 5;
    
    [self.view addSubview:_controlMenuTop];
    [UIView view:_scrollViewHomeFanZone setY:47];
    
    _controlMenuTop.selectedSegmentIndex = _currentIndex;
    
    _imgViewLineSegments.alpha = 1;
    
}


//-- segment category Selected
- (void)segmentedControlChangedValue:(HMSegmentedControlOriginal *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex != _currentIndex) {
        
        [self setCurrentIndex:segmentedControl.selectedSegmentIndex];
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
    }
}


#pragma mark - scrollview delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollViewHomeFanZone)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = floor(fractionalPage);
        
        if (page != _currentIndex) {
            
            [self setCurrentIndex:page];
        }
    }
}


#pragma mark - TableFanzoneViewControllerDelegate

-(void)goToDetailFanZoneViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    NSLog(@"%s", __func__);
    Comment *post = (Comment*)[listData objectAtIndex:indexRow];
    
    DetailsCommentViewController *dcVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailsCommentViewControllerId"];
    dcVC.superComment = post;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:dcVC animated:YES];
    else
        [self.navigationController pushViewController:dcVC animated:NO];
}


#pragma mark - shoot delegate from fan zone

- (void) shootLastestMessage
{
    NSLog(@"%s", __func__);
    self.delegateFanZone = [SlideBarCenterViewController sharedSlideBarCenter];
    
    //-- shoot latest message to music control. send total 5 messages
    if ([self.delegateFanZone respondsToSelector:@selector(fanZoneViewController:sendLatestMessages:)]) {
        
        NSMutableArray *arrToSend = nil;
        NSRange range;
        
        if ([self.shoutboxDataArray count] < 5) {
            
            if ([self.shoutboxDataArray count] > 0) {
                
                range = NSMakeRange(0, [self.shoutboxDataArray count]);
                
                arrToSend = [[NSMutableArray alloc] initWithArray:[self.shoutboxDataArray subarrayWithRange:range]];
            }else {
                
                arrToSend = [[NSMutableArray alloc] init];
            }
            
            switch ([self.shoutboxDataArray count]) {
                case 0:
                    [arrToSend addObjectsFromArray:[self addObjectsToArraySendByIndex:0]];
                    break;
                    
                case 1:
                    [arrToSend addObjectsFromArray:[self addObjectsToArraySendByIndex:1]];
                    break;
                    
                case 2:
                    [arrToSend addObjectsFromArray:[self addObjectsToArraySendByIndex:2]];
                    break;
                    
                case 3:
                    [arrToSend addObjectsFromArray:[self addObjectsToArraySendByIndex:3]];
                    break;
                    
                case 4:
                    [arrToSend addObjectsFromArray:[self addObjectsToArraySendByIndex:4]];
                    break;
                    
                default:
                    break;
            }
            
        }else {
            
            range = NSMakeRange(0, 5);
            
            arrToSend = [[NSMutableArray alloc] initWithArray:[self.shoutboxDataArray subarrayWithRange:range]];
        }
        
        [self.delegateFanZone fanZoneViewController:self sendLatestMessages:arrToSend];
    }
}

-(NSMutableArray *) addObjectsToArraySendByIndex:(int) index {
    NSLog(@"%s", __func__);
    
    NSMutableArray *arrToSend = [[NSMutableArray alloc] init];
    NSMutableArray *arrMessagesHistory = [[NSMutableArray alloc] init];
    
    arrMessagesHistory = [VMDataBase getAllMessagesFanZoneWithStartTime:[self unixTimeAgoWeek:1] endTime:[self unixTimeForStartTimeToday]];
    
    if (arrMessagesHistory.count > 0) {
        
        NSInteger countObject = (arrMessagesHistory.count >= 5 - index) ? 5 - index : arrMessagesHistory.count;
        
        for (NSInteger i=0; i< countObject ; i++) {
            
            Comment *messageModel = (Comment*)[arrMessagesHistory objectAtIndex:i];
            [arrToSend addObject:messageModel];
        }
    }
    
    return arrToSend;
}


#pragma mark - Base view controller delegate

- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
//    _isProcessLikeAPI = false;
}

- (void)baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    [AppDelegate addLocalLogWithString:@"LG200" info:[Profile debugDescription]];
    if (_isClickComment) {
        
        //-- switch to today tab
        _currentIndex = 0;
        _controlMenuTop.selectedSegmentIndex = 0;
        
        [self scrollToIndex:0];
        
        //-- stop timer
        if (_timer && [_timer isValid])
            [_timer invalidate];
        
        //-- post comment
        [self showDialogComments:CGPointZero title:@"Bình luận"];
    }
}

#pragma mark - time

- (NSInteger)unixTimeForStartTimeToday
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
   
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit
                                                   fromDate:now];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSLog(@"timezone:%@",dateComponents.timeZone);
    NSDate *midnightUTC = [calendar dateFromComponents:dateComponents];
    
    return [midnightUTC timeIntervalSince1970];
}

- (NSInteger)unixTimeAgoWeek:(NSInteger)agoWeek
{
    NSInteger secondForAWeek = 60*60*24*7;
    NSInteger startTime = 0;
    NSInteger beginToday = [self unixTimeForStartTimeToday];
    switch (agoWeek) {
        
        case 1:{ //-- ago 1 week
            startTime = beginToday - secondForAWeek;
            break;
        }
            
        case 2:{ //-- ago 2 week
            startTime = beginToday - (secondForAWeek*2);
            break;
        }
            
        default:
            break;
    }
    
    return startTime;
}


#pragma mark - swipe

-(IBAction) handleSwipeGesture:(UIGestureRecognizer *)sender
{
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *)sender direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft: {
            
            if (_currentIndex > 0) {
                
                _currentIndex--;
                //-- change segmanet
                [self scrollToIndex:_currentIndex];
                _controlMenuTop.selectedSegmentIndex = _currentIndex;
                [self fetchingData];
            }
            
            break;
        }
            
        case UISwipeGestureRecognizerDirectionRight: {
            
            if (_currentIndex < ([_arrCategories count] - 1)) {
                
                 _currentIndex++;
                //-- change segmanet
                [self scrollToIndex:_currentIndex];
                _controlMenuTop.selectedSegmentIndex = _currentIndex;
                [self fetchingData];
            }
            
            break;
        }
            
        default:
            break;
    }
    
}


@end
