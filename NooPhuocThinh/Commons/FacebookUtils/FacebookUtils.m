//
//  FacebookUtils.m
//  AGKGlobal
//
//  Created by Thuy Dao on 6/21/13.
//  Copyright (c) 2013 Thuy Dao. All rights reserved.
//

#import "FacebookUtils.h"
#import "MulticastDelegate.h"

@interface FacebookUtils ()
{
    MulticastDelegate<FacebookUtilsDelegate> *delegates;
}

+ (FacebookUtils*)shared;

- (FBSession*)facebookSession;
- (BOOL)isAuthorized;
- (void)logInFacebook;
- (void)logOutFacebook;
- (void)resetFacebookSession;

- (void) refreshNewsFeed:(NSString*)query;

- (void) like:(NSString*)postID HTTPMethod:(NSString*)method;

- (void)requestProfileWithID:(NSString*)userID;

- (void)getMe;

- (void)refreshFriends;

- (void)comment:(NSString*)postID withText:(NSString*)text;

- (void)getCommentForPost:(NSString*)PostID;

- (void)getCommentForID:(NSString *)CommentID;

- (void)getPost:(NSString*)PostID;

- (void)getALLFriendsList;

- (void)getProfilesList:(NSString*)listId;

- (void)getPagesList:(NSString*)listId;

- (void)getNewsFeedSeeMore:(NSInteger)limitNumber;

- (void)getComment:(NSString *)PostID seeMore:(NSInteger)offset;

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication;

- (void)getPlace:(NSString*)checkinID;

- (void) getNearbyPlaces:(CLLocation*)location;

- (void)hidenPost:(NSString*)postID;

- (void)getDetailPhoto:(NSString*)pid;

- (void)sharePost:(NSString*)url text:(NSString*)text audience:(NSMutableDictionary*)audienceDict;

- (void)multiQuery:(NSString*)querry;

- (void)getNewFeedsMultiQuery;

- (void)getSeeMoreNewFeedsMultiQuery:(NSString*)limit;

- (void)getNewsFeedStories;

- (void)deletePost:(NSString*)postID;

@end

static FacebookUtils *_wkFacebook = nil;

@implementation FacebookUtils


#pragma mark - CLASS METHODS

+ (FacebookUtils*)shared
{
    if (!_wkFacebook) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _wkFacebook = [[FacebookUtils alloc] init];
        });
    }
    return _wkFacebook;
}

+ (void)initWithDelegate:(id<FacebookUtilsDelegate>) delegate
{
    [[FacebookUtils shared] addDelegate:delegate];
}

+ (FBSession*)facebookSession
{
    return [[FacebookUtils shared] facebookSession];
}

+ (void)resetFacebookSession
{
    [[FacebookUtils shared] resetFacebookSession];
}

- (void)resetFacebookSession
{
    __fbSession = nil;
}

+ (void)logInFacebook
{
    [[FacebookUtils shared] logInFacebook];
}

+ (BOOL)isAuthorized
{
    return [[FacebookUtils shared] isAuthorized];
}

+ (BOOL)isOpen
{
    return [FBSession activeSession].isOpen;
}

+ (void)logOutFacebook
{
    return [[FacebookUtils shared] logOutFacebook];
}

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication
{
    return [[FacebookUtils shared] handleOpenURL:url sourceApplication:sourceApplication];
}

#pragma mark - PRIVATR METHOD

- (void)facebookSessionInit
{
    
    NSArray *permissions = [NSArray arrayWithObjects:
                            @"email",
                            @"user_location",
                            @"read_stream",
                            @"user_status",
                            @"user_birthday",
                            @"public_profile",
                            @"publish_stream",
                            @"publish_checkins",
                            @"publish_actions",
                            @"user_status",
                            @"friends_status",
                            @"offline_access",
                            @"export_stream",
                            @"read_requests",
                            @"share_item",
                            @"export_stream",
                            @"user_activities",
                            @"user_photos",
                            @"friends_photos",
                            @"friends_likes",
                            @"user_likes",
                            @"read_insights",
                            @"read_friendlists",
                            nil];
    
    __fbSession = [[FBSession alloc] initWithPermissions:permissions];
}

- (id)init
{
    self = [super init];
    [self facebookSessionInit];
    delegates = (MulticastDelegate<FacebookUtilsDelegate>*) [[MulticastDelegate alloc] init];
    return self;
}

- (FBSession*)facebookSession
{
    return __fbSession;
}

- (void)logInFacebook
{
    if (__fbSession == nil) {
        NSLog(@"relogin");
        [self facebookSessionInit];
    }
    
    if (__fbSession) {
        
        if (__fbSession.state == FBSessionStateCreated || __fbSession.state == FBSessionStateCreatedTokenLoaded) {
            
            [__fbSession openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
                
                [FBSession setActiveSession:session];
                
                if (status == FBSessionStateOpen) {
                    if ([delegates respondsToSelector:@selector(facebook:didLoginFinish:)]) {
                        [delegates facebook:self didLoginFinish:__fbSession.accessTokenData.accessToken];
                    }
                }
                else if (status == FBSessionStateClosedLoginFailed) {
                    if ([delegates respondsToSelector:@selector(facebook:didLoginFail:)])
                        [delegates facebook:self didLoginFail:error];
                }
            }];
        }
    }
}

- (BOOL)isAuthorized
{
    if (__fbSession != nil) {
        return [__fbSession isOpen];
    }
    return NO;
}

- (void)logOutFacebook
{
    if (__fbSession) {
        [__fbSession closeAndClearTokenInformation];
        __fbSession = nil;
        if ([delegates respondsToSelector:@selector(facebook:didLogout:)]) {
            [delegates facebook:self didLogout:YES];
        }
    }
    
}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:__fbSession];
}

#pragma mark thuy development

+ (void) refreshNewsFeed:(NSString*)query
{
    [[FacebookUtils shared] refreshNewsFeed:query];
}

//method = POST: like   or = DELETE: unlike
+ (void) like:(NSString*)postID HTTPMethod:(NSString*)method
{
    [[FacebookUtils shared] like:postID HTTPMethod:method];
}

+ (void)requestProfileWithID:(NSString*)userID
{
    [[FacebookUtils shared] requestProfileWithID:userID];
}

+ (void)getNewFeedsMultiQuery
{
    [[FacebookUtils shared] getNewFeedsMultiQuery];
}

+ (void)getSeeMoreNewFeedsMultiQuery:(NSString*)limit
{
    [[FacebookUtils shared] getSeeMoreNewFeedsMultiQuery:limit];
}

+ (void)getNewsFeedStories
{
    [[FacebookUtils shared] getNewsFeedStories];
}

+ (void)getPagesList:(NSString*)listId
{
    [[FacebookUtils shared] getPagesList:listId];
}

+ (void)deletePost:(NSString*)postID
{
    [[FacebookUtils shared] deletePost:postID];
}

- (void) refreshNewsFeed:(NSString*)query
{
    
    if (![self isAuthorized]) {
        return;
    }
    
    [NetworkActivity show];
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    if ([query length] < 1) {
        query = [NSString stringWithFormat:@"SELECT post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting, permalink FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = 'newsfeed') AND is_hidden = 0 %@ LIMIT 10",[Utility getStringQueryNewsFeed]];
    }
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      id result,
                                      NSError *error) {
        [NetworkActivity hide];
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didRefeshNewFeedFinish:)]) {
                [delegates facebook:self didRefeshNewFeedFinish:result];
            }
        }
        else
        {
            if ([delegates respondsToSelector:@selector(facebook:didRefeshNewFeedFail:)]) {
                [delegates facebook:self didRefeshNewFeedFail:error];
            }
        }
    }];
    
}

- (void) like:(NSString*)postID HTTPMethod:(NSString*)method
{
    if (![self isAuthorized]) {
        return;
    }
    [NetworkActivity show];
    
    FBRequest *request = [FBRequest requestWithGraphPath:[NSString stringWithFormat:@"%@/likes", postID] parameters:nil HTTPMethod:method];
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [connection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        [NetworkActivity hide];
        
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didLikeFinish:)]) {
                [delegates facebook:self didLikeFinish:result];
            }
        }
        else
        {
            if ([delegates respondsToSelector:@selector(facebook:didLikeFail:)]) {
                [delegates facebook:self didLikeFail:error];
            }
        }
        
    }];
    [connection start];
}

- (void)requestProfileWithID:(NSString*)userID
{
    if (![self isAuthorized]) {
        return;
    }
    
    if (userID == nil)
    {
        if ([delegates respondsToSelector:@selector(facebook:didGetUserInfoFail:)]) {
            NSError* err1 = nil;
            [delegates facebook:self didGetUserInfoFail:err1];
        }
    }
    else {
        
        //http://stackoverflow.com/questions/6461312/fql-query-to-select-friends-that-go-to-same-college //
        FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
        NSString *query = [NSString stringWithFormat:@"SELECT name,id,pic,type,url,username FROM profile WHERE id = %@",userID];
        
        [fql.parameters setObject:query forKey:@"q"];
        [fql.parameters setObject:[[FBSession activeSession] accessTokenData].accessToken forKey:@"access_token"];
        NSLog(@"requestProfileWithID.fql=%@",fql);
        
        [NetworkActivity show];
        [fql startWithCompletionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
            
            [NetworkActivity hide];
            
            if (result) {
                if ([delegates respondsToSelector:@selector(facebook:didGetUserInfoFinish:)]) {
                    [delegates facebook:self didGetUserInfoFinish:result];
                }
            }
            else {
                if ([delegates respondsToSelector:@selector(facebook:didGetUserInfoFail:)]) {
                    [delegates facebook:self didGetUserInfoFail:error];
                }
            }
        }];
        
    }
}

+ (void)getMe
{
    [[FacebookUtils shared] getMe];
}

- (void)getMe
{
    
    if (![self isAuthorized]) {
        return;
    }
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"me?fields=id,name,picture,location,email"];
    
    [NetworkActivity show];
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      FBGraphObject *result,
                                      NSError *error) {
        [NetworkActivity hide];
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didGetMeFinish:)]) {
                [delegates facebook:self didGetMeFinish:result];
            }
        } else {
            if ([delegates respondsToSelector:@selector(facebook:didGetMeFail:)]) {
                [delegates facebook:self didGetMeFail:error];
            }
        }
    }];
    
}

+ (void)refreshFriends
{
    [[FacebookUtils shared] refreshFriends];
}

- (void)refreshFriends
{
    if (![self isAuthorized]) {
        return;
    }
    
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    // http://stackoverflow.com/questions/6461312/fql-query-to-select-friends-that-go-to-same-college //
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    NSString *query = @"SELECT name,first_name,last_name,uid,pic,current_location FROM user WHERE uid IN (SELECT uid1 FROM friend WHERE uid2=me())";
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    
    
    NSLog(@"self.myFacebookToken: %@",myFacebookToken);
    
    [NetworkActivity show];
    
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      FBGraphObject *result,
                                      NSError *error) {
        
        [NetworkActivity hide];
        
        NSLog(@"conn:3");
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didGetReFeshFriendFinish:)]) {
                [delegates facebook:self didGetReFeshFriendFinish:result];
            }
        } else {
            if ([delegates respondsToSelector:@selector(facebook:didGetReFeshFriendFail:)]) {
                [delegates facebook:self didGetReFeshFriendFail:error];
            }
        }
    }];
    
}

+ (void)comment:(NSString*)postID withText:(NSString*)text
{
    [[FacebookUtils shared] comment:postID withText:text];
}

- (void)comment:(NSString *)postID withText:(NSString *)text
{
    if (![self isAuthorized]) {
        return;
    }
    
    NSDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:text, @"message", nil];
    
    FBRequest *request = [FBRequest requestWithGraphPath:[NSString stringWithFormat:@"%@/comments", postID] parameters:parameters HTTPMethod:@"POST"];
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [NetworkActivity show];
    
    [connection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        [NetworkActivity hide];
        
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didCommentFinish:)]) {
                [delegates facebook:self didCommentFinish:result];
            }
        }
        else
        {
            if ([delegates respondsToSelector:@selector(facebook:didCommentFail:)]) {
                [delegates facebook:self didCommentFail:error];
            }
        }
        
    }];
    [connection start];
    
}

+ (void)getCommentForPost:(NSString*)PostID
{
    [[FacebookUtils shared] getCommentForPost:PostID];
}

+ (void)getCommentForID:(NSString *)CommentID
{
    [[FacebookUtils shared] getCommentForID:CommentID];
}

- (void)getCommentForID:(NSString *)CommentID
{
    if (![self isAuthorized]) {
        return;
    }
    
    [NetworkActivity show];
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    
    //SELECT text,post_id  FROM comment  WHERE post_id IN(SELECT post_id  FROM stream  WHERE source_id=page_id_here)
    
    NSString* query = [NSString stringWithFormat:@"SELECT text, post_id, user_likes, time, text_tags, likes, id, fromid FROM comment  WHERE id ='%@'",CommentID];
    
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      id result,
                                      NSError *error) {
        
        [NetworkActivity hide];
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didGetCommentForIDFinish:)]) {
                [delegates facebook:self didGetCommentForIDFinish:result];
            }
        }
        else
        {
            if ([delegates respondsToSelector:@selector(facebook:didGetCommentForIDFail:)]) {
                [delegates facebook:self didGetCommentForIDFail:error];
            }
        }
    }];
    
}

- (void)getCommentForPost:(NSString *)PostID
{
    if (![self isAuthorized]) {
        return;
    }
    
    [NetworkActivity show];
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    
    NSString* query = [NSString stringWithFormat:@"SELECT text, post_id, user_likes, time, text_tags, likes, id, fromid FROM comment  WHERE post_id ='%@' LIMIT 10",PostID];
    
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      id result,
                                      NSError *error) {
        
        [NetworkActivity hide];
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didGetCommentForPostFinish:)]) {
                [delegates facebook:self didGetCommentForPostFinish:result];
            }
        }
        else
        {
            if ([delegates respondsToSelector:@selector(facebook:didGetCommentForPostFail:)]) {
                [delegates facebook:self didGetCommentForPostFail:error];
            }
        }
    }];
    
}

+ (void)getPost:(NSString*)PostID
{
    [[FacebookUtils shared] getPost:PostID];
}

- (void)getPost:(NSString *)PostID
{
    if (![self isAuthorized]) {
        return;
    }
    
    
    [NetworkActivity show];
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    
    NSString* query = [NSString stringWithFormat:@"SELECT app_id,post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting, permalink,share_info FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = 'newsfeed') AND post_id = '%@'",PostID];
    
    
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    
    if (FBSession.activeSession.isOpen) {
        [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
            
            [NetworkActivity hide];
            NSLog(@"%@",result);
            if (result) {
                if ([delegates respondsToSelector:@selector(facebook:didGetPostFinish:)]) {
                    [delegates facebook:self didGetPostFinish:result];
                }
            }
            else
            {
                if ([delegates respondsToSelector:@selector(facebook:didGetPostFail:)]) {
                    [delegates facebook:self didGetPostFail:error];
                }
            }
        }];
    }
    else {
        NSLog(@"NEW Unrecognized selector");
    }
    
    
}

+ (void)getALLFriendsList
{
    [[FacebookUtils shared] getALLFriendsList];
}

- (void)getALLFriendsList
{
    if (![self isAuthorized]) {
        return;
    }
    
    
    [NetworkActivity show];
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    
    NSString* query = [NSString stringWithFormat:@"SELECT flid, owner, name,owner_cursor,type FROM friendlist WHERE owner=me()"];
    
    
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      id result,
                                      NSError *error) {
        
        [NetworkActivity hide];
        NSLog(@"%@",result);
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didGetAllFriendListFinish:)]) {
                [delegates facebook:self didGetAllFriendListFinish:result];
            }
        }
        else
        {
            if ([delegates respondsToSelector:@selector(facebook:didGetAllFriendListFail:)]) {
                [delegates facebook:self didGetAllFriendListFail:error];
            }
        }
    }];
    
}

+ (void)getProfilesList:(NSString*)listId
{
    [[FacebookUtils shared] getProfilesList:listId];
}

- (void)getProfilesList:(NSString*)listId
{
    if (![self isAuthorized]) {
        return;
    }
    
    else {
        
        if ([listId isEqualToString:@""]) {
            return;
        }
        
        //http://stackoverflow.com/questions/6461312/fql-query-to-select-friends-that-go-to-same-college //
        FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
        NSString *query = [NSString stringWithFormat:@"SELECT name,id,pic,type,url,username FROM profile WHERE id IN (%@)",listId];
        
        [fql.parameters setObject:query forKey:@"q"];
        [fql.parameters setObject:[[FBSession activeSession] accessTokenData].accessToken forKey:@"access_token"];
        NSLog(@"requestProfileWithID.fql=%@",fql);
        
        [NetworkActivity show];
        [fql startWithCompletionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
            
            [NetworkActivity hide];
            
            if (result) {
                if ([delegates respondsToSelector:@selector(facebook:didGetProfileListFinish:)]) {
                    [delegates facebook:self didGetProfileListFinish:result];
                }
            }
            else {
                if ([delegates respondsToSelector:@selector(facebook:didGetProfileListFail:)]) {
                    [delegates facebook:self didGetProfileListFail:error];
                }
            }
        }];
        
    }
}

- (void)getPagesList:(NSString*)listId
{
    if (![self isAuthorized]) {
        return;
    }
    
    else {
        
        //http://stackoverflow.com/questions/6461312/fql-query-to-select-friends-that-go-to-same-college //
        FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
        NSString *query = [NSString stringWithFormat:@"SELECT page_id, name,pic FROM page where page_id IN (%@)",listId];
        
        [fql.parameters setObject:query forKey:@"q"];
        [fql.parameters setObject:[[FBSession activeSession] accessTokenData].accessToken forKey:@"access_token"];
        NSLog(@"requestProfileWithID.fql=%@",fql);
        
        [NetworkActivity show];
        [fql startWithCompletionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
            
            [NetworkActivity hide];
            
            if (result) {
                if ([delegates respondsToSelector:@selector(facebook:didGetProfileListFinish:)]) {
                    [delegates facebook:self didGetProfileListFinish:result];
                }
            }
            else {
                if ([delegates respondsToSelector:@selector(facebook:didGetProfileListFail:)]) {
                    [delegates facebook:self didGetProfileListFail:error];
                }
            }
        }];
    }
}

+ (void)getNewsFeedSeeMore:(NSInteger)limitNumber
{
    [[FacebookUtils shared] getNewsFeedSeeMore:limitNumber];
}

- (void)getNewsFeedSeeMore:(NSInteger)limitNumber
{
    if (![self isAuthorized]) {
        return;
    }
    
    else {
        
        //http://stackoverflow.com/questions/6461312/fql-query-to-select-friends-that-go-to-same-college //
        FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
        NSString* query = [NSString stringWithFormat:@"SELECT post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = 'newsfeed') AND is_hidden = 0 %@ %@ LIMIT %d",[Utility getStringQueryNewsFeed],[Utility getStringCreated_time],limitNumber];
        
        [fql.parameters setObject:query forKey:@"q"];
        [fql.parameters setObject:[[FBSession activeSession] accessTokenData].accessToken forKey:@"access_token"];
        NSLog(@"requestProfileWithID.fql=%@",fql);
        
        [NetworkActivity show];
        [fql startWithCompletionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
            
            [NetworkActivity hide];
            
            if (result) {
                if ([delegates respondsToSelector:@selector(facebook:didGetNewsFeedSeeMoreFinish:)]) {
                    [delegates facebook:self didGetNewsFeedSeeMoreFinish:result];
                }
            }
            else {
                if ([delegates respondsToSelector:@selector(facebook:didGetNewsFeedSeeMoreFail:)]) {
                    [delegates facebook:self didGetNewsFeedSeeMoreFail:error];
                }
            }
        }];
        
    }
    
}

+ (void)getComment:(NSString *)PostID seeMore:(NSInteger)offset
{
    [[FacebookUtils shared] getComment:PostID seeMore:offset];
}

- (void)getComment:(NSString *)PostID seeMore:(NSInteger)offset
{
    if (![self isAuthorized]) {
        return;
    }
    
    [NetworkActivity show];
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    
    //SELECT text,post_id  FROM comment  WHERE post_id IN(SELECT post_id  FROM stream  WHERE source_id=page_id_here)
    
    NSString* query = [NSString stringWithFormat:@"SELECT text, post_id, user_likes, time, text_tags, likes, id, fromid FROM comment  WHERE post_id ='%@' LIMIT %d",PostID,offset];
    
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      id result,
                                      NSError *error) {
        
        [NetworkActivity hide];
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didGetCommentSeeMoreFinish:)]) {
                [delegates facebook:self didGetCommentSeeMoreFinish:result];
            }
        }
        else
        {
            if ([delegates respondsToSelector:@selector(facebook:didGetCommentSeeMoreFail:)]) {
                [delegates facebook:self didGetCommentSeeMoreFail:error];
            }
        }
    }];
}

- (void)addDelegate:(id)delegate
{
    [delegates addDelegate:delegate];
}

+ (void)addDelegate:(id)delegate
{
    [[FacebookUtils shared] addDelegate:delegate];
}

+ (void)removeDelegate:(id)delegate
{
    [[FacebookUtils shared] removeDelegate:delegate];
}

- (void)removeDelegate:(id)delegate
{
    [delegates removeDelegate:delegate];
}

+ (void)getPlace:(NSString*)checkinID
{
    [[FacebookUtils shared] getPlace:checkinID];
}


- (void)getPlace:(NSString *)checkinID
{
    if (![self isAuthorized]) {
        return;
    }
    
    [NetworkActivity show];
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    
    //SELECT text,post_id  FROM comment  WHERE post_id IN(SELECT post_id  FROM stream  WHERE source_id=page_id_here)
    
    //    NSString* query = [NSString stringWithFormat:@"SELECT coords, message, timestamp,FROM checkin  WHERE post_id = %@",checkinID];
    
    
    NSString* query = [NSString stringWithFormat:@"SELECT page_id, name, description, geometry, pic, pic_crop, pic_large, pic_small, content_age, display_subtext, is_unclaimed FROM place WHERE page_id in (%@)",checkinID];
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      id result,
                                      NSError *error) {
        
        [NetworkActivity hide];
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didGetPlaceFinish:)]) {
                [delegates facebook:self didGetPlaceFinish:result];
            }
            
        }
        else
        {
            NSLog(@"error getPlace");
            if ([delegates respondsToSelector:@selector(facebook:didGetPlaceFail:)]) {
                [delegates facebook:self didGetPlaceFail:error];
            }
        }
    }];
    
}


+ (void)multiQuery:(NSString*)querry
{
    if (querry == nil) {
        querry =
        @"{"
        @"'friends':'SELECT uid2 FROM friend WHERE uid1 = me()',"
        @"'friendinfo':'SELECT uid, name, pic FROM user WHERE uid IN (SELECT uid2 FROM #friends)',"
        @"}";
        
        //        querry = @"SELECT post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = 'newsfeed') AND is_hidden = 0 LIMIT 10";
        //
        querry = @"{"
        @"'post':'SELECT post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = \"newsfeed\") AND is_hidden = 0 LIMIT 10',"
        
        @" 'friendinfo':'SELECT uid, name, pic FROM user WHERE uid IN (SELECT actor_id FROM #post)',"
        @"}";
        
    }
    [[FacebookUtils shared] multiQuery:querry];
}


- (void)multiQuery:(NSString*)querry
{
    
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": querry };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSLog(@"Result: %@", result);
                              }
                          }];
}


+ (void) getNearbyPlaces:(CLLocation*)location
{
    [[FacebookUtils shared] getNearbyPlaces:location];
}

- (void) getNearbyPlaces:(CLLocation*)location
{
    if (![self isAuthorized]) {
        return;
    }
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    
    /*NSString *query = @"SELECT page_id, name, display_subtext, description, distance(latitude, longitude, "37.76", "-122.427"), checkin_count FROM placeWHERE ((distance(latitude, longitude, "37.76", "-122.427") < 25000) AND (strpos(lower(name), "coffee") >= 0 OR strpos(lower(description), "coffee") >= 0)) ORDER BY distance(latitude, longitude, "37.76", "-122.427") ASC LIMIT 20 OFFSET 0";*/
    
    CGFloat lat = location.coordinate.latitude;
    CGFloat lon = location.coordinate.longitude;
    
    NSString *query = [NSString stringWithFormat:@""@"SELECT pic, geometry, page_id, name, display_subtext, description, checkin_count FROM place WHERE distance(latitude, longitude, \"%f\", \"%f\") < 1000 ORDER BY distance(latitude, longitude,\"%f\", \"%f\") ASC LIMIT 10",lat,lon,lat,lon];
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      id result,
                                      NSError *error) {
        
        if (result) {
            
            if ([delegates respondsToSelector:@selector(facebook:didGetNearbyPlacesFinish:)]) {
                [delegates facebook:self didGetNearbyPlacesFinish:result];
            }
            
        }
        else
        {
            NSLog(@"error getNearbyPlaces");
            if ([delegates respondsToSelector:@selector(facebook:didGetNearbyPlacesFail:)]) {
                [delegates facebook:self didGetNearbyPlacesFail:error];
            }
            
        }
    }];
}

+ (void)hidenPost:(NSString*)postID
{
    [[FacebookUtils shared] hidenPost:postID];
}

- (void)hidenPost:(NSString*)postID
{
    if (![self isAuthorized]) {
        return;
    }
    [NetworkActivity show];
    
    FBRequest *request = [FBRequest requestWithGraphPath:[NSString stringWithFormat:@"%@",postID] parameters:nil HTTPMethod:@"DELETE"];
    
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [connection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [NetworkActivity hide];
        NSLog(@"Facebook Hide Result: %@", result);
        if (error != nil)
        {
            NSLog(@"Facebook Posting Error: %@", [error localizedDescription]);
        }
        
    }];
    [connection start];
    
}

+ (void)getDetailPhoto:(NSString*)pid
{
    [[FacebookUtils shared] getDetailPhoto:pid];
}


- (void)getDetailPhoto:(NSString*)pid
{
    if (![self isAuthorized]) {
        return;
    }
    
    FBRequest *fql = [FBRequest requestForGraphPath:@"fql"];
    
    NSString *query = [NSString stringWithFormat:@""@"SELECT pid, like_info, comment_info, caption, object_id FROM photo WHERE object_id = '%@'",pid];
    
    [fql.parameters setObject:query
                       forKey:@"q"];
    NSString *myFacebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    [fql.parameters setObject:myFacebookToken forKey:@"access_token"];
    
    [fql startWithCompletionHandler:^(FBRequestConnection *connection,
                                      id result,
                                      NSError *error) {
        
        if (result) {
            
            if ([delegates respondsToSelector:@selector(facebook:didGetDetailPhotoFinish:)]) {
                [delegates facebook:self didGetDetailPhotoFinish:result];
            }
            
        }
        else
        {
            NSLog(@"error didGetDetailPhotoFail");
            if ([delegates respondsToSelector:@selector(facebook:didGetDetailPhotoFail:)]) {
                [delegates facebook:self didGetDetailPhotoFail:error];
            }
            
        }
        
    }];
    
}


+ (void)sharePost:(NSString*)url text:(NSString*)text audience:(NSMutableDictionary*)audienceDict
{
    [[FacebookUtils shared] sharePost:url text:text audience:audienceDict];
}

- (void)sharePost:(NSString*)url text:(NSString*)text audience:(NSMutableDictionary*)audienceDict
{
    if (![self isAuthorized]) {
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *linkURL = url;
    [param setObject:linkURL  forKey:@"link"];
    [param setObject:text forKey:@"message"];
    NSString* audienceStr = [FacebookUtils getAudienceValue:audienceDict];
    [param setObject:audienceStr forKey:@"privacy"];
    
    [NetworkActivity show];
    
    FBRequest *request = [FBRequest requestWithGraphPath:@"me/feed" parameters:param HTTPMethod:@"POST"];
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [connection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        [NetworkActivity hide];
        
        if (result) {
            if ([delegates respondsToSelector:@selector(facebook:didShareFinish:)]) {
                [delegates facebook:self didShareFinish:result];
            }
        }
        else
        {
            if ([delegates respondsToSelector:@selector(facebook:didShareFail:)]) {
                [delegates facebook:self didShareFail:error];
            }
        }
        
    }];
    [connection start];
}

- (void)getNewFeedsMultiQuery
{
    if (![self isAuthorized]) {
        return;
    }
    
    NSString* querry = @"";
    
#if !testOnePost
//    querry = [NSString stringWithFormat:@"{"
//                        @"'post':'SELECT app_id,post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting, permalink, share_info FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = \"newsfeed\") AND is_hidden = 0 %@ LIMIT 10',"
//                        
//                        @" 'facebookuser':'SELECT name,id,pic,type,url,username FROM profile WHERE id IN (SELECT actor_id FROM #post)',"
//                        @"}",[Utility getStringQueryNewsFeed]];
    
    querry = [NSString stringWithFormat:@"{"
              @"'post':'SELECT app_id,post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting, permalink, share_info FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = \"newsfeed\") AND is_hidden = 0 %@ LIMIT 10',"
              @"}",[Utility getStringQueryNewsFeed]];
#else
    
//    querry = [NSString stringWithFormat:@"{"
//                        @"'post':'SELECT app_id,post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting, permalink, share_info FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = \"newsfeed\") AND is_hidden = 0 %@ AND post_id=\"100002949310037_430545607053746\" LIMIT 10',"
//
//                        @" 'facebookuser':'SELECT name,id,pic,type,url,username FROM profile WHERE id IN (SELECT actor_id FROM #post)',"
//                        @"}",[Utility getStringQueryNewsFeed]];
    
    querry = [NSString stringWithFormat:@"{"
              @"'post':'SELECT app_id,post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting, permalink, share_info FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = \"newsfeed\") AND is_hidden = 0 %@ AND post_id=\"176146169124_726636624019597\"',"
              @"}",[Utility getStringQueryNewsFeed]];

#endif
    
    
    [NetworkActivity show];
    NSDictionary *queryParam = @{ @"q": querry };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              
                              if (result) {
                                  if ([delegates respondsToSelector:@selector(facebook:didRefeshNewFeedFinish:)]) {
                                      [delegates facebook:self didRefeshNewFeedFinish:result];
                                  }
                              }
                              
                              else
                              {
                                  if ([delegates respondsToSelector:@selector(facebook:didRefeshNewFeedFail:)]) {
                                      [delegates facebook:self didRefeshNewFeedFail:error];
                                  }
                              }
                          }];
}

- (void)getSeeMoreNewFeedsMultiQuery:(NSString*)limit
{
    if (![self isAuthorized]) {
        return;
    }
    
//    NSString* querry = [NSString stringWithFormat:@"{"
//                        @"'post':'SELECT app_id,post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting, permalink,share_info FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = \"newsfeed\") AND is_hidden = 0 %@ LIMIT %@',"
//                        
//                        @" 'facebookuser':'SELECT name,id,pic,type,url,username FROM profile WHERE id IN (SELECT actor_id FROM #post)',"
//                        @"}", [Utility getStringQueryNewsFeed],limit];
    NSString* querry = [NSString stringWithFormat:@"{"
                        @"'post':'SELECT app_id,post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting, permalink,share_info FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = \"newsfeed\") AND is_hidden = 0 %@ LIMIT %@',"
                        @"}", [Utility getStringQueryNewsFeed],limit];

    
   [NetworkActivity show];
    NSDictionary *queryParam = @{ @"q": querry };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              
                              if (result) {
                                  if ([delegates respondsToSelector:@selector(facebook:didGetNewsFeedSeeMoreFinish:)]) {
                                      [delegates facebook:self didGetNewsFeedSeeMoreFinish:result];
                                  }
                              }
                              else {
                                  if ([delegates respondsToSelector:@selector(facebook:didGetNewsFeedSeeMoreFail:)]) {
                                      [delegates facebook:self didGetNewsFeedSeeMoreFail:error];
                                  }
                              }
                              
                          }];
    
}

- (void)getNewsFeedStories
{
    if (![self isAuthorized]) {
        return;
    }
    
    NSString* querry = [NSString stringWithFormat:@"{"
                        @"'post':'SELECT app_id,post_id, actor_id, target_id, message, source_id, comments, attachment, created_time,updated_time , type, likes, attribution, action_links, place, targeting, permalink,share_info FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = \"newsfeed\") AND is_hidden = 0 %@ %@',"
                        
                        @" 'facebookuser':'SELECT name,id,pic,type,url,username FROM profile WHERE id IN (SELECT actor_id FROM #post)',"
                        @"}",[Utility getLastestTime], [Utility getStringQueryNewsFeed]];
    
    [NetworkActivity show];
    NSDictionary *queryParam = @{ @"q": querry };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         
         if (result) {
             if ([delegates respondsToSelector:@selector(facebook:didGetNewsFeedStoriesFinish:)]) {
                 [delegates facebook:self didGetNewsFeedStoriesFinish:result];
             }
         }
         else {
             if ([delegates respondsToSelector:@selector(facebook:didGetNewsFeedStoriesFail:)]) {
                 [delegates facebook:self didGetNewsFeedStoriesFail:error];
             }
         }
         
     }];
    
}

- (void)deletePost:(NSString*)postID
{
    if (![self isAuthorized]) {
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"/%@",postID];
    [NetworkActivity show];
    [FBRequestConnection startWithGraphPath:path
                                 parameters:nil
                                 HTTPMethod:@"DELETE"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         [NetworkActivity hide];
         if (error) {
             if ([delegates respondsToSelector:@selector(facebook:didDeletePostFail:)]) {
                 [delegates facebook:self didDeletePostFail:error];
             }
         } else {
             if ([delegates respondsToSelector:@selector(facebook:didDeletePostFinish:)]) {
                 [delegates facebook:self didDeletePostFinish:result];
             }
             
         }
     }];
    
}


#pragma mark - util

+ (NSString*)ConverCount:(NSString*)count
{
    NSInteger countInt = [count integerValue];
    
    if (countInt/1000000 >= 1) {
        return [NSString stringWithFormat:@"%d.%dM",countInt/1000000,(countInt/100000)%10];
    }
    else if (countInt/1000 >= 1){
        return [NSString stringWithFormat:@"%d.%dK",countInt/1000,(countInt/100)%10];
    }
    else
    {
        return count;
    }
}

+ (NSString*)getAudienceValue:(NSDictionary*)audienceDict
{
    NSString *flid = [audienceDict objectForKey:@"flid"];
    
    if ([flid isEqualToString:@"0"]) {
        return @"{'value':'EVERYONE'}";
    }
    
    else if ([flid isEqualToString:@"1"]) {
        return @"{'value':'ALL_FRIENDS'}";
    }
    
    else if ([flid isEqualToString:@"2"]) {
        return @"{'value':'SELF'}";
    }
    
    else
    {
        //        NSString *owner = [audienceDict objectForKey:@"owner_cursor"];"friends", "SOME_FRIENDS"
        //        return [NSString stringWithFormat:@"{'value': '%@'}",owner];
        return [NSString stringWithFormat:@"{'value': 'CUSTOM', 'allow': '%@'}",flid];
    }
}

@end
