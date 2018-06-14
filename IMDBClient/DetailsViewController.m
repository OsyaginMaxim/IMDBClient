//
//  DetailsViewController.m
//  IMDBClient
//
//  Created by Maksim  on 11.06.2018.
//  Copyright © 2018 Maksim . All rights reserved.
//
#import "AFNetworking/AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailsViewController.h"
#import <CoreData/CoreData.h>
#import "filmModel.h"


@interface DetailsViewController ()
@property(nonatomic, strong) filmModel *fModel;
@end

@implementation DetailsViewController
@synthesize imdbId, fModel;
//@synthesize managedObjectContext;

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize fetchedResultsController;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    //fModel = [[filmModel alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData{
    AFHTTPSessionManager *manager   = [AFHTTPSessionManager manager];
    [manager    GET:[NSString stringWithFormat:@"http://www.omdbapi.com/?apikey=373557b&i=%@", imdbId]
         parameters:nil
           progress:nil
            success:^(NSURLSessionTask *task, id responseObject) {
                NSLog(@"IMDB ID: %@", self.imdbId);
                self->fModel = [[filmModel alloc] init];
                self.name.text = [responseObject valueForKey:@"Title"];
                self.genre.text = [responseObject valueForKey:@"Genre"];
                self.rating.text = [responseObject valueForKey:@"Rating"];
                self.director.text = [responseObject valueForKey:@"Director"];
                self.actors.text = [responseObject valueForKey:@"Actors"];
                self.runtime.text = [responseObject valueForKey:@"Runtime"];
                self.released.text = [responseObject valueForKey:@"Released"];
                self.discript.text = [responseObject valueForKey:@"Plot"];
                [self.poster sd_setImageWithURL:[NSURL URLWithString:[responseObject valueForKey:@"Poster"]]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                self.navigationItem.title = [responseObject valueForKey:@"Title"];
                self->fModel.filmName = [responseObject valueForKey:@"Title"];
                self->fModel.type = [responseObject valueForKey:@"Genre"];
                self->fModel.year = [responseObject valueForKey:@"Released"];
                self->fModel.imdbID = [responseObject valueForKey:@"Rating"];
                self->fModel.imageUrl = [responseObject valueForKey:@"Poster"];
            }
            failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }
     ];
}
- (IBAction)save:(id)sender {
    //AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    //[record setValue:self->fModel.filmName forKey:@"title"];
    [record setValue:self->fModel.filmName forKey:@"title"];
    //[record setValue:self->fModel.type forKey:@"genre"];
    //[record setValue:self->fModel.year forKey:@"released"];
    //[record setValue:self->fModel.imdbID forKey:@"rating"];
    //[record setValue:self->fModel.imageUrl forKey:@"poster"];
    
    NSError *error;
    BOOL isSaved = [self.managedObjectContext save:&error]; //[appDelegate.managedObjectContext save:&error];
    NSLog(@"%d - successfully saved", isSaved);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
