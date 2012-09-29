
#import "CocosNode.h"

@interface HealthPoint : CocosNode {
	Texture2D *background;
	Texture2D *foreground;
	
	float value;
	float stub;
}

@property float value;

+ (id)healthPointWithWidth:(float)width;

+ (id)healthPointWithValue:(float)value;

+ (id)healthPointWithWidth:(float)width value:(float)value;


- (id)initWithWidth:(float)width;

- (id)initWithValue:(float)value;

- (id)initWithWidth:(float)width value:(float)value;

@end
