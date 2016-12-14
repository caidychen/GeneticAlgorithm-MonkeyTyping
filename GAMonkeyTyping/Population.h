//
//  Population.h
//  GAMonkeyTyping
//
//  Created by CHEN KAIDI on 8/12/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNA.h"

@interface Population : NSObject
@property (nonatomic, strong) NSMutableArray <DNA *>*population;

-(instancetype)initWithTarget:(NSString *)targetString poolSize:(NSInteger)size mutatingProbability:(float)mutating;

-(void)calculateFitness;
-(void)naturalSelection;
-(void)generateNextPopulation;
-(NSDictionary *)evaluate;

-(void)printPopulation;
-(void)printMatingPool;

@end
