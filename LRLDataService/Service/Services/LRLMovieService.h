//
//  LRLMovieService.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 11/02/2014.
//
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@class LRLIMDBService;
@class LRLRottenTomatoesService;
@class LRLTrailerAddictService;
@class LRLConfigurationService;
@protocol LRLMovie;

@interface LRLMovieService : NSObject

+ (instancetype) serviceWithIMDBService:(LRLIMDBService *)imdbService rottenTomatoesService:(LRLRottenTomatoesService *)rottenTomatoesService trailerService:(LRLTrailerAddictService *)trailerService;
+ (instancetype) serviceWithConfigurationService:(LRLConfigurationService *)configurationService;

@property (nonatomic, readonly) LRLIMDBService *imdbService;
@property (nonatomic, readonly) LRLRottenTomatoesService *rottenTomatoesService;
@property (nonatomic, readonly) LRLTrailerAddictService *trailerService;

// Gets trailer and rotten tomatoes info
- (RACSignal *) detailedMovie:(id<LRLMovie>)movie;

@end
