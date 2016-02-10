//
//  SQLiteManager.h
//  SupORM
//
//  Created by Denis MLUDEK on 22/03/2014.
//  Copyright (c) 2014 denis mludek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fmdb/FMDatabase.h"
#import "Db.h"

@interface SQLiteManager : NSObject <Db>

+ (void) persist:(id)object;
+ (void) update:(id)object;
+ (NSMutableArray*) find:(Class)classObject where:(NSString*)params ;
+ (NSMutableArray*) findAll:(Class)classObject ;

+ (void) setDbPath:(NSString*)dbPath_ ;

@end
