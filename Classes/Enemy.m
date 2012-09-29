//
//  Enemy.m
//  Heli
//
//  Created by vy phan on 09/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "Weapon.h"
#import "CubicBezier.h"
#import "CubicBezierBy.h"
#import "CGPointExtension.h"


@implementation Enemy

@synthesize enemyType;
@synthesize enemySpeed;
@synthesize hp;


+(id)EmemyWithID:(int)enemyID_ Speed:(int)enemySpeed_ HP:(int)hp_ ImagePath:(NSString*)image_{
	return [[[self alloc] initEnemyID:enemyID_ Speed:enemySpeed_ HP:hp_ ImagePath:image_] autorelease];
}
-(id)initEnemyID:(int)enemyID_ Speed:(int)enemySpeed_ HP:(int)hp_ ImagePath:(NSString*)image_{
	self = [super initWithFile:image_];
	if (self != nil) {
		enemyType = enemyID_;
		enemySpeed = enemySpeed_;
		hp = hp_;
		//enemyManager = [[[AtlasSpriteManager alloc] initWithFile:image_ capacity:1] autorelease];
		
	}
	return self;
}
-(Enemy*)EnemyWithType:(int)type_{
	Enemy* enemy = nil;
	switch (type_) {
		case ENEMY_HELI:
			enemy = [[Enemy alloc] initWithFile:@"enemy_hc1.png"];
			enemy.enemyType = ENEMY_HELI;
			enemy.enemySpeed = 5;
			enemy.hp = 20;
			[self animatedEnemy:enemy];
			break;
		case ENEMY_HELI_2:
			enemy = [[Enemy alloc] initWithFile:@"e_air_3_1.png"];
			enemy.enemyType = ENEMY_HELI_2;
			enemy.enemySpeed = 5;
			enemy.hp = 20;
			//[self animatedEnemy:enemy];
			break;
		case ENEMY_HELI_3:
			enemy = [[Enemy alloc] initWithFile:@"enemy_aircraft1.png"];
			enemy.enemyType = ENEMY_HELI_3;
			enemy.enemySpeed = 5;
			enemy.hp = 20;
			[self animatedEnemy:enemy];
			break;
		case ENEMY_BOSS:
			enemy = [[Enemy alloc] initWithFile:@"enemy_boss1.png"];
			enemy.enemyType = ENEMY_BOSS;
			enemy.enemySpeed = 2;
			enemy.hp = 100;
			[self animatedEnemy:enemy];
			break;

		default:
			break;
	}
	return enemy;
}
-(void)animatedEnemy:(Enemy*)enemy_{
	
	if(enemy_.enemyType == ENEMY_HELI){
		Animation* enemyAnimation = [Animation animationWithName:@"heliEnemy" delay:0.001];
		for (int i=1; i<=2; i++)
			[enemyAnimation addFrameWithFilename:[NSString stringWithFormat:@"enemy_hc%d.png", i]];
		[enemy_ runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:enemyAnimation]]];
	}
	
	if(enemy_.enemyType == ENEMY_HELI_2){
		Animation* enemyAnimation = [Animation animationWithName:@"heliEnemy" delay:0.001];
		for (int i=1; i<=2; i++)
			[enemyAnimation addFrameWithFilename:[NSString stringWithFormat:@"e_air_3_%d.png", i]];
		[enemy_ runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:enemyAnimation]]];
	}
	
	if(enemy_.enemyType == ENEMY_HELI_3){
		Animation* enemyAnimation = [Animation animationWithName:@"heliEnemy" delay:0.001];
		for (int i=1; i<=2; i++)
			[enemyAnimation addFrameWithFilename:[NSString stringWithFormat:@"enemy_aircraft%d.png", i]];
		[enemy_ runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:enemyAnimation]]];
	}
	
	if(enemy_.enemyType == ENEMY_BOSS){
		Animation* enemyAnimation = [Animation animationWithName:@"heliEnemy" delay:0.001];
		for (int i=1; i<=2; i++)
			[enemyAnimation addFrameWithFilename:[NSString stringWithFormat:@"enemy_boss%d.png", i]];
		enemy_.position = ccp(400, 320/2);
		[enemy_ runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:enemyAnimation]]];
	}
}

-(Weapon*)attach:(int)weaponType_ {	
	Weapon* weapon = nil;
	switch (weaponType_) {
			
		case WEAPON_NORMAL_BULLET:
			weapon = [[Weapon alloc]WeaponWithType:WEAPON_NORMAL_BULLET];
			weapon.rotation = 90;
			weapon.position = ccp(self.position.x-self.contentSize.width/2, self.position.y);
			break;
			
		default:
			break;
	}
	return weapon;
}

@end
