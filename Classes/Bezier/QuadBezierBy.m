
#import "QuadBezierBy.h"

@implementation QuadBezierBy

+ (id)actionWithDuration:(ccTime)duration origin:(CGPoint)origin control:(CGPoint)control destination:(CGPoint)destination {
	return [[[self alloc] initWithDuration:duration origin:origin control:control destination:destination] autorelease];
}

- (id)initWithDuration:(ccTime)duration_ origin:(CGPoint)origin_ control:(CGPoint)control_ destination:(CGPoint)destination_ {
	self = [super initWithDuration:duration_];
	
	if (self != nil) {
		origin = origin_;
		control = control_;
		destination = destination_;
	}
	
	return self;
}

- (id)copyWithZone:(NSZone*)zone {
	return [[[self class] allocWithZone:zone] initWithDuration:duration origin:origin control:control destination:destination];
}

- (void)start {
	[target setPosition:origin];
	
	[super start];
}

- (void)update:(ccTime)t {
	[target setPosition:CGPointMake((1-t)*(1-t)*origin.x + 2.0f*(1-t)*t*control.x + t*t*destination.x,
									(1-t)*(1-t)*origin.y + 2.0f*(1-t)*t*control.y + t*t*destination.y)];
}

@end
