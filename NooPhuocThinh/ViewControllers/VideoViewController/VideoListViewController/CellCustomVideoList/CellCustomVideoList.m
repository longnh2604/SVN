//
//  CellCustomVideoList.m
//  NooPhuocThinh
//
//  Created by longnh on 1/3/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "CellCustomVideoList.h"

@implementation CellCustomVideoList

@synthesize imgViewVideo;
@synthesize lblNameVideo;
@synthesize lblCountPlay;
@synthesize lblCountLike;
@synthesize lblCountComments;
@synthesize lblCountShares;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
