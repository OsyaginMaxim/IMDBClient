//
//  DetailsViewController.h
//  IMDBClient
//
//  Created by Maksim  on 11.06.2018.
//  Copyright © 2018 Maksim . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DetailsViewController : UIViewController <NSFetchedResultsControllerDelegate>


@property(nonatomic, strong) NSString *imdbId;
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *genre;
@property (weak, nonatomic) IBOutlet UITextView *rating;
@property (weak, nonatomic) IBOutlet UITextView *director;
@property (weak, nonatomic) IBOutlet UITextView *actors;
@property (weak, nonatomic) IBOutlet UITextView *runtime;
@property (weak, nonatomic) IBOutlet UITextView *released;
@property (weak, nonatomic) IBOutlet UITextView *discript;


@end
