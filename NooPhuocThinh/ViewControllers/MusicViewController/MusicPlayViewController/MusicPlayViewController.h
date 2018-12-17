//
//  MusicPlayViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicCustomCellPlay.h"
#import "MusicTrackNew.h"
#import "MusicTrackLyric.h"
#import "MusicTrackComment.h"
#import "AppDelegate.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "Utility.h"
#import "MulticastDelegate.h"
#import "UIImageView+WebCache.h"
#import "AudioPlayer.h"
#import "HMSegmentedControl.h"
#import "BaseCommentsTableViewController.h"
#import "CommentsNewsViewController.h"
#import "Comment.h"
#import "Downloader.h"

@class AudioPlayer;

@interface MusicPlayViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AudioPlayerDelegate, AVAudioPlayerDelegate, UIScrollViewDelegate,BaseCommentsTableViewControllerDelegate,BaseViewControllerDelegate, DetailCommentsViewControllerDelegate, UIAlertViewDelegate, FileDownloaderDelegate>
{
    IBOutlet UIButton       *btnRefresh;
    IBOutlet UIButton       *btnRepeat;
    IBOutlet UIButton       *btnSuffer;
    IBOutlet UIButton       *btnNext;
    IBOutlet UIButton       *btnPrevious;
    IBOutlet UIButton       *btnTimer;
    IBOutlet UIButton       *btnSpeaker;
    IBOutlet UIButton       *btnComment;
    IBOutlet UIButton       *btnShare;
    IBOutlet UIButton       *btnDownload;
    IBOutlet UIButton       *btnPhone;
    IBOutlet UIButton       *btnLike;    
    IBOutlet UIButton       *btnViewLyric;
    IBOutlet UIButton       *btnViewComment;
    
    BOOL                    isTimer;
    BOOL                    isSpeaker;
    BOOL                    isLyric;
    BOOL                    isComment;
    BOOL                    _isAutoScroll;
    BOOL                    _isLike;
    BOOL                    _isCreateComment;
    
    NSMutableArray          *comments;
    NSMutableArray          *userProfiles;
    
    AudioPlayer *_audioPlayer;
    
    //-- segment
    HMSegmentedControl                  *segmentedControlComment;
    NSInteger                           currentIndexSegment;
    
    //-- download music
    UIImageView *loadingView;
}

@property (nonatomic, retain) IBOutlet UIView               *viewTop;

@property (nonatomic, retain) BaseCommentsTableViewController  *tableviewComments;

@property (nonatomic, retain) IBOutlet UIView               *viewSegment;
@property (nonatomic, retain) IBOutlet UIView               *viewAddScroll;
@property (nonatomic, retain) IBOutlet UIScrollView         *scrollContent;

@property (nonatomic, retain) IBOutlet UIImageView          *imgCover;
@property (nonatomic, retain) IBOutlet UIImageView          *imgTop;
@property (nonatomic, retain) IBOutlet CBAutoScrollLabel    *lblArtist;
@property (nonatomic, retain) IBOutlet UILabel              *lblAlbum;
@property (nonatomic, retain) IBOutlet UILabel              *lblCommented;
@property (nonatomic, retain) IBOutlet UILabel              *lblLiked;
@property (nonatomic, retain) IBOutlet UISlider             *sliderBar;
@property (nonatomic, retain) IBOutlet UITableView          *tableViewComment;
@property (nonatomic, retain) IBOutlet UIView               *viewLyric;
@property (nonatomic, retain) IBOutlet UITextView           *txvLyric;
@property (nonatomic, retain) IBOutlet UIButton             *btnPlayPause;

@property (nonatomic, weak)  IBOutlet CBAutoScrollLabel     *autoFullName;
@property (nonatomic, retain) IBOutlet NSString             *titleAlbum;

//-- download music
@property (nonatomic, retain) NSMutableDictionary *musicDownloadsInProgress;

//-- Data from MusicAlbum
@property (nonatomic, retain) NSMutableArray                *arrTrack;
@property (nonatomic, assign) NSInteger                     indexOfSong;

@property (nonatomic, retain) MusicTrackNew                 *musicTrack;
@property (nonatomic, retain) Comment                       *superComment;
@property (nonatomic, retain) NSString                      *totalTimeString;
@property (nonatomic, retain) NSTimer                       *sliderTimer;


//--Aciton
- (IBAction)clickToBtnRefresh:(id)sender;
- (IBAction)clickToBtnPlayPause:(id)sender;
- (IBAction)clickToBtnRepeat:(id)sender;
- (IBAction)clickToBtnSuffer:(id)sender;
- (IBAction)clickToBtnNext:(id)sender;
- (IBAction)clickToBtnPrevious:(id)sender;
- (IBAction)clickToBtnTimer:(id)sender;
- (IBAction)clickToBtnSpeaker:(id)sender;
- (IBAction)clickToBtnComment:(id)sender;
- (IBAction)clickToBtnShare:(id)sender;
- (IBAction)clickToBtnDownload:(id)sender;
- (IBAction)clickToBtnPhone:(id)sender;
- (IBAction)clickToBtnLike:(id)sender;

- (IBAction)clickToBtnViewLyric:(id)sender;
- (IBAction)clickToBtnViewComment:(id)sender;

@end
