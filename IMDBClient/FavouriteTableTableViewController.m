//
//  FavouriteTableTableViewController.m
//  IMDBClient
//
//  Created by Maksim  on 13.06.2018.
//  Copyright © 2018 Maksim . All rights reserved.
//

#import "FavouriteTableTableViewController.h"
#import "TVFavouriteCell.h"
#import "AFNetworking/AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreData/CoreData.h>

@interface FavouriteTableTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayForID;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation FavouriteTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayForID = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"Favourite";
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(deleteAllFavourites)];
    
    self.navigationItem.rightBarButtonItem = sendButton;

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
     [self loadData];
    self.tableView.tableFooterView = [UIView new];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@"Count in numberOfRowsInSection - %lu", (unsigned long)self.array.count);
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TVFavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favouriteCell" forIndexPath:indexPath];
    cell.favouriteFilmName.text = [self.array[indexPath.row] valueForKey:@"title"];
    [cell.imageFavourite sd_setImageWithURL:[NSURL URLWithString:[self.array[indexPath.row] valueForKey:@"poster"]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
}

-(void) loadData{
    //[self.tableView reloadData];
    self.arrayForID = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityN" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    request.includesPropertyValues = false;
    [request setEntity:entity];
    self.array = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    NSLog(@"For : %@", self.array);
    NSLog(@"Count in loadData - %lu", (unsigned long)self.array.count);
    if(self.array.count){
        for (NSManagedObject *object in self.array) {
            NSLog(@"Object %@\n",[object valueForKey:@"title"]);
            [self.arrayForID addObject:[object valueForKey:@"imdbID"]];
            NSLog(@"Object with ID - %@", self.arrayForID);
        }
        //[self.tableView reloadData];
    }
    [self.tableView reloadData];
}

-(void) deleteAllFavourites{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityN" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSMutableArray *array = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    NSLog(@"Delete begin!");
    for (NSUInteger i = 0; i<array.count; i++) {
        [appDelegate.managedObjectContext deleteObject:[array objectAtIndex:i]];
        NSError *error = nil;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        NSLog(@"Delete!");
    }
    NSLog(@"Delete end!");
    [self.array removeAllObjects];
    [self.tableView reloadData];
    NSLog(@"ReloadData!");
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelect Favourite indexPath - %ld", (long)indexPath.row);
    [self performSegueWithIdentifier:@"takeIdByFavourite" sender:indexPath];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [self.tableView beginUpdates];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.managedObjectContext deleteObject:[self.array objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.array removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        [self.tableView endUpdates];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"takeIdByFavourite"]) {
        NSIndexPath *indexPath = sender; //[self.tableView indexPathsForSelectedRows];
        DetailsViewController *destViewController = segue.destinationViewController;
        destViewController.imdbId = self.arrayForID[indexPath.row] ;
        NSLog(@"self.arrayForID[indexPath.row] - %@ || indexPath.row - %ld  || self.arrayForID - %@", self.arrayForID[indexPath.row], indexPath.row, self.arrayForID);
        NSLog(@"segue takeIdByFavourite indexPath %ld, ID - %@",(long)indexPath.row, destViewController.imdbId);
    }else{
        NSLog(@"segue not found identifier");
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
