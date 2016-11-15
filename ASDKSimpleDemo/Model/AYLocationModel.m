//
//  AYLocationModel.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYLocationModel.h"
#import <CoreLocation/CLGeocoder.h>

@implementation AYLocationModel
{
    BOOL _placemarkFetchInProgress;
    void (^_placemarkCallbackBlock)(AYLocationModel *);
}

#pragma mark - Lifecycle

- (nullable instancetype)initWith500pxPhoto:(NSDictionary *)dictionary
{
    NSNumber *latitude  = [dictionary objectForKey:@"latitude"];
    NSNumber *longitude = [dictionary objectForKey:@"longitude"];
    
    // early return if location is "<null>"
    if (![latitude isKindOfClass:[NSNumber class]] || ![longitude isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        // set coordiantes
        _coordinates = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        
        // get CLPlacemark with MKReverseGeocoder
        [self beginReverseGeocodingLocationFromCoordinates];
    }
    
    return self;
}

#pragma mark - Instance Methods

// return location placemark if fetched, else set completion block for fetch finish
- (void)reverseGeocodedLocationWithCompletionBlock:(void (^)(AYLocationModel *))blockName
{
    if (_placemark) {
        
        // call block if placemark already fetched
        if (blockName) {
            blockName(self);
        }
        
    } else {
        
        // set placemark reverse geocoding completion block
        _placemarkCallbackBlock = blockName;
        
        // if fetch not in progress, begin
        if (!_placemarkFetchInProgress) {
            
            [self beginReverseGeocodingLocationFromCoordinates];
        }
    }
}


#pragma mark - Helper Methods

- (void)beginReverseGeocodingLocationFromCoordinates
{
    if (_placemarkFetchInProgress) {
        return;
    }
    _placemarkFetchInProgress = YES;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_coordinates.latitude longitude:_coordinates.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // completion handler gets called on main thread
        _placemark      = [placemarks lastObject];
        _locationString = [self locationStringFromCLPlacemark];
        
        // check if completion block set, call it - DO NOT CALL A NIL BLOCK!
        if (_placemarkCallbackBlock) {
            
            // call the block with arguments
            _placemarkCallbackBlock(self);
        }
    }];
}

- (nullable NSString *)locationStringFromCLPlacemark
{
    if (!_placemark)
    {
        return nil;
    }

    NSString *locationString;
    
    if (_placemark.inlandWater) {
        locationString = _placemark.inlandWater;
    } else if (_placemark.subLocality && _placemark.locality) {
        locationString = [NSString stringWithFormat:@"%@, %@", _placemark.subLocality, _placemark.locality];
    } else if (_placemark.administrativeArea && _placemark.subAdministrativeArea) {
        locationString = [NSString stringWithFormat:@"%@, %@", _placemark.subAdministrativeArea, _placemark.administrativeArea];
    } else if (_placemark.country) {
        locationString = _placemark.country;
    } else {
        locationString = @"ERROR";
    }
    
    return locationString;
}

@end
