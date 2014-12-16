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
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    
    // добавлен в Main.storyboard
    [self.mapTypeControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged]; // устанавливаем @selector для SegmentedControl для выбора типа карт
    self.mapTypeControl.clipsToBounds = YES;
    self.mapTypeControl.backgroundColor = [UIColor whiteColor];
    self.mapTypeControl.alpha = .75f;
    
    // кастомизация кнопок ZOOM
    for (UIButton *zoomButton in self.zoomButtonsCollection) {
        zoomButton.layer.cornerRadius = 5;
        zoomButton.alpha = .75f;
        zoomButton.backgroundColor = [UIColor whiteColor];
        zoomButton.layer.borderColor = [UIColor grayColor].CGColor;
        zoomButton.layer.borderWidth = 1;
        zoomButton.clipsToBounds = YES;
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

@end