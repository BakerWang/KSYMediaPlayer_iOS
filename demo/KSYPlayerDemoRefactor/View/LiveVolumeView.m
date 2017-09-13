//
//  LiveVolumeView.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/13.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "LiveVolumeView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIColor+Additions.h"

@interface LiveVolumeView ()
@property (nonatomic, strong) UISlider     *volumeSlider;
@property (nonatomic, strong) MPVolumeView *volumeView;
@end

@implementation LiveVolumeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.volumeView.showsRouteButton = NO;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTapEv)];
    [self addGestureRecognizer:tap];
    [self addSubview:self.volumeSlider];
    [self configeConstraints];
}

- (void)aTapEv {}

- (void)sliderValueChangedHandler {
    
}

- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] initWithFrame:CGRectZero];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeSlider = (UISlider*)view;
                self.volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
                self.volumeSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#1D1D1F"];
                break;
            }
        }
    }
    return _volumeView;
}

- (void)configeConstraints {
    [self.volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.leading.mas_equalTo(15);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.volumeView.frame = self.bounds;
}

@end
