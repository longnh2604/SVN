//
//  ContentTypeList.h
//  NooPhuocThinh
//
//  Created by longnh on 1/2/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentTypeList : NSObject

@property(nonatomic, retain) NSString *content_type_id;
@property(nonatomic, retain) NSString *content_type_name;
@property(nonatomic, retain) NSString *current_page;
@property(nonatomic, retain) NSString *node_total;
@property(nonatomic, retain) NSString *paging_total;

@end
