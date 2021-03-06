//
//  ViewController.m
//  IMDBClient
//
//  Created by Maksim  on 07.06.2018.
//  Copyright © 2018 Maksim . All rights reserved.
//

#import "ViewController.h"
#import "filmModel.h"
#import "FilmCellTableViewCell.h"
#import "AFNetworking/AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailsViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayModels;

@end

@implementation ViewController{

    NSURL *URL;
    NSMutableArray *arrayObjects;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayModels = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    UITapGestureRecognizer * handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCloseKeyboard)];
    [self.view addGestureRecognizer:handleTap];
    handleTap.cancelsTouchesInView = false;
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(deleteAllFavourites)];
    self.navigationItem.rightBarButtonItem = sendButton;
    // Do any additional setup after loading the view, typically from a nib.

    self.tableView.tableFooterView = [UIView new];
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
    //[self.array removeAllObjects];
    //[self.tableView reloadData];
    NSLog(@"ReloadData!");
    
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    [self loadData:searchText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleCloseKeyboard {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    FilmCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.nameLabel.text = [self.arrayModels[indexPath.row] valueForKey:@"filmName"];
    cell.yearLabel.text = [self.arrayModels[indexPath.row] valueForKey:@"year"];
    cell.typeLabel.text = [self.arrayModels[indexPath.row] valueForKey:@"type"];
    cell.imdbIDLabel.text = [self.arrayModels[indexPath.row] valueForKey:@"imdbID"];
    [cell.imageCell sd_setImageWithURL:[NSURL URLWithString:[self.arrayModels[indexPath.row] valueForKey:@"imageUrl"]]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
- (void) loadData:(NSString *)text{
    [self.arrayModels removeAllObjects];
    AFHTTPSessionManager *manager   = [AFHTTPSessionManager manager];
    [manager    GET:[NSString stringWithFormat:@"http://www.omdbapi.com/?apikey=373557b&s=%@", text]
         parameters:nil
           progress:nil
            success:^(NSURLSessionTask *task, id responseObject) {
                
                self->arrayObjects = [responseObject objectForKey:@"Search"];
                NSLog(@"array: %@",self->arrayObjects);
                for(int i = 0; i < self->arrayObjects.count; i++){
                    filmModel *model = [[filmModel alloc]init];

                    model.filmName = [self->arrayObjects[i] valueForKey:@"Title"];
                    model.type = [self->arrayObjects[i] valueForKey:@"Type"];
                    model.year = [self->arrayObjects[i] valueForKey:@"Year"];
                    model.imdbID = [self->arrayObjects[i] valueForKey:@"imdbID"];
                    model.imageUrl = [self->arrayObjects[i] valueForKey:@"Poster"];
                    [self.arrayModels addObject:model];
                    NSLog(@"Flag - %@", model.favoriteFlag);
                }
                [self.tableView reloadData];
                NSLog(@"%lu", (unsigned long)self->arrayObjects.count);
                NSLog(@"%@", self.arrayModels);
            }
            failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }
     ];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"segue takeId indexPath %ld",(long)indexPath.row);
    [self performSegueWithIdentifier:@"takeId" sender:indexPath];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Tab on Done");
    [self.searchBar resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"takeId"]) {
        NSIndexPath *indexPath = sender;
        DetailsViewController *destViewController = segue.destinationViewController;
        destViewController.imdbId = [self.arrayModels[indexPath.row] valueForKey:@"imdbID"];
        NSLog(@"segue takeId indexPath %ld",(long)indexPath.row);
    }else{
        NSLog(@"segue not found identifier");
    }
}

@end
