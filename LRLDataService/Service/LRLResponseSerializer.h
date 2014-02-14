//
//  LRLResponseSerializer.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 17/02/2014.
//
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

@interface LRLResponseSerializer : AFHTTPResponseSerializer

@property (nonatomic, strong) AFJSONResponseSerializer *jsonSerializer;
@property (nonatomic, strong) AFXMLParserResponseSerializer *xmlSerializer;

@end
