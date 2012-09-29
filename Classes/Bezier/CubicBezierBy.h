
#import "IntervalAction.h"

@interface CubicBezierBy : IntervalAction {
	CGPoint origin, control1, control2, destination;
}

+ (id)actionWithDuration:(ccTime)duration origin:(CGPoint)origin control1:(CGPoint)control1 control2:(CGPoint)control2 destination:(CGPoint)destination;
- (id)initWithDuration:(ccTime)duration origin:(CGPoint)origin control1:(CGPoint)control1 control2:(CGPoint)control2 destination:(CGPoint)destination;

@end
