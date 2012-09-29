//
//  Rectange.m
//  Heli
//
//  Created by vy phan on 06/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Rectange.h"


@implementation Rectange

@synthesize	rect_;
@synthesize	color_;


-(id)initRect:(CGRect)Rect_ Color:(ccColor3B)Color_{
	self = [super init];
	rect_ = Rect_;
	color_ = Color_;
	return self;
}
- (void)draw {
	/*
	glEnableClientState(GL_VERTEX_ARRAY);
	
	static GLfloat squareVertices[8];
	squareVertices[0] = squareVertices[4] = position_.x - anchorPoint_.x*rect_.size.width + rect_.origin.x;
	squareVertices[1] = squareVertices[3] = position_.y - anchorPoint_.y*rect_.size.height +rect_.origin.y;
	squareVertices[2] = squareVertices[6] = squareVertices[0] + rect_.origin.x + rect_.size.width;
	squareVertices[5] = squareVertices[7] = squareVertices[1] + rect_.origin.y + rect_.size.height;
	
	glColor4ub(color_.r, color_.g, color_.b, 255);
	
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glColor4ub(255, 255, 255, 255);
	
	glDisableClientState(GL_VERTEX_ARRAY);
	
	*/
	
	glColor4ub(color_.r, color_.g, color_.b, 255);
	CGPoint vertices[] = {
		ccp(position_.x - rect_.size.width/2, position_.y - rect_.size.height/2),
		ccp(position_.x + rect_.size.width/2, position_.y - rect_.size.height/2),
		ccp(position_.x + rect_.size.width/2, position_.y + rect_.size.height/2),
		ccp(position_.x - rect_.size.width/2, position_.y + rect_.size.height/2)
	};
	drawPoly(vertices, 4, YES);
}
@end
