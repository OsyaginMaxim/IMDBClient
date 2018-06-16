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
@property(nonatomic) BOOL alreadySet;
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
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityN" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSMutableArray *array = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    NSLog(@"For :");
    BOOL notFavourite = YES;
    for (NSManagedObject *object in array) {
        NSLog(@"Object %@\n",[object valueForKey:@"title"]);
        if(self.imdbId == [object valueForKey:@"imdbID"]){
            self->fModel = [[filmModel alloc] init];
            self.name.text = [object valueForKey:@"title"];
            self.genre.text = [object valueForKey:@"genre"];
            self.rating.text = [object valueForKey:@"rating"];
            self.director.text = [object valueForKey:@"director"];
            self.actors.text = [object valueForKey:@"actors"];
            self.runtime.text = [object valueForKey:@"runtime"];
            self.released.text = [object valueForKey:@"released"];
            self.discript.text = [object valueForKey:@"discript"];
            [self.poster sd_setImageWithURL:[NSURL URLWithString:[object valueForKey:@"poster"]]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            self.navigationItem.title = [object valueForKey:@"title"];
            notFavourite = NO;
            self.alreadySet = YES;
            break;
        }
            
    }
    
    
    if (notFavourite){
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
                    self->fModel.imdb = self.imdbId;
                    self->fModel.director = [responseObject valueForKey:@"Director"];
                    self->fModel.actors = [responseObject valueForKey:@"Actors"];
                    self->fModel.runtime = [responseObject valueForKey:@"Runtime"];
                    self->fModel.discript = [responseObject valueForKey:@"Plot"];
                    self.alreadySet = NO;
                    //self->fModel.favoriteFlag = @"true";
                
                }
                failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }
         ];
    }
}
- (IBAction)save:(id)sender {
    if(!self.alreadySet){
        AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //NSManagedObjectContext * context = [self managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"EntityN" inManagedObjectContext:appDelegate.managedObjectContext];
        //NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        //[entity setValue:self->fModel.filmName forKey:@"title"];
    
        [entity setValue:self->fModel.filmName forKey:@"title"];
        [entity setValue:self->fModel.type forKey:@"genre"];
        [entity setValue:self->fModel.year forKey:@"released"];
        [entity setValue:self->fModel.imdbID forKey:@"rating"];
        [entity setValue:self->fModel.imageUrl forKey:@"poster"];
        [entity setValue:self->fModel.director forKey:@"director"];
        [entity setValue:self->fModel.actors forKey:@"actors"];
        [entity setValue:self->fModel.discript forKey:@"discript"];
        [entity setValue:self->fModel.imdb forKey:@"imdbID"];
        [entity setValue:self->fModel.favoriteFlag forKey:@"flag"];
        [entity setValue:self->fModel.runtime forKey:@"runtime"];
        [entity setValue:@"true" forKey:@"flag"];
        NSError *error;
        BOOL isSaved = [appDelegate.managedObjectContext save:&error];
        NSLog(@"%d - successfully saved", isSaved);
        self.alreadySet = YES;
    }else{
        NSLog(@"already saved!");
    }
    
    
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
