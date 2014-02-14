//
//  LRLRottenTomatoesService.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 18/02/2014.
//
//

#import "LRLRottenTomatoesService.h"

#import "LRLMovie.h"
#import "RACSignal+LRLOperatons.h"
#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>

NSString *const LRLRottenTomatoesServiceErrorDomain = @"com.github.lawrencelomax.lrldataservice.rottentomatoes";

@implementation LRLRottenTomatoesService

- (RACSignal *) updatedMovieInfo:(LRLMovie *)movie {
	return [[[[[self mapToURL:^(LRLDataFetcher *fetcher, LRLConfiguration *configuration) {
			NSError *error = nil;
			if(!configuration.rottenTomatoesAPIKey) {
				error = [NSError errorWithDomain:LRLRottenTomatoesServiceErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : @"Missing rottenTomatoesAPIKey"}];
			}
			if(!movie.imdbID) {
				error = [NSError errorWithDomain:LRLRottenTomatoesServiceErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : @"Missing imdbID"}];
			}
			if(error) {
				return [RACSignal return:error];
		 	}
		
			NSString *imdbID = [movie.imdbID stringByReplacingOccurrencesOfString:@"tt" withString:@""];
		
			NSURL *url = [configuration.rottenTomatoesEndpoint URLByAppendingPathComponent:@"movie_alias.json"];
			url = [url URLByAppendingQueryDictionary:@{
				@"id" : imdbID,
				@"type" : @"imdb",
				@"apikey" : configuration.rottenTomatoesAPIKey
			}];
			return [fetcher dataForResourceURL:url withLocalCache:YES repeatInterval:-1];
		}]
		lrl_checkCorrectClass:NSDictionary.class]
		try:^BOOL(NSDictionary *dictionary, NSError **errorPtr) {
			return dictionary[@"error"] == nil;
		}]
		map:^(NSDictionary *dictionary) {
			return [movie movieWithUpdate:^(LRLMovie *movie) {
				movie.criticsRating = dictionary[@"ratings"][@"critics_rating"];
				NSDictionary *poster = dictionary[@"posters"];
				NSString *urlString = poster[@"detailed"] ?: poster[@"profile"];
				if(urlString) {
					movie.artworkURL = [NSURL URLWithString:urlString];
				}
				return movie;
			}];
		}]
		setNameWithFormat:@"updatedMovieInfo"];
}

@end
