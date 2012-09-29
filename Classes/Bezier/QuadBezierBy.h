
#import "IntervalAction.h"

@interface QuadBezierBy : IntervalAction {
	CGPoint origin, control, destination;
}

+ (id)actionWithDuration:(ccTime)duration origin:(CGPoint)origin control:(CGPoint)control destination:(CGPoint)destination;
- (id)initWithDuration:(ccTime)duration origin:(CGPoint)origin control:(CGPoint)control destination:(CGPoint)destination;

@end
