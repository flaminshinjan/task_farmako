//
//  BatteryPlugin.m
//  Runner
//
//  Created by Shinjan Patra on 16/10/23.
//  BatteryPlugin.m
#import "BatteryPlugin.h"
#import <UIKit/UIKit.h>

@implementation BatteryPlugin

- (float)getBatteryLevel {
    UIDevice* device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    float batteryLevel = [device batteryLevel];
    // Returns the battery level. If battery monitoring is not enabled, battery level is -1.0.
    return batteryLevel;
}

@end
