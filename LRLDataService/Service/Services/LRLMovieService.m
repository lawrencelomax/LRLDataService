//
//  LRLMovieService.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 11/02/2014.
//
//

#import "LRLMovieService.h"

#import "LRLIMDBService.h"
#import "LRLRottenTomatoesService.h"
#import "LRLTrailerAddictService.h"
#import "LRLMovie.h"

@interface LRLMovieService ()

@property (nonatomic, strong) LRLIMDBService *imdbService;
@property (nonatomic, strong) LRLRottenTomatoesService *rottenTomatoesService;
@property (nonatomic, strong) LRLTrailerAddictService *trailerService;

@end

@implementation LRLMovieService

+ (instancetype) serviceWithIMDBService:(LRLIMDBService *)imdbService rottenTomatoesService:(LRLRottenTomatoesService *)rottenTomatoesService trailerService:(LRLTrailerAddictService *)trailerService {
	LRLMovieService *movieService = [[self alloc] init];
	movieService.imdbService = imdbService;
	movieService.rottenTomatoesService = rottenTomatoesService;
	movieService.trailerService = trailerService;
	return movieService;
}

+ (instancetype) serviceWithConfigurationService:(LRLConfigurationService *)configurationService {
	LRLIMDBService *imdb = [LRLIMDBService dataServiceWithFetcher:configurationService.fetcher configurationService:configurationService];
	LRLRottenTomatoesService *rottenTomatoes = [LRLRottenTomatoesService dataServiceWithFetcher:configurationService.fetcher configurationService:configurationService];
	LRLTrailerAddictService *trailerService = [LRLTrailerAddictService dataServiceWithFetcher:configurationService.fetcher configurationService:configurationService];
	return [self serviceWithIMDBService:imdb rottenTomatoesService:rottenTomatoes trailerService:trailerService];
}

- (RACSignal *) detailedMovie:(id<LRLMovie>)movie {
	return [[[[[[self.imdbService configuredService]
		deliverOn:RACScheduler.scheduler]
		map:^(id _) {
			return [RACSignal
				combineLatest:@[
					[self.imdbService detailedMovie:movie],
					[self.rottenTomatoesService updatedMovieInfo:movie],
					[RACSignal return:nil]
					//[[[self.trailerService trailerForMovie:movie] startWith:nil] catchTo:RACSignal.empty].logAll
				]
			  	reduce:^(id<LRLMovie> imdbMovie, id<LRLMovie> rottenTomatoesMovie, LRLTrailer *trailer){
					return [imdbMovie movieWithUpdate:^(id<LRLMovieMutable> movie) {
						if(rottenTomatoesMovie) {
							movie.artworkURL = rottenTomatoesMovie.artworkURL;
							movie.criticsRating = rottenTomatoesMovie.criticsRating;
						}
					  	if(trailer) {
							movie.trailer = trailer;
					  	}
					}];
				}];
		}]
		switchToLatest]
		deliverOn:RACScheduler.mainThreadScheduler]
		setNameWithFormat:@"-detailedMovie"];
}

@end
