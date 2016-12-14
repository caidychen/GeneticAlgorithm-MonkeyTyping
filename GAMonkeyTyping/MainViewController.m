//
//  MainViewController.m
//  GAMonkeyTyping
//
//  Created by CHEN KAIDI on 8/12/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "MainViewController.h"
#import "Population.h"
#import "DNA.h"

@interface MainViewController ()
@property (nonatomic, strong) Population *population;
@property (nonatomic, strong) UILabel *textLabel, *poolLabel;
@property (nonatomic, strong) NSTimer *timer;
@end

static NSString *targetString = @"jesus take the wheel";
static NSInteger poolSize = 500;
static float mutating = 0.01;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    

    UILabel *targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    targetLabel.textColor = [UIColor whiteColor];
    targetLabel.textAlignment = NSTextAlignmentCenter;
    targetLabel.font = [UIFont systemFontOfSize:25];
    targetLabel.text = targetString;
    [self.view addSubview:targetLabel];
    
    self.population = [[Population alloc] initWithTarget:targetString poolSize:poolSize mutatingProbability:mutating];
    
    [self.population calculateFitness];
    
    self.textLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.textLabel.numberOfLines = 0;
    [self.view addSubview:self.textLabel];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:25];
    
    self.poolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 300)];
    self.poolLabel.numberOfLines = 0;
    [self.view addSubview:self.poolLabel];
    self.poolLabel.textColor = [UIColor whiteColor];
    self.poolLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(loop) userInfo:nil repeats:YES];
    [self.timer fire];
    
}

-(void)loop{
    NSDictionary *resultDict;
    [self.population naturalSelection];
    [self.population generateNextPopulation];
    [self.population calculateFitness];
    
    NSString *result = @"";
    BOOL flag = false;
    for (DNA *dna in self.population.population){
        result = [result stringByAppendingString:[dna getStringRepresentation]];
        if (!flag) {
            result = [result stringByAppendingString:@"   "];
        }else{
            result = [result stringByAppendingString:@"\n"];
        }
        flag = !flag;
        
    }
    self.poolLabel.text = result;
    
    resultDict = [self.population evaluate];
    self.textLabel.text = [NSString stringWithFormat:@"%@\n\n相似度:%zd%%",[resultDict objectForKey:@"codes"],[[resultDict objectForKey:@"fitness"] integerValue]];

    if ([[resultDict objectForKey:@"codes"] isEqualToString:targetString]){
        NSLog(@"result: %@",[resultDict objectForKey:@"codes"]);
        self.textLabel.textColor = [UIColor greenColor];
        [self.timer invalidate];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
