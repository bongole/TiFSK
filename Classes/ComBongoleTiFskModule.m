/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComBongoleTiFskModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"


@implementation ComBongoleTiFskModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"f5f696a5-319b-4ef5-8cff-04d0bfeb63c0";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.bongole.ti.fsk";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    session.delegate = self;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    
    recognizer = [[[FSKRecognizer alloc] init] retain];
    [recognizer addReceiver:self];
    analyzer = [[[AudioSignalAnalyzer alloc] init] retain];
    [analyzer addRecognizer:recognizer];
    
    generator = [[[FSKSerialGenerator alloc] init] retain];
    [generator play];
    
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
    
    [analyzer stop];
    RELEASE_TO_NIL(analyzer);
    RELEASE_TO_NIL(recognizer);
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

- (void) receivedChar:(char)input
{
    NSDictionary *e  = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%c", input], @"char"
                         ,nil
                        ];
    
    [self fireEvent:@"data" withObject:e];
}

-(void)startAnalyzing:(id)args
{
    [analyzer record];
}

-(void)stopAnalyzing:(id)args
{
    [analyzer stop];
}

-(void)send:(id)args
{
    NSString *data;
    ENSURE_ARG_AT_INDEX(data, args, 0, NSString);
    
    const char* bytes = [data UTF8String];
    int bytes_len = [data length];
    [generator writeBytes:(const UInt8 *)bytes length: bytes_len];
}

@end
