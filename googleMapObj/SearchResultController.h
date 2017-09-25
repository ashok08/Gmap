//
//  SearchResultController.h
//  googleMapObj
//
//  Created by Intern on 20/09/17.
//  Copyright © 2017 Intern. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LocateOnTheMap

-(void) locateWithLongitude:(double) lon
                andLatitude:(double) lat
                   andTitle: (NSString*) title;

@end
@interface SearchResultController : UITableViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) id <LocateOnTheMap> delegate;
-(void) reloadDataWithArray:(NSArray*) array;
@end
