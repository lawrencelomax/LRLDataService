//
//  LRLMessageBusDataProvider.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 9/02/2014.
//
//

#import "LRLMessageBusDataProvider.h"

#import "LRLURLHelpers.h"

@interface LRLMessageBusDataProvider_KeyValueInterchange : LRLMessageBusDataProvider

@property (nonatomic, readonly) LRLKeyValueInterchange *interchange;

@end

@implementation LRLMessageBusDataProvider_KeyValueInterchange

- (instancetype) initWithInterchange:(LRLKeyValueInterchange *)interchange {
	if( (self = [super init]) ){
		_interchange = interchange;
	}
	return self;
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL {
	NSString *keyString = [LRLURLHelpers uniqueStringForURL:resourceURL];
	return [_interchange rac_valuesAndChangesForKeyPath:keyString options:0 observer:self];
}

@end

@implementation LRLMessageBusDataProvider

+ (instancetype) dataProvider {
	return [[self alloc] init];
}

+ (instancetype) dataProviderWithInterchange:(LRLKeyValueInterchange *)interchange {
	return [LRLMessageBusDataProvider_KeyValueInterchange dataProviderWithInterchange:interchange];
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL {
	NSAssert(NO, @"Should implement %@", NSStringFromSelector(_cmd));
	return nil;
}

@end
