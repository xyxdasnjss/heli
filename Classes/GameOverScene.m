//
//  GameOverScene.m
//  Heli
//
//  Created by vy phan on 30/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"
#import "CGPointExtension.h"
#import "Menu.h"
#import "MenuItem.h"
#import "cocos2d.h"
#import "GameScene.h"

@implementation GameOverScene
-(id)init{
	self = [super init];
	if(self != nil){
		Layer* layer = [[Layer alloc]init];
	
		Sprite* bg = [Sprite spriteWithFile:@"GameOver.gif"];
		bg.position = ccp(240, 160);
		bg.scaleX = 1.7;
		bg.scaleY = 1.5;
	
		[layer addChild:bg];
	
		[self addChild:layer];
		
		MenuItem *replay = [MenuItemFont itemFromString:@"Replay" target:self selector:@selector(replaceScene:) ];
		
		replay.position = ccp(240, 160);
		
		Menu* menu = [Menu menuWithItems:replay, nil];
		
		menu.position = CGPointZero;
		
		[self addChild:menu];
		
		
	}
	return self;
}
-(void)replaceScene:(id)sender{
	[[Director sharedDirector]replaceScene:[[GameScene alloc]init]];
}
@end
