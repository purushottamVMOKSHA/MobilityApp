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
    
    self.ticketHeadingLabel.font = [UIFont fontWithName:@"MuseoSans-700" size:16];
    self.agentAssignedLabel.font = [UIFont fontWithName:@"MuseoSans-300" size:12];
    self.timeLabel.font = [UIFont fontWithName:@"MuseoSans-300" size:12];
    self.currentStatusLabel.font = [UIFont fontWithName:@"MuseoSans-300" size:12];
    
    self.ticketHeadingLabel.highlightedTextColor = [UIColor whiteColor];
    self.agentAssignedLabel.highlightedTextColor = [UIColor whiteColor];
    self.timeLabel.highlightedTextColor = [UIColor whiteColor];
    self.currentStatusLabel.highlightedTextColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRequestModel:(RequestModel *)requestModel
{
    _requestModel = requestModel;
    
    self.colorCodeView.backgroundColor = [self colorForImpact:requestModel.requestImpact];
    self.ticketHeadingLabel.text = requestModel.requestServiceName;
    
    self.timeLabel.text = [dateFormatter stringFromDate:requestModel.requestDate];
    
    NSString *staus = [requestModel.requestIncidentNo stringByAppendingString:@", New"];
    self.currentStatusLabel.text = staus;
}

-(void)setTicketListModel:(TicketListModel *)ticketListModel
{
    _ticketListModel = ticketListModel;
    
//    self.colorCodeView.backgroundColor = [self colorForImpact:ticketListModel.requestImpact];
//    self.colorCodeView.backgroundColor = [self colorForImpact:<#(NSInteger)#>];
    self.ticketHeadingLabel.text = ticketListModel.serviceName;
    
//    self.timeLabel.text = [dateFormatter stringFromDate:requestModel.requestDate];
    
//    NSString *staus = [ticketListModel.requestIncidentNo stringByAppendingString:@", New"];
    
    self.agentAssignedLabel.text = ticketListModel.agentname;
    self.currentStatusLabel.text = ticketListModel.status;
    
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
