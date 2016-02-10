//
//  Tools.m
//  SupORM
//
//  Created by Denis MLUDEK on 26/03/2014.
//  Copyright (c) 2014 denis mludek. All rights reserved.
//

#import "Introspection.h"
#import <objc/runtime.h>

@implementation Introspection

+ (NSMutableDictionary*) analyzeClass:(id)object {
  
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  NSMutableDictionary *dictValues = [NSMutableDictionary dictionary];
  NSMutableDictionary *dictTypeBDD = [NSMutableDictionary dictionary];
  
  [dict setObject:NSStringFromClass([object class]) forKey:@"className"];
  
  unsigned int count;
  NSString *nameField;
  NSString *valueField;
  NSString *typeField;
  NSString *typeBDD;
  
  Ivar *vars = class_copyIvarList([object class], &count);
  for (NSUInteger i=0; i<count; i++) {
    
    Ivar var = vars[i];
    nameField = [NSString stringWithUTF8String:ivar_getName(var)];
    typeField = [NSString stringWithFormat:@"%s", ivar_getTypeEncoding(var)];
    
    if([typeField isEqualToString:@"c"]){
      int itmp = [[object valueForKey:nameField] intValue];
      char ctmp = (char) itmp ;
      valueField = [NSString stringWithFormat:@"'%c'" , ctmp];
      typeBDD = @"CHAR(1)";
    }
    if([typeField isEqualToString:@"C"]){
      int itmp = [[object valueForKey:nameField] intValue];
      char ctmp = (char) itmp ;
      valueField = [NSString stringWithFormat:@"'%c'" , ctmp];
      typeBDD = @"CHAR(1)";
    }
    if([typeField isEqualToString:@"i"]){
      valueField = [NSString stringWithFormat:@"%@" , [object valueForKey:nameField]];
      if([valueField isEqualToString:@"0"]){
        valueField = @"(null)";
      }
      typeBDD = @"INTEGER";
    }
    if([typeField isEqualToString:@"I"]){
      valueField = [NSString stringWithFormat:@"%@" , [object valueForKey:nameField]];
      if([valueField isEqualToString:@"0"]){
        valueField = @"(null)";
      }
      typeBDD = @"INTEGER";
    }
    if([typeField isEqualToString:@"q"]){
      valueField = [NSString stringWithFormat:@"%@" , [object valueForKey:nameField]];
      if([valueField isEqualToString:@"0"]){
        valueField = @"(null)";
      }
      typeBDD = @"BIGINT";
    }
    if([typeField isEqualToString:@"Q"]){
      valueField = [NSString stringWithFormat:@"%@" , [object valueForKey:nameField]];
      if([valueField isEqualToString:@"0"]){
        valueField = @"(null)";
      }
      typeBDD = @"UNSIGNED BIG INT";
    }
    if([typeField isEqualToString:@"f"]){
      valueField = [NSString stringWithFormat:@"%@" , [object valueForKey:nameField]];
      if([valueField isEqualToString:@"0"]){
        valueField = @"(null)";
      }
      typeBDD = @"FLOAT";
    }
    if([typeField isEqualToString:@"d"]){
      valueField = [NSString stringWithFormat:@"%@" , [object valueForKey:nameField]];
      if([valueField isEqualToString:@"0"]){
        valueField = @"(null)";
      }
      typeBDD = @"DOUBLE";
    }
    if([typeField isEqualToString:@"B"]){
      valueField = [NSString stringWithFormat:@"%@" , [object valueForKey:nameField]];
      typeBDD = @"BOOLEAN";
    }
    if([typeField isEqualToString:@"@\"NSString\""]){
      valueField = [NSString stringWithFormat:@"'%@'" , [object valueForKey:nameField]];
      typeBDD = @"TEXT";
    }
    if([typeField isEqualToString:@"@\"NSNumber\""]){
      valueField = [NSString stringWithFormat:@"%@" , [object valueForKey:nameField]];
      typeBDD = @"DOUBLE";
    }
    
    [dictValues setObject:valueField forKey:nameField];
    [dictTypeBDD setObject:typeBDD forKey:nameField];
    
  }
  
  [dict setObject:dictValues forKey:@"values"];
  [dict setObject:dictTypeBDD forKey:@"typeBDD"];
  
  return dict;
}

+ (id)initializeObjectFromDictionary:(NSDictionary*)dic class:(Class)classObject {
  
  unsigned int count;
  NSString *nameField;
  NSString *typeField;
  
  id object = [[classObject alloc] init];
  
  Ivar *vars = class_copyIvarList(classObject, &count);
  for (NSUInteger i=0; i<count; i++) {
    
    Ivar var = vars[i];
    nameField = [NSString stringWithUTF8String:ivar_getName(var)];
    typeField = [NSString stringWithFormat:@"%s", ivar_getTypeEncoding(var)];
    
    if([typeField isEqualToString:@"c"]){
      const char *cc = [[dic objectForKey:nameField] UTF8String];
      char c = *cc;
      [object setValue:[NSNumber numberWithChar:c] forKey:nameField];
    }
    if([typeField isEqualToString:@"C"]){
      const char *cc = [[dic objectForKey:nameField] UTF8String];
      unsigned char c = *cc;
      [object setValue:[NSNumber numberWithUnsignedChar:c] forKey:nameField];
    }
    if([typeField isEqualToString:@"i"]){
      [object setValue:[NSNumber numberWithInt:[[dic objectForKey:nameField] intValue]] forKey:nameField];
    }
    if([typeField isEqualToString:@"I"]){
      [object setValue:[NSNumber numberWithUnsignedInt:[[dic objectForKey:nameField] intValue]] forKey:nameField];
    }
    if([typeField isEqualToString:@"q"]){
      [object setValue:[NSNumber numberWithLong:[[dic objectForKey:nameField] longValue]] forKey:nameField];
    }
    if([typeField isEqualToString:@"Q"]){
      [object setValue:[NSNumber numberWithUnsignedLong:[[dic objectForKey:nameField] longValue]] forKey:nameField];
    }
    if([typeField isEqualToString:@"f"]){
      [object setValue:[NSNumber numberWithFloat:[[dic objectForKey:nameField] floatValue]] forKey:nameField];
    }
    if([typeField isEqualToString:@"d"]){
      [object setValue:[NSNumber numberWithDouble:[[dic objectForKey:nameField] doubleValue]] forKey:nameField];
    }
    if([typeField isEqualToString:@"B"]){
      if([[dic objectForKey:nameField] intValue] == 1){
        [object setValue:[NSNumber numberWithBool:true] forKey:nameField];
      }else{
        [object setValue:[NSNumber numberWithBool:false] forKey:nameField];
      }
    }
    if([typeField isEqualToString:@"@\"NSString\""]){
      [object setValue:[NSString stringWithFormat:@"%@",[dic objectForKey:nameField]] forKey:nameField];
    }
    if([typeField isEqualToString:@"@\"NSNumber\""]){
      int n = [[dic objectForKey:nameField] intValue];
      NSNumber *nn = [NSNumber numberWithInt:n];
      [object setValue:nn forKey:nameField];
    }
    
  }
  
  return object;
}

@end
