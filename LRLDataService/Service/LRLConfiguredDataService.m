//
//  LRLConfiguredDataService.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLConfiguredDataService.h"

@interface LRLConfiguredDataService()

@property (nonatomic, strong) LRLConfigurationService *configurationService;

@end

@implementation LRLConfiguredDataService

+ (instancetype) dataServiceWithFetcher:(LRLDataFetcher *)fetcher configurationService:(LRLConfigurationService *)configurationService {
	LRLConfiguredDataService *configuredService = [self dataServiceWithFetcher:fetcher];
	configuredService.configurationService = configurationService;
	return configuredService;
}

- (RACSignal *) mapToURL:( RACSignal *(^)(LRLDataFetcher *, LRLServiceConfiguration *) )mapping {
	LRLDataFetcher *fetcher = self.fetcher;
	
	return [[self.configurationService.configuration
		map:^(LRLServiceConfiguration *configuration) {
			return mapping(fetcher, configuration);
		}]
		switchToLatest];
}

@end
