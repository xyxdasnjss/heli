//
//  TestLayer.m
//  Heli
//
//  Created by vy phan on 02/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestLayer.h"
#import "cocos2d.h"
#import "CGPointExtension.h"
#import "CusSprite.h"
#import "Rectange.h"
#import "Menu.h"
#import "MenuItem.h"
#import "Enemy.h"
#import "Character.h"
#import "Label.h"
#import "Item.h"
#import "DrawingPrimitives.h"
#import "TestDraw.h"

@implementation TestLayer
Menu* actionMenu;
MenuItem* menuItem1;
CGPoint heliPos;
int curWeapon = 0;
int curTranform = 0;
float waitingTime = 0.0f;
float enemyAppearTime = 0.0f;
// Status Label
Label* scoreLabel;
Label* missileLabel;
Label* missileValue;
Label* bombLabel;
Label* bombValue;
Label* rankLabel;
//Label* 

-(id)init{
	heliScore = 0;
	joypadTouchHash = 0;
	int preX = 240;
	joyStickMoving = FALSE;
	
	tanksArray = [[NSMutableArray alloc]init];
	bulletsArray = [[NSMutableArray alloc]init];
	enemiesArray = [[NSMutableArray alloc]init];
	enemyBullets = [[NSMutableArray alloc]init];
	itemArray = [[NSMutableArray alloc]init];
	
	CGSize winSize = [[Director sharedDirector] winSize];
	
	self = [super initWithColor:ccc4(255, 255, 255, 255)];
	if(self != nil){
		
		isTouchEnabled = TRUE;
		// Load background
		background = [Sprite spriteWithFile:@"bg.png"];
		background.position = ccp(preX, 320/2);
		
		// Load cloud
		clouds = [self initObjectArray:clouds withBG:@"bg3 " withX:preX withY:320-205/2];
		// Load mountain
		mountains = [self initObjectArray:mountains withBG:@"bg2 " withX:preX withY:0+150];
		farMountains = [self initObjectArray:farMountains withBG:@"bg nui " withX:preX withY:0+175];
		// Load tree
		trees = [self initObjectArray:trees withBG:@"bg1 " withX:preX withY:0+150];
		// Load road
		roads = [self initObjectArray:roads withBG:@"bg dat " withX:preX withY:0+50];
		// Load grass
		grass = [self initObjectArray:grass withBG:@"book " withX:preX withY:0+45];
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		// Test thay doi character
		// Helicpoter animation
		/*
		heliAnimation = [Animation animationWithName:@"heli" delay:0.001];
		for (int i=1; i<=5; i++)
			[heliAnimation addFrameWithFilename:[NSString stringWithFormat:@"truc thang %d.png", i]];
		
		
		
		heliSprite = [Sprite spriteWithFile:@"truc thang 1.png"];
		heliSprite.position = ccp(winSize.width/2, winSize.height/2);
		[heliSprite runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:heliAnimation]]];
		 */
		heliSprite = [[Character alloc]CharacterWithType:CHARACTER_1];
		heliSprite.position = ccp(winSize.width/2, winSize.height/2);
		////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		// Boss animation
		Enemy *bossEnemy = [[Enemy alloc]EnemyWithType:ENEMY_BOSS];
		bossEnemy.position = ccp(480 - bossEnemy.contentSize.width/2, 160);
		[self addChild:bossEnemy z:7];
		[bossEnemy runAction:[RepeatForever actionWithAction:[Sequence actionOne:[MoveTo actionWithDuration:5 position:ccp(bossEnemy.position.x, 0+bossEnemy.contentSize.height/2)] two:[MoveTo actionWithDuration:5 position:ccp(bossEnemy.position.x, 320-bossEnemy.contentSize.height/2)]]]];
		
		[bossEnemy runAction:[RepeatForever actionWithAction:[Sequence actionOne:[DelayTime actionWithDuration:0.2f] two:[CallFuncN actionWithTarget:self selector:@selector(addEnemyBullet:)]]]];
		
		[enemiesArray addObject:bossEnemy];
		
		transformManager = [AtlasSpriteManager spriteManagerWithFile:@"trans_eff.png"];
		
		bulletManager = [[AtlasSpriteManager alloc] initWithFile:@"bullets.png" capacity:1];
		tankManager = [[AtlasSpriteManager alloc] initWithFile:@"13.png" capacity:1];
		
		// Bomb
		
		
		expManager = [[AtlasSpriteManager alloc] initWithFile:@"ep2.png" capacity:1];
		
		
		joypad = [Sprite spriteWithFile:@"icon 1.png"];
		joycap = [Sprite spriteWithFile:@"joypadCap.png"];
		
		
		joypad.position = ccp(0+joypad.contentSize.width/2, 0+joypad.contentSize.height/2);
		joycap.position = ccp(joypad.position.x, joypad.position.y);
		
		
		joypadCenterx = joypad.position.x;
		joypadCentery = joypad.position.y;
		distance = touchAngle = 0.0f;
		
		
		menuItem1 = [MenuItemFont itemFromString:@"Transform" target:self selector:@selector(transform:)];
		menuItem1.position = ccp(480-menuItem1.contentSize.width/2, 0+menuItem1.contentSize.height/2);
		
		MenuItem *menuItem2 = [MenuItemFont itemFromString:@"Weapon" target:self selector:@selector(changeWeapon:)];
		menuItem2.position = ccp(480-menuItem1.contentSize.width - menuItem2.contentSize.width/2, 0+menuItem1.contentSize.height- menuItem2.contentSize.height/2);
		
		MenuItem *menuItem3 = [MenuItemFont itemFromString:@"ResetHP" target:self selector:@selector(setHP:)];
		menuItem3.position = ccp(menuItem2.position.x - menuItem3.contentSize.width, menuItem2.position.y);
		
		actionMenu = [Menu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
		actionMenu.position = CGPointZero;
		
		[self addChild:actionMenu z:10];
		
		// Status Label
		scoreLabel = [[Label alloc]initWithString:@"Kill: 000000000" fontName:@"Arial" fontSize:15];
		scoreLabel.position = ccp(10 + scoreLabel.contentSize.width/2, winSize.height - 10);
		[self addChild:scoreLabel z:10];
		
		bombLabel = [[Label alloc]initWithString:@"Bomb" fontName:@"Arial" fontSize:15];
		bombLabel.position = ccp(200, scoreLabel.position.y);
		[self addChild:bombLabel z:10];
		
		bombValue = [[Label alloc]initWithString:@"0000" fontName:@"Arial" fontSize:15];
		bombValue.position = ccp(bombLabel.position.x, bombLabel.position.y - bombLabel.contentSize.height);
		[self addChild:bombValue z:10];
		
		missileLabel = [[Label alloc]initWithString:@"Missile" fontName:@"Arial" fontSize:15];
		missileLabel.position = ccp(bombLabel.position.x + bombLabel.contentSize.width +20, scoreLabel.position.y);
		[self addChild:missileLabel z:10];
		
		missileValue = [[Label alloc]initWithString:@"0000" fontName:@"Arial" fontSize:15];
		missileValue.position = ccp(missileLabel.position.x, missileLabel.position.y - missileLabel.contentSize.height);
		[self addChild:missileValue z:10];
		
		//CGPoint polyPoints[] = {
		//	ccp(scoreLabel.position.x - scoreLabel.contentSize.width/2 - 2, scoreLabel.position.y + scoreLabel.contentSize.height/2 + 2), 
		//	ccp(scoreLabel.position.x + scoreLabel.contentSize.width/2 + 2, scoreLabel.position.y + scoreLabel.contentSize.height/2 + 2),
		//	ccp(scoreLabel.position.x - scoreLabel.contentSize.width/2 - 2, scoreLabel.position.y + scoreLabel.contentSize.height/2 + 2),
		//	ccp(scoreLabel.position.x - scoreLabel.contentSize.width/2 - 2, scoreLabel.position.y - scoreLabel.contentSize.height/2 - 2)
		//};
		/*
		CGPoint polyPoints[] = {
			ccp(100, 200), 
			ccp(300, 200),
			ccp(300, 100),
			ccp(100, 100)
		};
		drawPoly(polyPoints, 4, YES);
		*/
		//CGPoint vertices[] = { ccp(0,0), ccp(50,50), ccp(100,50), ccp(100,100), ccp(50,100) };
		
		int rectWidth = (missileLabel.position.x + missileLabel.contentSize.width/2 + 1)-(bombLabel.position.x - bombLabel.contentSize.width/2 - 1);
		int rectHeight = (missileLabel.position.y + missileLabel.contentSize.height/2 + 1)-(missileValue.position.y - missileValue.contentSize.width/2 - 1);
		
		Rectange* r = [[Rectange alloc]initRect:CGRectMake(0, 0, rectWidth, rectHeight) Color:ccc3(255, 0, 255)];
		//printf("missileValue posx %d posy %d\n", (int)missileValue.position.x, (int)missileValue.position.y);
		//r.anchorPoint = ccp(0,0);
		r.position = ccp((bombLabel.position.x+missileValue.position.x)/4, (bombLabel.position.y + bombValue.position.y)/4 - 3);
		//r.position = ccp(winSize.width/2, winSize.height/2);
		//[self addChild:r z:11];
		
		//TestDraw* td = [[TestDraw alloc]init];
		//CGPoint vertices[] = { ccp(0,0), ccp(50,50), ccp(100,50), ccp(100,100), ccp(50,100) };
		//TestDraw*td = [[TestDraw alloc]initVertices:vertices Color:ccc3(255, 255, 0)];
		//td.position = ccp(100, 200);
		//[self addChild:td z:10];
		
		// HP bar
		hpBar = [[HP alloc] init];
		[hpBar setValue:1.0f];
		[hpBar draw];
		hpBar.position = ccp(10, scoreLabel.position.y - scoreLabel.contentSize.height - 5);//ccp(hpBar.contentSize.width/2, 320 - hpBar.contentSize.height/2);
		[self addChild:hpBar z:10];
		// 
		[self addChild:background z:0];
		
		for(Sprite *c in clouds){
			[self addChild:c z:1];
		}
		for(Sprite *fm in farMountains){
			[self addChild:fm z:2];
		}
		for(Sprite *m in mountains){
			[self addChild:m z:3];
		}
		
		for(Sprite *t in trees){
			[self addChild:t z:4];
		}
		
		for(Sprite *r in roads){
			[self addChild:r z:5];
		}
		
		[self addChild:heliSprite z:6];
		
		
		for(Sprite *g in grass){
			[self addChild:g z:7];
		}
		
		[self addChild:joypad z:8];
		[self addChild:joycap z:9];
		
		// Add enemy
		[self schedule:@selector(addSprite:) interval:0.5];
		// Add bullet
		[self schedule:@selector(addBullet:) interval:0.1f];
		// Add missile
		[self schedule:@selector(addWeapon:) interval:0.5f];
		// Add bomb
		[self schedule:@selector(addBomb:) interval:0.5f];
		
		
		[self addChild:bulletManager z:6];
		
		[self addChild:expManager z:6];
		
		[self addChild:transformManager z:6];
		[self schedule:@selector(setHeliPosition:) interval:1.0/60];
		[self schedule:@selector(update:) interval:1.0/60];
		
		[self schedule:@selector(collision:) interval:1.0/60];
	}
	return self;
}
-(void)setHP:(id)sender{
	heliSprite.character_hp = heliSprite.character_max_hp;
	//[label setString:[NSString stringWithFormat:@"HP:%d", heliSprite.character_hp]];
}
-(void)addWeapon:(ccTime)dt{
	//printf("\nMissile %d\n", heliSprite.missileAmount);
	if(heliSprite.missileAmount > 0){
	Weapon *missile = nil;
	if (curWeapon == 0) {
		missile = [[Weapon alloc]WeaponWithType:WEAPON_MISSILE_1];
	}
	if (curWeapon == 1) {
		missile = [[Weapon alloc]WeaponWithType:WEAPON_MISSILE_2];
	}
	if (curWeapon == 2) {
		missile = [[Weapon alloc]WeaponWithType:WEAPON_MISSILE_3];
	}
	missile.rotation = 180;
	missile.position = ccp(heliSprite.position.x, heliSprite.position.y);
	[self addChild:missile z:6];
	[self moveBullet:missile DestPosition:ccp(480+missile.contentSize.width/2, missile.position.y) Duration:(480 - heliSprite.position.x) / (480+missile.contentSize.width/2) * 2.0f];
	[bulletsArray addObject:missile];
		heliSprite.missileAmount--;
	}
}
-(void)changeWeapon:(id)sender{
	curWeapon++;
	if (curWeapon > 2) {
		curWeapon = 0;
	}
}
-(void)collision:(ccTime)dt{
	///////////////////////////////////////////////////////////////////////////////////////////////////
	NSMutableArray *bulletsToDelete = [[NSMutableArray alloc] init];
	for (Weapon* bas in bulletsArray) {
		CGRect bulletRect = CGRectMake(bas.position.x - (bas.contentSize.width/2), 
									   bas.position.y - (bas.contentSize.height/2), 
									   bas.contentSize.width, 
									   bas.contentSize.height);
		
		Enemy* e = nil;
			
			for (Enemy* tas in enemiesArray) {
				CGRect tankRect = CGRectMake(tas.position.x - (tas.contentSize.width/2), 
											 tas.position.y - (tas.contentSize.height/2), 
											 tas.contentSize.width, 
											 tas.contentSize.height);
				
				if (CGRectIntersectsRect(bulletRect, tankRect)) {
					e = tas;
					break;
				}
			}
		
		if(e != nil){
			// Mau giam di
			e.hp-= bas.weapon_damage;
			// het mau thi chet
			if (e.hp <= 0) {
				[enemiesArray removeObject:e];
				[self removeChild:e cleanup:YES];
				[self explodeAtPosition:e.position];
				heliScore++;
			}
			[bulletsToDelete addObject:bas];
		}
	}
	// Enemy ban
	NSMutableArray* enemyBulletDelete = [[NSMutableArray alloc] init];
	CGRect heliRect = CGRectMake(heliSprite.position.x - (heliSprite.contentSize.width/2), 
								 heliSprite.position.y - (heliSprite.contentSize.height/2), 
								 heliSprite.contentSize.width, 
								 heliSprite.contentSize.height);
	
	
	for(Weapon* eBullet in enemyBullets){
		
		CGRect ebulletRect = CGRectMake(eBullet.position.x - (eBullet.contentSize.width/2), 
									   eBullet.position.y - (eBullet.contentSize.height/2), 
									   eBullet.contentSize.width, 
									   eBullet.contentSize.height);
	
		// Cach 2: chay OK
		if (CGRectIntersectsRect(ebulletRect, heliRect)) {
			[enemyBulletDelete addObject:eBullet];
			
			
			if(heliSprite.character_hp >=0){
				heliSprite.character_hp -= eBullet.weapon_damage;
				
				//[hpBar setValue:(float)((float)heliSprite.character_hp / (float)heliSprite.character_max_hp)];
				if (heliSprite.character_hp <= 0) {
					[self removeChild:heliSprite cleanup:YES];
					[self unschedule:@selector(collision:)];
					[self explodeAtPosition:heliSprite.position];
					[self schedule:@selector(incWaitingTime:) interval:0.5f];
				}
				break;
			}
		}
		 
	}
	
	for (Weapon* enemyBullet in enemyBulletDelete)
	{
		[enemyBullets removeObject:enemyBullet];
		[self removeChild:enemyBullet cleanup:YES];
	}
	for (Weapon* bas in bulletsToDelete){
		[bulletsArray removeObject:bas];
		[self removeChild:bas cleanup:YES];
	}
	
	[enemyBulletDelete release];
	[bulletsToDelete release];

	// Pickup item
	NSMutableArray* itemToDelete = [[NSMutableArray alloc]init];
	for (Item* item in itemArray) {
		CGRect itemRect = CGRectMake(item.position.x - (item.contentSize.width/2), 
									   item.position.y - (item.contentSize.height/2), 
									   item.contentSize.width, 
									   item.contentSize.height);
		if (CGRectIntersectsRect(heliRect, itemRect)) {
			if (heliSprite.character_hp < heliSprite.character_max_hp) {
				heliSprite.character_hp += item.hp;
			}
			else {
				heliSprite.character_hp = heliSprite.character_max_hp;
			}
			heliSprite.bombAmount += item.bombAmount;
			heliSprite.missileAmount += item.missileAmount;
			/*
			if (heliSprite.bombAmount < heliSprite.max_bombAmount) {
				heliSprite.bombAmount += item.bombAmount;
			}
			else {
				heliSprite.bombAmount = heliSprite.max_bombAmount;
			}
			
			if (heliSprite.missileAmount < heliSprite.max_missileAmount) {
				heliSprite.missileAmount += item.missileAmount;
			}
			else {
				heliSprite.missileAmount = heliSprite.max_missileAmount;
			}
			*/
			[itemToDelete addObject:item];
			break;
		}
	}
	for(Item* item in itemToDelete){
		[itemToDelete removeObject:item];
		[itemArray removeObject:item];
		[self removeChild:item cleanup:YES];
	}
	[itemToDelete release];
	// Va cham voi vat the khac
}
-(void)incWaitingTime:(ccTime)dt{
	waitingTime+=dt;
	if (waitingTime >= 1) {
		[[Director sharedDirector] replaceScene:[[GameOverScene alloc]init]];
	}
}
-(void)update:(ccTime)dt {
	// Move cloud
	[self moveWithObject:clouds withSpeed:1];
	// Move mountain
	[self moveWithObject:mountains withSpeed:2];
	[self moveWithObject:farMountains withSpeed:2];
	// Move tree
	[self moveWithObject:trees withSpeed:6];
	// Move road
	[self moveWithObject:roads withSpeed:8];
	// Move grass
	[self moveWithObject:grass withSpeed:8];
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	[scoreLabel setString:[NSString	stringWithFormat:@"Kill: %09d", heliScore]];
	[hpBar setValue:(float)heliSprite.character_hp / (float)heliSprite.character_max_hp];
	[bombValue setString:[NSString stringWithFormat:@"%04d", heliSprite.bombAmount]];
	[missileValue setString:[NSString stringWithFormat:@"%04d", heliSprite.missileAmount]];
}
//////////////////////////////////////////////////////////
// Tranform
-(void)transform:(id)sender{
	
	//[heliSprite setVisible:FALSE];
	////////
	heliPos = heliSprite.position;
	//[self unschedule:@selector(addBullet:)];
	[self removeChild:heliSprite cleanup:NO];
	AtlasSprite* transformSprite = [AtlasSprite spriteWithRect:CGRectMake(0, 0, 117/2, 32) spriteManager:transformManager];
	
	AtlasAnimation* transformAnimation = [AtlasAnimation animationWithName:@"transform" delay:0.1];
	for (int i=0; i<4; i++)
		[transformAnimation addFrameWithRect:CGRectMake(468-i*117, 0, 117, 32)];
	transformSprite.position = ccp(heliSprite.position.x, heliSprite.position.y);
	transformSprite.scaleX = 2;
	transformSprite.scaleY = 4;
	[transformManager addChild:transformSprite];
	
	[transformSprite runAction:[Sequence actions:
								[Animate actionWithAnimation:transformAnimation], 
								[CallFuncN actionWithTarget:self selector:@selector(removeTransform:)], 
								[CallFuncN actionWithTarget:self selector:@selector(addTest:)],
								nil]];
}
-(void)addTest:(id)sender{
	heliAnimation = [Animation animationWithName:@"heli" delay:0.001];
	for (int i=1; i<=2; i++)
		[heliAnimation addFrameWithFilename:[NSString stringWithFormat:@"enemy_hc%d.png", i]];
	
	
	
	heliSprite = [Sprite spriteWithFile:@"enemy_hc1.png"];
	heliSprite.position = ccp(480/2, 320/2);
	heliSprite.scaleX = -1;
	[heliSprite runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:heliAnimation]]];
	
	[self addChild:heliSprite];
	
}
-(void)removeTransform:(id)sender{
	[transformManager removeChild:sender cleanup:YES];
}
//////////////////////////////////////////////////////////
// Explode
-(void)removeExplodeAction:(id)sender{
	[expManager removeChild:sender cleanup:YES];
}
-(void)explodeAtPosition:(CGPoint)pos{
	// Exp
	
	AtlasSprite* expSprite  = [[[AtlasSprite alloc] initWithRect:CGRectMake(0, 0, 80, 119) spriteManager:expManager] autorelease];
	
	expSprite.position = pos;
	
	//[tankManager addChild:tankAtlasSprite z:0];
	
	expAnimation = [AtlasAnimation animationWithName:@"exp" delay:0.07];
	//[AAnimation animationWithName:@"tank" delay:1.0/60];
	
	for(int row = 0; row < 3; row++)
		for (int col = 0; col < 3; col++)
		{
			[expAnimation addFrameWithRect:CGRectMake(col*80, row*119, 80, 119)];
			
		}
	
	//[expSprite runAction:[Sequence actionOne:[Animate actionWithAnimation:expAnimation] two:[CallFuncN actionWithTarget:self selector:@selector(removeExplodeAction:)]]];
	[expSprite runAction:[Sequence actions:[Animate actionWithAnimation:expAnimation], [CallFuncN actionWithTarget:self selector:@selector(addItem:)], [CallFuncN actionWithTarget:self selector:@selector(removeExplodeAction:)], nil]];
	[expManager addChild:expSprite z:0 tag:0];
	//[expManager add]
}
//////////////////////////////////////////////////////////
-(void)addItem:(id)sender{
	int tmpArray[] = {ITEM_HP, ITEM_BOMB, ITEM_MISSILE, ITEM_SUPER};
	int choose = arc4random()%4;
	Item* item = [[[Item alloc] ItemWithType:tmpArray[choose]] autorelease];
	item.position = [expManager getChildByTag:0].position;
	[self addChild:item z:6];
	[itemArray addObject:item];
	[self moveBullet:item DestPosition:ccp(item.position.x, 0 - item.contentSize.height/2) Duration:3.0f];
}
-(void)addBomb:(ccTime)dt{
	//printf("\nbomb %d\n", heliSprite.bombAmount);
	if(heliSprite.bombAmount > 0){
		CGPoint origin, control1, control2, destination;
		Weapon* bombWP = [[Weapon alloc]WeaponWithType:WEAPON_BOMB];
		bombWP.position = ccp(heliSprite.position.x, heliSprite.position.y);
		[self addChild:bombWP z:6];
		CubicBezier *cubic = [CubicBezier cubicBezierWithOrigin:ccp(heliSprite.position.x, heliSprite.position.y) control1:ccp(heliSprite.position.x-20, heliSprite.position.y-100) control2:ccp(heliSprite.position.x-50, 0 - heliSprite.contentSize.height/2) destination:ccp(heliSprite.position.x-150, 0 - heliSprite.contentSize.height/2) segments:100 color:ccc3(255, 255, 255)];
		[cubic origin:&origin control1:&control1 control2:&control2 destination:&destination];
		id actionMoveDone = [CallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
		id actionMove = [CubicBezierBy actionWithDuration:3.0f origin:origin control1:control1 control2:control2 destination:destination];
		[bombWP runAction:[Sequence actions:actionMove , 
						   actionMoveDone,
						   nil]];
		[bulletsArray addObject:bombWP];
		heliSprite.bombAmount--;
	}
}
-(void)addBullet:(ccTime)dt{	
	Weapon* bullet = [[Weapon alloc]WeaponWithType:WEAPON_NORMAL_BULLET];
	bullet.rotation = 90;
	bullet.position = ccp(heliSprite.position.x+heliSprite.contentSize.width/2-10, heliSprite.position.y-20);
	[self addChild:bullet z:6];
	[bulletsArray addObject:bullet];
	[self moveBullet:bullet DestPosition:ccp(480+bullet.contentSize.width/2, bullet.position.y) Duration:(480 - heliSprite.position.x) / (480+bullet.contentSize.width/2) * 0.8f];
}

-(void)addEnemyBullet:(Enemy*)enemy {
	/*
	Weapon* bullet = [[Weapon alloc]WeaponWithType:WEAPON_NORMAL_BULLET];
	bullet.rotation = 90;
	bullet.position = ccp(enemy.position.x-enemy.contentSize.width/2, enemy.position.y);
	[self addChild:bullet z:6];
	[enemyBullets addObject:bullet];
	[self moveBullet:bullet DestPosition:ccp(0-bullet.contentSize.width/2, bullet.position.y) Duration:( enemy.position.x) / (480+bullet.contentSize.width/2) * 1.0f];
	*/
	 
	switch (enemy.enemyType) {
		case ENEMY_HELI:
		{
			Weapon* bullet = [[Weapon alloc]WeaponWithType:WEAPON_NORMAL_BULLET];
			bullet.rotation = 90;
			bullet.position = ccp(enemy.position.x-enemy.contentSize.width/2, enemy.position.y);
			[self addChild:bullet z:6];
			[enemyBullets addObject:bullet];
			[self moveBullet:bullet DestPosition:ccp(0-bullet.contentSize.width/2, bullet.position.y) Duration:( enemy.position.x) / (480+bullet.contentSize.width/2) * 1.0f];
			break;
		}
		case ENEMY_HELI_2:
		{
			Weapon* bullet = [[Weapon alloc]WeaponWithType:WEAPON_NORMAL_BULLET];
			bullet.rotation = 90;
			bullet.position = ccp(enemy.position.x-enemy.contentSize.width/2, enemy.position.y);
			[self addChild:bullet z:6];
			[enemyBullets addObject:bullet];
			[self moveBullet:bullet DestPosition:ccp(0-bullet.contentSize.width/2, bullet.position.y) Duration:( enemy.position.x) / (480+bullet.contentSize.width/2) * 1.0f];
			
			Weapon* bullet2 = [[Weapon alloc]WeaponWithType:WEAPON_NORMAL_BULLET];
			bullet2.rotation = 90;
			bullet2.position = ccp(enemy.position.x-enemy.contentSize.width/2, enemy.position.y - 10);
			[self addChild:bullet2 z:6];
			[enemyBullets addObject:bullet2];
			[self moveBullet:bullet2 DestPosition:ccp(0-bullet2.contentSize.width/2, bullet2.position.y) Duration:( enemy.position.x) / (480+bullet2.contentSize.width/2) * 1.0f];
			
			break;
		}
		case ENEMY_HELI_3:
		{
			Weapon* bullet = [[Weapon alloc]WeaponWithType:WEAPON_MISSILE_1];
			//bullet.rotation = 90;
			bullet.position = ccp(enemy.position.x-enemy.contentSize.width/2, enemy.position.y);
			[self addChild:bullet z:6];
			[enemyBullets addObject:bullet];
			[self moveBullet:bullet DestPosition:ccp(0-bullet.contentSize.width/2, bullet.position.y) Duration:( enemy.position.x) / (480+bullet.contentSize.width/2) * 2.0f];
			break;
		}	
		case ENEMY_BOSS:
		{
			Weapon* bullet = [[Weapon alloc]WeaponWithType:WEAPON_NORMAL_BULLET];
			bullet.rotation = 90;
			bullet.position = ccp(enemy.position.x-enemy.contentSize.width/2, enemy.position.y);
			[self addChild:bullet z:6];
			[enemyBullets addObject:bullet];
			[self moveBullet:bullet DestPosition:ccp(0-bullet.contentSize.width/2, bullet.position.y) Duration:( enemy.position.x) / (480+bullet.contentSize.width/2) * 1.0f];
			/*
			Weapon* bullet2 = [[Weapon alloc]WeaponWithType:WEAPON_MISSILE_1];
			//bullet2.rotation = 90;
			bullet2.position = ccp(enemy.position.x-enemy.contentSize.width/2, enemy.position.y + 20);
			[self addChild:bullet2 z:6];
			[enemyBullets addObject:bullet2];
			[self moveBullet:bullet2 DestPosition:ccp(0-bullet2.contentSize.width/2, bullet2.position.y) Duration:( enemy.position.x) / (480+bullet2.contentSize.width/2) * 5.0f];
			
			Weapon* bullet3 = [[Weapon alloc]WeaponWithType:WEAPON_MISSILE_2];
			//bullet3.rotation = 90;
			bullet3.position = ccp(enemy.position.x-enemy.contentSize.width/2, enemy.position.y - 20);
			[self addChild:bullet3 z:6];
			[enemyBullets addObject:bullet3];
			[self moveBullet:bullet3 DestPosition:ccp(0-bullet3.contentSize.width/2, bullet3.position.y) Duration:( enemy.position.x) / (480+bullet3.contentSize.width/2) * 5.0f];
			*/
			break;
		}
		default:
			break;
	}
	
	
	
}

-(void)addSprite:(ccTime)dt{
	enemyAppearTime += dt;
	if(((int)enemyAppearTime % 4) == 0)
	{
		Enemy *enemy = [[Enemy alloc] EnemyWithType:ENEMY_HELI];
		int actual = 320-enemy.contentSize.height/2 - 100;
		enemy.position = ccp(480+enemy.contentSize.width/2,  arc4random() % actual +100);
	
		[enemy runAction:[RepeatForever actionWithAction:[Sequence actionOne:[DelayTime actionWithDuration:0.5f] two:[CallFuncN actionWithTarget:self selector:@selector(addEnemyBullet:)]]]];
	
		[self addChild:enemy z:6];
		[self moveBullet:enemy DestPosition:ccp(0-enemy.contentSize.width/2, enemy.position.y) Duration:5.0f];
		[enemiesArray addObject:enemy];
	}
	
	if(((int)enemyAppearTime % 7) == 0)
	{
		Enemy *enemy = [[Enemy alloc] EnemyWithType:ENEMY_HELI_2];
		int actual = 320-enemy.contentSize.height/2 - 100;
		enemy.position = ccp(480+enemy.contentSize.width/2,  arc4random() % actual +100);
		
		[enemy runAction:[RepeatForever actionWithAction:[Sequence actionOne:[DelayTime actionWithDuration:0.5f] two:[CallFuncN actionWithTarget:self selector:@selector(addEnemyBullet:)]]]];
		
		[self addChild:enemy z:6];
		[self moveBullet:enemy DestPosition:ccp(0-enemy.contentSize.width/2, enemy.position.y) Duration:5.0f];
		[enemiesArray addObject:enemy];
	}
	
	if(((int)enemyAppearTime % 5) == 0)
	{
		Enemy *enemy = [[Enemy alloc] EnemyWithType:ENEMY_HELI_3];
		int actual = 320-enemy.contentSize.height/2 - 100;
		enemy.position = ccp(480+enemy.contentSize.width/2,  arc4random() % actual +100);
		
		[enemy runAction:[RepeatForever actionWithAction:[Sequence actionOne:[DelayTime actionWithDuration:1.5f] two:[CallFuncN actionWithTarget:self selector:@selector(addEnemyBullet:)]]]];
		
		[self addChild:enemy z:6];
		[self moveBullet:enemy DestPosition:ccp(0-enemy.contentSize.width/2, enemy.position.y) Duration:5.0f];
		[enemiesArray addObject:enemy];
	}
	
}

-(void)bulletMoveFinished:(id)sender {
	AtlasSprite *sprite_ = (AtlasSprite *)sender;
	[bulletManager removeChild:sprite_ cleanup:YES];
	//[self removeChild:tankManager cleanup:YES];
}

-(void)moveBullet:(Sprite*)sprite_ DestPosition:(CGPoint)dpoint_ Duration:(float)duration_{
	id actionMoveDone = [CallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[sprite_ runAction:[Sequence actionOne:[MoveTo actionWithDuration:duration_ position:dpoint_] two:actionMoveDone]];
}

-(void)spriteMoveFinished:(id)sender {
	//printf("cleanup sender\n");
	if ([enemyBullets containsObject:sender]) {
		[enemyBullets removeObject:sender];
	}
	if ([bulletsArray containsObject:sender]) {
		[bulletsArray removeObject:sender];
	}
	if ([itemArray containsObject:sender]) {
		[itemArray removeObject:sender];
	}
	if ([enemiesArray containsObject:sender]) {
		[enemiesArray removeObject:sender];
	}
	[self removeChild:sender cleanup:YES];
}

-(void)moveSprite:(AtlasSprite*)sprite_ DestPosition:(CGPoint)dpoint_ Duration:(int)duration_{
	// Determine speed of the bullet
	int minDuration = 1.0;
	int maxDuration = 4.0;
	int rangeDuration = maxDuration - minDuration;
	//int actualDuration = (arc4random() % rangeDuration) + minDuration;
	int actualDuration = duration_;

	
	// Create the actions
	//id actionMove = [MoveTo actionWithDuration:actualDuration position:ccp(0-sprite_.contentSize.width/2, sprite_.position.y)];
	id actionMove = [MoveTo actionWithDuration:actualDuration position:dpoint_];
	id actionMoveDone = [CallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	
	[sprite_ runAction:[Sequence actions:actionMove, actionMoveDone, nil]];
	
	
}

-(void)moveWithObject:(NSMutableArray*)objectArray withSpeed:(int)speed{
	for (int i = 0; i < objectArray.count; i++) {
		Sprite *r1 = [objectArray objectAtIndex:i];
		Sprite *r2 = [objectArray objectAtIndex:(i-1)*(3*i-4)/2];
		
		if (r1.position.x+r1.contentSize.width/2 <= 0) {
			if (i == 0) {
				r1.position = ccp(r2.position.x + r1.contentSize.width-speed, r1.position.y);
			}
			else
				r1.position = ccp(r2.position.x + r1.contentSize.width, r1.position.y);
			
			
		}
		else {
			r1.position = ccp(r1.position.x-speed, r1.position.y);
		}
		
		
	}
}


-(NSMutableArray*)initObjectArray:(NSMutableArray*)objectArray withBG:(NSString*)fileName withX:(int)x withY:(int)y {
	objectArray = [[NSMutableArray alloc] init];
	for (int i = 1; i < 4; i++) {
		NSString * imageString = [NSString stringWithFormat:@"%@%d.png", fileName,i];
		Sprite *sp = [Sprite spriteWithFile:imageString];
		[[sp texture] setAliasTexParameters];
		if (i-1 == 0) {
			sp.position = ccp(x, y);
		}
		else {
			Sprite *temp = [objectArray objectAtIndex:(i-1-1)];
			sp.position = ccp(temp.position.x+sp.contentSize.width, y);
		}
		[objectArray addObject:sp];
	}
	return objectArray;
}

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[Director sharedDirector] convertToGL:location];
	
	if( 
	   CGRectContainsPoint(CGRectMake(joypad.position.x-joycap.contentSize.width/2, joypad.position.y-joycap.contentSize.height/2, joycap.contentSize.width, joycap.contentSize.height) , location) 
	   && 
	   !joyStickMoving
	   ){
		[self schedule:@selector(setHeliPosition:) interval:1.0/60];
		joyStickMoving = TRUE;
		joypadTouchHash = [touch hash];
	}
	else {
		//[moveSprite ]
	}

	return kEventHandled;

}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (NSSet *touch in touches) {
	if ([touch hash] == joypadTouchHash) {
		joycap.position = joypad.position;
		[self unschedule:@selector(setHeliPosition:)];
		joyStickMoving = FALSE;
		}
	}
	return kEventHandled;
}

-(BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if (joyStickMoving == FALSE) {
		return kEventIgnored;
	}
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[Director sharedDirector] convertToGL:location];
	//printf("ccTouchesMoved");
	if(location.x <= joypad.contentSize.width && 
	   location.y <= joypad.contentSize.height && 
	   joyStickMoving){
		
		joycap.position = ccp(location.x, location.y);
		
		
		// Calculate the angle of the touch from the center of the joypad
		
		
		float dx = joypadCenterx - location.x;
		float dy = joypadCentery - location.y;
		
		distance = sqrtf((joypadCenterx - location.x) * (joypadCenterx - location.x) + 
						 (joypadCentery - location.y) * (joypadCentery - location.y));
		
		// Calculate the angle of the players touch from the center of the joypad
		touchAngle = atan2(dy, dx);
		
		//NSLog(@"ccTouchesMoved");
		return kEventHandled;
	};
	return kEventIgnored;
}

-(void)setHeliPosition:(ccTime)dt{
	CGPoint newLocation = CGPointMake(heliSprite.position.x - distance/4 * cosf(touchAngle), 
									  heliSprite.position.y - distance/4 * sinf(touchAngle));
	if (newLocation.x < 0 || newLocation.x > 480 || newLocation.y < tankAtlasSprite.position.y || newLocation.y > 320) {
		return;
	}
	else {
		
		heliSprite.position = newLocation;
	}
}


-(void) dealloc
{
	[enemiesArray release];
	[tanksArray release];
	[bulletsArray release];
	[tankManager release];
	[bulletManager release];
	[hpBar release];
	[super dealloc];
}
@end
