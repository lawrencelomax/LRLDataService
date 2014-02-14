//
//  RACSignal+LRLOperatons.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 15/02/2014.
//
//

#import <ReactiveCocoa/ReactiveCocoa.h>

extern NSString *const LRLSignalOperationsErrorDomain;

@interface RACSignal (LRLOperatons)

- (RACSignal *) lrl_modelByMappingToClass:(Class)clazz;

- (RACSignal *) lrl_checkCorrectClass:(Class)clazz;

- (RACSignal *) lrl_retryWithInterval:(NSTimeInterval)interval;

@end
