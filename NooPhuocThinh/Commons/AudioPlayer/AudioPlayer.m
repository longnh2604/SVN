//
//  AudioPlayer.m
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioButton.h"
#import "AudioStreamer.h"
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import "UIImageView+WebCache.h"

static AudioPlayer *sharedPlayAudio = nil;

@implementation AudioPlayer

@synthesize streamer, button, url;
@synthesize listSongsAlbum, indexOfSong;
@synthesize totalTimeString, sliderBar, sliderTimer;
@synthesize delegateAudio;
@synthesize isStartMusic;

int taskCountFinishedSong = 0;

+ (AudioPlayer *)sharedAudioPlayerMusic
{
    if (sharedPlayAudio == nil) {
        static dispatch_once_t threeToken;
        dispatch_once(&threeToken, ^{
            sharedPlayAudio = [[AudioPlayer alloc] init];
        });
    }
    
    return sharedPlayAudio;
}


+ (void)initWithDelegateAudio:(id<AudioPlayerDelegate>) delegateAudio {
    
    [[AudioPlayer sharedAudioPlayerMusic] addDelegate:delegateAudio];
}

+ (void)addDelegateAudio:(id)delegateAudio
{
    [[AudioPlayer sharedAudioPlayerMusic] addDelegate:delegateAudio];
}

+ (void)removeDelegateAudio:(id)delegateAudio
{
    [[AudioPlayer sharedAudioPlayerMusic] removeDelegate:delegateAudio];
}

- (void)addDelegate:(id)delegate
{
    [delegatesAudio addDelegate:delegate];
}

- (void)removeDelegate:(id)delegate
{
    [delegatesAudio removeDelegate:delegate];
}


- (id)init
{
    self = [super init];
    if (self) {
        self.isStartMusic = NO;
        timer = nil;
        delegatesAudio = (MulticastDelegate<AudioPlayerDelegate>*) [[MulticastDelegate alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [super dealloc];
    [url release];
    [streamer release];
    [button release];
    [timer invalidate];
    [listSongsAlbum release];
    [totalTimeString release];
    [sliderTimer release];
    [sliderBar release];
}


- (BOOL)isProcessing
{
    return [streamer isPlaying] || [streamer isWaiting] || [streamer isFinishing] ;
}

- (BOOL)isFinishingSong {
    
    return [streamer isFinishing];
}

- (BOOL)isPlayingSong {
    
    return [streamer isPlaying];
}

- (BOOL)isPausedSong {
    
    return [streamer isPaused];
}

- (BOOL)isWaitingSong {
    
    return [streamer isWaiting];
}

- (BOOL)isIdleSong {
    
    return [streamer isIdle];
}

- (void)setVolumeMusic:(float)Level {
    
    [streamer setVolume:Level];
}

- (void)play
{
//    NSLog(@"%s", __func__);
    isStartMusic = NO;
    if (!streamer) {
        
        self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
        self.streamer.fixedLength = self.fixedLength;
        
        // set up display updater
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(updateProgress)]];    
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        if (timer && [timer isValid]) {
            [timer invalidate];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             invocation:invocation 
                                                repeats:YES];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:streamer];
        
        taskCountFinishedSong = 0;
    }
    
    if ([streamer isPlaying]) {
        [streamer pause];
    } else {
        [streamer start];
    }
    
    //Modified by TuanNM@20140828
    //de tranh goi play() play() lan lon khi pause tu lockscreen
    [self setSongToPlay];
    //end
    
}

//Add by TuanNM@20140828
//ktra xem co phai dang play album hay la welcome
- (bool)isPlayWelcomeMusic
{
    NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
    NSString *musicAuthorMusicId = [defaultSongId valueForKey:@"DefaultAuthorMusicId"];
    if (musicAuthorMusicId != nil)
        return false;
    return true;
}

//lua chon bai hat welcome hay trong album
- (void)setSongToPlay
{
    NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
    
    //longnh kiem tra neu la pause roi replay thi khong load lai music info
    NSDictionary *playInfoDic = [[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    NSString *playTrackName = [playInfoDic objectForKey:MPMediaItemPropertyTitle];
    NSString *defaultTrackName = [defaultSongId valueForKey:@"DefaultNameSong"];
    NSLog(@"playing:%@ default:%@",playTrackName,defaultTrackName);
    if ([playTrackName isEqualToString:defaultTrackName]) {
        return;
    }
    
    
    
    // Modified by TuanNM@20140828
    // Hien tai khi play welcome music thi play1() nhung neu pause tu LockScreen thi khi vao lai app play() duoc goi
    // Tuong tu neu play album
    // --> sua tam: check neu DefaultAuthorMusicId!=nil --> dang play album, else play welcome music
    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
    if (![self isPlayWelcomeMusic]) {
        NSString *musicAlbumName = [defaultSongId valueForKey:@"DefaultAlbumName"];
        NSString *musicAuthorMusicId = [defaultSongId valueForKey:@"DefaultAuthorMusicId"];
        NSString *musicTrackName = [defaultSongId valueForKey:@"DefaultNameSong"];
        NSString *albumThumbImagePath = [defaultSongId valueForKey:@"DefaultAlbumThumbImagePath"];
        
        //--set download image cover
        UIImageView *imgCover = [[UIImageView alloc] init];
        [imgCover setImageWithURL:[NSURL URLWithString:albumThumbImagePath]
                 placeholderImage:[UIImage imageNamed:@"MusicDefault.png"]
                          options:SDWebImageProgressiveDownload
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                            //longnh: chuyen code vao day de fix bug khong hien dung image album
                            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:imgCover.image];
                            
                            [songInfo setObject:musicTrackName forKey:MPMediaItemPropertyTitle];
                            [songInfo setObject:musicAuthorMusicId forKey:MPMediaItemPropertyArtist];
                            [songInfo setObject:musicAlbumName forKey:MPMediaItemPropertyAlbumTitle];
                            [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
                            NSLog(@"albumThumbImagePath:%@",albumThumbImagePath);
                            NSLog(@"Play album: %@ with song id=%@ - %@", musicAlbumName, musicAuthorMusicId, musicTrackName);
                            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
                            
                        }];
        /*
        [imgCover setImageWithURL:[NSURL URLWithString:albumThumbImagePath] placeholderImage:[UIImage imageNamed:@"MusicDefault.png"] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
            //
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            //-- finish
            if (image) {
                imgCover.image = image;
            }else {
                imgCover.image = [UIImage imageNamed:@"MusicDefault.png"];
            }
        }];
        */
        //-- call set Data Music when run Background
    }
    else { //welcome Music
        
        NSUserDefaults *defaultMusic = [NSUserDefaults standardUserDefaults];
        //    NSString *musicAlbumName = [defaultSongId valueForKey:@"DefaultAlbumName"];
        //    NSString *musicAuthorMusicId = [defaultSongId valueForKey:@"DefaultAuthorMusicId"];
        NSString *musicTrackName = [[defaultMusic  objectForKey:@"startMusic"] objectForKey:@"name"];
        //    NSString *albumThumbImagePath = [defaultSongId valueForKey:@"DefaultAlbumThumbImagePath"];
        
        //-- call set Data Music when run Background
        [songInfo setObject:musicTrackName forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:@"" forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:@"" forKey:MPMediaItemPropertyAlbumTitle];
        NSLog(@"Play welcome song: last_update=%@, id=%@ - %@", [[defaultMusic  objectForKey:@"startMusic"] objectForKey:@"last_update"], [[defaultMusic  objectForKey:@"startMusic"] objectForKey:@"music_id"], musicTrackName);
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
}
//end adding

//longnh add
- (void)play1
{
//    NSLog(@"%s", __func__);
    if (!streamer) {
        
        self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
        self.streamer.fixedLength = self.fixedLength;
        
        // set up display updater
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(updateProgress)]];
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        if (timer && [timer isValid]) {
            [timer invalidate];
        }
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             invocation:invocation
                                                repeats:YES];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:streamer];
        
        taskCountFinishedSong = 0;
    }
    
    if ([streamer isPlaying]) {
        [streamer pause];
    } else {
        [streamer start];
    }

    //Modified by TuanNM@20140828
    //de tranh goi play() play() lan lon khi pause tu lockscreen
    [self setSongToPlay];
    //end

}

- (void)stop
{
//    NSLog(@"%s", __func__);
    [button setProgress:0];
    [button stopSpin];

    button.image = [UIImage imageNamed:playImage];
    button = nil; // Tránh vấn đề flash player
    [button release];     
    
    // release streamer
	if (streamer)
	{
        //longnh fix bug thoat app khi play dung luc het bai
//        NSLog(@"streamer state:%d",streamer.state);
        AudioStreamer *s = streamer;
        streamer = nil;
		[s stop];
		[s release];
		s = nil;
//        NSLog(@"streamer state:%d",s.state);
        
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:ASStatusChangedNotification
                                                      object:s];
	}
}

-(void) pauseSong {
    NSLog(@"%s", __func__);
    
    //-- pause song
    if (streamer) {
        [streamer pause];
    }
}


-(void) updateSlideChangedToTimeByValue:(double) sliderValue {
    
    [streamer seekToTime:sliderValue];
}

- (void)updateProgress
{
    if (streamer.progress <= streamer.duration ) {
        [button setProgress:streamer.progress/streamer.duration];
        
    } else {
        [button setProgress:0.0f];
    }
    
    if ([streamer isPlaying]) {
        
        //-- pass delegate
        NSUserDefaults *defaultEditSlider = [NSUserDefaults standardUserDefaults];
        
        if ([defaultEditSlider boolForKey:@"isEditSlider"] == NO && [delegatesAudio respondsToSelector:@selector(updateTimerSliderAudio:WithSlider:withSliderMaxvalue:)]) {
            [delegatesAudio updateTimerSliderAudio:streamer.currentTime WithSlider:streamer.progress withSliderMaxvalue:streamer.duration];
        }
    }
}


/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
//    NSLog(@"%s", __func__);
	if ([streamer isWaiting])
	{
//        NSLog(@"streamer isWaiting");
        button.image = [UIImage imageNamed:stopImage];
        [button startSpin];
    } else if ([streamer isIdle]) {
//        NSLog(@"streamer isIdle");
        button.image = [UIImage imageNamed:playImage];
		[self stop];
        
        if ([delegatesAudio respondsToSelector:@selector(playFailedAudio)]) {
            [delegatesAudio playFailedAudio];
        }
        
	} else if ([streamer isPaused]) {
//        NSLog(@"streamer isPaused");
        button.image = [UIImage imageNamed:playImage];
        [button stopSpin];
        [button setColourR:0.0 G:0.0 B:0.0 A:0.0];
        
        //-- pass delegate
        NSUserDefaults *defaultEditSlider = [NSUserDefaults standardUserDefaults];
        
        if ([defaultEditSlider boolForKey:@"isEditSlider"] == NO && [delegatesAudio respondsToSelector:@selector(setUpSlideBarBottomByIsPlaying:)]) {
            [delegatesAudio setUpSlideBarBottomByIsPlaying:NO];
        }
        
    } else if ([streamer isPlaying]) {
//        NSLog(@"streamer isPlaying");
        button.image = [UIImage imageNamed:stopImage];
        [button stopSpin];
        
        //-- pass delegate
        if ([delegatesAudio respondsToSelector:@selector(setUpSlideBarBottomByIsPlaying:)]) {
            [delegatesAudio setUpSlideBarBottomByIsPlaying:YES];
        }
        
	} else if ([streamer isFinishing]) {
//        NSLog(@"streamer isFinishing");
        button.image = [UIImage imageNamed:stopImage];
        [button stopSpin];
        
        taskCountFinishedSong ++;
        if (taskCountFinishedSong == 2) {
            
            if ([delegatesAudio respondsToSelector:@selector(playFinishedAudio)]) {
                [delegatesAudio playFinishedAudio];
            }
        }
    }
    
    [button setNeedsLayout];
    [button setNeedsDisplay];
}


- (void)playNextSong
{
//    NSLog(@"%s", __func__);
    NSUserDefaults *repeatSufferFlagsDefault = [NSUserDefaults standardUserDefaults];
    
    if (indexOfSong < [listSongsAlbum count]-1)
    {
        //-- change song
        indexOfSong += 1;
        
        //-- load play song
        [self LoadUpdateSongContent];
        
    }else {
        
        self.indexOfSong = 0;
        
        //-- load play song
        [self LoadUpdateSongContent];
    }
    
    
    //-- check is suffer active
    if ([repeatSufferFlagsDefault boolForKey:@"SufferFlags"] == YES) {
        
        if ([listSongsAlbum count] >2) {
            
            //-- play random list song
            int indexRandom = (arc4random()%[listSongsAlbum count]);
            
            while (indexRandom == self.indexOfSong) {
                
                indexRandom = (arc4random()%[listSongsAlbum count]);
            }
            
            self.indexOfSong = indexRandom;
        }
    }
}

- (void)playPreviousSong
{
    NSLog(@"%s", __func__);
    NSUserDefaults *repeatSufferFlagsDefault = [NSUserDefaults standardUserDefaults];
    
    if (indexOfSong >= 1)
    {
        //-- change song
        indexOfSong -= 1;
        
        //-- load play song
        [self LoadUpdateSongContent];
        
    }else {
        
        if ([repeatSufferFlagsDefault boolForKey:@"RepeatFlags"] == YES) {
            
            self.indexOfSong = [listSongsAlbum count] -1;
            
            //-- load play song
            [self LoadUpdateSongContent];
        }
    }
    
    //-- check is suffer active
    if ([repeatSufferFlagsDefault boolForKey:@"SufferFlags"] == YES) {
        
        if ([listSongsAlbum count] >2) {
            
            //-- play random list song
            int indexRandom = (arc4random()%[listSongsAlbum count]);
            
            while (indexRandom == self.indexOfSong) {
                
                indexRandom = (arc4random()%[listSongsAlbum count]);
            }
            
            self.indexOfSong = indexRandom;
        }
    }
}

//-- change content of song
-(void) LoadUpdateSongContent {
//    NSLog(@"%s", __func__);
    
    if ([self.listSongsAlbum count] > 0) {
        
        NSString *musicTrack = [[self.listSongsAlbum objectAtIndex:indexOfSong] valueForKey:@"musicPath"];
        NSString *musicTrackNodeId = [[self.listSongsAlbum objectAtIndex:indexOfSong] valueForKey:@"nodeId"];
        
        NSString *musicTrackName = [[self.listSongsAlbum objectAtIndex:indexOfSong] valueForKey:@"name"];
        NSString *musicAlbumName = [[self.listSongsAlbum objectAtIndex:indexOfSong] valueForKey:@"albumName"];
        NSString *musicAlbumId = [[self.listSongsAlbum objectAtIndex:indexOfSong] valueForKey:@"albumId"];
        NSString *albumThumbImagePath = [[self.listSongsAlbum objectAtIndex:indexOfSong] valueForKey:@"albumThumbImagePath"];
        NSString *musicAuthorMusicId = [[self.listSongsAlbum objectAtIndex:indexOfSong] valueForKey:@"albumAuthorMusicId"];
        
        NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
        [defaultSongId setValue:musicAlbumName forKey:@"DefaultAlbumName"];
        [defaultSongId setValue:musicAuthorMusicId forKey:@"DefaultAuthorMusicId"];
        [defaultSongId setValue:musicTrackName forKey:@"DefaultNameSong"];
        [defaultSongId setValue:albumThumbImagePath forKey:@"DefaultAlbumThumbImagePath"];
        [defaultSongId setValue:musicTrackNodeId forKey:@"DefaultSongId"];
        [defaultSongId synchronize];
        
        //-- stop
        [self stop];
        //longnh fix
        if (isStartMusic) {
            NSUserDefaults *defaultMusic = [NSUserDefaults standardUserDefaults];
            if ([[defaultMusic objectForKey:@"startMusic"] objectForKey:@"musicLocalPath"]) {
//                NSString *filePath = [NSURL fileURLWithPath:[[defaultMusic objectForKey:@"startMusic"] objectForKey:@"musicLocalPath"]];
                self.url = [NSURL fileURLWithPath:[[defaultMusic objectForKey:@"startMusic"] objectForKey:@"musicLocalPath"]];
                self.fixedLength = YES;
                [self play1];
            } else {
                if ([self checkExistMusicPath:musicTrack] == YES) {
                    
                    //-- if existing musicPath is Play
                    self.url = [NSURL URLWithString:musicTrack];
                    self.fixedLength = NO;
                    [self play1];
                }else {
                    //-- if not existing musicPath is show message
                    if ([delegatesAudio respondsToSelector:@selector(playFailedAudio)]) {
                        [delegatesAudio playFailedAudio];
                    }
                }
            
            }

        } else {
            //-- check downloader video
            NSString *filePath = [Utility getMusicFilePathWithCategoryId:musicAlbumId withNodeId:musicTrackNodeId];
            BOOL isShowDownLoad = [Utility checkingAFileExistsWithPath:filePath];
            if (isShowDownLoad == YES) {
                
                //-- if existing musicPath is Play
                self.url = [NSURL fileURLWithPath:filePath];
                self.fixedLength = YES;
                [self play];
            } else {
                if ([self checkExistMusicPath:musicTrack] == YES) {
                    
                    //-- if existing musicPath is Play
                    self.url = [NSURL URLWithString:musicTrack];
                    self.fixedLength = NO;
                    [self play];
                }else {
                    //-- if not existing musicPath is show message
                    if ([delegatesAudio respondsToSelector:@selector(playFailedAudio)]) {
                        [delegatesAudio playFailedAudio];
                    }
                }
            }
        }
        //-- Call notification reload data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload_MusicAlbumVC" object:nil];
    }
}

//-- validate MusicPath
-(BOOL) checkExistMusicPath:(NSString *) musicPathStr {
    NSLog(@"%s", __func__);
    
    //-- validate content
    NSString *tempMusicPath = [musicPathStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereAreJustSpaces = [tempMusicPath isEqualToString:@""];
    
    if( ((!thereAreJustSpaces) || [musicPathStr length] > 0))
        return YES;
    else
        return NO;
}

@end
