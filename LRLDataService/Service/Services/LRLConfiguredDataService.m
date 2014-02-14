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

- (RACSignal *) configuredService {
	LRLDataFetcher *fetcher = self.fetcher;
	
	return [[self.configurationService.configuration
		map:^(LRLConfiguration *configuration) {
			return RACTuplePack(fetcher, configuration);
		}]
		setNameWithFormat:@"-configuredService"];
}

- (RACSignal *) mapToURL:( RACSignal *(^)(LRLDataFetcher *, LRLConfiguration *) )mapping {
	return [[self.configuredService
		reduceEach:^RACSignal *(LRLDataFetcher *dataFetcher, LRLConfiguration *configuration){
			return mapping(dataFetcher, configuration);
		}]
		switchToLatest];
}

@end
