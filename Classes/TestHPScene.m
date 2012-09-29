
#import "TestHPScene.h"
#import "CGPointExtension.h"
#import "HealthPoint.h"
#import "HealthPointX.h"

enum {
	kTagHealthPoint,
	kTagHealthPointX
};

@implementation TestHPScene

- (id)init {
	if (self = [super init]) {
		HealthPoint *hp1 = [HealthPoint node];
		hp1.position = ccp(20, 200);
		[self addChild:hp1];
		
		HealthPoint *hp2 = [HealthPoint healthPointWithWidth:50 value:0.5];
		hp2.scaleX = 3.0f;
		hp2.scaleY = 2.0f;
		hp2.position = ccp(hp1.position.x, hp1.position.y-50);
		[self addChild:hp2];
		
		HealthPoint *hp3 = [HealthPoint node];
		hp3.scale = 2.0f;
		hp3.position = ccp(hp1.position.x, hp2.position.y-50);
		[self addChild:hp3 z:0 tag:kTagHealthPoint];
		
		HealthPointX *hpx1 = [HealthPointX node];
		hpx1.position = ccp(260, 200);
		[self addChild:hpx1];
		
		HealthPointX *hpx2 = [HealthPointX healthPointWithWidth:50 value:0.5 threshold:0.5];
		hpx2.scaleX = 3.0f;
		hpx2.scaleY = 2.0f;
		hpx2.position = ccp(hpx1.position.x, hpx1.position.y-50);
		[self addChild:hpx2];
		
		HealthPointX *hpx3 = [HealthPointX node];
		hpx3.scale = 2.0f;
		hpx3.position = ccp(hpx1.position.x, hpx2.position.y-50);
		[self addChild:hpx3 z:0 tag:kTagHealthPointX];
		
		[self schedule:@selector(changeHP) interval:0.1];
	}
	
	return self;
}

- (void)changeHP {
	HealthPoint *hp = (HealthPoint*)[self getChildByTag:kTagHealthPoint];
	HealthPointX *hpx = (HealthPointX*)[self getChildByTag:kTagHealthPointX];
	
	if (hp.value <= 0.0) {
		[hp setValue:1.0f];
	}
	else {
		
		[hp setValue:hp.value-0.01];
	}

	if (hpx.value <= 0.0) {
		[hpx setValue:1.0f];
	}
	else {
		[hpx setValue:hpx.value-0.01];
	}

	
	
	//[hp setValue:hp.value-0.01];
	//[hpx setValue:hpx.value-0.01];
	printf("\nhp=%2.2f, hpx=%2.2f", hp.value, hpx.value);
	
	//if (hp.value <= 0) {
	//	[self unschedule:@selector(changeHP)];
	//}
}
		
@end
