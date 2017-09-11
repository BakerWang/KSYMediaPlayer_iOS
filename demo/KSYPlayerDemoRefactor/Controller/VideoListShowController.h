//
//  VideoListShowController.h
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/11.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "BaseViewController.h"
//#import "VideoListViewModel.h"
//#import "PlayerViewController.h"
//#import "FlowLayout.h"
//#import "Masonry.h"
//#import "VideoCollectionViewCell.h"
//#import "PlayerViewController.h"
//#import "PlayerViewModel.h"
//#import "VideoCollectionHeaderView.h"
//#import "SuspendPlayView.h"
//#import "VideoContainerView.h"
//#import "QRViewController.h"
//#import "VideoModel.h"
//#import "UIView+Toast.h"
#import "Constant.h"

@interface VideoListShowController : BaseViewController
//<UICollectionViewDataSource, UICollectionViewDelegate, FlowLayoutDelegate>
//@property (nonatomic, strong) VideoListViewModel        *videoListViewModel;
//@property (nonatomic, strong) UICollectionView          *videoCollectionView;
//@property (nonatomic, strong) VideoCollectionHeaderView *headerView;
//@property (nonatomic, strong) PlayerViewController      *pvc;
//@property (nonatomic, strong) SuspendPlayView           *suspendView;
//@property (nonatomic, strong) UIView                    *clearView;
//@property (nonatomic, assign) BOOL willAppearFromPlayerView;
//@property (nonatomic, assign) BOOL isMoving;
//@property (nonatomic, assign) VideoListShowType showType;
//
//- (instancetype)initWithShowType:(VideoListShowType)showType;

@property (nonatomic, assign) BOOL hasSuspendView;

@property (nonatomic, assign) VideoListShowType showType;

@end
