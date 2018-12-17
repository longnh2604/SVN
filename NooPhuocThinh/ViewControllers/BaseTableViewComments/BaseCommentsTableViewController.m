//
//  BaseCommentsTableViewController.m
//  NooPhuocThinh
//
//  Created by longnh on 1/5/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "BaseCommentsTableViewController.h"
#import "CellCustomComments.h"

@interface BaseCommentsTableViewController ()

@end

@implementation BaseCommentsTableViewController
@synthesize listDataComments,avtArray;
@synthesize delegateComments;
@synthesize nodeId;

//-- free memory
-(void) dealloc {
    
    [listDataComments release];
    [avtArray release];
    
    [super dealloc];
}

//****************************************************************************//
#pragma mark - Main

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
    
    //-- alloc data
    listDataComments = [[NSMutableArray alloc] init];
    avtArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//****************************************************************************//
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listDataComments count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //-- Configure the cell...
    CellCustomComments *cell = (CellCustomComments *)[self setTableViewCellWithIndexPath:indexPath];
    
    //-- Set background for TableView
    tableView.backgroundView = nil;
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    
    return cell;
}


//-- set up table view cell for iPhone
-(CellCustomComments *) setTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sbCellCustomCommentsId";
    CellCustomComments *cell = (CellCustomComments *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CellCustomComments" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CellCustomComments *) currentObject;
                break;
            }
        }
    }
    
    //-- set data for cell
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}


-(CellCustomComments *)setDataForTableViewCell:(CellCustomComments *)cell withIndexPath:(NSIndexPath *)indexPath
{
    //-- set color background for cell
    if ((indexPath.row%2) == 0)
        cell.contentView.backgroundColor = COLOR_PLAY_CELL_BOLD;
    else
        cell.contentView.backgroundColor = COLOR_PLAY_CELL_REGULAR;
    
    Comment *commentTrack = (Comment *)[listDataComments objectAtIndex:indexPath.row];
    
    //-- custom avatar of user to circle
    cell.imgAvatar.layer.borderWidth = 1.0f;
    cell.imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.imgAvatar.layer.cornerRadius = 22;
    cell.imgAvatar.layer.masksToBounds = YES;
    
    //dynamic content textview
    CGFloat heightOfText = [Utility heightFromString:commentTrack.content maxWidth:210 font:[UIFont systemFontOfSize:14.0f]];
    if (heightOfText < 60) {
        heightOfText = 60;
    }else{
        heightOfText = heightOfText + 10;
    }
    
    CGRect frame = cell.txtViewComment.frame;
    frame.size.height = heightOfText;
    cell.txtViewComment.frame = frame;
    [Utility setHTMLContent:[Utility convertTextInit:commentTrack.content] forTextView:cell.txtViewComment];
    cell.txtViewComment.scrollEnabled = NO;
    cell.txtViewComment.editable = NO;
    cell.txtViewComment.userInteractionEnabled = NO;
    cell.txtViewComment.textColor = [UIColor whiteColor];
    
    cell.lblNickName.text = commentTrack.profileUser.fullName;
    
    cell.lblDateTime.text = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[commentTrack.timeStamp integerValue]]];
    cell.lblPointOfUser.text = commentTrack.profileUser.point;
    cell.lblTotalChildComment.text = commentTrack.numberOfSubcommments;
    
    [cell.imgAvatar setImageWithURL:[NSURL URLWithString:commentTrack.profileUser.userImage] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"] completed:nil];
    cell.imgAvatar.tag = indexPath.row;
    cell.imgAvatar.userInteractionEnabled = YES;
    
    //--add tap gesture
    UITapGestureRecognizer *tapSelectAvt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToTapAvatar:)];
    [cell.imgAvatar addGestureRecognizer:tapSelectAvt];
    
    
    //-- set action for button
    [cell.btnShowListComments addTarget:self action:@selector(clickAddComment:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnShowListComments.tag = indexPath.row;
    
    return cell;
}

- (void)clickToTapAvatar:(UIGestureRecognizer *)sender
{
    NSInteger indexAlbum = [sender view].tag;
    
    Comment *aComment = (Comment *)[listDataComments objectAtIndex:indexAlbum];
    
    //-- pass Delegate
    [[self delegateComments] goToProfileScreenViewControllerByComment:aComment];
}


#pragma mark - UITableViewDelegate

//- fix crash tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//- (NSInteger)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger heightRow = 0;
    Comment *aComment = [listDataComments objectAtIndex:indexPath.row];
    //dynamic content textview
    CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:210 font:[UIFont systemFontOfSize:14.0f]];
    
    if (heightOfText < 60) {
        heightRow = 90;
    }else{
        heightRow = heightOfText + 40;
    }
    
    return heightRow;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //-- pass Delegate
    [[self delegateComments] goToCommentsScreenViewControllerWithListData:listDataComments withIndexRow:indexPath.row];
}



#pragma mark - Action

- (void)clickAddComment:(id)sender
{
    NSLog(@"clickAddComment");
}


@end
