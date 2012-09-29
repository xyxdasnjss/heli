//
//  TestLayer.h
//  Heli
//
//  Created by vy phan on 02/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Layer.h"
#import "Sprite.h"
#import "AtlasSpriteManager.h"
#import "AtlasSprite.h"
#import "ButtonX.h"
#import "TouchDispatcher.h"
#import "CusSprite.h"
#import "Enemy.h"
#import "CubicBezier.h"
#import "CubicBezierBy.h"
#import "MyDefine.h"
#import "Weapon.h"
#import "Character.h"
#import "GameOverScene.h"
#import "HP.h"

@interface TestLayer : ColorLayer {
	// Helicopter
	AtlasSpriteManager* heliManager;
	//Sprite* heliSprite;
	Character* heliSprite;
	Animation* heliAnimation;
	// Tank
	AtlasSpriteManager* tankManager;
	CusSprite* tankAtlasSprite;
	Sprite* tankSprite;
	AtlasAnimation* tankAnimation;
	NSMutableArray* tanksArray;
	
	
	
	// Enemies
	//Enemy* tankEnemy1;
	//Enemy* bossEnemy;
	//Enemy* heliEnemy;
	NSMutableArray* enemiesArray;
	NSMutableArray* enemyBullets;
	
	AtlasSpriteManager* transformManager;
	
	
	
	// Joystick
	Sprite* joypad;
	Sprite* joycap;
	int joypadTouchHash;
	//ButtonX* redBut;
	BOOL joyStickMoving;
	float joypadCenterx, joypadCentery, distance, touchAngle;
	// Bullet
	AtlasSpriteManager *bulletManager;
	//CusSprite *bulletAtlasSprite;
	NSMutableArray* bulletsArray;
	// Bomb
	Sprite* bombSprite;
	NSMutableArray* bombArray;
	
	
	// Exp
	AtlasSpriteManager *expManager;
	//AtlasSprite *expSprite;
	AtlasAnimation *expAnimation;
	// Terrain
	// Background
	Sprite *background;
	// Road
	NSMutableArray *roads;
	// Tree
	NSMutableArray *trees;
	// Mountain
	NSMutableArray *mountains;
	NSMutableArray *farMountains;
	// Cloud
	NSMutableArray *clouds;
	// Grass
	NSMutableArray *grass;
	
	// HP Bar
	HP *hpBar;
	
	// Point
	int heliScore;
	
	NSMutableArray *itemArray;
	
}
-(NSMutableArray*)initObjectArray:(NSMutableArray*)objectArray withBG:(NSString*)fileName withX:(int)x withY:(int)y;
-(void)moveWithObject:(NSMutableArray*)objectArray withSpeed:(int)speed;
-(void)moveBullet:(Sprite*)sprite_ DestPosition:(CGPoint)dpoint_ Duration:(float)duration_;
-(void)explodeAtPosition:(CGPoint)position_;
@end
