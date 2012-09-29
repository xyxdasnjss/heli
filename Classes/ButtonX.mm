
#import "ButtonX.h"

@implementation ButtonX

float userholdTime = 0.5f; // 0.5 second
float holdTime = 0.0f;

+ (id)buttonWithTarget:(id)target selector:(SEL)selector {
	return [[[self alloc] initWithTarget:target selector:selector] autorelease];
}

- (id)initWithTarget:(id)target selector:(SEL)selector {
	self = [super init];
	
	if (self != nil) {
		if (target && selector) {
			NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:selector];
			
			invocation = nil;
			
			invocation = [NSInvocation invocationWithMethodSignature:sig];
			
			[invocation setTarget:target];
			[invocation setSelector:selector];
			[invocation setArgument:&self atIndex:2];
			
			[invocation retain];
		}
		
		anchorPoint_ = CGPointMake(0, 0);

		priority = 0;
		
		isTouchEnabled = YES;
		isSelected = NO;
	}
	
	return self;
}

+ (id)buttonWithTarget:(id)target selector:(SEL)selector key:(int)key {
	return [[[self alloc] initWithTarget:target selector:selector key:(int)key ] autorelease];
}

- (id)initWithTarget:(id)target selector:(SEL)selector key:(int)key {
	self = [super init];
	
	if (self != nil) {
		if (target && selector) {
			NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:selector];
			
			invocation = nil;
			
			invocation = [NSInvocation invocationWithMethodSignature:sig];
			
			[invocation setTarget:target];
			[invocation setSelector:selector];
			[invocation setArgument:&key atIndex:2];
			
			[invocation retain];
		}
		
		anchorPoint_ = CGPointMake(0, 0);
		
		//priority = 0;
		priority = -1;
		
		isTouchEnabled = NO;
		isSelected = NO;
	}
	
	return self;
}

+ (id)buttonWithTarget:(id)target selector:(SEL)selector priority:(int)priority {
	return [[[self alloc] initWithTarget:target selector:selector priority:priority] autorelease];
}

- (id)initWithTarget:(id)target selector:(SEL)selector priority:(int)priority_ {
	self = [super init];
	
	if (self != nil) {
		if (target && selector) {
			NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:selector];
			
			invocation = nil;
			
			invocation = [NSInvocation invocationWithMethodSignature:sig];
			
			[invocation setTarget:target];
			[invocation setSelector:selector];
			[invocation setArgument:&self atIndex:2];
			
			[invocation retain];
		}
		
		anchorPoint_ = CGPointMake(0, 0);
		
		priority = priority_;
		
		isTouchEnabled = NO;
		isSelected = NO;
	}
	
	return self;
}

+ (id)buttonWithTarget:(id)target selector:(SEL)selector priority:(int)priority key:(int)key {
	return [[[self alloc] initWithTarget:target selector:selector priority:priority key:key] autorelease];
}

- (id)initWithTarget:(id)target selector:(SEL)selector priority:(int)priority_ key:(int)key {
	self = [super init];
	
	if (self != nil) {
		if (target && selector) {
			NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:selector];
			
			invocation = nil;
			
			invocation = [NSInvocation invocationWithMethodSignature:sig];
			
			[invocation setTarget:target];
			[invocation setSelector:selector];
			[invocation setArgument:&key atIndex:2];
			
			[invocation retain];
		}
		
		anchorPoint_ = CGPointMake(0, 0);
		
		priority = priority_;
		
		isTouchEnabled = NO;
		isSelected = NO;
	}
	
	return self;
}


- (int)priority {
	return priority;
}

- (void)setPriority:(int)priority_ {
	if (priority != priority_) {
		priority = priority_;
		
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

- (BOOL)isSelected {
	return isSelected;
}

- (void)onExit {
	
	if (isTouchEnabled)
		[[TouchDispatcher sharedDispatcher] removeDelegate:self];
	
	[super onExit];
}


- (BOOL)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:[touch view]];
	
	if ([self contains:point]) {
		isSelected = YES;
		
		[self selected];
		
		return kEventHandled;
	}
	
	//isSelected = NO;
	
	return kEventIgnored;
}

- (BOOL)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	if (isSelected) {
		return kEventHandled;
	}
	
	return kEventIgnored;
}

- (BOOL)ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:[touch view]];
	
	if (isSelected) {
		isSelected = NO;
		
		[self unselected];
		
		if ([self contains:point]) {
			[self activate];
		}
		
		return kEventHandled;
	}
	
	return kEventIgnored;
}

- (void)coutHoldTime:(ccTime)dt{
	holdTime+=dt;
}


- (void)selected {
	
}

- (void)unselected {
}

- (void)activate {
	[invocation invoke];
}

- (BOOL)contains:(CGPoint)point {
	return NO;
}


- (void)dealloc {
	[invocation release];
	
	[super dealloc];
}

@end
