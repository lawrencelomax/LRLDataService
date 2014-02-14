//
//  LRLConfiguredDataService.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLDataService.h"

#import "LRLConfigurationService.h"
#import "LRLConfiguration.h"

@interface LRLConfiguredDataService : LRLDataService

+ (instancetype) dataServiceWithFetcher:(LRLDataFetcher *)fetcher configurationService:(LRLConfigurationService *)configurationService;

@property (nonatomic, readonly) LRLConfigurationService *configurationService;

- (RACSignal *) configuredService;
- (RACSignal *) mapToURL:( RACSignal *(^)(LRLDataFetcher *fetcher, LRLConfiguration *configuration) )mapping;

@end
