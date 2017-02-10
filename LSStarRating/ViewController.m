//
//  ViewController.m
//  LSStarRating
//
//  Created by Dylan on 2017/1/20.
//  Copyright © 2017年 Dylan. All rights reserved.
//

#import "ViewController.h"
#import "LSStarRatingView.h"

@interface ViewController ()<LSStarRatingDelegate>

@property (nonatomic,strong)LSStarRatingView* starRatingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.starRatingView = [[LSStarRatingView alloc] initWithFrame:CGRectMake(30, 200, 300, 45) numberOfStar:5];
    self.starRatingView.backgroundColor = [UIColor lightGrayColor];
    self.starRatingView.spacing = 15;
    self.starRatingView.clickOnScore = YES;
    self.starRatingView.delegate = self;
    self.starRatingView.clickOnScoreType = LSStarRatingHalfStar;
//    self.starRatingView.allowIncompleteStar = YES;
    [self.starRatingView setScore:0.6 animation:NO];
    [self.view addSubview:self.starRatingView];
    
    
}



- (void)starRatingView:(LSStarRatingView *)starRatingView score:(CGFloat)score
{
    
    NSLog(@"score == %lf",score);
}

- (IBAction)btn:(UIButton *)sender {
    
    self.starRatingView.spacing = 25;
    [self.starRatingView setScore:0.65 animation:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
