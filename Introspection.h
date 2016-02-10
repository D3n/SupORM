//
//  Tools.h
//  SupORM
//
//  Created by Denis MLUDEK on 26/03/2014.
//  Copyright (c) 2014 denis mludek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Introspection : NSObject

+ (NSMutableDictionary*) analyzeClass:(id)object;
+ (id)initializeObjectFromDictionary:(NSDictionary*)dic class:(Class)classObject;

@end
