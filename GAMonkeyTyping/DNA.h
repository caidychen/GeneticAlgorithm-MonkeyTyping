//
//  DNA.h
//  GAMonkeyTyping
//
//  Created by CHEN KAIDI on 8/12/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNA : NSObject

@property (nonatomic, strong) NSMutableArray *codes;
@property (nonatomic, assign) float fitness;
@property (nonatomic, assign) float mutating;

-(instancetype)initWithLength:(NSInteger)length;
-(DNA *)crossover:(DNA *)dna;
-(void)mutate:(float)mutationRate;
-(void)print;
-(NSString *)getStringRepresentation;
@end
