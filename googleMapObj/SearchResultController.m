//
//  SearchResultController.m
//  googleMapObj
//
//  Created by Intern on 20/09/17.
//  Copyright © 2017 Intern. All rights reserved.
//

#import "SearchResultController.h"

@interface SearchResultController()
@end

@implementation SearchResultController

NSArray *searResults;

#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    searResults =[[NSMutableArray alloc] init];
    [self.tableView registerClass: [UITableViewCell class]  forCellReuseIdentifier:@"cell"];
}

#pragma mark - TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = searResults[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:true completion:nil];
    NSString *unescaped =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",searResults[indexPath.row]];;
    NSString *escapedString = [unescaped stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:escapedString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      if (data != nil)
                                      {
                                          NSError *e = nil;
                                          NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableLeaves error: &e];
                                          if (!jsonArray)
                                          {
                                              NSLog(@"Error parsing JSON: %@", e);
                                          }
                                          else
                                          {
                                             double lat = [[[[[[jsonArray valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry" ] valueForKey:@"location" ]valueForKey:@"lat" ]doubleValue ];
                                              double lon = [[[[[[jsonArray valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry" ] valueForKey:@"location" ]valueForKey:@"lng" ]doubleValue ];
                                              [self.delegate locateWithLongitude:lon andLatitude:lat andTitle: searResults[indexPath.row]];
                                          }
                                      }
                                  }];
                [task resume];
    
}

#pragma mark - ReloadDataInTableview

-(void) reloadDataWithArray:(NSMutableArray*) array
{
    searResults = array;
    NSLog(@"%@",searResults);
    [self.tableView reloadData];
}

@end
