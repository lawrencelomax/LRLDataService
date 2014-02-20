//
//  LRLTrailerAddictService.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 16/02/2014.
//
//

#import "LRLConfiguredDataService.h"

@class LRLTrailer;
@protocol LRLMovie;

@interface LRLTrailerAddictService : LRLConfiguredDataService

- (RACSignal *) trailerForMovie:(id<LRLMovie>)movie;

@end
