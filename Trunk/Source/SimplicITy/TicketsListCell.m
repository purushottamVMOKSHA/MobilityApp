//
//  TicketsListCell.m
//  SimplicITy
//
//  Created by Varghese Simon on 12/11/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "TicketsListCell.h"

@interface TicketsListCell ()
@property (weak, nonatomic) IBOutlet UIView *colorCodeView;
@property (weak, nonatomic) IBOutlet UILabel *ticketHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentAssignedLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStatusLabel;

@end

@implementation TicketsListCell
{
    NSDateFormatter *dateFormatter;
}

- (void)awakeFromNib {
    // Initialization code
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTicketModel:(TicketModel *)ticketModel
{
    _ticketModel = ticketModel;
    
    self.colorCodeView.backgroundColor = ticketModel.colorCode;
    self.ticketHeadingLabel.text = ticketModel.ticketSubject;
    self.agentAssignedLabel.text =  ticketModel.agentName;
    
    NSString * status = [NSString stringWithFormat:@"%@, %@",ticketModel.ticketNum, ticketModel.currentStatus];
    self.currentStatusLabel.text =status;
    self.timeLabel.text = ticketModel.timeStamp;
}

- (void)setRequestModel:(RequestModel *)requestModel
{
    _requestModel = requestModel;
    
    self.colorCodeView.backgroundColor = [self colorForImpact:requestModel.requestImpact];
    self.ticketHeadingLabel.text = requestModel.requestServiceName;
    
    self.timeLabel.text = [dateFormatter stringFromDate:requestModel.requestDate];
}

- (UIColor *)colorForImpact:(NSInteger)imapact
{
    switch (imapact)
    {
        case 0:
            return [UIColor greenColor];
            break;
          
        case 1:
            return [UIColor yellowColor];
            break;
            
        case 2:
            return [UIColor orangeColor];
            break;
        
        case 3:
            return [UIColor redColor];
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end
