
#import "CocosNode.h"

@interface HealthPointX : CocosNode {
	Texture2D *background;
	Texture2D *foreground;
	
	float value;
	float threshold;
}

@property float value;

+ (id)healthPointWithWidth:(float)width;

+ (id)healthPointWithValue:(float)value;

+ (id)healthPointWithThreshold:(float)threshold;

+ (id)healthPointWithWidth:(float)width value:(float)value threshold:(float)threshold;


- (id)initWithWidth:(float)width;

- (id)initWithValue:(float)value;

- (id)initWithThreshold:(float)threshold;

- (id)initWithWidth:(float)width value:(float)value threshold:(float)threshold;


@end
