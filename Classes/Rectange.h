//
//  Rectange.h
//  Heli
//
//  Created by vy phan on 06/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Rectange : CocosNode {
	CGRect rect_;
	ccColor3B color_;
}
-(id)initRect:(CGRect)Rect_ Color:(ccColor3B)Color_;
@property (readwrite) CGRect rect_;
@property (readwrite) ccColor3B color_;
@end
