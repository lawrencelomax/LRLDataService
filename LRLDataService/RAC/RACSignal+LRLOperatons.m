//
//  RACSignal+LRLOperatons.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 15/02/2014.
//
//

#import "RACSignal+LRLOperatons.h"

#import <Mantle/Mantle.h>

NSString *const LRLSignalOperationsErrorDomain = @"com.github.lawrencelomax.lrldataservice.lrlsignaloperations";

@implementation RACSignal (LRLOperatons)

- (RACSignal *) lrl_modelByMappingToClass:(Class)clazz {
	return [self tryMap:^(id value, NSError *__autoreleasing *errorPtr) {
		NSError *error = nil;
		value = [MTLJSONAdapter modelOfClass:clazz fromJSONDictionary:value error:&error];
		return value;
	}];
}

- (RACSignal *) lrl_checkCorrectClass:(Class)clazz {
	return [self try:^(id value, NSError **errorPtr) {
		if(![value isKindOfClass:clazz]) {
			*errorPtr = [NSError errorWithDomain:LRLSignalOperationsErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%@ is not of class %@", value, NSStringFromClass(clazz)]}];
			return NO;
		}
		return YES;
	}];
}

- (RACSignal *) lrl_retryWithInterval:(NSTimeInterval)interval {
	NSAssert(interval > 0, @"Interval must be > 0");
	
	RACSignal *delay = [[RACSignal interval:interval onScheduler:RACScheduler.mainThreadScheduler] take:1];
	return [[[self catchTo:RACSignal.empty] concat:delay] repeat];
}

@end
