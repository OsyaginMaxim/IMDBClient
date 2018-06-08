//
//  FilmCellTableViewCell.h
//  IMDBClient
//
//  Created by Maksim  on 08.06.2018.
//  Copyright © 2018 Maksim . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilmCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *imdbIDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageCell;

@end
