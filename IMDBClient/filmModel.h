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

@end
