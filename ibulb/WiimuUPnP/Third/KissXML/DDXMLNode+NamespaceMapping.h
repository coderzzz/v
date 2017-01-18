//
//  DDXMLNode+NamespaceMapping.h
//  FreeDream
//
//  Created by Amor on 14-2-21.
//  Copyright (c) 2014年 Seewo. All rights reserved.
//

#import "DDXMLNode.h"

@interface DDXMLNode (NamespaceMapping)

- (NSArray *)nodesForXPath:(NSString *)xpath namespaceMappings:(NSDictionary*)namespaceMappings error:(NSError **)error;

@end
