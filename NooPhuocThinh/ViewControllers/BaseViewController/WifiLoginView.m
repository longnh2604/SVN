//
//  WifiLoginView.m
//  NooPhuocThinh
//
//  Created by longnh on 3/5/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "WifiLoginView.h"

@implementation WifiLoginView

@synthesize viewBottom,viewTop,imgBackground;
@synthesize lblTitleLogin;
@synthesize txtMessageLogin;
@synthesize txtPhoneNumber;
@synthesize txtPassWord;
@synthesize btnLogin;
@synthesize btnCreateAccount;
@synthesize btnExist;
@synthesize btnForgotPassword;
@synthesize lblForgotPassword;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

@end
