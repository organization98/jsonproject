//
//  MapViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "LocationManager.h"
#import "MapAnnotation.h"
#import "UIView+MKAnnotationView.h"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *zoomButtonsCollection;

@end

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mapView.delegate = self; // устанавливаем delegate для mapView
    
    [[LocationManager sharedManager] startTrackLocation];
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setRotateEnabled: YES]; // добовляет поворот карты и отображение компаса
    
    // SegmentedControl добавлен в Main.storyboard
    [self.mapTypeControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged]; // устанавливаем @selector для SegmentedControl для выбора типа карт
    self.mapTypeControl.clipsToBounds = YES;
    self.mapTypeControl.layer.cornerRadius = 4;
    self.mapTypeControl.backgroundColor = [UIColor whiteColor];
    self.mapTypeControl.alpha = .75f;
    
    // кастомизация кнопок ZOOM
    for (UIButton *zoomButton in self.zoomButtonsCollection) {
        zoomButton.backgroundColor = [UIColor whiteColor];
        zoomButton.alpha = .75f;
        zoomButton.layer.borderColor = [UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0f].CGColor; // iOS tintBlueColor
        zoomButton.layer.borderWidth = 1;
        zoomButton.layer.cornerRadius = 4;
        zoomButton.clipsToBounds = YES;
        zoomButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Zoom

- (IBAction)zoomInButton:(id)sender {
    MKCoordinateRegion currentRegion = self.mapView.region; // получаем текущий регион
    currentRegion.span.latitudeDelta = currentRegion.span.latitudeDelta / 3;
    currentRegion.span.longitudeDelta = currentRegion.span.longitudeDelta / 3; // изменяем дельту по широте и долнгате
    [self.mapView setRegion:currentRegion animated:YES];
}

- (IBAction)zoomOutButton:(id)sender {
    MKCoordinateRegion currentRegion = self.mapView.region; // получаем текущий регион
    currentRegion.span.latitudeDelta = currentRegion.span.latitudeDelta * 3;
    currentRegion.span.longitudeDelta = currentRegion.span.longitudeDelta * 3; // изменяем дельту по широте и долнгате
    if (currentRegion.span.latitudeDelta > 180 || currentRegion.span.latitudeDelta > 180) {
        return;
    } else {
        [self.mapView setRegion:currentRegion animated:YES];
    }
}


#pragma mark - MapType Control

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl {
    switch (aSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
}


#pragma mark - Location Manager delegates

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
/*
 - (NSString *)deviceLocation {
 return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
 }
 
 - (NSString *)deviceLat {
 return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
 }
 
 - (NSString *)deviceLon {
 return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
 }
 
 - (NSString *)deviceAlt {
 return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end