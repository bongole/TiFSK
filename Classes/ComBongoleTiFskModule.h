/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import <AVFoundation/AVFoundation.h>
#import "TiModule.h"
#import "FSKRecognizer.h"
#import "AudioSignalAnalyzer.h"
#import "CharReceiver.h"
#import "FSKSerialGenerator.h"

@interface ComBongoleTiFskModule : TiModule<AVAudioSessionDelegate, CharReceiver>
{
    FSKRecognizer *recognizer;
    AudioSignalAnalyzer *analyzer;
    FSKSerialGenerator *generator;
}

@end
