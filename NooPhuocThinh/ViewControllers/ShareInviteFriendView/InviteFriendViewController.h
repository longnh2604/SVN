//
//  InviteFriendViewController.h
//  NooPhuocThinh
//
//  Created by longnh on 4/16/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Accounts/Accounts.h>

@interface InviteFriendViewController : BaseViewController
{
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableContactList;
@property (nonatomic, retain) NSMutableArray *contactArray;
@property (nonatomic, retain) NSMutableArray *listSelected;
@property (nonatomic, retain) NSMutableArray *listSmsToSend;

@end
