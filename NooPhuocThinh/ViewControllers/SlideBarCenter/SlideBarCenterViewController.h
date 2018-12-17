//
//  SlideBarCenterViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicTrackNew.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "Utility.h"
#import "MulticastDelegate.h"
#import "UIImageView+WebCache.h"
#import "CBAutoScrollLabel.h"
#import "AudioPlayer.h"
#import "FanZoneViewController.h"
#import "AnimatedGif.h"


@interface SlideBarCenterViewController : BaseViewController
<AudioPlayerDelegate, AVAudioPlayerDelegate,FanZoneViewControllerDelegate, BaseViewControllerDelegate>
{
    NSTimer *timerChangeView;
    NSTimer *timerScrollUp;
    
    NSMutableArray *listMessagesFZ;
    NSInteger totalCountScrollUpLable;
    
    NSString *indexTapFanzone;
}

+ (SlideBarCenterViewController *) sharedSlideBarCenter;

@property (nonatomic, retain) MusicTrackNew           *musicTrack;
@property (nonatomic, retain) NSMutableArray          *arrTrack;

//-- fanzone
@property (nonatomic, retain) NSMutableArray          *listMessagesFZ;

//-- View News
@property (nonatomic, retain) IBOutlet UIView         *viewNews;
@property (nonatomic, retain) IBOutlet UIButton       *btnShowMusic;
@property (nonatomic, retain) IBOutlet UIButton       *btnHiddenNews;
@property (nonatomic, retain) IBOutlet UILabel        *lblContentFZ;
@property (nonatomic, weak) IBOutlet CBAutoScrollLabel      *lblTitleNews;


//-- View Music
@property (nonatomic, retain) IBOutlet UIView         *viewMusic;
@property (nonatomic, retain) IBOutlet UIButton       *btnPlayPause;
@property (nonatomic, retain) IBOutlet UIButton       *btnNext;
@property (nonatomic, retain) IBOutlet UIButton       *btnShowNews;
@property (nonatomic, retain) IBOutlet UILabel        *lblTimeSong;
@property (nonatomic, weak) IBOutlet CBAutoScrollLabel      *lblNameSong;


@property (nonatomic, retain) IBOutlet UISlider       *sliderBar;
@property (nonatomic, retain) NSTimer                 *sliderTimer;

@property (nonatomic, retain) NSString                *totalTimeString;
@property (nonatomic, assign) NSInteger               indexOfSong;

@property (nonatomic, retain) IBOutlet UIImageView    *imgViewVolume;

//-- Aciton
- (IBAction)clickToBtnPlayPauseSongSlidBar:(id)sender;
- (IBAction)clickToBtnNextSongSlidBar:(id)sender;
- (IBAction)clickToBtnPreviousSongSlidBar:(id)sender;
- (IBAction)clickBtnHiddenNews:(id)sender;

@end
