
#import "CocosNode.h"
#import "TouchDispatcher.h"
#import "TextureMgr.h"

static unsigned int nextPOT(unsigned int x) {
	if (x <= 2) return 2;
	
    x = x - 1;
	
    x = x | (x >> 1);
    x = x | (x >> 2);
    x = x | (x >> 4);
    x = x | (x >> 8);
    x = x | (x >> 16);
	
    return x + 1;
}

@interface ButtonX : CocosNode <StandardTouchDelegate> {
	NSInvocation *invocation;
	
	int priority;
	
	BOOL isTouchEnabled;
	BOOL isSelected;
}

+ (id)buttonWithTarget:(id)target selector:(SEL)selector;
- (id)initWithTarget:(id)target selector:(SEL)selector;

+ (id)buttonWithTarget:(id)target selector:(SEL)selector key:(int)key;
- (id)initWithTarget:(id)target selector:(SEL)selector key:(int)key;

+ (id)buttonWithTarget:(id)target selector:(SEL)selector priority:(int)priority;
- (id)initWithTarget:(id)target selector:(SEL)selector priority:(int)priority;

+ (id)buttonWithTarget:(id)target selector:(SEL)selector priority:(int)priority key:(int)key;
- (id)initWithTarget:(id)target selector:(SEL)selector priority:(int)priority key:(int)key;

- (void)selected;
- (void)unselected;
- (void)activate;
- (BOOL)contains:(CGPoint)point;

@property int priority;
@property BOOL isTouchEnabled;
@property (readonly) BOOL isSelected;

@end
