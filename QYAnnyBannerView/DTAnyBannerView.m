//
//  DTAnyBannerView.m
//  ClassMate
//
//  Created by YannChee_tal on 2019/1/8.
//  Copyright © 2019 tal. All rights reserved.
//

#define random(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#import "DTAnyBannerView.h"

static const int autoScrollDuration = 5; /**< 自动滚动时间间隔 */


@interface DTReycleViewCell : UICollectionViewCell

@end


@implementation DTReycleViewCell
@end


@interface DTAnyBannerView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIView *maskView; /**< 遮罩view */

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, weak) NSTimer *timer; /**< 定时器 */

@property (nonatomic, strong) NSArray *dataArr;

@end


@implementation DTAnyBannerView

+ (instancetype)bannerViewWithFrame:(CGRect)frame cellModelArr:(NSArray<DTAnyBannerCellModel *> *)cellModelArr {
    DTAnyBannerView *recycleView = [[self alloc] initWithFrame:frame];

    // 如果数组为空,返回默认cell,防止崩溃
    if (!cellModelArr.count) {
        [recycleView.collectionView registerClass:[DTReycleViewCell class] forCellWithReuseIdentifier:@"DTReycleViewCell"];
        return recycleView;
    }

    for (DTAnyBannerCellModel *cellModel in cellModelArr) {
        [recycleView registerCellWithCellModel:cellModel];
    }
    return recycleView;
}

- (void)registerCellWithCellModel:(DTAnyBannerCellModel *)cellModel {
    if (cellModel.isNibCell) { // nib加载
        [self.collectionView registerNib:[UINib nibWithNibName:cellModel.nibName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellModel.cellIdentifier];
    } else {
        [self.collectionView registerClass:cellModel.class forCellWithReuseIdentifier:cellModel.cellIdentifier];
    }
}


- (void)loadDataWithArray:(NSArray *)dataArr {
    [self endTimer];

    self.dataArr = dataArr;
    self.pageControl.hidden = (dataArr.count > 1) ? NO : YES;
    self.pageControl.numberOfPages = dataArr.count;
    [self.collectionView reloadData];

    (dataArr.count > 1) ? [self startTimer] : nil;
}

#pragma mark 初始化配置
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews {
    self.collectionView.bounces = NO;
    [self bringSubviewToFront:self.pageControl];

    self.maskView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //    if (!CGRectEqualToRect(self.pageControl.frame, CGRectMake(0, CGRectGetHeight(self.frame) - 20 , CGRectGetWidth(self.frame), 10))){
    //        self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 20, CGRectGetWidth(self.frame), 10);
    //    }
}
#pragma mark - 定时器设置
- (void)endTimer {
    // 下面两行顺序不能变
    self.timer.valid ? [self.timer invalidate] : nil;
    self.timer ? self.timer = nil : nil;
}

- (void)startTimer {
    [self endTimer];
    if (self.dataArr.count <= 1) {
        return;
    }

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:autoScrollDuration target:[YYWeakProxy proxyWithTarget:self] selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 自动滚动
- (void)automaticScroll {
    NSInteger targetIndex = self.currentPageIndex + 1;
    if (targetIndex == self.dataArr.count) {
        targetIndex = 0;
    }

    BOOL animated = targetIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellForItemAtIndexPathBlcok) {
        return self.cellForItemAtIndexPathBlcok(collectionView, indexPath);
    }

    UICollectionViewCell *placeHoderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DTReycleViewCell" forIndexPath:indexPath];
    placeHoderCell.backgroundColor = [UIColor whiteColor];
    return placeHoderCell;
}

#pragma mark - scrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dataArr.count <= 1) return; // 解决清除timer时偶尔会出现的问题
    self.pageControl.currentPage = self.currentPageIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}


#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor whiteColor];
        mainView.pagingEnabled = YES;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;

        [self addSubview:mainView];
        _collectionView = mainView;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - CGRectGetHeight(self.maskView.frame) - 5, CGRectGetWidth(self.frame), 6)];
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"FFFFFF"]; //[UIColor colorWithHexString:@"11a5e9"];
        pageControl.pageIndicatorTintColor = [[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:0.3];
        [self addSubview:pageControl];

        _pageControl = pageControl;
    }
    return _pageControl;
}

- (UIView *)maskView {
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        CGFloat h = 12.0;
        maskView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - h, CGRectGetWidth(self.frame), h);
        [self addSubview:maskView];
        _maskView = maskView;

        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        // 1.
        [bezierPath moveToPoint:CGPointMake(0, 0)];
        // 2
        [bezierPath addCurveToPoint:CGPointMake(CGRectGetWidth(maskView.frame), 0) controlPoint1:CGPointMake(CGRectGetWidth(maskView.frame) * (1.0 / 3.0), CGRectGetHeight(maskView.frame) + 3) controlPoint2:CGPointMake(CGRectGetWidth(maskView.frame) * (2.0 / 3.0), CGRectGetHeight(maskView.frame) + 3)];
        // 3.
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(maskView.frame), CGRectGetHeight(maskView.frame))];
        // 4.
        [bezierPath addLineToPoint:CGPointMake(0, CGRectGetHeight(maskView.frame))];
        // 5.
        [bezierPath addLineToPoint:CGPointMake(0, 0)];

        [bezierPath closePath];
        [UIColor.greenColor setFill];
        [bezierPath fill];

        CAShapeLayer *shaplayer = [CAShapeLayer layer];
        shaplayer.path = [bezierPath CGPath];

        shaplayer.strokeColor = [UIColor clearColor].CGColor;
        shaplayer.fillColor = [UIColor yellowColor].CGColor;

        maskView.layer.mask = shaplayer;
    }
    return _maskView;
}
- (NSInteger)currentPageIndex {
    NSInteger index = self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.bounds);
    return index;
}


@end


@implementation DTAnyBannerCellModel
+ (instancetype)bannerCellModelWithCellClass:(Class)cellCalss nibName:(NSString *)nibName cellIdentifier:(NSString *)cellIdentifier
                                   isNibCell:(BOOL)isNibCell {
    DTAnyBannerCellModel *cellModel = [[DTAnyBannerCellModel alloc] init];
    cellModel.cellCalss = cellCalss;
    cellModel.nibName = nibName;
    cellModel.cellIdentifier = cellIdentifier;
    cellModel.isNibCell = isNibCell;
    return cellModel;
}
@end
