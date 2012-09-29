
#import "HealthPoint.h"

#define DEFAULT_WIDTH	100.0f
#define DEFAULT_VALUE	1.0f

static inline NSUInteger nextPOT(NSUInteger x) {
	if (x <= 2) return 2;
	
    x = x - 1;
	
    x = x | (x >> 1);
    x = x | (x >> 2);
    x = x | (x >> 4);
    x = x | (x >> 8);
    x = x | (x >> 16);
	
    return x + 1;
}

static inline Texture2D* getTexture(NSString *filename, CGRect rect) {
	UIImage *uiImage = [UIImage imageNamed:filename];
	CGImageRef imageRef = CGImageCreateWithImageInRect([uiImage CGImage], rect);
	
	CGSize contentSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
	
	int width  = nextPOT(contentSize.width);
	printf("contentSize.width %f ----- width: %f\n", contentSize.width, width);
	int height = nextPOT(contentSize.height);
	
	void *data = malloc(height * width * 4);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef    context = CGBitmapContextCreate(data, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	
	CGColorSpaceRelease(colorSpace);
	
	CGContextClearRect(context, CGRectMake(0, 0, width, height));
	CGContextTranslateCTM(context, 0, height - contentSize.height);
	
	CGContextDrawImage(context, CGRectMake(0, 0, contentSize.width, contentSize.height), imageRef);
	
	CGContextRelease(context);
	
	Texture2D *texture = [[Texture2D alloc] initWithData:data pixelFormat:kTexture2DPixelFormat_RGBA8888 pixelsWide:width pixelsHigh:height contentSize:contentSize];
	
	free(data);
	
	return texture;
}

@implementation HealthPoint

+ (id)node {
	return [[[self alloc] initWithWidth:DEFAULT_WIDTH value:DEFAULT_VALUE] autorelease];
}

+ (id)healthPointWithWidth:(float)width {
	return [[[self alloc] initWithWidth:width value:DEFAULT_VALUE] autorelease];
}

+ (id)healthPointWithValue:(float)value {
	return [[[self alloc] initWithWidth:DEFAULT_WIDTH value:value] autorelease];
}

+ (id)healthPointWithWidth:(float)width value:(float)value {
	return [[[self alloc] initWithWidth:width value:value] autorelease];
}


- (id)init {
	return [self initWithWidth:DEFAULT_WIDTH value:DEFAULT_VALUE];
}

- (id)initWithWidth:(float)width {
	return [self initWithWidth:width value:DEFAULT_VALUE];
}

- (id)initWithValue:(float)value_ {
	return [self initWithWidth:DEFAULT_WIDTH value:value_];
}

- (id)initWithWidth:(float)width value:(float)value_ {
	if (self = [super init]) {
		background = getTexture(@"hp.png", CGRectMake(0, 0, 1, 10));
		
		stub = (value_ >= 0.75f ? 0.75f : (value_ >= 0.5f ? 0.5f : (value_ >= 0.25f ? 0.25f : 0.0f)));
		
		foreground = getTexture(@"hp.png", CGRectMake(0, (stub == 0.75f ? 10 : (stub == 0.5f ? 30 : (stub == 0.25f ? 40 : 20))), 1, 10)); // blue | green | yellow | red
		
		[self setValue:value_];
		
		[self setContentSize:CGSizeMake(width, background.contentSize.height)];
	}
	
	return self;
}


- (float)value {
	return value;
}

- (void)setValue:(float)value_ {
	if (value_ < 0) value = 0;
	else value = value_;
	
	if (value < stub) {
		stub -= 0.25f;
		
		[foreground release];
		
		foreground = getTexture(@"hp.png", CGRectMake(0, (stub == 0.75f ? 10 : (stub == 0.5f ? 30 : (stub == 0.25f ? 40 : 20))), 1, 10)); // blue | green | yellow | red
	}
}


- (void)draw {
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	[background drawInRect:CGRectMake(0, 0, contentSize_.width, contentSize_.height)];
	
	[foreground drawInRect:CGRectMake(0, 0, value * contentSize_.width, contentSize_.height)];
	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
}


- (void)dealloc {
	[background release];
	background = nil;
	
	[foreground release];
	foreground = nil;
	
	[super dealloc];
}

@end
