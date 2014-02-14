//
//  LRLMovie.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 11/02/2014.
//
//

#import "LRLMovie.h"

@interface LRLMovie()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *imdbID;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *plot;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) NSString *criticsRating;
@property (nonatomic, strong) NSURL *artworkURL;

@property (nonatomic, strong) LRLTrailer *trailer;

@end

@implementation LRLMovie

+ (instancetype) movie {
	return [[LRLMovie alloc] init];
}

- (LRLMovie *) movieWithUpdate:( LRLMovie *(^)(LRLMovie *movie) )update {
	LRLMovie *movie = [self copy];
	return update(movie);
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
