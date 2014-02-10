//
//  LRLConfigurationService.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLConfigurationService.h"

#import "LRLServiceConfiguration.h"

@implementation LRLConfigurationService

- (RACSignal *) configuration {
	return [[[self.fetcher dataForResourceURL:[NSURL URLWithString:@"foo"] withLocalCache:YES repeatInterval:100]
		tryMap:^(id value, NSError **errorPtr) {
			return [LRLServiceConfiguration modelWithDictionary:value error:errorPtr];
		}]
		distinctUntilChanged];
}

@end
