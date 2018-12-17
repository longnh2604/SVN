//
//  BaseTableVideoViewController.m
//  NooPhuocThinh
//
//  Created by longnh on 1/3/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "BaseTableVideoViewController.h"
#import "CellCustomVideoList.h"
#import "UIImage+ProportionalFill.h"

@interface BaseTableVideoViewController ()

@end

@implementation BaseTableVideoViewController


@synthesize listData;
@synthesize delegateVideo;
@synthesize videoTypeId;

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
    
    //--set background for TableView
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
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
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellCustomVideoList *cell = [self setCustomTableViewCellForWithIndexPath:indexPath];
    
    return cell;
}

//-- set up table view cell for iPhone
-(CellCustomVideoList *) setCustomTableViewCellForWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellCustomVideoList";
    CellCustomVideoList *cell = (CellCustomVideoList *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CellCustomVideoList" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CellCustomVideoList *) currentObject;
                break;
            }
        }
    }
    
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}

-(CellCustomVideoList *)setDataForTableViewCell:(CellCustomVideoList *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NSString *isLike;
    
    if ([listData count]>0) {
        
        if (videoTypeId == ContentTypeIDVideo || videoTypeId == ContentTypeIDAllVideo) {
            
            if (videoTypeId == ContentTypeIDAllVideo) {
                
                VideoAllModel *videoInfo = [listData objectAtIndex:indexPath.row];
                
                isLike = videoInfo.isLiked;
                
                cell.lblNameVideo.text = videoInfo.name;
                cell.lblCountPlay.text = videoInfo.snsTotalView;
                cell.lblCountLike.text = videoInfo.snsTotalLike;
                cell.lblCountComments.text = videoInfo.snsTotalComment;
                cell.lblCountShares.text = videoInfo.snsTotalShare;
                
                NSString *urlThumbnailImagePath = @"";
                if ([videoInfo.youtube_url length] < 5) {
                    
                    urlThumbnailImagePath = videoInfo.thumbnail_image_file_path;
                }else {
                    urlThumbnailImagePath = [Utility getImageNameFromYoutube_url:videoInfo.youtube_url];
                }
                
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlThumbnailImagePath] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
                 {
                     if(image !=nil) {
                         
                         cell.imgViewVideo.image = image;
                     }
                     else
                         cell.imgViewVideo.image = [UIImage imageNamed:@"VideoDefault.png"];
                 }];
                
            }else {
                
                VideoForAll *videoInfo = [listData objectAtIndex:indexPath.row];
                
                isLike = videoInfo.isLiked;
                cell.lblNameVideo.text = videoInfo.name;
                cell.lblCountPlay.text = videoInfo.snsTotalView;
                cell.lblCountLike.text = videoInfo.snsTotalLike;
                cell.lblCountComments.text = videoInfo.snsTotalComment;
                cell.lblCountShares.text = videoInfo.snsTotalShare;
                
                NSString *urlThumbnailImagePath = @"";
                if ([videoInfo.youtubeUrl length] < 5) {
                    
                    urlThumbnailImagePath = videoInfo.thumbImagePath;
                }else {
                    urlThumbnailImagePath = [Utility getImageNameFromYoutube_url:videoInfo.youtubeUrl];
                }
                
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlThumbnailImagePath] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
                 {
                     if(image !=nil) {
                         
                         cell.imgViewVideo.image = image;
                     }
                     else
                         cell.imgViewVideo.image = [UIImage imageNamed:@"VideoDefault.png"];
                 }];
            }
            
        }else {
            
            VideoForCategory *videoInfo = [listData objectAtIndex:indexPath.row];
            
            isLike = videoInfo.isLiked;
            cell.lblNameVideo.text = videoInfo.title;
            cell.lblCountPlay.text = videoInfo.snsTotalView;
            cell.lblCountLike.text = videoInfo.snsTotalLike;
            cell.lblCountComments.text = videoInfo.snsTotalComment;
            cell.lblCountShares.text = videoInfo.snsTotalShare;
            
            NSString *urlThumbnailImagePath = @"";
            if ([videoInfo.youtubeUrl length] < 5) {
                
                urlThumbnailImagePath = videoInfo.thumbnailImagePath;
            }else {
                urlThumbnailImagePath = [Utility getImageNameFromYoutube_url:videoInfo.youtubeUrl];
            }
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlThumbnailImagePath] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 if(image !=nil) {
                     
                     cell.imgViewVideo.image = image;
                 }
                 else
                     cell.imgViewVideo.image = [UIImage imageNamed:@"VideoDefault.png"];
                 
             }];
        }
        
        //-- set status like button
        if ([isLike isEqualToString:@"0"])
            [cell.btnLike setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
        else
            [cell.btnLike setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
    }
    
    [cell.imgViewVideo setClipsToBounds:YES];
    [cell.imgViewVideo setContentMode:UIViewContentModeScaleAspectFill];
    
    cell.imgLine.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //-- pass Delegate
    [[self delegateVideo] goToVideoPlayViewControllerWithListData:listData withVideoTypeId:videoTypeId withIndexRow:indexPath.row];
    
    //longnh add
    //VideoAllModel *videoInfo = [listData objectAtIndex:indexPath.row];
    //modified by TuanNM
    //
    NSObject *videoInfo = [listData objectAtIndex:indexPath.row];
    NSString *name = @"";
    if ([videoInfo respondsToSelector:@selector(name)])
        name = [videoInfo name];
    else
        name = [videoInfo title];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"play_video"  // Event action (required)
                                                           label:name
                                                           value:nil] build]];
    //end modified

}



@end
