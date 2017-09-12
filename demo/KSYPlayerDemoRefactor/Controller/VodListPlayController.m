//
//  VodListPlayController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/11.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "VodListPlayController.h"
#import "VodPlayController.h"
#import "PlayerViewModel.h"
#import "VideoModel.h"
#import "PlayerTableViewCell.h"
#import "AppDelegate.h"

@interface VodListPlayController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) PlayerViewModel          *playerViewModel;
@property (nonatomic, strong) VodPlayController        *playVC;
@property (nonatomic, strong) UITableView              *videoTableView;
@end

@implementation VodListPlayController

- (instancetype)initWithPlayerViewModel:(PlayerViewModel *)playerViewModel {
    if (self = [super init]) {
        _playerViewModel = playerViewModel;
        _playerViewModel.owner = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self setupUI];
}

- (void)dealloc {
    NSLog(@"VodListPlayController dealloced");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = YES;
}

- (void)setupUI {
    [self.view addSubview:self.videoTableView];
    [self.view addSubview:self.playVC.view];
    [self addChildViewController:self.playVC];
    
    [self.playVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.mas_equalTo(211);
    }];
    [self.videoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(212);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

- (VodPlayController *)playVC {
    if (!_playVC) {
        _playVC = [[VodPlayController alloc] initWithVideoModel:_playerViewModel.playingVideoModel];
        _playVC.playerViewModel = _playerViewModel;
    }
    return _playVC;
}

- (UITableView *)videoTableView {
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _videoTableView.dataSource = self;
        _videoTableView.delegate = self;
        _videoTableView.rowHeight = 88;
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _videoTableView.backgroundColor = [UIColor blackColor];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PlayerTableViewCell" bundle:nil] forCellReuseIdentifier:kPlayerTableViewCellId];
    }
    return _videoTableView;
}

#pragma mark --
#pragma mark - table dataSource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _playerViewModel.videoListViewModel.listViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlayerTableViewCellId];
    if (indexPath.row < _playerViewModel.videoListViewModel.listViewDataSource.count) {
        [cell configeWithVideoModel:_playerViewModel.videoListViewModel.listViewDataSource[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.playerViewModel.currPlayingIndex == indexPath.row) {
        return;
    }
    if (indexPath.row < _playerViewModel.videoListViewModel.listViewDataSource.count) {
        VideoModel *videoModel = _playerViewModel.videoListViewModel.listViewDataSource[indexPath.row];
        [self.playVC reload:[NSURL URLWithString:videoModel.PlayURL.firstObject]];
        self.playerViewModel.playingVideoModel = videoModel;
        self.playerViewModel.currPlayingIndex = indexPath.row;
    }
}

#pragma mark -
#pragma mark - Notifications

- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL fullScreen = (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft);
    [self.playerViewModel fullScreenHandlerForPlayController:self.playVC isFullScreen:fullScreen];
}

@end
