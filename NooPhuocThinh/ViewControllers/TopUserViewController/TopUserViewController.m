//
//  TopUserViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "TopUserViewController.h"
#import "SearchViewController.h"

@interface TopUserViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation TopUserViewController

@synthesize imgTop, viewTopUser, viewTrungthuong, segmentsArray, indexOfTopUser, tableviewTopUser, arrTopUser;
@synthesize pageViews = _pageViews;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //-- set data
    [self setDataWhenViewDidLoad];
    
    //-- set up view
    [self setViewWhenViewDidLoad];
    
    //-- create page scrolling
    [self createPageScrollTopUser];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Top user Screen";
}


- (void)setViewWhenViewDidLoad
{
    //--custom navigation bar
    [self customNavigationBar];
    
    [self setTitle:@"Top User"];
    
    //--set bool
    isTopUser = YES;
    isTrungthuong = YES;
    
    if (isTopUser == YES) {
        //-- selected Friend Request button
        [self clickToBtnTopUser:btnTopUser];
    }
    if (isTrungthuong == YES) {
        //-- selected Inbox button
        [self clickToBtnTrungthuong:btnTrungthuong];
    }
    
    //-- add segment
    [self setUpSegmentControl];
}


- (void)setDataWhenViewDidLoad
{
    NSArray *arrSeg = [NSArray arrayWithObjects:@"Tất cả", @"Hàng tháng", @"Hàng tuần", @"Hàng ngày", nil];
    segmentsArray  = [[NSMutableArray alloc] initWithArray:arrSeg];
    
    //-- alloc list data contest
    _listData = [[NSMutableArray alloc] init];
    _listWinners = [[NSMutableArray alloc] init];
    
    //-- get startAndEndOfWeek
    [self startAndEndOfCurrentWeek];
    
    //-- alloc array
    _dataSourceTopUser = [[NSMutableArray alloc] init];
    arrTopUser = [[NSMutableArray alloc] init];
    
    _isCacheTopUser = YES;
    
    //-- init char
    _currentPageLoadMore = 0;
    _currentIndex = 0;
    _numberViews = 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)customNavigationBar
{
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(clickToBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- search button
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(searchTopUser:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barItemRight;
}


#pragma mark - Action

- (void)clickToBtnBack:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)clickToBtnTopUser:(id)sender
{
    //-- set frame for image line top with animation
    CGRect frameLine = [imgLineBold frame];
    frameLine.origin.x = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        //-- set frame for image line top
        [imgLineBold setFrame:frameLine];
    }];
    
    viewTopUser.alpha = 1;
    viewTrungthuong.alpha = 0;
    
    isTopUser = YES;
    isTrungthuong = NO;
    
    [btnTopUser setSelected:YES];
    [btnTrungthuong setSelected:NO];
    
    btnTopUser.userInteractionEnabled = NO;
    btnTrungthuong.userInteractionEnabled = YES;
}


- (IBAction)clickToBtnTrungthuong:(id)sender
{
    //-- set frame for image line top with animation
    CGRect frameLine = [imgLineBold frame];
    frameLine.origin.x = 160;
    
    [UIView animateWithDuration:0.3 animations:^{
        //-- set frame for image line top
        [imgLineBold setFrame:frameLine];
    }];
    
    viewTopUser.alpha = 0;
    viewTrungthuong.alpha = 1;
    
    isTopUser = NO;
    isTrungthuong = YES;
    
    [btnTopUser setSelected:NO];
    [btnTrungthuong setSelected:YES];
    
    btnTopUser.userInteractionEnabled = YES;
    btnTrungthuong.userInteractionEnabled = NO;
    
    //-- hide webview
    _wvContest.alpha = 0;
    
    //-- get list winners
    [self getListWinners];
}


//********************************************************************************//
#pragma mark - Search Album

- (void)searchTopUser:(id)sender
{
    SearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idSearchViewControllerSb"];
    searchVC.searchtype = searchTopUsersType;
    
    [UIView animateWithDuration:0.55
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:searchVC animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}


//********************************************************************************//
#pragma mark - Set up scrollview

//-- create page scroll
-(void) createPageScrollTopUser
{
    _numberViews = [segmentsArray count];
    
    scrollContainer.contentSize = CGSizeMake(scrollContainer.frame.size.width * _numberViews, scrollContainer.frame.size.height);
    scrollContainer.showsHorizontalScrollIndicator = NO;
    scrollContainer.showsVerticalScrollIndicator = NO;
    scrollContainer.alwaysBounceVertical = NO;
    scrollContainer.pagingEnabled = YES;
    scrollContainer.scrollsToTop = NO;
    
    //-- Set up the array to hold the views for each page
    _pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < _numberViews; ++i) {
        
        [self.pageViews addObject:[NSNull null]];
    }
    
    //-- Set the scroll view's content size, autoscroll to the stating tableview,
    //-- and setup the other display elements.
    [self setScrollViewContentSize];
    [self setCurrentIndex:0];
    [self scrollToIndex:0];
}


-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = scrollContainer.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [scrollContainer scrollRectToVisible:frame animated:NO];
}


- (void)setScrollViewContentSize
{
    NSInteger pageCount = _numberViews;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(scrollContainer.frame.size.width * pageCount,
                             scrollContainer.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [scrollContainer setContentSize:size];
}


- (void)setCurrentIndex:(NSInteger)newIndex
{
    _currentIndex = newIndex;
    
    //-- change segmanet
    [_segmentedControlTopUser setSelectedSegmentIndex:_currentIndex];
    
    //-- load data
    [self loadDataAlbum:_currentIndex];
    
}



#pragma mark - Fetching data Top user

-(void)loadDataAlbum:(NSInteger)index
{
    if (index < 0 || index >= _numberViews) {
        return;
    }
    
    id currentTableView = [self.pageViews objectAtIndex:index];
    
    if (NO == [currentTableView isKindOfClass:[tableviewTopUser class]]) {
        
        if (index == 0)
        {
            _typeRank = type_day;
            _typeTime = yesterday;
            _typeTimeEnd = @"";
            _typeGet = get_all;
        }
        else if (index == 1)
        {
            _typeRank = type_month;
            _typeTime = currentMonth;
            _typeTimeEnd = @"";
            _typeGet = get_normal;
        }
        else if (index == 2)
        {
            _typeRank = type_week;
            _typeTime = weekStart;
            _typeTimeEnd = weekEnd;
            _typeGet = get_normal;
        }
        else if (index == 3)
        {
            _typeRank = type_day;
            _typeTime = currentDay;
            _typeTimeEnd = @"";
            _typeGet = get_normal;
        }

//        //-- get data
        [self fetchingTopUserByType:_typeRank tyleTime:_typeTime tyleTimeEnd:_typeTimeEnd tyleGet:_typeGet withIndex:index];
    }
}


- (void)unloadData:(NSInteger)index
{
    if (index < 0 || index >= _numberViews) {
        return;
    }
    
    id currentTableView = [self.pageViews objectAtIndex:index];
    if ([currentTableView isKindOfClass:[TableTopUserViewController class]]) {
        [currentTableView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}


- (void) fetchingTopUserByType:(NSString *)typeRank tyleTime:(NSString*)time tyleTimeEnd:(NSString*)timeEnd tyleGet:(NSString*)typeGet withIndex:(NSInteger)index
{
    NSString *indexStr = [NSString stringWithFormat:@"%d", index];
    
    //-- remove lable nodata
    [self removeLableNoDataFrom:scrollContainer withIndex:index];
    
    //-- read in cache
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    listData = [VMDataBase getAllTopUserByCategoryid:indexStr];
    
    if (listData.count > 0) {
        
        //-- hidden loading
        [_activityIndicator stopAnimating];
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:index];
        
        if (NO == [currentTableView isKindOfClass:[TableTopUserViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = [scrollContainer frame];
            frame.origin.x = frame.size.width * index;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            tableviewTopUser = [[TableTopUserViewController alloc] init];
            tableviewTopUser.delegate = self;
            tableviewTopUser.view.backgroundColor = [UIColor clearColor];
            [tableviewTopUser.view setFrame:frame];
            [tableviewTopUser.view setTag:index];
            [self.tableviewTopUser.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [self.tableviewTopUser.tableView setSeparatorColor:COLOR_SEPARATOR_CELL];

            tableviewTopUser.listTopUser  = listData;
            
            [scrollContainer addSubview:tableviewTopUser.view];
            [self.pageViews replaceObjectAtIndex:index withObject:tableviewTopUser];
            
        }else {
            
            tableviewTopUser.listTopUser  = listData;
            
            //-- reload data
            [tableviewTopUser.tableView reloadData];
        }
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [scrollContainer frame];
        frame.origin.x = frame.size.width * index;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable nodata
        [self addLableNoDataTo:scrollContainer withIndex:index withFrame:frame];
    }
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) return;
    
    //-- start indicator
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:NO];
    
    //-- check time
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesTopUserRefreshTime;
    
    if (([Setting sharedSetting].milestonesTopUserRefreshTime != 0) && (compeTime < [Setting sharedSetting].topUserRefreshTime*60) && (listData.count > 0)) {
        return;
    }
    else
    {
        [Setting sharedSetting].milestonesTopUserRefreshTime = currentDate;
        //-- request API get all music
        [self callAPIGetTopUser:typeRank tyleTime:time tyleTimeEnd:timeEnd tyleGet:typeGet withIndex:index];
    }
}


- (void)callAPIGetTopUser:(NSString *)typeRank tyleTime:(NSString*)time tyleTimeEnd:(NSString*)timeEnd tyleGet:(NSString*)typeGet withIndex:(NSInteger)index
{
    //-- request list top user async
    [API getTopUserPoint:typeRank
                singerId:SINGER_ID
                    time:time
                 timeEnd:timeEnd
             isGetAllDay:typeGet
                   limit:@"100"
            productionId:PRODUCTION_ID
       productionVersion:PRODUCTION_VERSION
               completed:^(NSDictionary *responseDictionary, NSError *error) {
                   
                   //-- stop indicator
                   [_activityIndicator stopAnimating];
                   [_activityIndicator setHidden:YES];
                   
                   //-- fetching
                   if (!error) {
                       [self createDataSourceTopUserFrom:responseDictionary byIndex:index];
                   }
               }];
}


-(void)createDataSourceTopUserFrom:(NSDictionary *)aDictionary byIndex:(int)index
{
    //-- remove lable nodata
    [self removeLableNoDataFrom:scrollContainer withIndex:index];
    
    NSString *indexStr = [NSString stringWithFormat:@"%d", index];
    NSMutableArray *arrData = [aDictionary objectForKey:@"data"];
    
    if ([arrData count] > 0)
    {
        //-- delete album music from DB
        [VMDataBase deleteAllTopUserByCategory:indexStr];
        
        //-- remove list
        [arrTopUser removeAllObjects];
        
        //-- add objects
        [self addObjectToListAndSaveDatabaseBy:arrData byIndex:index];
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [scrollContainer frame];
        frame.origin.x = frame.size.width * index;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable nodata
        [self addLableNoDataTo:scrollContainer withIndex:index withFrame:frame];
    }
    
}


//-- add object
-(void) addObjectToListAndSaveDatabaseBy:(NSMutableArray *)arrayTopUser byIndex:(NSInteger)index
{
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
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
        topUser.categoryId = [NSString stringWithFormat:@"%d",index];
        
        [listData addObject:topUser];
        
        //-- insert into DB
        [VMDataBase insertTopUser:topUser];
    }
    
    //-- check and add tableview music
    id currentTableView = [self.pageViews objectAtIndex:index];
    
    if (NO == [currentTableView isKindOfClass:[TableTopUserViewController class]]) {
        
        //-- Load the photo view.
        CGRect frame = scrollContainer.bounds;
        frame.origin.x = frame.size.width * index;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        tableviewTopUser = [[TableTopUserViewController alloc] init];
        tableviewTopUser.delegate = self;
        tableviewTopUser.view.backgroundColor = [UIColor clearColor];
        [tableviewTopUser.view setFrame:frame];
        [tableviewTopUser.view setTag:index];
        
        tableviewTopUser.listTopUser  = listData;
        
        [scrollContainer addSubview:tableviewTopUser.view];
        [self.pageViews replaceObjectAtIndex:index withObject:tableviewTopUser];
    }
}



#pragma mark - Fetching Danh sach trung thuong

- (void) getListWinners
{
    //-- start indicator
    [_activityIndicator startAnimating];
    
    //-- fetching data
    [API getListWinners:SINGER_ID
              contestId:@"2"
                roundId:@"1"
           productionId:PRODUCTION_ID
      productionVersion:PRODUCTION_VERSION
              completed:^(NSDictionary *responseDictionary, NSError *error) {
        
        //create data
        NSLog(@"contest:%@",responseDictionary);
        
        if (!error && responseDictionary) {
            [self createDataContest:responseDictionary];
        }else{
            _txvSubject.text = @"Hiện chưa có danh sách trúng thưởng. Khi nào có, chúng tôi sẽ thông báo";
            _txvSubject.userInteractionEnabled = NO;
            _txvSubject.scrollEnabled = NO;
        }
    }];
    
    [_activityIndicator stopAnimating];
}


- (void)createDataContest:(NSDictionary *)dataContest
{
    //-- get winner letter subject
    _winnerLetterSubject = [dataContest objectForKey:@"winner_newsletter_subject"];
    _winnerLetterBody = [dataContest objectForKey:@"winner_newsletter_body"];
    
    [self setContentWinnerLetterSubject:_winnerLetterSubject];
    
    //-- get winner data
    _listData = [dataContest objectForKey:@"data"];
    
    NSMutableArray *arrWinners = [[NSMutableArray alloc] init];
    
    if (_listData.count > 0) {
        for (NSInteger i = 0; i < [_listData count]; i ++) {
            _winnerId = [[_listData objectAtIndex:i] objectForKey:@"winner_id"];
            _winnerName = [[_listData objectAtIndex:i] objectForKey:@"winner_name"];
            arrWinners = [[_listData objectAtIndex:i] objectForKey:@"user_winner_list"];
            
            [self addObjectAndSaveListWinnersIntoDataBase:arrWinners];
        }
    }
    
    //-- set tableview frame
    _tableViewContest.frame = CGRectMake(0, _txvSubject.frame.size.height, _tableViewContest.frame.size.width, 60 * _listData.count * _listWinners.count + 30 * _listData.count);
    
    //-- custom webview
    [self customWebView:_wvContest];
    
    //-- fetchDataForWebview
    [self fetchDataForWebview];
    
    //-- set scrollview contentsize
    _scrollViewContest.contentSize = CGSizeMake(_scrollViewContest.frame.size.width, _txvSubject.frame.size.height + _tableViewContest.frame.size.height + _wvContest.frame.size.height);
    
    [_tableViewContest reloadData];
}


- (void)addObjectAndSaveListWinnersIntoDataBase:(NSMutableArray *)listWinners
{
    NSLog(@"listWinner:%@",listWinners);
    
    for (NSInteger i=0; i<listWinners.count; i++) {
        ListWinners *winnerInfo = [[ListWinners alloc] init];
        
        winnerInfo.facebookId   = [[listWinners objectAtIndex:i] objectForKey:@"facebook_id"];
        winnerInfo.facebookURL  = [[listWinners objectAtIndex:i] objectForKey:@"facebook_url"];
        winnerInfo.userAvatar   = [[listWinners objectAtIndex:i] objectForKey:@"user_avatar"];
        winnerInfo.userFullName   = [[listWinners objectAtIndex:i] objectForKey:@"user_full_name"];
        winnerInfo.userId = [[listWinners objectAtIndex:i] objectForKey:@"user_id"];
        winnerInfo.userName = [[listWinners objectAtIndex:i] objectForKey:@"user_name"];
        winnerInfo.userPoint = [[listWinners objectAtIndex:i] objectForKey:@"user_point"];
        winnerInfo.userRanking = [[listWinners objectAtIndex:i] objectForKey:@"user_ranking"];
        winnerInfo.userStatus = [[listWinners objectAtIndex:i] objectForKey:@"user_status"];
        
        [_listWinners addObject:winnerInfo];
    }
}


- (void)setContentWinnerLetterSubject:(NSString *)content
{
    _txvSubject.userInteractionEnabled = NO;
    _txvSubject.editable = NO;
    //-- lyric content
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        NSString *stringFormat = [NSString stringWithFormat:@"<div style=\"color: #fff; text-align:left; font-size: 14px; \">%@\n\n <b>Dưới đây là danh sách trúng thưởng:<b></div>",content];
        NSAttributedString *aStr = [[NSAttributedString alloc] initWithData:[stringFormat dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                              NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                         documentAttributes:nil error:nil];
        
        _txvSubject.attributedText = aStr;
    }else{
        [_txvSubject setValue:content forKey:@"contentToHTMLString"];
    }
    
    CGFloat heightOfTextView = [Utility heightFromString:content maxWidth:300 font:[UIFont systemFontOfSize:14.0f]];
    CGRect frame = _txvSubject.frame;
    frame.size.height = heightOfTextView + 25;
    
    _txvSubject.frame= frame;
}


- (void)fetchDataForWebview
{
    //-- get txt from file
    NSString *contentString = _winnerLetterBody;
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width = '300'"];
//    NSString *metaHTML = @"<meta name=\"viewport\" content=\"width = 300,initial-scale = 1.0,maximum-scale = 1.0\" />";
    NSString *metaHTML = @"";
    NSString *formatHTML = @"<html>%@<body style=\"background-color: clear color; font-size: 12; font-family: HelveticaNeue; color: #ffffff\">%@</body> </html>";
    NSString *contentHTML = [NSString stringWithFormat:formatHTML,metaHTML,contentString];
    
    //-- set webview data
    [_wvContest  loadHTMLString:contentHTML baseURL:[NSURL URLWithString:HOST_FOR_CONTENT]];
}


#pragma mark  - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
    if (page != _currentIndex) {
        [self setCurrentIndex:page];
    }
}


#pragma mark - Segment

-(void) setUpSegmentControl
{
    //-- Segmented control with scrolling
    _segmentedControlTopUser = [[HMSegmentedControl alloc] initWithSectionTitles:segmentsArray];
    _segmentedControlTopUser.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 5, 5);
    _segmentedControlTopUser.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentedControlTopUser.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControlTopUser.selectionIndicatorHeight = 4.0f;
    _segmentedControlTopUser.scrollEnabled = YES;
    _segmentedControlTopUser.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [_segmentedControlTopUser setFrame:CGRectMake(0, 0, 320, 40)];
    [_segmentedControlTopUser addTarget:self action:@selector(segmentedControlChangedScheduleValue:) forControlEvents:UIControlEventValueChanged];
    [_segmentedControlTopUser setTextColor:[UIColor grayColor]];
    _segmentedControlTopUser.backgroundColor = COLOR_BG_MENU;
    [_segmentedControlTopUser setSelectedTextColor:[UIColor whiteColor]];
    [_segmentedControlTopUser setSelectedSegmentIndex:_currentIndex];
    _segmentedControlTopUser.font = [UIFont systemFontOfSize:16.0f];
    
    [self.viewTopUser addSubview:_segmentedControlTopUser];
}


- (void)segmentedControlChangedScheduleValue:(HMSegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex != _currentIndex) {
        [self setCurrentIndex:segmentedControl.selectedSegmentIndex];
        _currentIndex = segmentedControl.selectedSegmentIndex;
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
    }
}



#pragma mark - Caculate timer

- (void)startAndEndOfCurrentWeek
{
//    for (int i=0; i<50; i++) {
//    NSCalendar *g = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *com = [g components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
//    
//    
//    
//    [com setDay:([com day] + i)];// for beginning of the week.
//    NSDate *today = [g dateFromComponents:com];
//        NSInteger dayweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];
//        if (dayweek == 1) {
//            dayweek = 8;
//        }
//        NSLog(@"thu: %d",dayweek);
    
    NSDate *today = [NSDate date];
    NSLog(@"Today date is %@",today);
    
    //-- set date format
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];// you can use your format.
    currentDay = [dateFormat stringFromDate:today];
    NSLog(@"currentDay:%@",currentDay);
    
    //--set month format
    NSDateFormatter *monthFormat = [[NSDateFormatter alloc] init];
    [monthFormat setDateFormat:@"yyyy:MM"];
    currentMonth = [monthFormat stringFromDate:today];
    NSLog(@"currentMonth:%@",currentMonth);
    
    //-- set yesterday time
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:-1];
    
    NSDate *yesterdayDate = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    yesterday = [dateFormat stringFromDate:yesterdayDate];
    NSLog(@"yesterday:%@",yesterday);
    
    //-- Week Start Date
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  | NSTimeZoneCalendarUnit //longnh add timezone
                                                fromDate:today];

    NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];
    NSLog(@"%d",[components day]);
    if (dayofweek == 1) { //longnh fix bug
        dayofweek = 8;
    }
    [components setDay:([components day] - ((dayofweek) - 2))];// for beginning of the week.
    NSLog(@"%d",[components day]);
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
    [dateFormat_first setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    
    NSDate *weekStartPrev = [dateFormat_first dateFromString:dateString2Prev];
    weekStart = [dateFormat_first stringFromDate:weekStartPrev];
    NSLog(@"StartDate:%@",weekStart);
    
    
    //-- Week End Date
    NSCalendar *gregorianEnd = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *componentsEnd = [gregorianEnd components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit //longnh add timezone
                                                      fromDate:today];
    
    NSInteger Enddayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    if (Enddayofweek == 1) { //longnh fix bug
        Enddayofweek = 8;
    }
    [componentsEnd setDay:([componentsEnd day]+(7-Enddayofweek)+1)];// for end day of the week
    
    NSDate *endOfWeek = [gregorianEnd dateFromComponents:componentsEnd];
    NSDateFormatter *dateFormat_End = [[NSDateFormatter alloc] init];
    [dateFormat_End setDateFormat:@"yyyy-MM-dd"];
    NSString *dateEndPrev = [dateFormat stringFromDate:endOfWeek];
    
    NSDate *weekEndPrev = [dateFormat_End dateFromString:dateEndPrev];
    weekEnd = [dateFormat_End stringFromDate:weekEndPrev];
    NSLog(@"EndDate:%@",weekEnd);
//    }
}



//*******************************************************************************//
#pragma mark - TableTopUserViewController delegate

-(void)goToDetailProfileViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
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



//****************************************************************************//
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listData count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    headerView.backgroundColor = COLOR_CONTEST_INFO;
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,30)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.shadowColor = [UIColor blackColor];
    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    tempLabel.text = [[_listData objectAtIndex:section] objectForKey:@"winner_name"];
    
    [headerView addSubview:tempLabel];
    
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"[_listWinners count]:%d",[_listWinners count]);
    return [_listWinners count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellContest *cell = [_tableViewContest dequeueReusableCellWithIdentifier:@"sbCustomCellContestId" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //-- set color background for cell
    if ((indexPath.row%2) == 0)
        cell.contentView.backgroundColor = COLOR_CONTEST_BOLD;
    else
        cell.contentView.backgroundColor = COLOR_CONTEST_REGULAR;
    
    //-- custom avatar of user to circle
    cell.imgAvatar.layer.borderWidth = 1.0f;
    cell.imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.imgAvatar.layer.cornerRadius = 18;
    cell.imgAvatar.layer.masksToBounds = YES;
    
    ListWinners *info = (ListWinners *)[_listWinners objectAtIndex:indexPath.row];
    
    //dynamic content textview
    CGFloat heightOfText = [Utility heightFromString:info.userStatus maxWidth:240 font:[UIFont systemFontOfSize:14.0f]];
    CGRect frame = cell.lblStatus.frame;
    frame.size.height = heightOfText+10;
    cell.lblStatus.frame= frame;
    
    //[Utility setHTMLContent:aComment.text forTextView:cell.txtViewComment];
    cell.lblFullName.text = info.userFullName;
    cell.lblPoint.text = [NSString stringWithFormat:@"Điểm: %@   thứ hạng: %@",info.userPoint, info.userRanking];
    cell.lblPoint.textColor = [UIColor yellowColor];
    
    [cell.imgAvatar setImageWithURL:[NSURL URLWithString:info.userAvatar] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"] completed:nil];
    
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightRow = 60;
    
    /*
    ListWinners *win = (ListWinners *)[_listWinners objectAtIndex:indexPath.row];
    
    CGFloat heightOfText = [Utility heightFromString:win.userStatus maxWidth:240 font:[UIFont systemFontOfSize:14.0f]];
    
    if (heightOfText < 20)
        heightRow = heightOfText + 46;
    else
        heightRow = heightOfText + 32;
     */
    
    return heightRow;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}


#pragma mark - UIWebviewDelegate

-(void)customWebView:(UIWebView*)aWebView
{
    aWebView.scrollView.scrollEnabled = YES;
    //-- remove background of webView and disable scroll view of webview
    [aWebView setOpaque:NO];
    [aWebView setBackgroundColor:[UIColor clearColor]];
    for (UIView* subView in [aWebView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            //-- disable scroll view of webview
            // ((UIScrollView *)(subView)).scrollEnabled = NO;
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                    [shadowView setHidden:YES];
            }
        }
    }
    //-- set attribute for webview
    aWebView.delegate=self;
    aWebView.scalesPageToFit = NO;
    aWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_activityIndicator) {
        [_activityIndicator stopAnimating];
        _activityIndicator.hidden = YES;
    }
    
    _wvContest.alpha = 1;
    
    float hw = webView.scrollView.contentSize.height;
    
    //-- set webview frame
    _wvContest.frame = CGRectMake(0, _txvSubject.frame.size.height + _tableViewContest.frame.size.height, webView.frame.size.width, hw);
    
    //-- set scrollview contentsize
    _scrollViewContest.contentSize = CGSizeMake(320, _txvSubject.frame.size.height + _tableViewContest.frame.size.height + _wvContest.frame.size.height);
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_activityIndicator) {
        [_activityIndicator stopAnimating];
        _activityIndicator.hidden = YES;
    }
}



@end
