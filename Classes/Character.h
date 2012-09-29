//
//  Character.h
//  Heli
//
//  Created by vy phan on 23/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"

@interface Character : Sprite {
	int character_type;
	int character_hp;
	int character_max_hp;
	int missileAmount;
	int bombAmount;
	int max_missileAmount;
	int max_bombAmount;
}

-(Character*)CharacterWithType:(int)type_;
-(void)animatedCharacter:(Character*)character_ FileName:(NSString*)imageFile;

@property (readwrite) int character_type;
@property (readwrite) int character_hp;
@property (readwrite) int character_max_hp;
@property (readwrite) int missileAmount;
@property (readwrite) int bombAmount;
@property (readwrite) int max_missileAmount;
@property (readwrite) int max_bombAmount;

@end
