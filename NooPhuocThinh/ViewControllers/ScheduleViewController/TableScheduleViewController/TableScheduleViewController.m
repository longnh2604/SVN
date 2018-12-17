//
//  TableScheduleViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/29/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "TableScheduleViewController.h"
#import "CustomCellScheduleHome.h"
#import "DetailsScheduleViewController.h"

@interface TableScheduleViewController ()

@end

@implementation TableScheduleViewController

@synthesize listSchedule;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



//****************************************************************************//
#pragma mark - Main

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


- (void)viewWillAppear:(BOOL)animated
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//****************************************************************************//
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"listSchedule.count: %d",listSchedule.count);
    return listSchedule.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellScheduleHome *cell = [self setCustomTableViewCellForWithIndexPath:indexPath];
    
    return cell;
}

//-- set up table view cell for iPhone
-(CustomCellScheduleHome *) setCustomTableViewCellForWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sbCustomCellScheduleHomeId";
    CustomCellScheduleHome *cell = (CustomCellScheduleHome *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCellScheduleHome" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CustomCellScheduleHome *) currentObject;
                break;
            }
        }
        
        //hiepph
        [self setDataForTableViewCell:cell withIndexPath:indexPath];
    }
    
    //hiepph
//    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}

-(CustomCellScheduleHome *)setDataForTableViewCell:(CustomCellScheduleHome *)cell withIndexPath:(NSIndexPath *)indexPath
{
    //-- set color background for cell
//    if ((indexPath.row%2) == 0)
//        cell.contentView.backgroundColor = COLOR_SCHEDULE_CELL_BOLD;
//    else
//        cell.contentView.backgroundColor = COLOR_SCHEDULE_CELL_REGULAR;
    
    if ([listSchedule count]>0) {
        
        Schedule *schedule = (Schedule*)[listSchedule objectAtIndex:indexPath.row];
        cell.lblCity.text = [NSString stringWithFormat:@"%@: %@", schedule.cityName, schedule.locationEventAddress];
        cell.lblAddress.text = schedule.locationEventAddress;
        cell.lblEventTitle.text = schedule.name;
        
        //-- convert schedule time
        cell.lblTimer.text = [Utility convertScheduleTime:schedule.startDate];
        
        //-- convert schedule calendar
        [self convertScheduleCalendar:schedule.startDate];
        
        cell.lblMonth.text = scheduleMonth;
        cell.lblDay.text = scheduleDay;
        
        NSURL *url = [NSURL URLWithString:schedule.imageFilePath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.imgView.image = [UIImage imageWithData:data];
    }
    
    //hiepph - set distance between cells
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 112, 320, 5)];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f
                                                        green:240.0f/255.0f
                                                         blue:240.0f/255.0f
                                                        alpha:1.0f];// you can also put image here
    [cell.contentView addSubview:separatorLineView];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //-- pass Delegate
    [[self delegate] goToDetailScheduleViewControllerWithListData:listSchedule withIndexRow:indexPath.row];
}



#pragma mark - Convert timer

- (void) convertScheduleCalendar:(NSString *)date
{
    NSDate *dateC = [Utility dateFromString:date];
    
    //-- set date format day
    NSDateFormatter *dateFormatDay = [[NSDateFormatter alloc] init];
    [dateFormatDay setDateFormat:@"dd"];// you can use your format.
    scheduleDay = [dateFormatDay stringFromDate:dateC];
    NSLog(@"scheduleDay:%@",scheduleDay);
    
    //-- set date format month
    NSDateFormatter *dateFormatMonth = [[NSDateFormatter alloc] init];
    [dateFormatMonth setDateFormat:@"MM"];// you can use your format.
    scheduleMonth = [dateFormatMonth stringFromDate:dateC];
    NSLog(@"scheduleMonth:%@",scheduleMonth);
    
    if ([scheduleMonth isEqualToString:@"01"]) {
        scheduleMonth = @"JAN";
    }else if ([scheduleMonth isEqualToString:@"02"]){
        scheduleMonth = @"FEB";
    }else if ([scheduleMonth isEqualToString:@"03"]){
        scheduleMonth = @"MAR";
    }else if ([scheduleMonth isEqualToString:@"04"]){
        scheduleMonth = @"APR";
    }else if ([scheduleMonth isEqualToString:@"05"]){
        scheduleMonth = @"MAY";
    }else if ([scheduleMonth isEqualToString:@"06"]){
        scheduleMonth = @"JUN";
    }else if ([scheduleMonth isEqualToString:@"07"]){
        scheduleMonth = @"JUL";
    }else if ([scheduleMonth isEqualToString:@"08"]){
        scheduleMonth = @"AUG";
    }else if ([scheduleMonth isEqualToString:@"09"]){
        scheduleMonth = @"SEP";
    }else if ([scheduleMonth isEqualToString:@"10"]){
        scheduleMonth = @"OCT";
    }else if ([scheduleMonth isEqualToString:@"11"]){
        scheduleMonth = @"NOV";
    }else if ([scheduleMonth isEqualToString:@"12"]){
        scheduleMonth = @"DEC";
    }
}


@end
