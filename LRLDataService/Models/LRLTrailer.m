//
//  LRLTrailer.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 16/02/2014.
//
//

#import "LRLTrailer.h"

@implementation LRLTrailer

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
	return @{
		@"title" : @"title",
		@"link" : @"link",
		@"pubDateString"  : @"pubDate",
		@"trailerId" : @"trailer_id",
		@"imdbId" : @"imdb",
		@"embed" : @"embed"
	};
}

@end
