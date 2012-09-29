//
//  CusSprite.m
//  Heli
//
//  Created by vy phan on 02/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CusSprite.h"
#import "CGPointExtension.h"
#import "TextureAtlas.h"

@implementation CusSprite

- (void)draw {
	glEnableClientState(GL_VERTEX_ARRAY);
	
	static GLfloat squareVertices[8];
	squareVertices[0] = squareVertices[6] = 0;//position_.x - anchorPoint_.x*rect_.size.width + rect_.origin.x;
	squareVertices[1] = squareVertices[3] = 0;//position_.y - anchorPoint_.y*rect_.size.height +rect_.origin.y;
	squareVertices[2] = squareVertices[4] = squareVertices[0] + rect_.size.width;
	squareVertices[5] = squareVertices[7] = squareVertices[1] + rect_.size.height;
	
	glColor4ub(255, 0, 0, 255);
	
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
	glDrawArrays(GL_LINE_LOOP, 0, 4);
	
	glColor4ub(255, 255, 255, 255);
	
	glDisableClientState(GL_VERTEX_ARRAY);
}
 
/*
-(id) addChild: (CocosNode*) child z:(int)z tag:(int) aTag
{	
	NSAssert( child != nil, @"Argument must be non-nil");
	NSAssert( child.parent == nil, @"child already added. It can't be added again");
	
	if( ! children )
		[self childrenAlloc];
	
	[self insertChild:child z:z];
	
	child.tag = aTag;
	
	[child setParent: self];
	
	if( isRunning )
		[child onEnter];
	return self;
}
*/
	
@end
