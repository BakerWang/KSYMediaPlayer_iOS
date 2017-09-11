//
//  LiveViewController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/22.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self fetchDatasource];
}

- (void)fetchDatasource {
    NSURL *url = [NSURL URLWithString:@"https://appdemo.download.ks-cdn.com:8682/api/GetLiveUrl/2017-01-01?Option=1"];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    [self.view makeToastActivity:CSToastPositionCenter];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view hideToastActivity];
        strongSelf.videoListViewModel = [[VideoListViewModel alloc] initWithJsonResponseData:data];
        [strongSelf.videoCollectionView reloadData];
        [strongSelf.headerView configeVideoModel:self.videoListViewModel.listViewDataSource.firstObject];
    }];
    [task resume];
}

@end
