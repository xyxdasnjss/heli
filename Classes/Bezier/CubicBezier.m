
#import "CubicBezier.h"

#define POINT_SIZE 10.0f
#define ANCHOR_COLOR ccc4(128, 128, 128, 128)
#define CONTROL_COLOR ccc4(0, 0, 255, 128)

@interface CubicBezier (Private)
- (void)updateVertices;
- (void)log;
@end

@implementation CubicBezier

@synthesize showAnothers;

+ (id)cubicBezierWithOrigin:(CGPoint)origin control1:(CGPoint)control1 control2:(CGPoint)control2 destination:(CGPoint)destination segments:(int)segments color:(ccColor3B)color {
	return [[[self alloc] initWithOrigin:origin control1:control1 control2:control2 destination:destination segments:segments color:color] autorelease];
}

- (id)initWithOrigin:(CGPoint)origin_ control1:(CGPoint)control1_ control2:(CGPoint)control2_ destination:(CGPoint)destination_ segments:(int)segments_ color:(ccColor3B)color {
	self = [super init];
	
	if (self != nil) {
		origin = origin_;
		control1 = control1_;
		control2 = control2_;
		destination = destination_;
		
		segments = segments_;
		
		bezierVertices = malloc((segments+1)*2*sizeof(GLfloat));
		bezierColors = malloc((segments+1)*4*sizeof(GLubyte));
		
		[self updateVertices];
		
		for (int i=0; i<=segments; i++) {
			bezierColors[i*4] = color.r;
			bezierColors[i*4+1] = color.g;
			bezierColors[i*4+2] = color.b;
			bezierColors[i*4+3] = 255;
		}
		
		lineVertices[0] = origin.x;
		lineVertices[1] = origin.y;
		lineVertices[2] = control1.x;
		lineVertices[3] = control1.y;
		lineVertices[4] = control2.x;
		lineVertices[5] = control2.y;
		lineVertices[6] = destination.x;
		lineVertices[7] = destination.y;
		
		for (int i=0; i<4; i++) {
			lineColors[i*4] = 255 - color.r;
			lineColors[i*4+1] = 255 - color.g;
			lineColors[i*4+2] = 255 - color.b;
			lineColors[i*4+3] = 255;
		}
		
		radius = POINT_SIZE/2;
		
		priority = -1;
		
		isTouchEnabled = NO;
		showAnothers = YES;
		
		inOrigin = inControl1 = inControl2 = inDestination = NO;
	}
	
	return self;
}


- (void)origin:(CGPoint*)origin_ control1:(CGPoint*)control1_ control2:(CGPoint*)control2_ destination:(CGPoint*)destination_ {
	*origin_ = origin;
	*control1_ = control1;
	*control2_ = control2;
	*destination_ = destination;
}


- (void)draw {
	glEnableClientState(GL_VERTEX_ARRAY);
	
	if (showAnothers) {
		glPointSize(POINT_SIZE);
	
		// anchors
	
		glColor4ub(ANCHOR_COLOR.r, ANCHOR_COLOR.g, ANCHOR_COLOR.b, ANCHOR_COLOR.a);
	
		glVertexPointer(2, GL_FLOAT, 0, &origin);
		glDrawArrays(GL_POINTS, 0, 1);
	
		glVertexPointer(2, GL_FLOAT, 0, &destination);
		glDrawArrays(GL_POINTS, 0, 1);
	
		// controls
	
		glColor4ub(CONTROL_COLOR.r, CONTROL_COLOR.g, CONTROL_COLOR.b, CONTROL_COLOR.a);
	
		glVertexPointer(2, GL_FLOAT, 0, &control1);
		glDrawArrays(GL_POINTS, 0, 1);
	
		glVertexPointer(2, GL_FLOAT, 0, &control2);
		glDrawArrays(GL_POINTS, 0, 1);
	
		glPointSize(1.0f);
	
		glColor4ub(255, 255, 255, 255);
	}
	
	glEnableClientState(GL_COLOR_ARRAY);
	
	// bezier curve
	
	glVertexPointer(2, GL_FLOAT, 0, bezierVertices);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, bezierColors);
	glDrawArrays(GL_LINE_STRIP, 0, segments+1);
	
	if (showAnothers) {
		// three tangential lines
	
		glVertexPointer(2, GL_FLOAT, 0, lineVertices);
		glColorPointer(4, GL_UNSIGNED_BYTE, 0, lineColors);
		glDrawArrays(GL_LINE_STRIP, 0, 4);
	}
	
	glDisableClientState(GL_COLOR_ARRAY);
	
	glDisableClientState(GL_VERTEX_ARRAY);
}


- (void)onEnter {
	[super onEnter];
	
	[self setIsTouchEnabled:YES];
}

- (void)onExit {
	if (isTouchEnabled)
		[[TouchDispatcher sharedDispatcher] removeDelegate:self];
	
	[super onExit];
}


- (int)priority {
	return priority;
}

- (void)setPriority:(int)priority_ {
	if (priority != priority_) {
		priority = priority_;
		
		if (isTouchEnabled)
			[[TouchDispatcher sharedDispatcher] setPriority:priority forDelegate:self];
	}
}

- (BOOL)isTouchEnabled {
	return isTouchEnabled;
}

- (void)setIsTouchEnabled:(BOOL)enabled {
	if (isTouchEnabled != enabled) {
		isTouchEnabled = enabled;
		
		if (isTouchEnabled)
			[[TouchDispatcher sharedDispatcher] addStandardDelegate:self priority:priority];
		else
			[[TouchDispatcher sharedDispatcher] removeDelegate:self];
	}
}


- (BOOL)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:[touch view]];
	
	float dx = point.y - (parent.position.x + position_.x);
	float dy = point.x - (parent.position.y + position_.y);
	
	if (dx >= origin.x-radius && dx <= origin.x+radius && dy >= origin.y-radius && dy <= origin.y+radius) {
		inOrigin = YES;
		oldPoint = point;
		
		return kEventHandled;
	}
	
	if (dx >= control1.x-radius && dx <= control1.x+radius && dy >= control1.y-radius && dy <= control1.y+radius) {
		inControl1 = YES;
		oldPoint = point;
		
		return kEventHandled;
	}
	
	if (dx >= control2.x-radius && dx <= control2.x+radius && dy >= control2.y-radius && dy <= control2.y+radius) {
		inControl2 = YES;
		oldPoint = point;
		
		return kEventHandled;
	}
	
	if (dx >= destination.x-radius && dx <= destination.x+radius && dy >= destination.y-radius && dy <= destination.y+radius) {
		inDestination = YES;
		oldPoint = point;
		
		return kEventHandled;
	}
	
	return kEventIgnored;
}

- (BOOL)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	if (!inOrigin && !inControl1 && !inControl2 && !inDestination) return kEventIgnored;
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:[touch view]];
	
	if (inOrigin) {
		origin = CGPointMake(origin.x + point.y - oldPoint.y, origin.y + point.x - oldPoint.x);
		
		lineVertices[0] = origin.x;
		lineVertices[1] = origin.y;	
	} else if (inControl1) {
		control1 = CGPointMake(control1.x + point.y - oldPoint.y, control1.y + point.x - oldPoint.x);
		
		lineVertices[2] = control1.x;
		lineVertices[3] = control1.y;
	} else if (inControl2) {
		control2 = CGPointMake(control2.x + point.y - oldPoint.y, control2.y + point.x - oldPoint.x);
		
		lineVertices[4] = control2.x;
		lineVertices[5] = control2.y;
	} else {
		destination = CGPointMake(destination.x + point.y - oldPoint.y, destination.y + point.x - oldPoint.x);
		
		lineVertices[6] = destination.x;
		lineVertices[7] = destination.y;
	}
	
	[self updateVertices];
	
	oldPoint = point;
	
	return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if (!inOrigin && !inControl1 && !inControl2 && !inDestination) return kEventIgnored;
	
	inOrigin = inControl1 = inControl2 = inDestination = NO;
	
	[self log];
	
	return kEventHandled;
}


- (void)updateVertices {
	float t = 0.0f;
	
	for (int i=0; i<segments; i++) {
		bezierVertices[i*2] = (1-t)*(1-t)*(1-t)*origin.x + 3.0f*(1-t)*(1-t)*t*control1.x + 3.0f*(1-t)*t*t*control2.x + t*t*t*destination.x;
		bezierVertices[i*2+1] = (1-t)*(1-t)*(1-t)*origin.y + 3.0f*(1-t)*(1-t)*t*control1.y + 3.0f*(1-t)*t*t*control2.y + t*t*t*destination.y;
		
		t += 1.0f/segments;
	}
	
	bezierVertices[segments*2] = destination.x;
	bezierVertices[segments*2+1] = destination.y;
}

- (void)log {
	printf("\n[CubicBezier: origin=(%d,%d), control1=(%d,%d), control2=(%d,%d), destination=(%d,%d)]\n", (int)origin.x, (int)origin.y, (int)control1.x, (int)control1.y, (int)control2.x, (int)control2.y, (int)destination.x, (int)destination.y);
}


- (void)dealloc {
	free(bezierVertices);
	free(bezierColors);
	
	[super dealloc];
}

@end
