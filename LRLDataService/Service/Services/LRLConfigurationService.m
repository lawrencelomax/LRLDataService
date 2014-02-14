//
//  LRLConfigurationService.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLConfigurationService.h"

#import <Mantle/Mantle.h>

#import "RACSignal+LRLOperatons.h"
#import "LRLConfiguredDataService.h"
#import "LRLConfiguration.h"

@interface LRLConfigurationService ()

@property (nonatomic, strong) LRLConfiguration *memoizedConfiguration;

@end

@implementation LRLConfigurationService

- (instancetype) initWithFetcher:(LRLDataFetcher *)fetcher {
	if( (self = [super initWithFetcher:fetcher]) ) {
		RAC(self, memoizedConfiguration) = [self configurationSignal];
	}
	return self;
}

- (RACSignal *) configuration {
	return [RACObserve(self, memoizedConfiguration) ignore:nil];
}

- (RACSignal *) configurationSignal {
	@weakify(self)
	return [[[self.bundledConfiguration
	   	lrl_modelByMappingToClass:LRLConfiguration.class]
	  	flattenMap:^(LRLConfiguration *configuration) {
			@strongify(self)
		  	return [[[self configurationWithURL:configuration.configEndpoint]
				startWith:configuration]
				lrl_retryWithInterval:600];
	  	}]
	 	distinctUntilChanged];
}

- (RACSignal *) configurationWithURL:(NSURL *)url {
	@weakify(self)
	
	return [[[[self.fetcher dataForResourceURL:url withLocalCache:YES repeatInterval:1000]
		distinctUntilChanged]
		lrl_modelByMappingToClass:LRLConfiguration.class]
		flattenMap:^(LRLConfiguration *configuration) {
			if([configuration.configEndpoint isEqual:url]) {
				return [RACSignal return:configuration];
			}
			
			@strongify(self)
			return [[self configurationWithURL:url] startWith:configuration];
		}];
}

- (RACSignal *) bundledConfiguration {
	return [[[[[RACSignal return:[[NSBundle mainBundle] URLForResource:@"config" withExtension:@"json"]]
		lrl_checkCorrectClass:NSURL.class]
		tryMap:^(NSURL *url, NSError **errorPtr) {
			return [NSData dataWithContentsOfURL:url options:0 error:errorPtr];
		}]
		tryMap:^(NSData *data, NSError **errorPtr) {
			return [NSJSONSerialization JSONObjectWithData:data options:0 error:errorPtr];
		}]
		lrl_checkCorrectClass:NSDictionary.class];
}

@end
