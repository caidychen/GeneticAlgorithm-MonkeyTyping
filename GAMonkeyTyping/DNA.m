//
//  DNA.m
//  GAMonkeyTyping
//
//  Created by CHEN KAIDI on 8/12/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "DNA.h"

@interface DNA ()
@property (nonatomic, strong) NSArray *characters;
@end

@implementation DNA

-(instancetype)initWithLength:(NSInteger)length{
    self = [super init];
    if (self) {
        self.codes = [[NSMutableArray alloc] initWithCapacity:length];
        for (NSInteger i = 0; i < length; i++) {
            [self.codes insertObject:[self.characters objectAtIndex:arc4random()%(self.characters.count-1)] atIndex:i];
        }
    }
    return self;
}

-(DNA *)crossover:(DNA *)dna{
    DNA *newDNA = [[DNA alloc] init];
    NSInteger middleIndex = self.codes.count/2;
    for (NSInteger i = 0; i < self.codes.count; i++) {
        if (i < middleIndex) {
            newDNA.codes[i] = self.codes[i];
        }else{
            newDNA.codes[i] = dna.codes[i];
        }
        
    }
    return newDNA;
}

-(void)mutate:(float)mutationRate{
    for (NSInteger i = 0; i < self.codes.count; i++) {
        if (arc4random()%100 < mutationRate*100) {
            self.codes[i] = [self.characters objectAtIndex:arc4random()%(self.characters.count-1)];
        }
    }
}

-(NSString *)getStringRepresentation{
    NSString *resultString = @"";
    for (NSString *string in self.codes){
        resultString = [resultString stringByAppendingString:string];
    }
    return resultString;
}

-(void)print{
    NSString *resultString = @"";
    for (NSString *string in self.codes){
        resultString = [resultString stringByAppendingString:string];
    }
    NSLog(@"%@ %f",resultString, self.fitness);
}

-(NSMutableArray *)codes{
    if (!_codes) {
        _codes = [[NSMutableArray alloc] init];
    }
    return _codes;
}

-(NSArray *)characters{
    if (!_characters) {
        _characters = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@" ",@" ",@"-",@"-",@"-",@" ",@" ",@" ",@" ",@"-"];
    }
    return _characters;
}

@end
