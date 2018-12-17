//
//  API.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/16/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#define API_HANDLE_ERROR(code,msg)\
if (error != nil) {\
if (msg != nil) *error = [API errorWithCode:code description:msg];\
else *error = [API errorWithCode:code description:@"An exception error"];\
}

// Error Description

#define ERROR_MSG_NETWORK         (@"Unable to connect to the network please check your network connection and try again")
#define ERROR_MSG_DATA            (@"Data from the server returns incorrectly!")
#define ERROR_MSG_UNKNOW          (@"An error occurred unspecified!")

#import "API.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation API

#pragma mark - handle error

+ (NSError*)errorWithCode:(NSInteger)code description:(NSString*)description
{
    NSLog(@"%s", __func__);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description
                                                         forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:ERROR_DOMAIN
                               code:code userInfo:userInfo];
}

#pragma mark - App id

+(NSString *) getUserIdifExist
{
    NSLog(@"%s", __func__);
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (userId==nil)
        userId=@"";
    else {
        if ([userId isKindOfClass:[NSString class]]) {
            if ([userId length] == 0)
                userId = @"";
        }
        else {
            userId = @"";
        }
    }
    
        
    
    return userId;
}

+ (void)getNodeForSingerID:(NSString*)singerID
             contentTypeId:(ContentTypeID)contentTypeId
                     limit:(NSString*)limit
                      page:(NSString *)page
                    period:(NSString*)period
                 isHotNode:(NSString*)isHotNode
                     start:(NSString*)start
                     appID:(NSString*)appID
                appVersion:(NSString*)appVersion
                 completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:singerID,@"singer_id",
                                    [self getUserIdifExist],@"user_id",
                                    [NSNumber numberWithInteger:contentTypeId],@"content_type_id",
                                    limit,@"limit",
                                    page,@"page",
                                    period,@"period",
                                    isHotNode, @"is_hot_node",
                                    start,@"start",
                                    appID,@"production_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_node_by_singer.php",HOST_FOR_CONTENT];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- log
        NSLog(@"operation hasAcceptableStatusCode: %d", [operation.response statusCode]);
        //NSLog(@"response string: %@ ", operation.responseString);
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) { //-- good data
            completed(dictResponse,nil);
        }
        else { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error request fail");
        //-- error
        completed(nil,error);
        
    }];
    
}

//--------------------------------get setting --------------------------------------//
+ (void)getSettingWithProductionId:(NSString*)productionId
                     distributorId:(NSString*)distributorId
              distributorChannelId:(NSString*)distributorChannelId
                        platformId:(PlatformOS) platformId
                 contentProviderId:(NSString*)contentProviderId
                         completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:productionId,@"production_id",
                                    distributorId,@"distributor_id",
                                    distributorChannelId,@"distributor_channel_id",
                                    contentProviderId,@"content_provider_id",
                                    [NSString stringWithFormat:@"%d",platformId],@"platform_id",
                                    [self getUserIdifExist],@"user_id",nil];
//    http://wrappersrv.soci.vn/gom_api_test/api/get_production_setting.php
//    NSString *urlString = [NSString stringWithFormat:@"%@/get_production_setting/get.json", HOST_FOR_CONTENT];
    NSString *urlString = @"http://wrappersrv.soci.vn/gom_api_v3/api/get_music_production_setting.php";
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client setDefaultHeader:@"Accept-Encoding" value:@"gzip"];//longnh add
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200)
        {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//-----------------------------------------------------------------------------------//


//-------------------------getFeedofSingerID----------------------------//

+ (void)getFeedofSingerID:(NSString *)productionId
        productionVersion:(NSString *)productionVersion
                 singerId:(NSString *)singerId completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:productionId,@"production_id",
                                    productionVersion,@"production_version",
                                    singerId,@"singer_id",
                                    [self getUserIdifExist],@"user_id",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"http://myidol.soci.vn/ati/service_v1.0/get_feed.php"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client getPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
    }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        //-- error
        completed(nil, error);
    }];
}
//-----------------------------------------------------------------------------------//

//-------------------------getAllMusicAndVideoOfSinglerID----------------------------//

+ (void)getAllMusicAndVideoOfSinglerID:(NSString*)singleID
                         contentTypeId:(ContentTypeID)contentTypeId
                                 limit:(NSString*)limit
                                  page:(NSString *)page
                             isHotNode:(NSString*)isHotNode
                                months:(NSString*)months
                                 appID:(NSString*)appID
                            appVersion:(NSString*)appVersion
                             completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:singleID,@"singer_id",
                                    [self getUserIdifExist],@"user_id",
                                    [NSString stringWithFormat:@"%d",contentTypeId],@"content_type_id",
                                    limit,@"limit",
                                    page,@"page",
                                    isHotNode, @"is_hot_node",
                                    months,@"months",
                                    appID,@"production_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_node_by_singer.php",HOST_FOR_CONTENT];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}
//-----------------------------------------------------------------------------------//


//-------------------------getAlumOfSinglerID----------------------------------------//
+ (void)getAlbumOfSinglerID:(NSString*)singleID
              contentTypeId:(ContentTypeID)contentTypeId
                      limit:(NSString*)limit
                       page:(NSString *)page
                  isGetBody:(NSString*)isGetBody
                   isGetHot:(NSString*)isGetHot
                      appID:(NSString*)appID
                 appVersion:(NSString*)appVersion
                  completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s page=%@ limit=%@, contentTypeId=%d", __func__, page, limit, contentTypeId);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:singleID,@"singer_id",
                                    [self getUserIdifExist],@"user_id",
                                    [NSString stringWithFormat:@"%d",contentTypeId],@"content_type_id",
                                    limit,@"limit",
                                    page,@"page",
                                    isGetBody,@"is_get_node_body",
                                    isGetHot, @"is_hot_node",
                                    appID,@"production_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_album_by_singer.php",HOST_FOR_CONTENT];
    NSLog(@"urlString:%@",urlString);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}
//-----------------------------------------------------------------------------------//


//-------------------------getMusicFromAlbumId----------------------------------------//
+ (void)getNodeByAlbum:(NSString*)albumId
         contentTypeId:(ContentTypeID)contentTypeId
                 limit:(NSString*)limit
                  page:(NSString *)page
             isHotNode:(NSString*)isHotNode
                 appID:(NSString*)appID
            appVersion:(NSString*)appVersion
             completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:albumId,@"album_id",
                                    [NSString stringWithFormat:@"%d",contentTypeId],@"content_type_id",
                                    limit,@"limit",
                                    page,@"page",
                                    isHotNode, @"is_hot_node",
                                    SINGER_ID,@"singer_id",
                                    [self getUserIdifExist],@"user_id",
                                    appID,@"production_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_node_by_album.php",HOST_FOR_CONTENT];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//-----------------------------------------------------------------------------------//



#pragma mark - Fanzone api

//-------------------------createAccount using facebook account---------------------//
+ (void)createAccount:(NSString*)userName
             fullName:(NSString *)fullName
            passwordd:(NSString*)password
                email:(NSString *)email
               gender:(NSString*)gender
             birthday:(NSString*)birthday
           countryIso:(NSString *)countryIso
             fbUserId:(NSString*)fbUserId
          accessToken:(NSString*)acessToken
               mobile:(NSString*)mobile
            userImage:(NSString*)userImage
                appID:(NSString*)appID
           appVersion:(NSString*)appVersion
           coverPhoto:(NSString*)coverPhoto
            completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
   NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"user_name",
                                    fullName,@"full_name",
                                    password,@"password",
                                    email,@"email",
                                    gender,@"gender",
                                    birthday,@"birthday",
                                    countryIso,@"country_iso",
                                    fbUserId,@"fb_user_id",
                                    acessToken,@"access_token",
                                    mobile,@"mobile",
                                    userImage,@"user_image",
                                    SINGER_ID,@"singer_id",
                                    appID,@"production_id",
                                    appVersion,@"production_version",
                                    coverPhoto,@"cover_photo",
                                    DISTRIBUTOR_CHANNEL_ID,@"distributor_channel_id",
                                    nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/add_user_with_mobile.php", HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//-----------------------------------------------------------------------------------//

//--------------------------------write user's status--------------------------------------//

+ (void)writeStatus:(NSString *) status
            user_id:(NSString *) userId
             app_id:(NSString *) appId
        app_version:(NSString *) appVersion
          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:status,@"content",
                                    userId,@"user_id",
                                    appId,@"production_id",
                                    SINGER_ID,@"singer_id",
                                    appVersion,@"production_version",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/add_status.php", HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
    
}


//-----------------------------------------------------------------------------------//

//--------------------------------get user info--------------------------------------//
+ (void)getUserInfo:(NSString*)userId withFaceBookID:(NSString*)fbUserId
       productionId:(NSString*)productionId
  productionVersion:(NSString*)productionVersion
         avatarSize:(NSString*)avatarSize
          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"user_id",
                                    productionId,@"production_id",
                                    productionVersion,@"production_version",
                                    SINGER_ID,@"singer_id",
                                    avatarSize,@"avatar_size",nil];
    
    if ([fbUserId length] > 2) {
        
        dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"user_id",
                          fbUserId,@"fb_user_id",
                          productionId,@"production_id",
                          productionVersion,@"production_version",
                          SINGER_ID,@"singer_id",
                          avatarSize,@"avatar_size",nil];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_user_info.php", HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}


+ (void)getUserInfoByFaceBookID:(NSString*)fbUserId withUserId:(NSString*)userId
                   productionId:(NSString*)productionId
              productionVersion:(NSString*)productionVersion
                     avatarSize:(NSString*)avatarSize
                      completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:fbUserId,@"fb_user_id",
                                    userId,@"user_id",
                                    productionId,@"production_id",
                                    productionVersion,@"production_version",
                                    SINGER_ID,@"singer_id",
                                    avatarSize,@"avatar_size",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_user_info.php", HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        NSLog(@"dictResponse:%@",dictResponse);
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//--------------------------------update user info--------------------------------------//
+ (void)updateUserInfo:(NSString*)userId fbUserId:(NSString*)fbUserId mobile:(NSString*)mobile
           accessToken:(NSString*)accessToken completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"user_id",
                                    fbUserId,@"fb_user_id",
                                    mobile,@"mobile",
                                    accessToken,@"access_token",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/update_user.php", HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}


//-----------------------------------------------------------------------------------//


//--------------------------------get user points------------------------------------//
+ (void)getUserPoints:(NSString*)userId
                appId:(NSString*)appId
           appVersion:(NSString*)appVersion
            completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    userId,@"user_id",
                                    appId,@"production_id",
                                    SINGER_ID,@"singer_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_user_point.php",HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//-----------------------------------------------------------------------------------//


//--------------------------------get data shoutbox----------------------------------//
+ (void)getDataShoutBox:(NSString*)pageId
                  limit:(NSString*)limit
              startTime:(NSString*)startTime
                endTime:(NSString*)endTime
                  appId:(NSString*)appId
             appVersion:(NSString*)appVersion
              completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    pageId,@"page_id",
                                    limit,@"limit",
                                    startTime,@"start_time",
                                    endTime,@"end_time",
                                    appId,@"production_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_shoutbox_data.php", HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//-----------------------------------------------------------------------------------//


//--------------------------------insert shoutbox------------------------------------//
+ (void)addShoutBox:(NSString*)pageId
             userId:(NSString *)userId
               text:(NSString *)text
              appId:(NSString*)appId
         appVersion:(NSString*)appVersion
          startTime:(NSString*)startTime
   isGetNewShoutBox:(NSString*)isGetNewShoutBox
          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    pageId,@"page_id",
                                    userId,@"user_id",
                                    text,@"text",
                                    appId,@"production_id",
                                    appVersion,@"production_version",
                                    startTime,@"start_time",
                                    isGetNewShoutBox,@"is_get_new_shoutbox", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/add_shoutbox.php", HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//-----------------------------------------------------------------------------------//


#pragma mark - SMS Register

//-- check user exist FB
+ (void)getUserExistByFBTypeRequest:(NSString*)typeRequest
                             mobile:(NSString*)mobile
                         fb_user_id:(NSString *)fb_user_id
                          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = nil;
    NSString *urlString = @"";
    
    if ([typeRequest isEqualToString:@"Mobile"]) {
        
        dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                          SINGER_ID,@"singer_id",
                          mobile,@"mobile", nil];
        
        urlString = [NSString stringWithFormat:@"%@/check_user_exist_by_mobile.php",HOST_FOR_USER];
        
    }else {
        
        dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                          SINGER_ID,@"singer_id",
                          fb_user_id,@"fb_user_id", nil];
        
        urlString = [NSString stringWithFormat:@"%@/check_user_exist_by_fb.php",HOST_FOR_USER];
    }
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//-- get Phone number if use 3G
+ (void)getPhoneNumberAPICompleted:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [userDefaults valueForKey:Key_get_phone_number_service_api];
    
    if ([urlString length] == 0)
        urlString = [NSString stringWithFormat:@"http://mfilm.vn/site/GetPhoneNumber"];
    
    NSDictionary *dictParameters = nil;
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//-- check exist Phone number
+ (void)getUserExistByPhoneNumberTypeRequest:(NSString*)typeRequest
                                      mobile:(NSString*)mobile
                                   completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    typeRequest,@"type",
                                    SINGER_ID,@"singer_id",
                                    mobile,@"mobile", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/check_user.php",HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}


//-- api API GSoapTest
//-- http://core.vteen.vn/GSoapClientTest/src/framework/base/GSoapTest.php? mobile=849012344566&code=DK&singer=DONGNHI

+ (void)callAPIGSoapTestPhoneNumber:(NSString *)mobileNumber
                               code:(NSString *)code
                             singer:(NSString*)singer sign:(NSString*)sign
                          completed:(void (^)(NSString *responseString, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    mobileNumber,@"mobile",
                                    singer,@"singer",
                                    sign,@"sign",
                                    code,@"code", nil];
    
    //-- edit 15.2.2014
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [userDefaults valueForKey:Key_noCharging_DK_api];
    
    if ([urlString length] == 0) {
        urlString = [NSString stringWithFormat:@"%@/GSoapClientTest/src/framework/base/GSoapTest.php",HOST_FOR_CHARGING];
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    
    [client getPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSString *response = operation.responseString;
        
        if ([operation.response statusCode] == 200) {
            completed(response,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil, error);
    }];
}


//-- api cash Phone number by link
//-- http://core.vteen.vn/SMSBIllingSystem/Application/Server/MPlus/ChargingSub.php?id=12_20140122154602&m=0901823245&c=DK+DONGNHI&s=000a2ae515f9e39cbf25d657f1c5945

+ (void)callCashPhoneNumberReqId:(NSString*)reqId
                    mobileNumber:(NSString *)mobileNumber
                      smsContent:(NSString *)smsContent
                            sign:(NSString*)sign
                       completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    reqId,@"id",
                                    mobileNumber,@"m",
                                    smsContent,@"c",
                                    sign,@"s",
                                    nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [userDefaults valueForKey:Key_wapSub_DK_api];
    
    if ([urlString length] == 0) {
        urlString = [NSString stringWithFormat:@"%@/SMSBIllingSystem/Application/Server/MPlus/ChargingSub.php",HOST_FOR_CHARGING];
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    
    [client getPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil, error);
    }];
}


//-- call api verify
//-- http://core.vteen.vn/SMSBIllingSystem/Application/Server/MPlus/WifyLogin.php?id=reqId&m=mobileNumber&c=singerCode&p=password&s=client_sign

+ (void)apiVerifyLoginWithPhoneNumberReqId:(NSString*)reqId mobileNumber:(NSString *)mobileNumber singerCode:(NSString *)singerCode password:(NSString *)password sign:(NSString*)sign completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    reqId,@"id",
                                    mobileNumber,@"m",
                                    singerCode,@"c",
                                    password,@"p",
                                    sign,@"s",
                                    nil];
    
    NSString *urlString = [self getLinkAPI_DKCT];
    
    if ([urlString length] == 0) {
        urlString = [NSString stringWithFormat:@"%@/SMSBIllingSystem/Application/Server/MPlus/WifyLogin.php",HOST_FOR_CHARGING];
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    
    [client getPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil, error);
    }];
}

//-- get link api
+(NSString *) getLinkAPI_DKCT {
    NSLog(@"%s", __func__);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *apiString = @"";
    
    //-- Get Carrier Info
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrieraa = [netinfo subscriberCellularProvider];
    
    if ([carrieraa.isoCountryCode isEqualToString:@""] && [carrieraa.carrierName isEqualToString:@"Carrier"]) {
        
        /*
         * Not exist Phome number : User just input phone number
         * Kh√¥ng c√≥ Sim
         */
        
        apiString = [userDefaults valueForKey:Key_wifi_nosim_DKCT_api];
        
    }else {
        
        /*
         * Not exist Phome number
         * Co Sim
         */
        
        //-- check 3G or wifi
        NSString *payment_typeDefaults = @"";
        if ([Utility checkNetWorkStatus] == 2)
            payment_typeDefaults = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_mobile_network_payment_type]];
        else
            payment_typeDefaults = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_wifi_payment_type]];
        
        //-- save Defaults payment_type
        [userDefaults setObject:payment_typeDefaults forKey:Key_payment_type];
        [userDefaults synchronize];
        
        
        NSInteger payment_type = [[userDefaults valueForKey:Key_payment_type] integerValue];
        switch (payment_type) {
                
                /*
                 * payment_type: 1 - Đăng ký qua wapcharging (bỏ qua)
                 * payment_type: 2 - Đăng ký qua SMS (theo cú pháp gửi tin và verify số điện thoại)
                 * payment_type: 3 - Đăng ký qua Sub SMS (theo cú pháp gửi tin)
                 * payment_type: 4 - Không đăng ký qua gì (call api API GSoapTest.php)
                 * payment_type: 5 - ChargingSub (call API ChargingSub.php).
                 *
                 */
                
            case 1:
                //-- Bo qua
                break;
                
            case 2:
                apiString = [userDefaults valueForKey:Key_sms_DKCT_api];
                break;
                
            case 3:
                apiString = [userDefaults valueForKey:Key_subSms_DKCT_api];
                break;
                
            case 4:
                break;
                
            case 5:
                break;
                
            default:
                break;
        }
    }
    
    return apiString;
}


//-- call api login Free app
+ (void)apiVerifyLoginFreeAppWithPhoneNumber:(NSString *)mobileNumber password:(NSString *)password completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    mobileNumber,@"mobile",
                                    password,@"password",
                                    SINGER_ID,@"singer_id",
                                    nil];
    
    NSString *urlString = [[NSUserDefaults standardUserDefaults] valueForKey:Key_Free_Login_Api];
    
    if ([urlString length] == 0) {
        urlString = [NSString stringWithFormat:@"https://myidol.soci.vn/ati/service_v1.0/user_login.php"];
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}


#pragma mark - Category

//-------------------------getCategoryBySinger----------------------------------------//

+ (void)getCategoryBySinger:(NSString*)singleID
              contentTypeId:(ContentTypeID)contentTypeId
                      appID:(NSString*)appID
                 appVersion:(NSString*)appVersion
                  completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:singleID,@"singer_id",
                                    [self getUserIdifExist],@"user_id",
                                    [NSString stringWithFormat:@"%d",contentTypeId],@"content_type_id",
                                    appID,@"production_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_category_by_singer.php",HOST_FOR_CONTENT];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}
//-----------------------------------------------------------------------------------//


//-------------------------get_node_by_category_singer-------------------------------//

+ (void)getNodeByCategoryForSingerWithContentTypeId:(ContentTypeID)contentTypeId
                                              limit:(NSString *)limit
                                               page:(NSString *)page
                                          isHotNode:(NSString *)isHotNode
                                      isGetNodeBody:(NSString *)isGetNodeBody
                                         categoryId:(NSString *)categoryID
                                             period:(NSString *)period
                                              start:(NSString *)start
                                              appID:(NSString *)appID
                                         appVersion:(NSString *)appVersion
                                             months:(NSString *)months
                                          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s contentTypeId=%d page=%@ limit=%@", __func__, contentTypeId, page, limit);
    NSString *contentTypeStr = [NSString stringWithFormat:@"%d",contentTypeId];
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:categoryID,@"category_id",
                                    contentTypeStr,@"content_type_id",
                                    limit,@"limit",
                                    page,@"page",
                                    period,@"period",
                                    isHotNode, @"is_hot_node",
                                    isGetNodeBody, @"is_get_node_body",
                                    start,@"start",
                                    SINGER_ID,@"singer_id",
                                    [self getUserIdifExist],@"user_id",
                                    appID,@"production_id",
                                    appVersion,@"production_version",
                                    months,@"months",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_node_by_category_singer.php",HOST_FOR_CONTENT];
    NSLog(@"dictParameters:%@",dictParameters.description);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    
    //[AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) { //-- good data
            completed(dictResponse,nil);
        }
        else { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil,error);
        
    }];
}


#pragma mark - Get Singer Info

+ (void)getNodeDetail:(NSString*)nodeId
        contentTypeId:(ContentTypeID)contentTypeId
                appId:(NSString*)appId
           appVersion:(NSString*)appVersion
            completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSString *contentTypeStr = [NSString stringWithFormat:@"%d",contentTypeId];
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:nodeId,@"node_id",
                                    contentTypeStr,@"content_type_id",
                                    SINGER_ID,@"singer_id",
                                    [self getUserIdifExist],@"user_id",
                                    appId,@"production_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_node_detail.php",HOST_FOR_CONTENT];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) { //-- good data
            completed(dictResponse,nil);
        }
        else { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil,error);
        
    }];
}



#pragma mark - Get Top user point

+ (void)getTopUserPoint:(NSString*)rankType
               singerId:(NSString*)singerId
                   time:(NSString*)time
                timeEnd:(NSString*)timeEnd
            isGetAllDay:(NSString*)isGetAllDay
                  limit:(NSString*)limit
           productionId:(NSString*)productionId
      productionVersion:(NSString*)productionVersion
              completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:rankType,@"ranking_type",
                                    singerId,@"singer_id",
                                    time,@"time",
                                    timeEnd,@"time_end",
                                    isGetAllDay,@"is_get_all_day",
                                    limit,@"limit",
                                    productionId, @"production_id",
                                    productionVersion, @"production_version",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_top_user_point.php",HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client setDefaultHeader:@"Accept-Encoding" value:@"gzip"];//longnh add
    
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) { //-- good data
            completed(dictResponse,nil);
        }
        else { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil,error);
        
    }];
}

#pragma mark - Sync Data

+ (void)syncData:(NSString*)userID
          pageId:(NSString*)pageId
        dataSync:(NSString*)dataSync
        dataType:(NSString*)dataType
    productionId:(NSString*)productionId
productionVersion:(NSString*)productionVersion
       completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"user_id",
                                    pageId,@"singer_id",
                                    dataSync,dataType,
                                    productionId, @"production_id",
                                    productionVersion, @"production_version",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/sync_like_comment.php",HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) { //-- good data
            completed(dictResponse,nil);
        }
        else { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil,error);
        
    }];
}



#pragma mark - Get comment data

+ (void)getCommentData:(NSString*)singerId
             contentId:(NSString*)contentId
         contentTypeId:(NSString*)contentTypeId
             commentId:(NSString*)commentId
   getCommentOfComment:(NSString*)getCommentOfComment
          productionId:(NSString*)productionId
     productionVersion:(NSString*)productionVersion
             completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    singerId,@"singer_id",
                                    contentId,@"content_id",
                                    contentTypeId,@"content_type_id",
                                    commentId,@"comment_id",
                                    getCommentOfComment,@"is_get_comment_of_comment",
                                    productionId, @"production_id",
                                    productionVersion, @"production_version",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_comment_data.php",HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) { //-- good data
            completed(dictResponse,nil);
        }
        else { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil,error);
        
    }];
}



#pragma mark - Get List Winners

+ (void)getListWinners:(NSString*)singerId
             contestId:(NSString*)contest_id
               roundId:(NSString*)roundId
          productionId:(NSString*)productionId
     productionVersion:(NSString*)productionVersion
             completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:singerId,@"singer_id",
                                    [self getUserIdifExist],@"user_id",
                                    contest_id,@"contest_id",
                                    roundId,@"round_id",
                                    productionId, @"production_id",
                                    productionVersion, @"production_version",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_contest_info_by_singer.php",HOST_FOR_CONTENT];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) { //-- good data
            completed(dictResponse,nil);
        }
        else { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil,error);
        
    }];
}



#pragma mark - Get ShoutBox Data Comment

+ (void)getShoutBoxDataComment:(NSString*)fanzoneId
                     startTime:(NSString*)startTime
                       endTime:(NSString*)endTime
                         limit:(NSString*)limit
                  productionId:(NSString*)productionId
             productionVersion:(NSString*)productionVersion
                     completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    fanzoneId,@"fanzone_id",
                                    startTime,@"start_time",
                                    endTime,@"end_time",
                                    limit,@"limit",
                                    SINGER_ID,@"singer_id",
                                    productionId, @"production_id",
                                    productionVersion, @"production_version",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/get_shoutbox_comment_data.php",HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) { //-- good data
            completed(dictResponse,nil);
        }
        else { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil,error);
        
    }];
}



#pragma mark - Post Comment Shoutbox

+ (void)postCommentFanzone:(NSString*)pageId
                 fanzoneId:(NSString*)fanzoneId
                    userId:(NSString*)userId
                      text:(NSString*)text
          isGetNewShoutBox:(NSString*)isGetNewShoutBox
                 startTime:(NSString*)startTime
                   endTime:(NSString*)endTime
                     limit:(NSString*)limit
              productionId:(NSString*)productionId
         productionVersion:(NSString*)productionVersion
                 completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    pageId,@"page_id",
                                    fanzoneId,@"fanzone_id",
                                    userId,@"user_id",
                                    text,@"text",
                                    isGetNewShoutBox,@"is_get_new_shoutbox",
                                    startTime,@"start_time",
                                    endTime,@"end_time",
                                    limit,@"limit",
                                    productionId, @"production_id",
                                    productionVersion, @"production_version",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/add_shoutbox_comment.php",HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) { //-- good data
            completed(dictResponse,nil);
        }
        else { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil,error);
        
    }];
}


//*********************************************************************************//
#pragma mark - Search API

+ (void)searchAPIOfSinglerID:(NSString*)singleID
              contentTypeId:(ContentTypeID)contentTypeId
                     keyword:(NSString*)keyword
                      limit:(NSString*)limit
                       page:(NSString *)page
                  isGetBody:(NSString*)isGetBody
                   isGetHot:(NSString*)isGetHot
                      appID:(NSString*)appID
                 appVersion:(NSString*)appVersion
                  completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:singleID,@"singer_id",
                                    [self getUserIdifExist],@"user_id",
                                    [NSString stringWithFormat:@"%d",contentTypeId],@"content_type_id",
                                    keyword,@"keyword",
                                    limit,@"limit",
                                    page,@"page",
                                    isGetBody,@"is_get_node_body",
                                    isGetHot, @"is_hot_node",
                                    appID,@"production_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/search_node.php",HOST_FOR_CONTENT];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

+ (void)searchUserOfSinglerID:(NSString*)singleID
                     keyword:(NSString*)keyword
                       limit:(NSString*)limit
                        page:(NSString *)page
                       appID:(NSString*)appID
                  appVersion:(NSString*)appVersion
                   completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:singleID,@"singer_id",
                                    keyword,@"keyword",
                                    limit,@"limit",
                                    page,@"page",
                                    appID,@"production_id",
                                    appVersion,@"production_version", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/search_user.php",HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}


//-- request get SONG_RINGBACKTONE_ID
+ (void)apiGetSongRingBackToneIDByMusicID:(NSString*)musicId
                      distributorChannelId:(NSString*)distributorChannelId
                        telcoCode:(NSString*)telcoCode
                        appID:(NSString*)appID
                   appVersion:(NSString*)appVersion
                    completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:SINGER_ID,@"singer_id",
                                    musicId,@"music_id",
                                    distributorChannelId,@"distributor_channel_id",
                                    telcoCode,@"telco_code",
                                    appID,@"production_id",
                                    appVersion,@"production_version", nil];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ringbackApi = [userDefaults valueForKey:Key_ringbackApi];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",ringbackApi];
    
    if ([urlString length] == 0) {
        urlString = [NSString stringWithFormat:@"http://wrappersrv.soci.vn/?q=/gom_services/get_ringback_tone_code/get.json"];
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

+ (void)sendLocalLog:(NSString*)sendLog
      completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:sendLog,@"log", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/save_log.php",HOST_FOR_USER];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

//test
+ (void)syncFeedData:(NSString*)userID
          singerId:(NSString*)singerId
        dataFeed:(NSString*)dataFeed
    productionId:(NSString*)productionId
productionVersion:(NSString*)productionVersion
       completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"user_id",
                                    singerId,@"singer_id",
                                    dataFeed,@"data_like_feed",
                                    productionId, @"production_id",
                                    productionVersion, @"production_version",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"https://myidol.soci.vn/ati/service_v1.0/sync_like_comment.php"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200)
        { //-- good data
            completed(dictResponse,nil);
        }
        else
        { //-- bad data
            
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //-- error
        completed(nil,error);
        
    }];
}


//-------------------------getCommentData----------------------------//
+ (void)getCommentDataFeed:(NSString*)singerID
                         productionId:(NSString*) productionId
                         productionVersion:(NSString*)productionVersion
                         contentTypeId:(NSString *)contentTypeId
                             contentId:(NSString*)contentId
                                commentId:(NSString*)commentId
                                 isGetComment:(NSString*)isGetComment
                            isFeed:(NSString*)isFeed
                             completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
{
    NSLog(@"%s", __func__);
    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    singerID,@"singer_id",
                                    PRODUCTION_ID,@"production_id",
                                    PRODUCTION_VERSION,@"production_version",
                                    contentTypeId,@"content_type_id",
                                    contentId, @"content_id",
                                    commentId,@"comment_id",
                                    isGetComment,@"is_get_comment_of_comment",
                                    isFeed,@"is_feed", nil];
    
    NSString *urlString = @"https://myidol.soci.vn/ati/service_v1.0/get_comment_data.php";

    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [client setAllowsInvalidSSLCertificate:YES];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        //-- data return
        NSDictionary *dictResponse = [operation.responseString JSONValue];
        
        if ([operation.response statusCode] == 200) {
            completed(dictResponse,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
            completed(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //-- error
        completed(nil, error);
    }];
}

@end
