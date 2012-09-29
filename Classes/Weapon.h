//
//  Weapon.h
//  Heli
//
//  Created by vy phan on 19/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "MyDefine.h"
#import "cocos2d.h"

@interface Weapon : Sprite {
	// Loai vu khi
	int weapon_type;
	// Muc do sat thuong cua vu khi
	int weapon_damage;
	// So luong dan max
	int weapon_maxAmmu;
	// So luong dan con
	int weapon_ammu;
}
-(Weapon*)WeaponWithType:(int)type_;
-(void)animatedWeapon:(Weapon*)weapon_ FileName:(NSString*)fileName_;
@property (readwrite) int weapon_type;
@property (readwrite) int weapon_damage;
@property (readwrite) int weapon_maxAmmu;
@property (readwrite) int weapon_ammu;
@end
