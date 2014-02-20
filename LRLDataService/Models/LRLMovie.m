//
//  LRLMovie.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 11/02/2014.
//
//

#import "LRLMovie.h"

@implementation LRLMovie

@synthesize title = _title;
@synthesize year = _year;
@synthesize imdbID = _imdbID;
@synthesize type = _type;

@synthesize plot = _plot;
@synthesize country = _country;

@synthesize criticsRating;
@synthesize artworkURL = _artworkURL;

@synthesize trailer = _trailer;


+ (instancetype) movie {
	return [[LRLMovie alloc] init];
}

- (id<LRLMovie>) movieWithUpdate:( void (^)(id<LRLMovieMutable> movieMutable) )update {
	LRLMovie *movie = [self copy];
	update(movie);
	return movie;
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
	return @{
		@"title" : @"Title",
		@"year" : @"Year",
		@"imdbID" : @"imdbID",
		@"type" : @"Type",
		@"plot" : @"Plot",
		@"country" : @"Country"
	};
}

@end
