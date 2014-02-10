//
//  LRLKeyValueInterchange.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import <Foundation/Foundation.h>

@interface LRLKeyValueInterchange : NSObject

- (void) postChangeForKey:(NSString *)key withValue:(id)value;

@end
