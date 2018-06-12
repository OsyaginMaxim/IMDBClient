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

@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize imdbId;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
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
            }
            failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }
     ];
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
