//
//  ViewController.m
//  IMDBClient
//
//  Created by Maksim  on 07.06.2018.
//  Copyright © 2018 Maksim . All rights reserved.
//

#import "ViewController.h"
#import "filmModel.h"
#import "AFNetworking/AFNetworking.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController{
    NSURL *URL;
    NSMutableArray *arrayObjects;
    NSMutableArray *arrayModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayModels = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    [self loadData:searchText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.lableTitle
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
- (void) loadData:(NSString *)text{
    AFHTTPSessionManager *manager   = [AFHTTPSessionManager manager];
    [manager    GET:[NSString stringWithFormat:@"http://www.omdbapi.com/?apikey=373557b&s=%@", text]
         parameters:nil
           progress:nil
            success:^(NSURLSessionTask *task, id responseObject) {
                filmModel *model = [[filmModel alloc]init];
                self->arrayObjects = [responseObject objectForKey:@"Search"];
                NSLog(@"array: %@",self->arrayObjects);
                for(int i = 0; i < self->arrayObjects.count; i++){
                    model.filmName = [self->arrayObjects[i] valueForKey:@"Title"];
                    model.type = [self->arrayObjects[i] valueForKey:@"Type"];
                    model.year = [self->arrayObjects[i] valueForKey:@"Year"];
                    model.imdbID = [self->arrayObjects[i] valueForKey:@"imdbID"];
                    model.imageUrl = [self->arrayObjects[i] valueForKey:@"Poster"];
                    [self->arrayModels addObject:model];
                }
                NSLog(@"%lu", (unsigned long)self->arrayObjects.count);
                NSLog(@"%@", self->arrayModels);
                //NSLog(@"Actors:%@", [responseObject valueForKey:@"Actors"]);
            }
            failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }
     ];
}

@end
