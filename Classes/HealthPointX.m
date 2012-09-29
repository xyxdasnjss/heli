
#import "HealthPointX.h"

#define DEFAULT_WIDTH		100.0f
#define DEFAULT_VALUE		1.0f
#define DEFAULT_THRESHOLD	0.5f

#define BLACK	0
#define GREEN	1
#define RED		2

static inline Texture2D* getTexture(int color) {
	CGSize contentSize = CGSizeMake(1, 10);
	
	int width = 2;
	int height = 16;
	
	void *data = calloc(1, height * width * 4);
	
	int *tmp = (int*)data;
	
	switch (color) {
		case BLACK:
		{
			int black[] = {-13619152, -11513776, -10461088, -9408400, -10461088, -11513776, -12566464, -13619152, -14671840, -15790321};
			
			for (int i=0; i<10; i++)
				tmp[i<<1] = black[i];
			
			break;
		}
		case GREEN:
		{
			int green[] = {-13601024, -11491296, -10437312, -9381792, -10437312, -11491296, -12677888, -13601024, -14721792, -15776512};
			
			for (int i=0; i<10; i++)
				tmp[i<<1] = green[i];
			
			break;
		}
		case RED:
		{
			int red[] = {-16777059, -13026067, -10921220, -9078532, -10921220, -13026067, -14999867, -16777059, -16777099, -16777139};
			
			for (int i=0; i<10; i++)
				tmp[i<<1] = red[i];
			
			break;
		}
	}
		
	Texture2D *texture = [[Texture2D alloc] initWithData:data pixelFormat:kTexture2DPixelFormat_RGBA8888 pixelsWide:width pixelsHigh:height contentSize:contentSize];
	
	free(data);
	
	return texture;
}

@implementation HealthPointX

+ (id)node {
	return [[[self alloc] initWithWidth:DEFAULT_WIDTH value:DEFAULT_VALUE threshold:DEFAULT_THRESHOLD] autorelease];
}

+ (id)healthPointWithWidth:(float)width {
	return [[[self alloc] initWithWidth:width value:DEFAULT_VALUE threshold:DEFAULT_THRESHOLD] autorelease];
}

+ (id)healthPointWithValue:(float)value {
	return [[[self alloc] initWithWidth:DEFAULT_WIDTH value:value threshold:DEFAULT_THRESHOLD] autorelease];
}

+ (id)healthPointWithThreshold:(float)threshold {
	return [[[self alloc] initWithWidth:DEFAULT_WIDTH value:DEFAULT_VALUE threshold:threshold] autorelease];
}

+ (id)healthPointWithWidth:(float)width value:(float)value threshold:(float)threshold {
	return [[[self alloc] initWithWidth:width value:value threshold:threshold] autorelease];
}


- (id)init {
	return [self initWithWidth:DEFAULT_WIDTH value:DEFAULT_VALUE threshold:DEFAULT_THRESHOLD];
}

- (id)initWithWidth:(float)width {
	return [self initWithWidth:width value:DEFAULT_VALUE threshold:DEFAULT_THRESHOLD];
}

- (id)initWithValue:(float)value_ {
	return [self initWithWidth:DEFAULT_WIDTH value:value_ threshold:DEFAULT_THRESHOLD];
}

- (id)initWithThreshold:(float)threshold_ {
	return [self initWithWidth:DEFAULT_WIDTH value:DEFAULT_VALUE threshold:threshold_];
}

- (id)initWithWidth:(float)width value:(float)value_ threshold:(float)threshold_ {
	if (self = [super init]) {
		threshold = threshold_;
		
		background = getTexture(BLACK);
		
		foreground = getTexture(value_ >= threshold ? GREEN : RED);
		
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
	
	if (value < threshold) {
		[foreground release];
		foreground = getTexture(RED);
		
		threshold = 0;
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
