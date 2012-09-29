//
//  Character.m
//  Heli
//
//  Created by vy phan on 23/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Character.h"
#import "cocos2d.h"
#import "MyDefine.h"

@implementation Character

@synthesize character_type;
@synthesize character_hp;
@synthesize character_max_hp;
@synthesize bombAmount;
@synthesize missileAmount;
@synthesize max_bombAmount;
@synthesize max_missileAmount;

-(Character*)CharacterWithType:(int)type_{
	Character* character = nil;
	if(type_ == CHARACTER_1){
		character = [[Character alloc] initWithFile:@"truc thang 1.png"];
		character.character_hp = character.character_max_hp = 999999;
		bombAmount = missileAmount = 0;
		max_bombAmount = 150;
		max_missileAmount = 100; 
		[self animatedCharacter:character FileName:@"truc thang "];
	}
	if(type_ == CHARACTER_2){
		character = [[Character alloc] initWithFile:@"hc1.png"];
		character.character_hp = character.character_max_hp = 200;
		bombAmount = missileAmount = 0;
		max_bombAmount = 100;
		max_missileAmount = 50; 
		[self animatedCharacter:character FileName:@"hc"];
	}
	return character;
}

-(void)animatedCharacter:(Character*)character_ FileName:(NSString*)imageFile{
	
		Animation* characterAnimation = [Animation animationWithName:@"charAni" delay:0.001];
		for (int i=1; i<=5; i++)
			[characterAnimation addFrameWithFilename:[NSString stringWithFormat:@"%@%d.png", imageFile,i]];
	
		[character_ runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:characterAnimation]]];
}

-(void)explode:(id)sender{
	
}


@end
