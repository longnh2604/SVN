//
//  TableNewsViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 3/6/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "TableNewsViewController.h"

@interface TableNewsViewController ()

@end

@implementation TableNewsViewController

@synthesize listNews;
@synthesize delegate = _delegate;
@synthesize isShowLableNodata;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //--set background for TableView
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:COLOR_SEPARATOR_CELL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//****************************************************************************//
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isShowLableNodata == YES) {
        
        //-- remove lable nodata
        [self removeLableNoDataFromTableView:self.tableView withIndex:0];
        
        if ([listNews count] == 0) {
            
            //-- Load the news
            CGRect frame = [self.tableView frame];
            frame.origin.x = 0.0f;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            //-- add lable no data
            [self addLableNoDataToTableView:self.tableView withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
        }
    }
    
    return listNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCellCustom *cell = [self setCustomTableViewCellForWithIndexPath:indexPath];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//longnh
    
    return cell;
}

//-- set up table view cell for iPhone
-(NewsCellCustom *) setCustomTableViewCellForWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sbNewsCellCustomId";
    NewsCellCustom *cell = (NewsCellCustom *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCellCustom" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (NewsCellCustom *) currentObject;
                break;
            }
        }
    }
    
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}

-(NewsCellCustom *)setDataForTableViewCell:(NewsCellCustom *)cell withIndexPath:(NSIndexPath *)indexPath
{
    //-- set color background for cell
//    if ((indexPath.row%2) == 0)
//        cell.imgViewBackground.image = [UIImage imageNamed:@"bg_tintuc2.png"];
//    else
//        cell.imgViewBackground.image = [UIImage imageNamed:@"bg_tintuc1.png"];
//longnh
    if ((indexPath.row%2) == 0)
        cell.contentView.backgroundColor = COLOR_NEWS_CELL_BOLD;
    else
        cell.contentView.backgroundColor = COLOR_NEWS_CELL_REGULAR;
    cell.backgroundColor = [UIColor clearColor];
    
    if ([listNews count]>0) {
        
        News *news =  (News*)[listNews objectAtIndex:indexPath.row];
        
        [cell.imgViewAvatar setImageWithURL:[NSURL URLWithString:news.thumbnailImagePath]
                           placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
        NSLog(@"image size w:%f h:%f",cell.imgViewAvatar.image.size.width,cell.imgViewAvatar.image.size.height);

        [cell.imgViewAvatar setContentMode:UIViewContentModeScaleAspectFill];
        [cell.imgViewAvatar setClipsToBounds:YES];
        [Utility scaleImage:cell.imgViewAvatar.image toSize:CGSizeMake(80, 80)];
        
        if(news)
        {
            cell.lblTitle.text = news.title;
            cell.lblShortContent.text = news.shortBody;
            cell.lblCommentCount.text = [NSString stringWithFormat:@"%d",news.snsTotalComment];
            cell.lblDate.text = [Utility relativeTimeFromDate:[Utility dateFromString:news.lastUpdate]];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //-- pass Delegate
    [[self delegate] goToDetailNewsViewControllerWithListData:listNews withIndexRow:indexPath.row];
}


#pragma mark - Add or Remove label Nodata

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

@end
