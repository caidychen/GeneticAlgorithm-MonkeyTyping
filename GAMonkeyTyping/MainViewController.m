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

@interface MainViewController (){
    NSString *targetString;
    BOOL running;
}
@property (nonatomic, strong) Population *population;
@property (nonatomic, strong) UILabel *targetLabel, *textLabel, *poolLabel;
@property (nonatomic, strong) NSTimer *timer;
@end

//static NSString *targetString = @"jesus take the wheel";
static NSInteger poolSize = 500;
static float mutating = 0.01;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    

    self.targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    self.targetLabel.textColor = [UIColor whiteColor];
    self.targetLabel.textAlignment = NSTextAlignmentCenter;
    self.targetLabel.font = [UIFont systemFontOfSize:25];
    
    [self.view addSubview:self.targetLabel];
    
    
    
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
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleInputText)]];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self toggleInputText];
}

-(void)toggleInputText{
    if (running) {
        return;
    }
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Target words"
                                                                              message: @"Type in any words or phrases"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Words";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        targetString = namefield.text;
        self.targetLabel.text = targetString;
        self.population = [[Population alloc] initWithTarget:targetString poolSize:poolSize mutatingProbability:mutating];
        [self.population calculateFitness];
        [self startAI];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)startAI{
    self.textLabel.textColor = [UIColor whiteColor];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(loop) userInfo:nil repeats:YES];
    [self.timer fire];

}

-(void)loop{
    running = YES;
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
    self.textLabel.text = [NSString stringWithFormat:@"%@\n\nsimilarity:%zd%%",[resultDict objectForKey:@"codes"],[[resultDict objectForKey:@"fitness"] integerValue]];

    if ([[resultDict objectForKey:@"codes"] isEqualToString:targetString]){
        NSLog(@"result: %@",[resultDict objectForKey:@"codes"]);
        self.textLabel.textColor = [UIColor greenColor];
        [self.timer invalidate];
        running = NO;
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
