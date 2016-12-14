//
//  Population.m
//  GAMonkeyTyping
//
//  Created by CHEN KAIDI on 8/12/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "Population.h"


@interface Population ()

@property (nonatomic, strong) NSMutableArray *matingPool;
@property (nonatomic, strong) NSString *targetString;
@property (nonatomic, assign) NSInteger poolSize;
@property (nonatomic, assign) float mutating;
@end

@implementation Population

-(instancetype)initWithTarget:(NSString *)targetString poolSize:(NSInteger)size mutatingProbability:(float)mutating{
    self = [super init];
    if (self) {
        self.targetString = targetString;
        self.poolSize = size;
        self.mutating = mutating;
        [self setup];
    }
    return self;
}

-(void)setup{
    for (NSInteger i = 0; i < self.poolSize; i++) {
        DNA *dna = [[DNA alloc] initWithLength:self.targetString.length];
        [self.population addObject:dna];
    }
}

// calculate fitness
-(void)calculateFitness{
    NSArray *targetStringArray = [self splitStringIntoArray:self.targetString];
    for (DNA *dna in self.population){
        NSInteger correct = 0;
        for (NSInteger i = 0; i < self.targetString.length; i++) {
            if ([targetStringArray[i] isEqualToString:dna.codes[i]]) {
                correct ++;
            }
        }
        dna.fitness = (float)correct/(float)self.targetString.length*100;
    }
}

// Generate mating pool
-(void)naturalSelection{
    [self.matingPool removeAllObjects];
    for (NSInteger i = 0; i < self.population.count; i++){
        DNA *dna = self.population[i];
        for (NSInteger repeat = 0; repeat < (int)dna.fitness + 1; repeat ++) {
            [self.matingPool addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    if (self.matingPool.count == 0) {
        NSLog(@"warning");
    }
}

// Create next generation
-(void)generateNextPopulation{
    NSMutableArray *newPopulation = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.population.count; i++) {
        NSInteger indexA = arc4random()%(self.matingPool.count-1);
        NSInteger indexB = arc4random()%(self.matingPool.count-1);
        DNA *partnerA = [self.population objectAtIndex:[self.matingPool[indexA] integerValue]];
        DNA *partnerB = [self.population objectAtIndex:[self.matingPool[indexB] integerValue]];
        DNA *child = [partnerA crossover:partnerB];
        [child mutate:self.mutating];
        [newPopulation addObject:child];
    }
    self.population = [[NSMutableArray alloc] initWithArray:newPopulation];
}

// Validate solution
-(NSDictionary *)evaluate{
    NSInteger highest = 0;
    NSInteger selectedIndex = 0;
    NSInteger index = 0;
    for (DNA *dna in self.population){
//        if ((int)dna.fitness == 100) {
//            return [self arrayToString:dna.codes];
//        }
        if ((int)dna.fitness > highest) {
            highest = (int)dna.fitness;
            selectedIndex = index;
        }
        index ++;
    }
    DNA *dna = self.population[selectedIndex];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[self arrayToString:dna.codes], @"codes", [NSNumber numberWithInteger:highest], @"fitness", nil];
    return dict;
}

-(NSArray *)splitStringIntoArray:(NSString *)str{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [str length]; i++) {
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        [array addObject:ch];
    }
    return array;
}

-(NSString *)arrayToString:(NSArray *)array{
    NSString *resultString = @"";
    for (NSString *string in array){
        resultString = [resultString stringByAppendingString:string];
    }
    return resultString;
}

-(void)printPopulation{
    NSLog(@"==========================");
    for (DNA *dna in self.population){
        [dna print];
    }
    NSLog(@"==========================");
}

-(void)printMatingPool{
    NSLog(@"%@",self.matingPool);
}

-(NSMutableArray *)population{
    if (!_population) {
        _population = [[NSMutableArray alloc] init];
    }
    return _population;
}

-(NSMutableArray *)matingPool{
    if (!_matingPool) {
        _matingPool = [[NSMutableArray alloc] init];
    }
    return _matingPool;
}

@end
