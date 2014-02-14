//
//  LRLIMDBService.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLConfiguredDataService.h"

@class LRLMovie;

extern NSString *const LRLIMDBServiceErrorDomain;

@interface LRLIMDBService : LRLConfiguredDataService

- (RACSignal *) moviesWithSearch:(NSString *)search;
- (RACSignal *) detailedMovie:(LRLMovie *)movie;

@end
