//
//  Weapon.m
//  Heli
//
//  Created by vy phan on 19/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"


@implementation Weapon
@synthesize weapon_type;
@synthesize weapon_damage;
@synthesize weapon_maxAmmu;
-(Weapon*)WeaponWithType:(int)type_{
	Weapon *weapon = nil;
	switch (type_) {
		case WEAPON_NORMAL_BULLET:
			weapon = [[Weapon alloc] initWithFile:@"bullet1.png"];
			weapon.weapon_type = WEAPON_NORMAL_BULLET;
			weapon.weapon_damage = 1;
			break;
		case WEAPON_BOMB:
			weapon = [[Weapon alloc] initWithFile:@"bomb.png"];
			weapon.weapon_type = WEAPON_BOMB;
			weapon.weapon_damage = 2;
			break;
		case WEAPON_MISSILE_1:
			weapon = [[Weapon alloc] initWithFile:@"M1_1.png"];
			weapon.weapon_type = WEAPON_MISSILE_1;
			weapon.weapon_damage = 5;
			[self animatedWeapon:weapon FileName:@"M1_"];
			break;
		case WEAPON_MISSILE_2:
			weapon = [[Weapon alloc] initWithFile:@"M2_1.png"];
			weapon.weapon_type = WEAPON_MISSILE_2;
			weapon.weapon_damage = 5;
			[self animatedWeapon:weapon FileName:@"M2_"];
			break;
			
		case WEAPON_MISSILE_3:
			weapon = [[Weapon alloc] initWithFile:@"M3_1.png"];
			weapon.weapon_type = WEAPON_MISSILE_3;
			weapon.weapon_damage = 5;
			[self animatedWeapon:weapon FileName:@"M3_"];
			break;
		default:
			break;
	}
	return weapon;
}
-(void)animatedWeapon:(Weapon*)weapon_ FileName:(NSString*)fileName_{
	Animation* missAni = [Animation animationWithName:@"missAni" delay:0.001];
	for (int i=1; i<=3; i++)
		[missAni addFrameWithFilename:[NSString stringWithFormat:@"%@%d.png", fileName_, i]];
	[weapon_ runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:missAni]]];
}

-(void)moveWeapon:(Sprite*)sprite_ DestPosition:(CGPoint)dpoint_ Duration:(float)duration_{
	id actionMoveDone = [CallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[sprite_ runAction:[Sequence actionOne:[MoveTo actionWithDuration:duration_ position:dpoint_] two:actionMoveDone]];
}

@end
