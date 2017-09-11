//
//  PlayController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/11.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "PlayController.h"
#import "VideoModel.h"
#import "AppDelegate.h"

@interface PlayController ()
@property (nonatomic, weak) VideoModel               *videoModel;
@property (nonatomic, assign) int64_t   prepared_time;
@property (nonatomic, assign) NSTimeInterval playedTime;
@end

@implementation PlayController

- (instancetype)initWithVideoModel:(VideoModel *)videoModel {
    if (self = [super init]) {
        _videoModel = videoModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver:self forKeyPath:@"player" options:NSKeyValueObservingOptionNew context:nil];
    [self setupPlayer];
}

- (void)dealloc {
    [self.player stop];
    [self.player removeObserver:self forKeyPath:@"currentPlaybackTime"];
    [self removeObserver:self forKeyPath:@"player"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupPlayer {
    //初始化播放器并设置播放地址
    self.player = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:_videoModel.PlayURL.firstObject] fileList:nil sharegroup:nil];
    [self setupObservers:_player];
    _player.controlStyle = MPMovieControlStyleNone;
    [self.view addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SettingModel *settingModel = delegate.settingModel;
    if (!settingModel) {
        settingModel = [[SettingModel alloc] init];
        delegate.settingModel = settingModel;
    }
    
    if(settingModel) {
        _player.videoDecoderMode = settingModel.videoDecoderMode;
        _player.shouldLoop = settingModel.shouldLoop;
        _player.bufferTimeMax = settingModel.bufferTimeMax;
        _player.bufferSizeMax = settingModel.bufferSizeMax;
        [_player setTimeout:(int)settingModel.preparetimeOut readTimeout:(int)settingModel.readtimeOut];
    }
    NSKeyValueObservingOptions opts = NSKeyValueObservingOptionNew;
    [_player addObserver:self forKeyPath:@"currentPlaybackTime" options:opts context:nil];
    self.prepared_time = (long long int)([[NSDate date] timeIntervalSince1970] * 1000);
    [_player prepareToPlay];
}

- (void)registerObserver:(NSString *)notification player:(KSYMoviePlayerController*)player {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(notification)
                                              object:player];
}

- (void)setupObservers:(KSYMoviePlayerController*)player {
    [self registerObserver:MPMediaPlaybackIsPreparedToPlayDidChangeNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackStateDidChangeNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackDidFinishNotification player:player];
    [self registerObserver:MPMoviePlayerLoadStateDidChangeNotification player:player];
    [self registerObserver:MPMovieNaturalSizeAvailableNotification player:player];
    [self registerObserver:MPMoviePlayerFirstVideoFrameRenderedNotification player:player];
    [self registerObserver:MPMoviePlayerFirstAudioFrameRenderedNotification player:player];
    [self registerObserver:MPMoviePlayerSuggestReloadNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackStatusNotification player:player];
    [self registerObserver:MPMoviePlayerNetworkStatusChangeNotification player:player];
    [self registerObserver:MPMoviePlayerSeekCompleteNotification player:player];
}

-(void)handlePlayerNotify:(NSNotification*)notify {
    
}

#pragma mark --
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
}

#pragma mark -
#pragma mark - public method

- (void)reload:(NSURL *)aUrl {
    [_player reload:aUrl];
}

@end
