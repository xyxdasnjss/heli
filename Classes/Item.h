//
//  Item.h
//  Heli
//
//  Created by vy phan on 26/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "MyDefine.h"

@interface Item : Sprite {
	int type;
	int hp;
	int	missileAmount;
	int	bombAmount;
}
-(Item*)ItemWithType:(int)type_;

@property (readwrite) int type;
@property (readwrite) int hp;
@property (readwrite) int missileAmount;
@property (readwrite) int bombAmount;
@end
