//
//  TicketsListCell.h
//  SimplicITy
//
//  Created by Varghese Simon on 12/11/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketModel.h"
#import "RequestModel.h"
@interface TicketsListCell : UITableViewCell

@property (nonatomic, strong) TicketModel *ticketModel;
@property (nonatomic, strong) RequestModel *requestModel;

@end
