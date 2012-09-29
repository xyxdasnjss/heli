
#import "QuadBezier.h"

#define POINT_SIZE 10.0f
#define ANCHOR_COLOR ccc4(128, 128, 128, 128)
#define CONTROL_COLOR ccc4(0, 0, 255, 128)

@interface QuadBezier (Private)
- (void)updateVertices;
- (void)log;
@end

@implementation QuadBezier

@synthesize showAnothers;

+ (id)quadBezierWithOrigin:(CGPoint)origin control:(CGPoint)control destination:(CGPoint)destination segments:(int)segments color:(ccColor3B)color {
	return [[[self alloc] initWithOrigin:origin control:control destination:destination segments:segments color:color] autorelease];
}

- (id)initWithOrigin:(CGPoint)origin_ control:(CGPoint)control_ destination:(CGPoint)destination_ segments:(int)segments_ color:(ccColor3B)color {
	self = [super init];
	
	if (self != nil) {
		origin = origin_;
		control = control_;
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
		lineVertices[2] = control.x;
		lineVertices[3] = control.y;
		lineVertices[4] = destination.x;
		lineVertices[5] = destination.y;
		
		for (int i=0; i<3; i++) {
			lineColors[i*4] = 255 - color.r;
			lineColors[i*4+1] = 255 - color.g;
			lineColors[i*4+2] = 255 - color.b;
			lineColors[i*4+3] = 255;
		}
		
		radius = POINT_SIZE/2;
		
		priority = -1;
		
		isTouchEnabled = NO;
		showAnothers = YES;
		
		inOrigin = inControl = inDestination = NO;
	}
	
	return self;
}


- (void)origin:(CGPoint*)origin_ control:(CGPoint*)control_ destination:(CGPoint*)destination_ {
	*origin_ = origin;
	*control_ = control;
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
	
		// control
	
		glColor4ub(CONTROL_COLOR.r, CONTROL_COLOR.g, CONTROL_COLOR.b, CONTROL_COLOR.a);
	
		glVertexPointer(2, GL_FLOAT, 0, &control);
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
		// two tangential lines
	
		glVertexPointer(2, GL_FLOAT, 0, lineVertices);
		glColorPointer(4, GL_UNSIGNED_BYTE, 0, lineColors);
		glDrawArrays(GL_LINE_STRIP, 0, 3);
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
	
	if (dx >= control.x-radius && dx <= control.x+radius && dy >= control.y-radius && dy <= control.y+radius) {
		inControl = YES;
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
	if (!inOrigin && !inControl && !inDestination) return kEventIgnored;
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:[touch view]];
	
	if (inOrigin) {
		origin = CGPointMake(origin.x + point.y - oldPoint.y, origin.y + point.x - oldPoint.x);
		
		lineVertices[0] = origin.x;
		lineVertices[1] = origin.y;
	} else if (inControl) {
		control = CGPointMake(control.x + point.y - oldPoint.y, control.y + point.x - oldPoint.x);
		
		lineVertices[2] = control.x;
		lineVertices[3] = control.y;
	} else {
		destination = CGPointMake(destination.x + point.y - oldPoint.y, destination.y + point.x - oldPoint.x);
		
		lineVertices[4] = destination.x;
		lineVertices[5] = destination.y;
	}
	
	[self updateVertices];
	
	oldPoint = point;
	
	return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if (!inOrigin && !inControl && !inDestination) return kEventIgnored;
	
	inOrigin = inControl = inDestination = NO;
	
	[self log];
	
	return kEventHandled;
}


- (void)updateVertices {
	float t = 0.0f;
	
	for (int i=0; i<segments; i++) {
		bezierVertices[i*2] = (1-t)*(1-t)*origin.x + 2.0f*(1-t)*t*control.x + t*t*destination.x;
		bezierVertices[i*2+1] = (1-t)*(1-t)*origin.y + 2.0f*(1-t)*t*control.y + t*t*destination.y;
		
		t += 1.0f/segments;
	}
	
	bezierVertices[segments*2] = destination.x;
	bezierVertices[segments*2+1] = destination.y;
}

- (void)log {
	printf("\n[QuadBezier: origin=(%d,%d), control=(%d,%d), destination=(%d,%d)]\n", (int)origin.x, (int)origin.y, (int)control.x, (int)control.y, (int)destination.x, (int)destination.y);
}


- (void)dealloc {
	free(bezierVertices);
	free(bezierColors);
	
	[super dealloc];
}

@end
