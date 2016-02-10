//
//  Orm.m
//  SupORM
//
//  Created by Denis MLUDEK on 26/03/2014.
//  Copyright (c) 2014 denis mludek. All rights reserved.
//

#import "Orm.h"
#import "SQLiteManager.h"

NSString *dbUsed;
NSString *dbPath;
NSArray *dbSupported ;
Class classDbManager;

@implementation Orm

+ (void) initialize {
  // If you want to support another storage engine, add it in the array
  dbSupported = [NSArray arrayWithObjects:@"sqlite", nil];
}

+ (void) setDbUsed:(NSString*)dbUsed_ {
  if([dbSupported containsObject:dbUsed_]) {
    dbUsed = dbUsed_;
    
    // If another storage engine, add an IF statement with it
    if([dbUsed isEqualToString:@"sqlite"]){
      classDbManager = [SQLiteManager class];
    }
    
  }
}

+ (void) setDbPath:(NSString*)dbPath_ {
  dbPath = dbPath_;
}

+ (void) persist:(id)object {
  if([self checkParams]) {
    if ([classDbManager conformsToProtocol:@protocol(Db)]) {
      [classDbManager setDbPath:dbPath];
      [classDbManager persist:object];
    }else{
      NSLog(@"Library has to implement the Db protocol !");
    }
  }
  
}

+ (void) update:(id)object {
  if([self checkParams]) {
    if ([classDbManager conformsToProtocol:@protocol(Db)]) {
      [classDbManager setDbPath:dbPath];
      [classDbManager update:object];
    }else{
      NSLog(@"Library has to implement the Db protocol !");
    }
  }
  
}

+ (NSMutableArray*) find:(Class)classObject where:(NSString*)params {
  if([self checkParams]) {
    if ([classDbManager conformsToProtocol:@protocol(Db)]) {
      [classDbManager setDbPath:dbPath];
      return [classDbManager find:classObject where:params];
    }else{
      NSLog(@"Library has to implement the Db protocol !");
    }
  }
  return false;
}

+ (NSMutableArray*) findAll:(Class)classObject {
  if([self checkParams]) {
    if ([classDbManager conformsToProtocol:@protocol(Db)]) {
      [classDbManager setDbPath:dbPath];
      return [classDbManager findAll:classObject];
    }else{
      NSLog(@"Library has to implement the Db protocol !");
    }
  }
  return false;
}

+ (bool) checkParams {
  if(!dbUsed){
    return false;
  }
  if(!dbPath){
    return false;
  }
  return true;
}

@end
