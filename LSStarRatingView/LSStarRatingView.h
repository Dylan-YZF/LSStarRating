//
//  LSStarRatingView.h
//  LSStarRating
//
//  Created by Dylan on 2017/1/20.
//  Copyright © 2017年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 点击评分的选择星的类型

 - LSStarRatingDefault: 默认选多少就是多少星
 - LSStarRatingCompleteStar: 整星
 - LSStarRatingHalfStar: 半星
 */
typedef NS_ENUM(NSInteger, ClickOnScoreType) {
    LSStarRatingDefault = 0,
    LSStarRatingCompleteStar,
    LSStarRatingHalfStar
};

@class LSStarRatingView;

/**
 点击评分的delegate
 */
@protocol LSStarRatingDelegate <NSObject>

/**
 点击评分的delegate

 @param starRatingView self
 @param score score
 */
- (void)starRatingView:(LSStarRatingView*)starRatingView score:(CGFloat)score;

@end

@interface LSStarRatingView : UIView

/**
 星的数量
 */
@property (nonatomic, readonly) NSInteger numberOfStar;

/**
 score
 */
@property (nonatomic, readonly) CGFloat score;


/**
 星之间的间距
 */
@property (nonatomic)CGFloat spacing;
/**
 是否可以点击评分，默认不可以
 */
@property (nonatomic)BOOL clickOnScore;

/**
 点击评分的选择星的类型
 */
@property (nonatomic)ClickOnScoreType clickOnScoreType;

/**
 点击评分的delegate
 */
@property (nonatomic,assign)id <LSStarRatingDelegate> delegate;

/**
 初始化

 @param frame frame
 @param numberOfStar 星的数量，最大100，最小1
 @return 初始化对象
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)numberOfStar;

/**
 设置分数

 @param score 0 - 1 之间
 @param animation 是否动画
 */
- (void)setScore:(CGFloat)score animation:(BOOL)animation;


@end
