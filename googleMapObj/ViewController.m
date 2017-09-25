//
//  ViewController.m
//  googleMapObj
//
//  Created by Intern on 20/09/17.
//  Copyright © 2017 Intern. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultController.h"
@import GoogleMaps;
@import GooglePlaces;

@interface ViewController () <UISearchBarDelegate,GMSAutocompleteFetcherDelegate,LocateOnTheMap,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *gmap;
@end

@implementation ViewController

GMSMapView *googlemap;
SearchResultController *search;
GMSAutocompleteFetcher *gmsFetch;
NSMutableArray *Results;
NSMutableArray *markersArray;
NSInteger count = 1;

#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    Results = [[NSMutableArray alloc]init];
    markersArray = [[NSMutableArray alloc] init];
}

#pragma mark - viewDidAppear

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    googlemap.frame = self.gmap.frame;
    [self.view addSubview: googlemap];
    search = [[SearchResultController alloc]init];
    search.delegate = self;
    gmsFetch = [[GMSAutocompleteFetcher alloc]init];
    gmsFetch.delegate = self;
}

#pragma mark - SearchLocation

- (IBAction)search:(id)sender
{
    count = 1;
    UISearchController *searc = [[UISearchController alloc]
                                 initWithSearchResultsController: search];
    searc.searchBar.delegate = self;
    [self presentViewController:searc animated:YES completion:nil];
}

#pragma mark - GMSAutocompleteFetcherDelegate

- (void)didAutocompleteWithPredictions:(NSArray<GMSAutocompletePrediction *> *)predictions
{
    GMSAutocompletePrediction *prediction ;
    for (prediction in predictions)
    {
        NSString *string = prediction.attributedFullText.string;
        [Results addObject:string];
    }
    [search reloadDataWithArray:Results];
}
- (void)didFailAutocompleteWithError:(NSError *)error
{
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [Results removeAllObjects];
    [gmsFetch sourceTextHasChanged:searchText];
}

#pragma mark - ProtocolMethodForMarker

- (void)locateWithLongitude:(double)lon andLatitude:(double)lat andTitle:(NSString *)title
{
        dispatch_sync(dispatch_get_main_queue(), ^{
        CLLocationCoordinate2D  position = CLLocationCoordinate2DMake(lat, lon);
        GMSMarker *maker = [GMSMarker markerWithPosition:position];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:10];
        googlemap.camera = camera;
        googlemap = [GMSMapView mapWithFrame:self.view.frame camera:camera];
        [self.view addSubview:googlemap];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,50)];
        UIImage *pin = [UIImage imageNamed:@"pin3"];
        CGRect frame = CGRectMake(0, 0,50, 50);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = pin;
        UILabel *label = [UILabel new];
        label.text = @"1";
        label.frame = CGRectMake(20, 0, 25, 25);
        [label sizeToFit];
        [view addSubview:imageView];
        [view addSubview:label];
        UIImage *markerIcon = [self imageFromView:view];
        maker.title = title;
        maker.icon = markerIcon;
        maker.map = googlemap;
        googlemap.delegate = self;
        [googlemap setSelectedMarker:maker];
    });
}

#pragma mark - SettingMarkerImage

- (UIImage *)imageFromView:(UIView *) view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    }
    else
    {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView
didTapPOIWithPlaceID:(NSString *)placeID
           name:(NSString *)name
       location:(CLLocationCoordinate2D)location
{
    count = count + 1;
    GMSMarker *maker = [GMSMarker markerWithPosition:location];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    UIImage *pin = [UIImage imageNamed:@"pin3"];
    CGRect frame = CGRectMake(0, 0, 50, 50);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = pin;
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(20, 0, 25, 25);
    label.text = [NSString stringWithFormat:@"%ld", (long)count];
    [label sizeToFit];
    [view addSubview:imageView];
    [view addSubview:label];
    UIImage *markerIcon = [self imageFromView:view];
    maker.title = name;
    maker.icon = markerIcon;
    maker.map = googlemap;
    googlemap.delegate = self;
    [googlemap setSelectedMarker:maker];
}

@end
