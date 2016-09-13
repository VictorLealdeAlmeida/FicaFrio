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
    _lineChartView.drawGridBackgroundEnabled = NO;
    
    _lineChartView.descriptionTextColor = [UIColor blueColor];
    _lineChartView.gridBackgroundColor = [UIColor darkGrayColor];
    _lineChartView.noDataText = @"No data provided";;
    NSMutableArray *mes = [NSMutableArray arrayWithObjects: @"Jan",@"Feb",@"Mar",@"Apr",@"May",@"June",@"July",@"August",@"Sept", @"Oct",@"Nov", @"Dec", nil];
    NSMutableArray *valor = [NSMutableArray array];
    for (NSInteger i = 0; i < 12; i++)
        [valor addObject:[NSNumber numberWithInteger:i*3]];
    [self setCharData:mes valor:valor];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


    // Dispose of any resources that can be recreated.
}

- (void)setCharData:(NSMutableArray*)mes valor:(NSMutableArray*)valor{
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <mes.count; i++) {
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i  y:[valor[i] doubleValue]]];
    }
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues: yVals1 label:@"First Set"];
    set1.axisDependency = AxisDependencyLeft;
    [set1 setColor: [[UIColor redColor] colorWithAlphaComponent:0.5f]];
    [set1 setCircleColor:[UIColor redColor]];
    set1.lineWidth = 2.0;
    set1.circleRadius = 6.0; // the radius of the node circle
    set1.fillAlpha = 65 / 255.0;
    set1.fillColor = [UIColor blueColor];
    set1.highlightColor = [UIColor whiteColor];
    set1.drawCircleHoleEnabled = true;
    
    //3 - create an array to store our LineChartDataSets
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject: set1];
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    
    
    
    
    //4 - pass our months in for our x-axis label value along with our dataSets
    [data setValueTextColor: [UIColor whiteColor]];
    
    //5 - finally set our data
    _lineChartView.data = data;
    _lineChartView.rightAxis.enabled = NO;
    [_lineChartView animateWithXAxisDuration:1.0];
    
}


@end




