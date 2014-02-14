//
//  LRLServiceConfiguration.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLConfiguration.h"

@interface LRLConfiguration ()

@end

@implementation LRLConfiguration

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
	return @{
		@"imdbEndpoint" : @"imdb_endpoint",
		@"configEndpoint" : @"config_endpoint",
		@"trailerAddictEndpoint" : @"traileraddict_endpoint",
		@"rottenTomatoesEndpoint" : @"rottentomatoes_endpoint",
		@"tvdbAPIKey" : @"tvdb_apikey",
		@"rottenTomatoesAPIKey" : @"rottentomatoes_apikey"
	};
}

+ (NSValueTransformer *) imdbEndpointJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *) configEndpointJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *) trailerAddictEndpointJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *) rottenTomatoesEndpointJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
