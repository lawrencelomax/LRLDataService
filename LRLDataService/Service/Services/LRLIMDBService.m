//
//  LRLIMDBService.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLIMDBService.h"

#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>

#import "RACSignal+LRLOperatons.h"
#import "LRLMovie.h"

NSString *const LRLIMDBServiceErrorDomain = @"com.github.lawrencelomax.lrldataservice.imdb";

@implementation LRLIMDBService

- (RACSignal *) moviesWithSearch:(NSString *)search {
	return [[[[[[[self mapToURL:^(LRLDataFetcher *fetcher, LRLConfiguration *configuration) {
			NSURL *url = [configuration.imdbEndpoint URLByAppendingQueryDictionary:@{
				@"i" : @"",
				@"s" : search
			}];
			return [fetcher dataForResourceURL:url];
		}]
		lrl_checkCorrectClass:NSDictionary.class]
		map:^(NSDictionary *value) {
			return value[@"Search"];
		}]
		lrl_checkCorrectClass:NSArray.class]
		flattenMap:^(NSArray *values) {
			return [[values.rac_sequence.signal lrl_modelByMappingToClass:LRLMovie.class] collect];
		}]
		deliverOn:RACScheduler.mainThreadScheduler]
		setNameWithFormat:@"-moviesWithSearch [%@]", search];
}


- (RACSignal *) detailedMovie:(LRLMovie *)movie {
	return [[[[self
		mapToURL:^(LRLDataFetcher *fetcher, LRLConfiguration *configuration) {
			NSError *error = nil;
			if(!configuration.imdbEndpoint) {
				error = [NSError errorWithDomain:LRLFileStorageDataProviderErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"No IMDB Endpoint"}];
			}
			if(!movie.imdbID) {
				error = [NSError errorWithDomain:LRLFileStorageDataProviderErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"No IMDB ID"}];
			}
			
			NSURL *path = [configuration.imdbEndpoint URLByAppendingQueryDictionary:@{
				@"i" : movie.imdbID
			}];
			return [fetcher dataForResourceURL:path];
		}]
		lrl_checkCorrectClass:NSDictionary.class].logAll
		lrl_modelByMappingToClass:LRLMovie.class]
		setNameWithFormat:@"-detailedMovie"];
}


@end
