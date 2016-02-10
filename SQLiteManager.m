//
//  SQLiteManager.m
//  SupORM
//
//  Created by Denis MLUDEK on 22/03/2014.
//  Copyright (c) 2014 denis mludek. All rights reserved.
//

#import "SQLiteManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Introspection.h"

NSString * dbPath = nil;
FMDatabase *database = nil ;

@implementation SQLiteManager

+ (void)persist:(id)object {
  
  NSMutableDictionary *dictObject = [Introspection analyzeClass:object];
  
  NSMutableDictionary *dictWithoutIdOrm = [dictObject objectForKey:@"values"];
  [dictWithoutIdOrm removeObjectForKey:@"idORM"];
  
  NSString *className = [dictObject objectForKey:@"className"];
  NSString *nameField;
  NSString *valueField;
  NSString *sql;
  
  NSMutableString *listFields = [NSMutableString stringWithString:@"("];
  NSMutableString *listValues = [NSMutableString stringWithString:@"("];
  int idReturn;
  
  [self createTableIfNotExists:object];
  
  for(id key in dictWithoutIdOrm){
    nameField = key;
    valueField = [dictWithoutIdOrm objectForKey:key];
    
    if(![key isEqualToString:[[dictWithoutIdOrm allKeys] lastObject]]){
      [listFields appendFormat:@"%@,",nameField];
      [listValues appendFormat:@"%@,",valueField];
    }else{
      [listFields appendFormat:@"%@)",nameField];
      [listValues appendFormat:@"%@)",valueField];
    }
  }
  
  sql = [NSString stringWithFormat:@"INSERT INTO %@ %@ VALUES %@ ;", className, listFields,listValues];
    
  [database open];
  [database executeUpdate: sql, nil];
  idReturn = [database lastInsertRowId];
  [object setValue:[NSNumber numberWithInt:idReturn] forKey:@"idORM"];
  [database close];  
}

+ (void)update:(id)object {
  
  NSMutableDictionary *dictObject = [Introspection analyzeClass:object];
  NSMutableDictionary *dictValues = [dictObject objectForKey:@"values"];
  
  NSMutableDictionary *dictWithoutIdOrm = [dictObject objectForKey:@"values"];
  [dictWithoutIdOrm removeObjectForKey:@"idORM"];
  
  NSString *className = [dictObject objectForKey:@"className"];
  NSString *nameField;
  NSString *valueField;
  NSString *sql;
  
  NSMutableString *listUpdateSql = [NSMutableString string];
  
  int idORM = [[object valueForKey:@"idORM"] intValue];
  
  if(idORM != 0 && [self checkIfIdOrmExists:object]) {
    
    for(id key in dictWithoutIdOrm){
      nameField = key;
      valueField = [dictValues objectForKey:key];
      
      if(![key isEqualToString:[[dictWithoutIdOrm allKeys] lastObject]]){
        [listUpdateSql appendFormat:@"%@ = %@, ",nameField, valueField];
      }else{
        [listUpdateSql appendFormat:@"%@ = %@ ",nameField, valueField];
      }
    }
    sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE idORM = %d ;",className, listUpdateSql, idORM];
    
    [database open];
    [database executeUpdate: sql, nil];
    [database close];
  }else{
    NSLog(@"Cannot update when there is no idORM, please use persist or find first");
  }
}

+ (NSMutableArray*) find:(Class)classObject where:(NSString*)params {
  
  NSString *className = NSStringFromClass(classObject);
  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", className, params ];
  NSMutableArray *arrayToReturn = [NSMutableArray array];
  
  id obj ;
    
  [database open];
  
  FMResultSet *results = [database executeQuery:sql];
  NSDictionary *dictColumnsAndValues;
  while([results next]){
    dictColumnsAndValues = [results resultDictionary];
    obj = [Introspection initializeObjectFromDictionary:dictColumnsAndValues class:classObject];
    [arrayToReturn addObject:obj];
  }

  [database close];
  
  return arrayToReturn;
}

+ (NSMutableArray*) findAll:(Class)classObject {
  
  NSString *className = NSStringFromClass(classObject);
  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ", className ];
  NSMutableArray *arrayToReturn = [NSMutableArray array];
  NSDictionary *dictColumnsAndValues;
  
  id obj ;
  
  [database open];
  
  FMResultSet *results = [database executeQuery:sql];
    
  while([results next]){
    dictColumnsAndValues = [results resultDictionary];
    obj = [Introspection initializeObjectFromDictionary:dictColumnsAndValues class:classObject];
    [arrayToReturn addObject:obj];
  }
  
  [database close];
  
  return arrayToReturn;
}
  

+ (void) createTableIfNotExists:(id)object {
  
  NSMutableDictionary *dictObject = [Introspection analyzeClass:object];
  NSMutableDictionary *dictTypesBDD = [dictObject objectForKey:@"typeBDD"];
  NSString *className = [dictObject objectForKey:@"className"];
  NSString *nameField;
  NSString *typeBDD;
  
  NSMutableString *sqlCreateTable = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", className];

  for(id key in dictTypesBDD){
    nameField = key;
    typeBDD = [dictTypesBDD objectForKey:key];
    
    [sqlCreateTable appendFormat:@"%@ %@,",nameField, typeBDD];
  }
  
  [sqlCreateTable appendString:@"PRIMARY KEY (idORM ASC));"];
    
  [database open];
  [database executeUpdate: sqlCreateTable, nil];
  [database close];
}

+ (bool) checkIfIdOrmExists:(id)object {
  
  int idORM = [[object valueForKey:@"idORM"] intValue];
  int nbRes;
  NSString *className = NSStringFromClass([object class]);
  NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@ WHERE idORM = %i",className, idORM];
  
  [database open];
  
  FMResultSet *results = [database executeQuery:sql];
  if([results next]) {
    nbRes = [results intForColumn:@"count"];
  }
   
  [database close];
  
  if(nbRes == 0){
    return false;
  }else{
    return true;
  }
  
}

+ (void) setDbPath:(NSString*)dbPath_ {
  dbPath = dbPath_;
  database = [FMDatabase databaseWithPath:dbPath];
}

@end
