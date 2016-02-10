//
//  Db.h
//  SupORM
//
//  Created by Denis MLUDEK on 26/03/2014.
//  Copyright (c) 2014 denis mludek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Db <NSObject>

@required
+ (void) persist:(id)object;
+ (void) update:(id)object;
+ (NSMutableArray*) find:(Class)classObject where:(NSString*)params ;
+ (NSMutableArray*) findAll:(Class)classObject ;

+ (void) setDbPath:(NSString*)dbPath_ ;

@end
