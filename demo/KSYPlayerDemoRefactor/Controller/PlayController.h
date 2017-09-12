//
//  PlayController.h
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/11.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "BaseViewController.h"
#import <KSYMediaPlayer/KSYMoviePlayerController.h>

@class VideoModel;

@interface PlayController : BaseViewController

@property (nonatomic, strong) KSYMoviePlayerController *player;

- (instancetype)initWithVideoModel:(VideoModel *)videoModel;

- (void)reload:(NSURL *)aUrl;

- (VideoModel *)currentVideoModel;

@end
