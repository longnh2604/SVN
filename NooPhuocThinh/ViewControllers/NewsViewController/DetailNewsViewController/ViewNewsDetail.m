//
//  ViewNewsDetail.m
//  NooPhuocThinh
//
//  Created by longnh on 6/2/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "ViewNewsDetail.h"

@implementation ViewNewsDetail

@synthesize webViewNewsDetail;
//@synthesize scrollViewDetailNews;
//@synthesize viewHeader;
//@synthesize imgAvatar;
//@synthesize lblTitle;
//@synthesize lblDate;
//@synthesize lblCountComments;
//@synthesize btnShowComments;

@synthesize viewToolbar;
@synthesize btnComment;
@synthesize btnShare;
@synthesize btnLikeNews;
@synthesize lblNumberOfLike;
@synthesize lblNumberOfComment;
@synthesize isLoaded;
@synthesize currentIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isLoaded = NO;
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
//    [aCoder encodeObject:self.scrollViewDetailNews  forKey:@"scrollViewDetailNews"];
    [aCoder encodeObject:self.webViewNewsDetail     forKey:@"webViewNewsDetail"];
//    [aCoder encodeObject:self.viewHeader            forKey:@"viewHeader"];
//    [aCoder encodeObject:self.imgAvatar             forKey:@"imgAvatar"];
//    [aCoder encodeObject:self.lblTitle              forKey:@"lblTitle"];
//    [aCoder encodeObject:self.lblDate               forKey:@"lblDate"];
//    [aCoder encodeObject:self.lblCountComments      forKey:@"lblCountComments"];
//    [aCoder encodeObject:self.btnShowComments       forKey:@"btnShowComments"];
    
    
    [aCoder encodeObject:self.viewToolbar           forKey:@"viewToolbar"];
    [aCoder encodeObject:self.btnComment            forKey:@"btnComment"];
    [aCoder encodeObject:self.btnShare              forKey:@"btnShare"];
    [aCoder encodeObject:self.btnLikeNews           forKey:@"btnLikeNews"];
    [aCoder encodeObject:self.lblNumberOfLike       forKey:@"lblNumberOfLike"];
    [aCoder encodeObject:self.lblNumberOfComment    forKey:@"lblNumberOfComment"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
//        self.scrollViewDetailNews   = [aDecoder decodeObjectForKey:@"scrollViewDetailNews"];
        self.webViewNewsDetail      = [aDecoder decodeObjectForKey:@"webViewNewsDetail"];
//        self.viewHeader             = [aDecoder decodeObjectForKey:@"viewHeader"];
//        self.imgAvatar              = [aDecoder decodeObjectForKey:@"imgAvatar"];
//        self.lblTitle               = [aDecoder decodeObjectForKey:@"lblTitle"];
//        self.lblDate                = [aDecoder decodeObjectForKey:@"lblDate"];
//        self.lblCountComments       = [aDecoder decodeObjectForKey:@"lblCountComments"];
//        self.btnShowComments        = [aDecoder decodeObjectForKey:@"btnShowComments"];
        
        self.viewToolbar            = [aDecoder decodeObjectForKey:@"viewToolbar"];
        self.btnComment             = [aDecoder decodeObjectForKey:@"btnComment"];
        self.btnShare               = [aDecoder decodeObjectForKey:@"btnShare"];
        self.btnLikeNews            = [aDecoder decodeObjectForKey:@"btnLikeNews"];
        self.lblNumberOfLike        = [aDecoder decodeObjectForKey:@"lblNumberOfLike"];
        self.lblNumberOfComment     = [aDecoder decodeObjectForKey:@"lblNumberOfComment"];
    }
    return self;
}

//- (void) dealloc
//{
//    //longnh: hidden all old control
//    scrollViewDetailNews = nil;
//    webViewNewsDetail = nil;
//
//    NSLog(@"%s", __func__);
//}

@end
