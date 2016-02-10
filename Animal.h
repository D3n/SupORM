//
//  Animal.h
//  SupORM
//
//  Created by Denis MLUDEK on 22/03/2014.
//  Copyright (c) 2014 denis mludek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animal : NSObject

@property(nonatomic,assign) int idORM;
@property(nonatomic,assign) bool b;
@property(nonatomic,assign) char c;
@property(nonatomic,assign) unsigned char uc;
@property(nonatomic,assign) int i;
@property(nonatomic,assign) unsigned int ui;
@property(nonatomic,assign) long l;
@property(nonatomic,assign) unsigned long ul;
@property(nonatomic,assign) float f;
@property(nonatomic,assign) double d;
@property(nonatomic,assign) NSString *name;
@property(nonatomic,assign) NSNumber *nn;

- (id) init;
-(id)initWithName:(NSString*)name_  andInt:(int)i_  andBool:(bool)b_ andChar:(char)c_ andUChar:(unsigned char)uc_ andUInt:(unsigned int)ui_
      andLong:(long)l_ andULong:(unsigned long)ul_ andFloat:(float)f_ andDouble:(double)d_ andNSNumber:(NSNumber*)nn_  ;


@end
