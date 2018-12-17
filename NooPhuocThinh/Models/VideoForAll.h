//
//  VideoForAll.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/18/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Model for unofficial video and official video
 */

@interface VideoForAll : NSObject

@property (nonatomic, retain) NSString          *categoryID;
@property (nonatomic, retain) NSString          *albumAuthorMusicId;
@property (nonatomic, retain) NSString          *albumDescription;
@property (nonatomic, retain) NSString          *albumEngName;
@property (nonatomic, retain) NSString          *albumId;
@property (nonatomic, retain) NSString          *albumIsHot;
@property (nonatomic, retain) NSString          *albumMusicPublisherId;
@property (nonatomic, retain) NSString          *albumMusicType;
@property (nonatomic, retain) NSString          *albumName;
@property (nonatomic, retain) NSString          *albumPublishedYear;
@property (nonatomic, retain) NSString          *albumSetingTotalRating;
@property (nonatomic, retain) NSString          *albumSettingTotalView;
@property (nonatomic, retain) NSString          *albumThumbImagePath;
@property (nonatomic, retain) NSString          *albumTotalTrack;
@property (nonatomic, retain) NSString          *albumTrueTotalRating;
@property (nonatomic, retain) NSString          *albumTrueTotalView;
@property (nonatomic, retain) NSString          *categoryList;
@property (nonatomic, retain) NSString          *content;
@property (nonatomic, retain) NSString          *countryId;
@property (nonatomic, retain) NSString          *nodeId;
@property (nonatomic, retain) NSString          *name;
@property (nonatomic, retain) NSString          *musicPath;
@property (nonatomic, retain) NSString          *engName;
@property (nonatomic, retain) NSString          *isHot;
@property (nonatomic, retain) NSString          *musicType;
@property (nonatomic, retain) NSString          *numberOfTrack;
@property (nonatomic, retain) NSString          *musicContent;
@property (nonatomic, retain) NSString          *translateContent;
@property (nonatomic, retain) NSString          *thumbImagePath;
@property (nonatomic, retain) NSString          *thumbImageType;
@property (nonatomic, retain) NSString          *trueTotalView;
@property (nonatomic, retain) NSString          *trueTotalRating;
@property (nonatomic, retain) NSString          *youtubeUrl;
@property (nonatomic, retain) NSString          *settingTotalRating;
@property (nonatomic, retain) NSString          *settingTotalView;

@property (nonatomic, retain) NSString          *snsTotalComment;
@property (nonatomic, retain) NSString          *snsTotalLike;
@property (nonatomic, retain) NSString          *snsTotalDisLike;
@property (nonatomic, retain) NSString          *snsTotalShare;
@property (nonatomic, retain) NSString          *snsTotalView;
@property (nonatomic, retain) NSString          *isLiked;

//-- properties additional
@property (nonatomic, assign) NSInteger         numberOfLike;
@property (nonatomic, retain) NSMutableArray    *arrComments;
@property (nonatomic, retain) NSString          *url;

@end
