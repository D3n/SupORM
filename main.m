//
//  main.m
//  SupORM
//
//  Created by Denis MLUDEK on 21/03/2014.
//  Copyright (c) 2014 denis mludek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal.h"
#import "Orm.h"


int main(int argc, const char * argv[])
{

    @autoreleasepool {
    
    [Orm setDbPath:@"suporm.sqlite"];
    [Orm setDbUsed:@"sqlite"];
          
    NSMutableArray *res;

    Animal * chat = [[Animal alloc] initWithName:@"Chat" andInt:2 andBool:false andChar:'c' andUChar:'C' andUInt:22 andLong:3 andULong:33 andFloat:2.2 andDouble:3.3 andNSNumber:[NSNumber numberWithInt:100]];
    Animal * chien = [[Animal alloc] initWithName:@"Chien" andInt:20 andBool:true andChar:'c' andUChar:'C' andUInt:55 andLong:65 andULong:75 andFloat:5.3 andDouble:9.2 andNSNumber:[NSNumber numberWithInt:200]];
      
    // Persist objet chat et chien
    [Orm persist:chat];
    [Orm persist:chien];
    
    NSLog(@"----------FIND ALL--------------");
    
    // Load all the objects of 1 class
    res = [Orm findAll:[Animal class]];
    int i = 0;
    for (Animal *a in res) {
      i++;
      NSLog(@"%@ %i", a.name, i);
    }

    NSLog(@"----------UPDATE--------------");

    // Update objet chat
    chat.name = @"Chat Tigré";
    [Orm update:chat];
    
    // Load all the objects of 1 class
    res = [Orm findAll:[Animal class]];
    for (Animal *a in res) {
      NSLog(@"%@", a.name);
    }
    
    NSLog(@"-----------FIND only 'Chat' -------------");
    // Load some objects (from DB) with specified parameters
    res = [Orm find:[Animal class] where:@"name='Chat'"];
    for (Animal *a in res) {
      NSLog(@"%@", a.name);
    }
        
    
    }
    return 0;
}

