//
//  UserInfo.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/19/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, retain) NSString          *userId;
@property (nonatomic, retain) NSString          *profilePageId;
@property (nonatomic, retain) NSString          *serverId;
@property (nonatomic, retain) NSString          *appId;
@property (nonatomic, retain) NSString          *appVersion;
@property (nonatomic, retain) NSString          *userGroupId;
@property (nonatomic, retain) NSString          *statusId;
@property (nonatomic, retain) NSString          *viewId;
@property (nonatomic, retain) NSString          *userName;
@property (nonatomic, retain) NSString          *fullName;
@property (nonatomic, retain) NSString          *email;
@property (nonatomic, retain) NSString          *gender;
@property (nonatomic, retain) NSString          *birthday;
@property (nonatomic, retain) NSString          *birthdaySearch;
@property (nonatomic, retain) NSString          *countryIso;
@property (nonatomic, retain) NSString          *languageId;
@property (nonatomic, retain) NSString          *styleId;
@property (nonatomic, retain) NSString          *timeZone;
@property (nonatomic, retain) NSString          *dstCheck;
@property (nonatomic, retain) NSString          *joined;
@property (nonatomic, retain) NSString          *lastLogin;
@property (nonatomic, retain) NSString          *lastActivity;
@property (nonatomic, retain) NSString          *userImage;
@property (nonatomic, retain) NSString          *hideTip;
@property (nonatomic, retain) NSString          *status;
@property (nonatomic, retain) NSString          *feedSort;
@property (nonatomic, retain) NSString          *footerBar;
@property (nonatomic, retain) NSString          *inviteUserId;
@property (nonatomic, retain) NSString          *imBeep;
@property (nonatomic, retain) NSString          *imHide;
@property (nonatomic, retain) NSString          *isInvisible;
@property (nonatomic, retain) NSString          *totalSpam;
@property (nonatomic, retain) NSString          *lastIpAddress;
@property (nonatomic, retain) NSString          *mobile;

@property (nonatomic, retain) NSMutableArray    *userInfoArray;


@end
