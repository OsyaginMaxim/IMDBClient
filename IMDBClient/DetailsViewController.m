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
@property(nonatomic) BOOL notFavourite;
@end

@implementation DetailsViewController

@synthesize imdbId, fModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.genre setUserInteractionEnabled:NO];
    [self.rating setUserInteractionEnabled:NO];
    [self.director setUserInteractionEnabled:NO];
    [self.discript setUserInteractionEnabled:NO];
    [self.released setUserInteractionEnabled:NO];
    [self.actors setUserInteractionEnabled:NO];
    [self.runtime setUserInteractionEnabled:NO];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
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
    self.notFavourite = YES;
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
            self.notFavourite = NO;
            self.alreadySet = YES;
            break;
        }
            
    }
    self.favorite.backgroundColor = [UIColor yellowColor];
    [self.favorite setTitle:@"from favorite" forState:UIControlStateNormal];
    
    
    if (self.notFavourite){
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
                
                }
                failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }
         ];
        self.favorite.backgroundColor = [UIColor redColor];
        [self.favorite setTitle:@"in favorite" forState:UIControlStateNormal];
    }
}
- (IBAction)save:(id)sender {
    if(!self.alreadySet){
        AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"EntityN" inManagedObjectContext:appDelegate.managedObjectContext];
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
        [self.favorite setTitle:@"from favorite" forState:UIControlStateNormal];
        self.favorite.backgroundColor = [UIColor yellowColor];
    }else{
        NSLog(@"already saved!");
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityN" inManagedObjectContext:appDelegate.managedObjectContext];
        NSFetchRequest *request =[[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSMutableArray *array = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
        NSUInteger i = 0;
        for (NSManagedObject *object in array) {
            NSLog(@"Object %@\n",[object valueForKey:@"title"]);
            NSLog(@"For : %@", array);
            NSLog(@"For : %lu", (unsigned long)i);
            NSLog(@"imdbId in object before if - %@ || imdbId in self.imdbId - %@", [object valueForKey:@"imdbID"], self.imdbId);
            if(self.imdbId == [object valueForKey:@"imdbID"]){
                NSLog(@"imdbId in object after if - %@ || imdbId in self.imdbId - %@", [object valueForKey:@"imdbID"], self.imdbId);
                [appDelegate.managedObjectContext deleteObject:[array objectAtIndex:i]];
                NSError *error = nil;
                if (![appDelegate.managedObjectContext save:&error]) {
                    NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                    return;
                }
                NSLog(@"Delete!");
                self.notFavourite = YES;
                self.alreadySet = NO;
                break;
            }
            i++;
            
        }
        [self.favorite setTitle:@"in favorite" forState:UIControlStateNormal];
        self.favorite.backgroundColor = [UIColor redColor];
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
