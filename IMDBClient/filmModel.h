//
//  filmModel.h
//  IMDBClient
//
//  Created by Maksim  on 08.06.2018.
//  Copyright © 2018 Maksim . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface filmModel : NSObject

@property (nonatomic, strong) NSString *filmName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *imdbID;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *favoriteFlag;
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *actors;
@property (nonatomic, strong) NSString *discript;
@property (nonatomic, strong) NSString *runtime;
@property (nonatomic, strong) NSString *imdb;

@end
