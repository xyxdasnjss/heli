//
//  Enemy.h
//  Heli
//
//  Created by vy phan on 09/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtlasSprite.h"
#import "AtlasSpriteManager.h"
#import "cocos2d.h"
#import "CocosNode.h"
#import "MyDefine.h"

@interface Enemy : Sprite {
	// ID cua con enemy
	int enemyType;
	// Toc do cua con enemy
	int enemySpeed;
	// Do ben, so lan ban moi chet
	int hp;
	
	NSMutableArray* enemyBullets;
	
}
-(id)initEnemyID:(int)enemyID_ Speed:(int)enemySpeed_ HP:(int)hp_ ImagePath:(NSString*)image_;
+(id)EmemyWithID:(int)enemyID_ Speed:(int)enemySpeed_ HP:(int)hp_ ImagePath:(NSString*)image_;


-(id)initEnemyID:(int)enemyID_ Speed:(int)enemySpeed_ HP:(int)hp_ SpriteManager:(AtlasSpriteManager*)manager_;
+(id)EmemyWithID:(int)enemyID_ Speed:(int)enemySpeed_ HP:(int)hp_ SpriteManager:(AtlasSpriteManager*)manager_;

-(Enemy*)EnemyWithType:(int)type_;
-(void)animatedEnemy:(Enemy*)enemy_;

@property (readwrite) int enemyType;
@property (readwrite) int enemySpeed;
@property (readwrite) int hp;

//@property (nonatomic ,readwrite) AtlasSprite* enemyAtlasSprite;
@end
