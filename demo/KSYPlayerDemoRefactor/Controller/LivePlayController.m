//
//  LivePlayController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/11.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "LivePlayController.h"
#import "RecordeViewController.h"
#import "LivePlayOperationView.h"
#import "KSYUIVC.h"

@interface LivePlayController ()
@property (nonatomic, strong) RecordeViewController     *recordeController;
@property (nonatomic, strong) LivePlayOperationView     *playOperationView;
@end

@implementation LivePlayController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc {
    NSLog(@"LivePlayController dealloced");
}

- (void)setupUI {
    [self.view addSubview:self.playOperationView];
    [self.playOperationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (LivePlayOperationView *)playOperationView {
    if (!_playOperationView) {
        _playOperationView = [[LivePlayOperationView alloc] initWithVideoModel:self.currentVideoModel];
    }
    return _playOperationView;
}

- (void)setupOperationBlock  {
    
    __weak typeof(self) weakSelf = self;
    
    self.recordeController = [[RecordeViewController alloc] initWithPlayer:self.player screenRecordeFinishedBlock:^{
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view sendSubviewToBack:strongSelf.playOperationView];
        [strongSelf.view sendSubviewToBack:strongSelf.player.view];
//        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//        if (orientation == UIDeviceOrientationPortrait) {
//            [strongSelf.playerViewModel fullScreenHandlerForPlayController:strongSelf isFullScreen:NO];
//        }
    }];
    
    self.playOperationView.playStateBlock = ^(VCPlayHandlerState state) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (state == VCPlayHandlerStatePause) {
            [strongSelf.player pause];
        } else if (state == VCPlayHandlerStatePlay) {
            [strongSelf.player play];
        }
    };
    self.playOperationView.screenShotBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        UIImage *thumbnailImage = strongSelf.player.thumbnailImageAtCurrentTime;
        [KSYUIVC saveImageToPhotosAlbum:thumbnailImage];
    };
    self.playOperationView.screenRecordeBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        //        [strongSelf.playOperationView bringSubviewToFront:strongSelf.player.view];
        //        [strongSelf.playOperationView bringSubviewToFront:strongSelf.volumeBrightControlView];
        [strongSelf.view addSubview:strongSelf.recordeController.view];
        [strongSelf addChildViewController:strongSelf.recordeController];
        [strongSelf.recordeController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(strongSelf.view);
        }];
        [strongSelf.recordeController startRecorde];
    };
}

#pragma mark --
#pragma mark - notification handler

-(void)handlePlayerNotify:(NSNotification*)notify
{
    if (!self.player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        if(self.player.shouldAutoplay == NO)
            [self.player play];
    }
    /*
     if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
     NSLog(@"------------------------");
     NSLog(@"player playback state: %ld", (long)_player.playbackState);
     NSLog(@"------------------------");
     }
     if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
     NSLog(@"player load state: %ld", (long)_player.loadState);
     if (MPMovieLoadStateStalled & _player.loadState) {
     NSLog(@"player start caching");
     }
     if (_player.bufferEmptyCount &&
     (MPMovieLoadStatePlayable & _player.loadState ||
     MPMovieLoadStatePlaythroughOK & _player.loadState)){
     NSLog(@"player finish caching");
     NSString *message = [[NSString alloc]initWithFormat:@"loading occurs, %d - %0.3fs",
     (int)_player.bufferEmptyCount,
     _player.bufferEmptyDuration];
     [self toast:message];
     }
     }
     if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
     NSLog(@"player finish state: %ld", (long)_player.playbackState);
     NSLog(@"player download flow size: %f MB", _player.readSize);
     NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
     (int)_player.bufferEmptyCount,
     _player.bufferEmptyDuration);
     }
     if (MPMovieNaturalSizeAvailableNotification ==  notify.name) {
     NSLog(@"video size %.0f-%.0f, rotate:%ld\n", _player.naturalSize.width, _player.naturalSize.height, (long)_player.naturalRotate);
     if(((_player.naturalRotate / 90) % 2  == 0 && _player.naturalSize.width > _player.naturalSize.height) ||
     ((_player.naturalRotate / 90) % 2 != 0 && _player.naturalSize.width < _player.naturalSize.height))
     {
     如果想要在宽大于高的时候横屏播放，你可以在这里旋转
     }
     }
     if (MPMoviePlayerFirstVideoFrameRenderedNotification == notify.name)
     {
     fvr_costtime = (int)((long long int)([self getCurrentTime] * 1000) - prepared_time);
     NSLog(@"first video frame show, cost time : %dms!\n", fvr_costtime);
     }
     if (MPMoviePlayerFirstAudioFrameRenderedNotification == notify.name)
     {
     far_costtime = (int)((long long int)([self getCurrentTime] * 1000) - prepared_time);
     NSLog(@"first audio frame render, cost time : %dms!\n", far_costtime);
     }
     if (MPMoviePlayerSuggestReloadNotification == notify.name)
     {
     NSLog(@"suggest using reload function!\n");
     if(!reloading)
     {
     reloading = YES;
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
     if (_player) {
     NSLog(@"reload stream");
     [_player reload:_reloadUrl flush:YES mode:MPMovieReloadMode_Accurate];
     }
     });
     }
     }
     if(MPMoviePlayerPlaybackStatusNotification == notify.name)
     {
     int status = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackStatusUserInfoKey] intValue];
     if(MPMovieStatusVideoDecodeWrong == status)
     NSLog(@"Video Decode Wrong!\n");
     else if(MPMovieStatusAudioDecodeWrong == status)
     NSLog(@"Audio Decode Wrong!\n");
     else if (MPMovieStatusHWCodecUsed == status )
     NSLog(@"Hardware Codec used\n");
     else if (MPMovieStatusSWCodecUsed == status )
     NSLog(@"Software Codec used\n");
     else if(MPMovieStatusDLCodecUsed == status)
     NSLog(@"AVSampleBufferDisplayLayer  Codec used");
     }
     if(MPMoviePlayerNetworkStatusChangeNotification == notify.name)
     {
     int currStatus = [[[notify userInfo] valueForKey:MPMoviePlayerCurrNetworkStatusUserInfoKey] intValue];
     int lastStatus = [[[notify userInfo] valueForKey:MPMoviePlayerLastNetworkStatusUserInfoKey] intValue];
     NSLog(@"network reachable change from %@ to %@\n", [self netStatus2Str:lastStatus], [self netStatus2Str:currStatus]);
     }
     if(MPMoviePlayerSeekCompleteNotification == notify.name)
     {
     NSLog(@"Seek complete");
     }
     */
}

#pragma mark --
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if([keyPath isEqual:@"currentPlaybackTime"]) {
        
    }
    //    else if([keyPath isEqual:@"clientIP"])
    //    {
    //        NSLog(@"client IP is %@\n", [change objectForKey:NSKeyValueChangeNewKey]);
    //    }
    //    else if([keyPath isEqual:@"localDNSIP"])
    //    {
    //        NSLog(@"local DNS IP is %@\n", [change objectForKey:NSKeyValueChangeNewKey]);
    //    }
    else if ([keyPath isEqualToString:@"player"]) {
        if (self.player) {
            
        } else {
            
        }
    }
}

@end
