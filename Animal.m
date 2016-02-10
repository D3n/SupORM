//
//  Animal.m
//  SupORM
//
//  Created by Denis MLUDEK on 22/03/2014.
//  Copyright (c) 2014 denis mludek. All rights reserved.
//

#import "Animal.h"

@implementation Animal

@synthesize idORM;
@synthesize b;
@synthesize c;
@synthesize uc;
@synthesize i;
@synthesize ui;
@synthesize l;
@synthesize ul;
@synthesize f;
@synthesize d;
@synthesize name;
@synthesize nn;


-(id)init {
  if(self = [super init]) {
    return self;
    idORM = 0;
  }
  return nil;
}

-(id)initWithName:(NSString*)name_  andInt:(int)i_  andBool:(bool)b_ andChar:(char)c_ andUChar:(unsigned char)uc_ andUInt:(unsigned int)ui_
      andLong:(long)l_ andULong:(unsigned long)ul_ andFloat:(float)f_ andDouble:(double)d_ andNSNumber:(NSNumber*)nn_ {
  
  if (self = [super init]) {
    idORM = 0;
    name = name_;
    i = i_;
    b = b_;
    c = c_;
    uc = uc_;
    ui = ui_;
    l = l_;
    ul = ul_;
    f = f_;
    d = d_;
    nn = nn_;
    return self;
  }
  return nil;
}


@end
