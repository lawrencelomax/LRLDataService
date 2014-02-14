//
//  LRLRottenTomatoesService.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 18/02/2014.
//
//

#import "LRLConfiguredDataService.h"

@class LRLMovie;

extern NSString *const LRLRottenTomatoesServiceErrorDomain;

@interface LRLRottenTomatoesService : LRLConfiguredDataService

- (RACSignal *) updatedMovieInfo:(LRLMovie *)movie;

@end
