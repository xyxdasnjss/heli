
#import "CocosNode.h"
#import "TouchDispatcher.h"

@interface CubicBezier : CocosNode <StandardTouchDelegate> {
	CGPoint origin, control1, control2, destination;
	
	int segments;
	
	GLfloat *bezierVertices;
	GLubyte *bezierColors;
	
	GLfloat lineVertices[4*2];
	GLubyte lineColors[4*4];
	
	float radius;
	CGPoint oldPoint;
	
	int priority;
	
	BOOL isTouchEnabled;
	BOOL showAnothers;
	
	BOOL inOrigin, inControl1, inControl2, inDestination;
}

+ (id)cubicBezierWithOrigin:(CGPoint)origin control1:(CGPoint)control1 control2:(CGPoint)control2 destination:(CGPoint)destination segments:(int)segments color:(ccColor3B)color;
- (id)initWithOrigin:(CGPoint)origin control1:(CGPoint)control1 control2:(CGPoint)control2 destination:(CGPoint)destination segments:(int)segments color:(ccColor3B)color;

- (void)origin:(CGPoint*)origin control1:(CGPoint*)control1 control2:(CGPoint*)control2 destination:(CGPoint*)destination;

@property int priority;
@property BOOL isTouchEnabled;
@property BOOL showAnothers;

@end
