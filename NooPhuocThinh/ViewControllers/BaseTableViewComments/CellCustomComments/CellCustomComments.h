//
//  CellCustomComments.h
//  NooPhuocThinh
//
//  Created by longnh on 1/5/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellCustomComments : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView   *imgAvatar;
@property (nonatomic, retain) IBOutlet UIImageView   *imgBackground;
@property (nonatomic, retain) IBOutlet UILabel       *lblNickName;
@property (nonatomic, retain) IBOutlet UILabel       *lblPointOfUser;
@property (nonatomic, retain) IBOutlet UILabel       *lblDateTime;
@property (nonatomic, retain) IBOutlet UILabel       *lblTotalChildComment;
@property (nonatomic, retain) IBOutlet UITextView    *txtViewComment;
@property (nonatomic, retain) IBOutlet UIButton      *btnShowListComments;
@property (nonatomic, retain) IBOutlet UIView        *viewInfo;

@end
