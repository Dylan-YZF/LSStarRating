//
//  LSStarRatingView.m
//  LSStarRating
//
//  Created by Dylan on 2017/1/20.
//  Copyright © 2017年 Dylan. All rights reserved.
//

#import "LSStarRatingView.h"

#define kDEFAULT_NUMBER 5

@interface LSStarRatingView ()

@property(nonatomic,strong)UIView* foreView;

@end

@implementation LSStarRatingView


- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:kDEFAULT_NUMBER];
}


- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)numberOfStar
{
    self = [super initWithFrame:frame];
    if (self) {
        if (numberOfStar > 100) {
            _numberOfStar = 100;
        }else if (numberOfStar<=0){
            numberOfStar = 1;
        }
        _numberOfStar = numberOfStar;
        [self createStarWithFrame:frame numberOfStar:numberOfStar];
    }
    return self;
}



- (void)setScore:(CGFloat)score animation:(BOOL)animation
{
    if (score < 0) {
        score = 0.00;
    }
    
    if (score > 1) {
        score = 1.00;
    }
    
    
    // 单个星的分数
    CGFloat aStarScores = 1.00/_numberOfStar;
    
    if (_clickOnScoreType == LSStarRatingCompleteStar){
        
        // 算出当前分数占单个星的倍数
        CGFloat scoreProportion = score/aStarScores;
        if (scoreProportion > floor(scoreProportion)) {
            score = floor(scoreProportion)*aStarScores + aStarScores;
        }
    }else if (_clickOnScoreType == LSStarRatingHalfStar){
        // 算出当前分数占单个星的倍数
        CGFloat scoreProportion = score/aStarScores;
        
        if (scoreProportion > floor(scoreProportion)) {
            
            if ((scoreProportion - floor(scoreProportion))<0.5) {
                score = floor(scoreProportion)*aStarScores + aStarScores/2;
            }else{
                score = floor(scoreProportion)*aStarScores + aStarScores;
            }
        }
    }
    
    NSString* scoreStr = [NSString stringWithFormat:@"%.2lf",score];
    score = scoreStr.floatValue;
    
    [self resetForeViewFrameWithScore:score animation:animation];
    
    if ([self.delegate respondsToSelector:@selector(starRatingView:score:)]) {
        [self.delegate starRatingView:self score:score];
    }
}


- (void)createStarWithFrame:(CGRect)frame numberOfStar:(NSInteger)numberOfStar
{
    // 重设自身的宽度
    [self resetFrame];
    [self foreView];
    
    for (NSInteger i=0; i<numberOfStar; i++) {
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*(CGRectGetHeight(self.frame)+self.spacing), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        [imageView setImage:[UIImage imageNamed:@"icon_stare"]];
        imageView.tag = 10000+i;
        [self addSubview:imageView];
    }
}


// 重设自身的宽度
- (void)resetFrame
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), (CGRectGetHeight(self.frame)+self.spacing)*self.numberOfStar -self.spacing, CGRectGetHeight(self.frame))];
    [self resetForeViewFrameWithScore:self.score animation:NO];
}

- (void)resetForeViewFrameWithScore:(float)score animation:(BOOL)animation
{
    
    _score = score;
    // 每个星的宽度
    CGFloat starWidth = CGRectGetHeight(self.frame);
    // 所有高亮的满星的数量
    NSInteger scoreInteger = self.numberOfStar* score;
    
    // 剩余未满星占满星的比例
    CGFloat scoreFloat = self.numberOfStar* score - scoreInteger;
    
    // 上面所有星的宽度
    CGFloat foreViewWidth = (CGRectGetHeight(self.frame)+self.spacing)*scoreInteger + scoreFloat* starWidth;
    
    if (animation) {
        [UIView animateWithDuration:1 animations:^{
            [self.foreView setFrame:CGRectMake(CGRectGetMinX(self.foreView.frame), CGRectGetMinY(self.foreView.frame), foreViewWidth, CGRectGetHeight(self.frame))];
        }];
    }else{
        [self.foreView setFrame:CGRectMake(CGRectGetMinX(self.foreView.frame), CGRectGetMinY(self.foreView.frame), foreViewWidth, CGRectGetHeight(self.frame))];
    }
}


- (void)setSpacing:(CGFloat)spacing
{
    _spacing = spacing;
    [self resetFrame];
    
    for (NSInteger i=0; i<self.numberOfStar; i++){
        UIImageView* imageView = (UIImageView*)[self viewWithTag:10000+i];
        [imageView setFrame:CGRectMake(i*(CGRectGetHeight(self.frame)+self.spacing), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        
        UIImageView* foreImg = (UIImageView*)[self viewWithTag:20000+i];
        [foreImg setFrame:CGRectMake(i*(CGRectGetHeight(self.frame)+self.spacing), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_clickOnScore) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        // 判断给定的点是否被一个CGRect包含
        if(CGRectContainsPoint(self.bounds,point)){
            
            // 点击的位置占控件比例
            CGFloat proportion = point.x/(CGRectGetWidth(self.frame)+_spacing);
            
            // 点击的位置占星数的比例
            CGFloat clickNumber = _numberOfStar*proportion;
            
            // 算出整星的数量
            CGFloat clickNumber1 = floor(clickNumber);
            
            // 算出减去整星之外星的比例
            CGFloat clickNumber2 = clickNumber - clickNumber1;
            
            // 算出减去整星之外星的宽度
            CGFloat clickWidth = (CGRectGetHeight(self.frame)+_spacing)*clickNumber2;
            
            
            CGFloat score11 = 0.00;
            if (clickWidth>CGRectGetHeight(self.frame)) {
                
                score11 = 1.00/_numberOfStar;
            }else{
                score11 = clickWidth/(CGRectGetHeight(self.frame)*_numberOfStar);
            }
            
            // 根据点击点的位置算出分数
            _score = clickNumber1/_numberOfStar+score11;
            
            [self setScore:self.score animation:NO];
        }
    }
}


- (UIView*)foreView
{
    if (!_foreView) {
        _foreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.frame))];
        _foreView.clipsToBounds = YES;
        [self addSubview:_foreView];
        
        for (NSInteger i=0; i<self.numberOfStar; i++) {
            UIImageView* foreImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*(CGRectGetHeight(self.frame)+self.spacing), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
            [foreImg setImage:[UIImage imageNamed:@"icon_star"]];
            foreImg.tag = 20000+i;
            [_foreView addSubview:foreImg];
        }
    }
    
    return _foreView;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
