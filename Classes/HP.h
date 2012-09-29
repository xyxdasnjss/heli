//
//  HP.h
//  Heli
//
//  Created by vy phan on 30/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CocosNode.h"

@interface HP : CocosNode {
	Texture2D* bgTexture;
	Texture2D* barTexture;
}

-(void)setValue:(float)value;
@end
