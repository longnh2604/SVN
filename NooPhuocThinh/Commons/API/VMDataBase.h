//
//  VMDataBase.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/20/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    DBResultOpenSuccessful = 0,
    DBResultOpenFails,
    DBResultClose_Successful,
    DBResultCloseFails,
    DBResultStatementSuccessful,
    DBResultStatementFails
    
}DBResult;

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
#import "VMConstant.h"
#import "ShoutBoxData.h"
#import "News.h"
#import "CategoryBySinger.h"
#import "MusicAlbum.h"
#import "MusicTrackNew.h"
#import "ListAlbumPhoto.h"
#import "ListPhotosInAlbum.h"
#import "Schedule.h"
#import "SingerInfo.h"
#import "TopUser.h"
#import "Store.h"
#import "VideoAllModel.h"
#import "VideoForAll.h"
#import "VideoForCategory.h"
#import "Utility.h"
#import "ListFeedData.h"
#import "PhotoListFeedData.h"

@interface VMDataBase : NSObject


#pragma mark - connection

+ (FMDatabase *)getNewDBConnection;

#pragma mark - fanzone

/*
 * get all rows at DB_TABLE_SHOUTBOXDATA
 */
+ (NSMutableArray *)getAllMessagesFanZone;

/*
 * get all rows at DB_TABLE_SHOUTBOXDATA with start time and end time is unix time
 */
+ (NSMutableArray *)getAllMessagesFanZoneWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime;

/*
 * get all rows at DB_TABLE_SHOUTBOXDATA before time, time is unix time
 */
+ (NSMutableArray *)getAllMessagesFanZoneBeforeTime:(NSInteger)time;

/*
 * insert a row at DB_TABLE_SHOUTBOXDATA
 */
+ (DBResult)insertShoutBoxData:(Comment*)aMessage;

/*
 * update a row at DB_TABLE_SHOUTBOXDATA with numberOfSubComments
 */
+(DBResult) updateShoutBoxData:(Comment*)aMessage;

/*
 * delete all rows at DB_TABLE_SHOUTBOXDATA
 */
+ (DBResult)deleteAllMesaageFanZoneDataBase;

/*
 * delete a row at DB_TABLE_SHOUTBOXDATA
 */
+ (DBResult)deleteMessageFanzoneWithShoutBoxData:(Comment*)aMessage;

/*
 * delete all rows at DB_TABLE_SHOUTBOXDATA with start time and end time is unix time
 */
+ (DBResult)deleteMessagesFanZoneWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime;

#pragma mark - Feeds

+ (DBResult) deleteAllFeedsFromDB;

+ (DBResult) insertFeedBySinger:(ListFeedData*)feedBySinger;

+ (NSMutableArray *) getAllFeeds:(NSString *)feedParentId;

+ (DBResult) insertPhotoListFeedBySinger:(PhotoListFeedData*)feedBySinger;

+ (NSMutableArray *) getAllPhotoFeeds:(NSString *)albumId;

+ (DBResult)deleteAllPhotoFeedsFromDB;

#pragma mark - News

/*
 * get all rows at DB_TABLE_NEWS
 */
+ (NSMutableArray *)getAllNews;

/*
 * get all rows with categoryID at DB_TABLE_NEWS
 */
+ (NSMutableArray *) getAllNewsWithCategoryID:(NSString *)categoryID;


/*
 get all news by page for category
 */
+ (NSMutableArray *) getAllNewsWithCategoryIDPerPage:(NSString *)categoryID pageId:(NSInteger)pageId pageSize:(NSInteger)pageSize;

+ (News *) getANewsByCategoryId:(NSString *)nodeId;

/*
 * insert a row at DB_TABLE_NEWS
 */
+ (DBResult)insertWithNews:(News*)aNews;

/*
 * update a row at DB_TABLE_NEWS
 */
+(DBResult)updateWithNews:(News*)aNews;

/*
 * delete all rows at DB_TABLE_NEWS
 */
+ (DBResult)deleteAllNews;

/*
 * delete a row at DB_TABLE_NEWS
 */
+ (DBResult)deleteNewsWithID:(NSString*)newsID;

/*
 * delete multiple rows with categoryID at DB_TABLE_NEWS
 */
+ (DBResult)deleteNewsWithCategoryID:(NSString *)categoryID;


#pragma mark - category by singer

/*
 * gets multiple rows with contentType at DB_TABLE_CATEGORY_SINGER
 */
+ (NSMutableArray *) getAllCategoryForContentType:(ContentTypeID)contentType;

/*
 * insert a row with CategoryBySinger at DB_TABLE_CATEGORY_SINGER
 */
+ (DBResult) insertCategoryBySinger:(CategoryBySinger*)categoryBySinger;

/*
 * delete multiple rows with contentType at DB_TABLE_CATEGORY_SINGER
 */
+ (DBResult)deleteAllCategoriesForContentTypeId:(ContentTypeID)contentType;



#pragma mark - Music

//-- Music Album --//
/**
 *  get multiple rows with contentType at DB_TABLE_MUSIC_ALBUM
 **/
+ (NSMutableArray *) getAllAlbumForContentType:(ContentTypeID)contentType;

/**
 * insert a row with MusicAlbum at DB_TABLE_MUSIC_ALBUM
 **/
+ (DBResult) insertAlbumBySinger:(MusicAlbum*)albumBySinger;

/**
 * delete multiple rows with contentType at DB_TABLE_MUSIC_ALBUM
 **/
+ (DBResult)deleteAllAlbumFromDB;


//-- Music Track --//

/**
 *  get multiple rows with contentType at DB_TABLE_MUSIC_TRACK
 **/
+ (NSMutableArray *) getAllTrackByAlbumId:(NSString *)albumId;

+ (MusicTrackNew *) getATrackByNodeId:(NSString *)nodeId;

/**
 * insert a row with MusicAlbum at DB_TABLE_MUSIC_TRACK
 **/
+ (DBResult) insertTrackByAlbum:(MusicTrackNew*)trackInAlbum;

/**
 * update a row with MusicAlbum at DB_TABLE_MUSIC_TRACK
 **/
+ (DBResult)updateTrackByAlbum:(MusicTrackNew*)trackInAlbum;

/**
 * delete multiple rows with contentType at DB_TABLE_MUSIC_TRACK
 **/
+ (DBResult)deleteAllTrackByAlbumId:(NSString *)albumId;

+ (DBResult)deleteTrackByNodeId:(NSString *)nodeId;


#pragma mark - Category By Video

/*
 * gets multiple rows with contentType at DB_TABLE_CATEGORY_VIDEO
 */
+ (NSMutableArray *) getAllCategoryVideoForContentType:(ContentTypeID)contentType;

/*
 * insert a row with CategoryBySinger at DB_TABLE_CATEGORY_VIDEO
 */
+ (DBResult) insertCategoryByVideo:(CategoryBySinger*)categoryBySinger;

/*
 * delete multiple rows with contentType at DB_TABLE_CATEGORY_VIDEO
 */
+ (DBResult)deleteAllCategoriesByVideoForContentTypeId:(ContentTypeID)contentType;



//-- Video OffiCial and UnOffiCial Of Album --//

/**
 *  get multiple rows with contentType at Video OffiCial Of Album
 **/
+ (NSMutableArray *) getAllVideosOffiCialByCategoryId:(NSString *)categoryIdStr;

/**
 *  get multiple rows with contentType at Video UnOffiCial Of Album
 **/
+ (NSMutableArray *) getAllVideosUnOffiCialByCategoryId:(NSString *)categoryIdStr;


/**
 *  get a rows with contentType at Video UnOffiCial Of Album
 **/
+ (VideoForCategory *) getAVideosUnOffiCialBynodeID:(NSString *)nodeIdStr categoryId:(NSString *)categoryId;

+ (NSMutableArray *) getAllVideosUnOffiCial:(NSString *)categoryId; ;
+ (NSMutableArray *) getAllVideosOffiCial:(NSString *)categoryId;;


/**
 *  get a rows with contentType at Video OffiCial Of Album
 **/
+ (VideoForAll *) getAVideosOffiCialByNodeId:(NSString *)nodeId categoryId:(NSString *)categoryId;


/**
 * insert a row with Video OffiCial Of Album
 **/
+ (DBResult) insertVideosOffiCial:(VideoForAll *) videoOffiCial;

/**
 * insert a row with Video UnOffiCial Of Album
 **/
+ (DBResult) insertVideosUnOffiCial:(VideoForCategory *) videoUnOffiCial;


/**
 * update a row with Video OffiCial and UnOffiCial Of Album
 **/
+ (DBResult)updateVideosOffiCial:(VideoForAll *) videoOffiCial;

/**
 * update a row with Video OffiCial and UnOffiCial Of Album
 **/
+ (DBResult)updateVideosUnOffiCial:(VideoForCategory *) videoUnOffiCial;


/**
 * delete multiple rows with contentType at Video OffiCial Of Album
 **/
+ (DBResult)deleteAllVideosOffiCialByCategoryId:(NSString *)categoryIdStr;

/**
 * delete multiple rows with contentType at Video UnOffiCial Of Album
 **/
+ (DBResult)deleteAllVideosUnOffiCialByCategoryId:(NSString *)categoryIdStr;


/**
 * delete a rows with contentType at Video UnOffiCial Of Album
 **/
+ (DBResult)deleteAVideosUnOffiCialByBynodeID:(NSString *)nodeIdStr categoryId:(NSString *)categoryId;;


/**
 * delete a rows with contentType at Video OffiCial Of Album
 **/
+ (DBResult)deleteAVideosOffiCialByNodeId:(NSString *)nodeId categoryId:(NSString *)categoryId;;


/**
 *  get multiple rows with contentType at Video
 **/
+ (NSMutableArray *) getAllVideos;


/**
 *  get multiple rows with contentType at Video
 **/
+ (VideoAllModel *) getAVideosBynodeID:(NSString *)nodeIdStr;

/**
 * insert a row with Video
 **/
+ (DBResult) insertVideosOfTBVideoAll:(VideoAllModel *) video;

/**
 * update a row with Video
 **/
+ (DBResult)updateVideosOfTBVideoAll:(VideoAllModel *) video;

/**
 * delete multiple rows with contentType at Video
 **/
+ (DBResult)deleteAllVideosOfTBVideoAll;

/**
 * delete a rows with contentType at Video UnOffiCial Of Album
 **/
+ (DBResult)deleteAVideosOfTBVideoAllBynodeID:(NSString *)nodeIdStr;


#pragma mark - Photo

//-- Photo Album --//
/**
 *  get multiple rows with contentType at DB_TABLE_PHOTO_ALBUM
 **/
+ (NSMutableArray *) getAllAlbumPhotoForContentType:(ContentTypeID)contentType;

/**
 * insert a row with MusicAlbum at DB_TABLE_PHOTO_ALBUM
 **/
+ (DBResult) insertAlbumPhotoBySinger:(ListAlbumPhoto*)albumBySinger;

/**
 * delete multiple rows with contentType at DB_TABLE_PHOTO_ALBUM
 **/

+ (DBResult) updateAlbumTotalPhotoBySinger:(NSString *)abId totalPhoto:(NSInteger)totalPhoto;

+ (DBResult)deleteAllAlbumPhotoFromDB;


//-- Photos in Album --//
/**
 *  get multiple rows with contentType at DB_TABLE_PHOTO_DETAILS
 **/
+ (NSMutableArray *) getAllPhotoInAlbumByAlbumId:(NSString *)albumId;

/**
 *  get getAPhotoAlbumByNodeId rows with nodeId at DB_TABLE_PHOTO_DETAILS
 **/
+ (ListPhotosInAlbum *) getAPhotoAlbumByNodeId:(NSString *)nodeId;

/**
 * insert a row with MusicAlbum at DB_TABLE_PHOTO_DETAILS
 **/
+ (DBResult) insertPhotoInAlbumoBySinger:(ListPhotosInAlbum*)albumBySinger;

/**
 * update a row with MusicAlbum at DB_TABLE_PHOTO_DETAILS
 **/
+ (DBResult)updatePhotoInAlbumBySinger:(ListPhotosInAlbum*)albumBySinger;

/**
 * delete multiple rows with contentType at DB_TABLE_PHOTO_DETAILS
 **/
+ (DBResult)deleteAllPhotoInAlbumByAlbumId:(NSString *)albumId;



#pragma mark - Schedule

//-- Schedule --//
/**
 *  get multiple rows with contentType at DB_TABLE_SCHEDULE
 **/
+ (NSMutableArray *) getAllScheduleByCategoryid:(NSString *)categoryId;

+ (Schedule *) getAScheduleByNodeId:(NSString *)nodeId;

/**
 * insert a row with MusicAlbum at DB_TABLE_SCHEDULE
 **/
+ (DBResult) insertSchedule:(Schedule*)schedule;

/**
 * update a row with MusicAlbum at DB_TABLE_SCHEDULE
 **/
+ (DBResult)updateSchedule:(Schedule*)schedule;

/**
 * delete multiple rows with contentType at DB_TABLE_SCHEDULE
 **/
+ (DBResult) deleteAllScheduleByCategory:(NSString *)categoryId;


#pragma mark - TopUser

//-- Top User --//
/**
 *  get multiple rows with contentType at DB_TABLE_TOPUSER
 **/
+ (NSMutableArray *) getAllTopUserByCategoryid:(NSString *)categoryId;

/**
 * insert a row with MusicAlbum at DB_TABLE_TOPUSER
 **/
+ (DBResult) insertTopUser:(TopUser *)topUser;

/**
 * delete multiple rows with contentType at DB_TABLE_TOPUSER
 **/
+ (DBResult) deleteAllTopUserByCategory:(NSString *)categoryId;


#pragma mark - Store

/*
 * get all rows at DB_TABLE_STORE
 */
+ (NSMutableArray *)getAllStore;

/*
 * get all rows with category ID at DB_TABLE_STORE
 */
+ (NSMutableArray *) getAllStoreWithCategoryID:(NSString *)categoryID;

/*
 * insert a row at DB_TABLE_STORE
 */
+ (DBResult)insertWithStore:(Store*)aStore;

/*
 * delete all rows at DB_TABLE_STORE
 */
+ (DBResult)deleteAllStore;

/*
 * delete multiple rows at DB_TABLE_STORE with categoryID
 */
+ (DBResult)deleteStoreWithCategoryID:(NSString *)categoryID;

//update comment
+(DBResult)updateLikeCommentShare:(ListFeedData*)aNews;

@end
