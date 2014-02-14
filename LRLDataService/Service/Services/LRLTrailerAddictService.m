//
//  LRLTrailerAddictService.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 16/02/2014.
//
//

#import "LRLTrailerAddictService.h"

#import "LRLMovie.h"
#import "LRLTrailer.h"
#import "RACSignal+LRLOperatons.h"

#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>

@implementation LRLTrailerAddictService

- (RACSignal *) trailerForMovie:(LRLMovie *)movie {
	return [[[self mapToURL:^(LRLDataFetcher *fetcher, LRLConfiguration *configuration) {
			NSURL *url = [configuration.trailerAddictEndpoint URLByAppendingQueryDictionary:@{@"imdb" : movie.imdbID }];
			return [fetcher dataForResourceURL:url];
		}]
		lrl_checkCorrectClass:LRLTrailer.class]
		setNameWithFormat:@"-trailerForMovie"];
}

@end
