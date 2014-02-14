//
//  LRLTrailerAddictService.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 16/02/2014.
//
//

#import "LRLConfiguredDataService.h"

@class LRLTrailer;
@class LRLMovie;

@interface LRLTrailerAddictService : LRLConfiguredDataService

- (RACSignal *) trailerForMovie:(LRLMovie *)movie;

@end
