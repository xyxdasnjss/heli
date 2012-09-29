//
//  GameScene.m
//  Heli
//
//  Created by vy phan on 02/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

- (id) init {
	self = [super init];
	if (self != nil){
		
		TestLayer *testLayer = [[[TestLayer alloc] init] autorelease];
		// gang tag de danh dau cho doi tuong tao ra
		[self addChild:testLayer z:0 tag:1];
	}
	return self;
}

- (void) dealloc {
	NSLog(@"GameScene dealloc");
	[super dealloc];
}

@end
