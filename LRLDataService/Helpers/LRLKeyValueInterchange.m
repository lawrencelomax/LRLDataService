//
//  LRLKeyValueInterchange.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLKeyValueInterchange.h"

@interface LRLKeyValueInterchange()

@property (nonatomic, strong) NSString *temporaryKey;
@property (nonatomic, strong) NSString *temporaryValue;

@end

@implementation LRLKeyValueInterchange

- (instancetype) init {
	if( (self = [super init]) ) {
		
	}
	return self;
}

- (void) postChangeForKey:(NSString *)key withValue:(id)value {
	@synchronized(self) {
		[self willChangeValueForKey:key];
		self.temporaryKey = key;
		self.temporaryValue = value;
		[self didChangeValueForKey:key];
		
		self.temporaryKey = nil;
		self.temporaryValue = nil;
	}
}

- (id) valueForKey:(NSString *)key {
	NSAssert([self.temporaryKey isEqualToString:key], @"Tried to obtain a value that is ephermeral");
	
	return self.temporaryValue;
}

@end
