
#import "CubicBezierBy.h"

@implementation CubicBezierBy

+ (id)actionWithDuration:(ccTime)duration origin:(CGPoint)origin control1:(CGPoint)control1 control2:(CGPoint)control2 destination:(CGPoint)destination {
	return [[[self alloc] initWithDuration:duration origin:origin control1:control1 control2:control2 destination:destination] autorelease];
}

- (id)initWithDuration:(ccTime)duration_ origin:(CGPoint)origin_ control1:(CGPoint)control1_ control2:(CGPoint)control2_ destination:(CGPoint)destination_ {
	self = [super initWithDuration:duration_];
	
	if (self != nil) {
		origin = origin_;
		control1 = control1_;
		control2 = control2_;
		destination = destination_;
	}
	
	return self;
}

- (id)copyWithZone:(NSZone*)zone {
	return [[[self class] allocWithZone:zone] initWithDuration:duration origin:origin control1:control1 control2:control2 destination:destination];
}

- (void)start {
	[target setPosition:origin];
	
	[super start];
}

- (void)update:(ccTime)t {
	[target setPosition:CGPointMake((1-t)*(1-t)*(1-t)*origin.x + 3.0f*(1-t)*(1-t)*t*control1.x + 3.0f*(1-t)*t*t*control2.x + t*t*t*destination.x,
									(1-t)*(1-t)*(1-t)*origin.y + 3.0f*(1-t)*(1-t)*t*control1.y + 3.0f*(1-t)*t*t*control2.y + t*t*t*destination.y)];
}

@end
