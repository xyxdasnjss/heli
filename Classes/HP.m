//
//  HP.m
//  Heli
//
//  Created by vy phan on 30/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HP.h"


@implementation HP

-(id)init{
	self = [super init];
	if (self != nil) {
		bgTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"bars.png"] Rect:CGRectMake(0, 0, 128, 10)];
		barTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"bars.png"] Rect:CGRectMake(0, 0, 128, 10)];
		//[self setContentSize:CGSizeMake(bgTexture.contentSize.width*2, bgTexture.contentSize.height*2) ];
		[self setContentSize:bgTexture.contentSize];
		
	}
	return self;
}

-(void)setValue:(float)value {
	[barTexture release];
	
	//bgTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"bars.png"] Rect:CGRectMake(0, 0, value*128, 10)];
	
	if (value <= 0.3) {
		barTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"bars.png"] Rect:CGRectMake(0, 20, value*128, 10)];
	}
	else {
		barTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"bars.png"] Rect:CGRectMake(0, 10, value*128, 10)];
	}

	
}

- (void) draw
{
	glEnableClientState( GL_VERTEX_ARRAY);
	glEnableClientState( GL_TEXTURE_COORD_ARRAY );
	glEnable( GL_TEXTURE_2D);
	
	
	//[barTexture drawAtPoint: CGPointZero];
	
	[bgTexture drawInRect:CGRectMake(0, 0, bgTexture.contentSize.width, contentSize_.height*1.5)];
	
	[barTexture drawInRect:CGRectMake(0, 0, barTexture.contentSize.width, contentSize_.height*1.5)];
	
	glDisable( GL_TEXTURE_2D);
	glDisableClientState(GL_VERTEX_ARRAY );
	glDisableClientState( GL_TEXTURE_COORD_ARRAY );
}

- (void)dealloc {
	[bgTexture release];
	bgTexture = nil;
	
	[barTexture release];
	barTexture = nil;
	[super dealloc];
}

@end
