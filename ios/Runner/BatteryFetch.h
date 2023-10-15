//
//  BatteryFetch.h
//  Runner
//
//  Created by Shinjan Patra on 15/10/23.
//

// BatteryFetcher.h
#import <Foundation/Foundation.h>

@interface BatteryFetch : NSObject

- (void)fetchBatteryLevelWithCompletion:(void (^)(float batteryLevel))completion;

@end
