//
//  FeedbackViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "FeedbackViewController.h"
@import Charts;

@interface FeedbackViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lineChartView.delegate = self;
    _lineChartView.descriptionText = @"Tap node for details";
    _lineChartView.dragEnabled = YES;
    [_lineChartView setScaleEnabled:YES];
    _lineChartView.pinchZoomEnabled = YES;
    _lineChartView.drawGridBackgroundEnabled = YES;
    _lineChartView.descriptionTextColor = [UIColor whiteColor];
    _lineChartView.gridBackgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha: .0f];
    _lineChartView.noDataText = @"No data provided";
    _lineChartView.xAxis.drawGridLinesEnabled = NO;
    _lineChartView.leftAxis.drawGridLinesEnabled = NO;
    _lineChartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    _lineChartView.backgroundColor = [UIColor colorWithRed: 0/255.0f green: 0/255.0f blue: 0/255.0f alpha:.0f];
    _lineChartView.xAxis.enabled = NO;
    _lineChartView.leftAxis.enabled = NO;
    _lineChartView.legend.enabled = NO;
    
    NSMutableArray *valor = [NSMutableArray array];
    NSArray *array = @[@2, @5, @7, @1, @4, @19, @21, @25, @30, @32, @37, @40];
    for (NSInteger i = 0; i < 12; i++)
        [valor addObject:[NSNumber numberWithInteger:i*3]];
    [self setCharData:valor valor2:array];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


    // Dispose of any resources that can be recreated.
}

- (void)setCharData:(NSMutableArray*)valor valor2:(NSArray*)valor2{
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <9; i++) {
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i  y:[valor[i] doubleValue]]];
        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:i y:[valor2[i] doubleValue]]];
    }
    [yVals1 addObject:[[ChartDataEntry alloc] initWithX:8  y:[valor[8] doubleValue]]];
    [yVals2 addObject:[[ChartDataEntry alloc] initWithX:8 y:[valor2[8] doubleValue]]];
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues: yVals1 label:@"First Set"];
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithValues: yVals2 label:@"Será que vai"];
    set1.axisDependency = AxisDependencyLeft;
    set2.axisDependency = AxisDependencyLeft;
    [set1 setColor: [UIColor colorWithRed:23.0f/255.0f green:77.0f/255.0f blue:96.0f/255.0f alpha:5.0f]];
    [set2 setColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:249.0f/255.0f alpha:5.0f]];
    [set1 setCircleColor:[UIColor colorWithRed:23.0f/255.0f green:77.0f/255.0f blue:96.0f/255.0f alpha:5.0f]];
    [set2 setCircleColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:249.0f/255.0f alpha:5.0f]];
    set1.lineWidth = 2.0;
    set2.lineWidth = 2.0;
    set1.circleRadius = 6.0; // the radius of the node circle
    set2.circleRadius = 6.0;
    set1.fillAlpha = 65 / 255.0;
    set2.fillAlpha = 65 / 255.0;
    //set1.fillColor = [UIColor blueColor];
    //set2.fillColor = [UIColor yellowColor];
    set1.highlightColor = [[UIColor yellowColor] colorWithAlphaComponent:0.f];
    set2.highlightColor = [[UIColor redColor] colorWithAlphaComponent:0.f];
    set1.drawCircleHoleEnabled = true;
    set2.drawCircleHoleEnabled = true;
    //set2.mode = LineChartModeCubicBezier;
    //set1.mode = LineChartModeCubicBezier;
    set1.drawCubicEnabled = YES;
    set2.drawCubicEnabled = YES;
    set1.drawValuesEnabled = NO;
    set2.drawValuesEnabled = NO;
    
    
    //3 - create an array to store our LineChartDataSets
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject: set1];
    [dataSets addObject:set2];
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    
    
    //4 - pass our months in for our x-axis label value along with our dataSets
    [data setValueTextColor: [UIColor whiteColor]];
    
    //5 - finally set our data
    _lineChartView.data = data;
    _lineChartView.rightAxis.enabled = NO;
    [_lineChartView animateWithXAxisDuration:1.0];
    
}


@end




