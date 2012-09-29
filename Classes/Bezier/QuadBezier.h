
#import "CocosNode.h"
#import "TouchDispatcher.h"

@interface QuadBezier : CocosNode <StandardTouchDelegate> {
	CGPoint origin, control, destination;

	int segments;
	
	GLfloat *bezierVertices;
	GLubyte *bezierColors;
	
	GLfloat lineVertices[3*2];
	GLubyte lineColors[3*4];
	
	float radius;
	CGPoint oldPoint;
	
	int priority;
	
	BOOL isTouchEnabled;
	BOOL showAnothers;
	
	BOOL inOrigin, inControl, inDestination;
}

+ (id)quadBezierWithOrigin:(CGPoint)origin control:(CGPoint)control destination:(CGPoint)destination segments:(int)segments color:(ccColor3B)color;
- (id)initWithOrigin:(CGPoint)origin control:(CGPoint)control destination:(CGPoint)destination segments:(int)segments color:(ccColor3B)color;

- (void)origin:(CGPoint*)origin control:(CGPoint*)control destination:(CGPoint*)destination;

@property int priority;
@property BOOL isTouchEnabled;
@property BOOL showAnothers;

@end
