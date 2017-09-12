//
//  ChoiceViewController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/22.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "ChoiceViewController.h"
#import "VideoListShowController.h"
#import "VersionSwitchHandler.h"
#import "Constant.h"

@interface ChoiceViewController ()

@end

@implementation ChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)switchToOldVersion:(id)sender {
    [VersionSwitchHandler switchToOldVersion];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    VideoListShowType showType = VideoListShowTypeUnknown;
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"pushToLiveVideoListId"]) {
        showType = VideoListShowTypeLive;
    } else if ([identifier isEqualToString:@"pushToVodVideoListId"]) {
        showType = VideoListShowTypeVod;
    }
    if (showType != VideoListShowTypeUnknown) {
        VideoListShowController *vlsc = (VideoListShowController *)segue.destinationViewController;
        vlsc.showType = showType;
    }
}


@end
