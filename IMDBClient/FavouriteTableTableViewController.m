//
//  FavouriteTableTableViewController.m
//  IMDBClient
//
//  Created by Maksim  on 13.06.2018.
//  Copyright © 2018 Maksim . All rights reserved.
//

#import "FavouriteTableTableViewController.h"
#import "TVFavouriteCell.h"
#import <CoreData/CoreData.h>

@interface FavouriteTableTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayForID;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation FavouriteTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayForID = [[NSMutableArray alloc] init];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TVFavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favouriteCell" forIndexPath:indexPath];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityN" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    [request setEntity:entity];
    self.array = [[appDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    NSLog(@"For :");
    for (NSManagedObject *object in self.array) {
        NSLog(@"Object %@\n",[object valueForKey:@"title"]);
        [self.arrayForID addObject:[object valueForKey:@"imdbID"]];
        NSLog(@"Object with ID - %@", self.arrayForID[indexPath.row]);
    }
    cell.favouriteFilmName.text = [self.array[indexPath.row] valueForKey:@"title"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //DetailsViewController * detailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsView"];
    //[self.navigationController pushViewController:detailsView animated:YES];
    [self performSegueWithIdentifier:@"takeIdByFavourite" sender:indexPath];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
        NSLog(@"segue indexPath %ld",(long)indexPath);
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
