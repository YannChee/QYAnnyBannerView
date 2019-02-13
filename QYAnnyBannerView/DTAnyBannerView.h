//
//  DTAnyBannerView.h
//  ClassMate
//
//  Created by YannChee_tal on 2019/1/8.
//  Copyright © 2019 tal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface DTAnyBannerCellModel : NSObject
@property (nonatomic, strong) Class cellCalss;
@property (nonatomic, strong) NSString *nibName;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, assign) BOOL isNibCell;

+ (instancetype)bannerCellModelWithCellClass:(nullable Class)cellCalss
                                     nibName:(nullable NSString *)nibName
                              cellIdentifier:(NSString *)cellIdentifier
                                   isNibCell:(BOOL)isNibCell;
@end


@interface DTAnyBannerView : UIView

+ (instancetype)bannerViewWithFrame:(CGRect)frame cellModelArr:(NSArray<DTAnyBannerCellModel *> *)cellModelArr;

@property (nonatomic, strong) UICollectionViewCell * (^cellForItemAtIndexPathBlcok)(UICollectionView *collectionView, NSIndexPath *indexPath); /**< 设置每行cell */


- (void)loadDataWithArray:(NSArray *)dataArr;


@end

NS_ASSUME_NONNULL_END
