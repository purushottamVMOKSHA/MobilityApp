//
//  NewsContentModel.h
//  SimplicITy
//
//  Created by Vmoksha on 23/02/15.
//  Copyright (c) 2015 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsContentModel : NSObject

@property(nonatomic,assign) NSInteger ID;
@property (nonatomic,strong) NSString *newsCode;
@property (nonatomic,strong) NSString *newsDetails;
@property (nonatomic,strong) NSDate *recivedDate;
@property (nonatomic,assign)BOOL viewed;
@property (nonatomic,strong)NSString *subject;
@end
