//
//  Item.m
//  Heli
//
//  Created by vy phan on 26/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Item.h"


@implementation Item
@synthesize type;
@synthesize hp;
@synthesize	missileAmount;
@synthesize	bombAmount;
-(Item*)ItemWithType:(int)type_{
	Item* item = nil;
	switch (type_) {
		case ITEM_HP:
			item = [[Item alloc]initWithFile:@"firstaid.png"];
			item.hp = 20;
			item.type = ITEM_HP;
			item.bombAmount = 0;
			item.missileAmount = 0;
			break;
		case ITEM_BOMB:
			item = [[Item alloc]initWithFile:@"B1.gif"];
			item.hp = 0;
			item.type = ITEM_BOMB;
			item.bombAmount = 20;
			item.missileAmount = 0;
			break;
		case ITEM_MISSILE:
			item = [[Item alloc]initWithFile:@"R.png"];
			item.hp = 0;
			item.type = ITEM_MISSILE;
			item.bombAmount = 0;
			item.missileAmount = 20;
			break;
		case ITEM_SUPER:
			item = [[Item alloc]initWithFile:@"S.png"];
			item.hp = 0;
			item.type = ITEM_SUPER;
			item.bombAmount = 20;
			item.missileAmount = 20;
			break;
		default:
			break;
	}
	return item;
}
@end
