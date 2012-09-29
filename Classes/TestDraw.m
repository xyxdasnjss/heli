//
//  TestDraw.m
//  Heli
//
//  Created by vy phan on 08/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestDraw.h"


@implementation TestDraw
-(id)initVertices:(CGPoint*)vertices_ Color:(ccColor3B)color_{
	self = [super init];
	//vertices = vertices_;
	vertices = vertices_;
	vertices = malloc(5);
	color = color_;
	return self;
}
-(void)draw{
	// open yellow poly
	//glColor4ub(255, 255, 0, 255);
	glColor4ub(color.r, color.g, color.b, 255);
	
	glLineWidth(10);
	//CGPoint vertices[] = { ccp(0,0), ccp(50,50), ccp(100,50), ccp(100,100), ccp(50,100) };
	drawPoly( vertices, 5, YES);
}
@end
