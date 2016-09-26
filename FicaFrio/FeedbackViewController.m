//
//  FeedbackViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "FeedbackViewController.h"
#import "BD.h"
#import "Step.h"
@import Charts;

@interface FeedbackViewController () <ChartViewDelegate>{
    NSArray *pickerData;
    NSArray *arrayAutoexposicao;
    NSArray *arrayEstudos;
    NSArray *arrayTrabalho;
    NSArray *arrayInteracaoSocial;
    NSArray *arrayOutros;
    NSArray *tags;
    NSDictionary* tagsMedia;
    Step *currentStep;
    double average;
    BD *dataBD;
}
@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTag;
@property (weak, nonatomic) IBOutlet UILabel *mediaTag;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *nodata;
- (IBAction)back:(id)sender;


@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titulo.text = NSLocalizedString(@"Heart Rate", "");
    _nodata.text = NSLocalizedString(@"No data available!", "");
    
    //BD - para buscar as informaçoes
    dataBD = [[BD alloc] init];
    
    //Inicializa as configs do grafico
    [self setChar];
    
    //busca no banco as informaçoes sobre cada Tag
    [self inicializaVetoresTag];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

-(void)setChar{
    //Configuraçao de estilo do grafico
    _lineChartView.delegate = self;
    _lineChartView.descriptionText = NSLocalizedString(@"Tap node for details", "");
    _lineChartView.descriptionTextColor = [UIColor whiteColor];
    _lineChartView.dragEnabled = YES;
    [_lineChartView setScaleEnabled:YES];
    _lineChartView.pinchZoomEnabled = YES;
    _lineChartView.drawGridBackgroundEnabled = YES;
    _lineChartView.gridBackgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha: .0f];
    _lineChartView.noDataText = @" ";
    _lineChartView.noDataTextColor = [UIColor blueColor];
    _lineChartView.xAxis.drawGridLinesEnabled = NO;
    _lineChartView.leftAxis.drawGridLinesEnabled = NO;
    _lineChartView.backgroundColor = [UIColor colorWithRed: 0/255.0f green: 0/255.0f blue: 0/255.0f alpha:.0f];
    _lineChartView.xAxis.enabled = NO;
    _lineChartView.leftAxis.enabled = NO;
    _lineChartView.legend.enabled = NO;
    
    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:7.0 label:@""];
    [_lineChartView.xAxis addLimitLine:llXAxis];
    
    
    //BalloonMarker
    BalloonMarker *maker = [[BalloonMarker alloc] initWithColor: [UIColor colorWithRed: 94/255.0f green: 170/255.0f blue: 170/255.0f alpha: 0.4f] font: [UIFont systemFontOfSize:12.0] textColor: UIColor.whiteColor insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    maker.chartView = _lineChartView;
    maker.minimumSize = CGSizeMake(80.f, 40.f);
    _lineChartView.marker = maker;
    _nodata.hidden = YES;
}

- (void)setCharData:(double)valor valor2:(NSArray*)valor2{
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    int j = 0;
    average = 0;
    
    for (int i = 0; i <valor2.count; i++) {
        currentStep = valor2[valor2.count-i-1];
        if([currentStep.avgHeartRate integerValue] > 0){
            [yVals2 addObject:[[ChartDataEntry alloc] initWithX:(i-j) y:[currentStep.avgHeartRate doubleValue]]];
            average = average + [currentStep.avgHeartRate doubleValue];
        }else{
            j++;
        }
        
    }
    
    if(yVals2.count>0){
        average = average/(valor2.count-j);
        for (int i = 0; i <yVals2.count; i++){
            [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i  y: average]];
        }
        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:(valor2.count - 1) y:[currentStep.avgHeartRate doubleValue]]];
    }else{
        average = 0;
    }
    
    LineChartDataSet *set1 = nil;
    LineChartDataSet *set2 = nil;
    
    if (_lineChartView.data.dataSetCount > 0){
        if (valor2.count == 0){
            _lineChartView.data = nil;
            _nodata.hidden = NO;
        }else{
            set1 = (LineChartDataSet *)_lineChartView.data.dataSets[0];
            set2 = (LineChartDataSet *)_lineChartView.data.dataSets[1];
            set1.values = yVals1;
            set2.values = yVals2;
            _nodata.hidden = YES;
        }
        [_lineChartView.data notifyDataChanged];
        [_lineChartView notifyDataSetChanged];
        [_lineChartView animateWithXAxisDuration: 1.5];
    }else{
        set1 = [[LineChartDataSet alloc] initWithValues: yVals1 label:@""];
        set2 = [[LineChartDataSet alloc] initWithValues: yVals2 label:@""];
        set1.axisDependency = AxisDependencyLeft;
        set2.axisDependency = AxisDependencyLeft;
        [set1 setColor: [UIColor colorWithRed:120.0f/255.0f green:189.0f/255.0f blue:186.0f/255.0f alpha:5.0f]];
        [set2 setColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:249.0f/255.0f alpha:5.0f]];
        [set2 setCircleColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:249.0f/255.0f alpha:5.0f]];
        set1.lineWidth = 2.0;
        set2.lineWidth = 2.0;
        set1.drawCirclesEnabled = NO;
        set2.circleRadius = 6.0;
        set1.fillAlpha = 65 / 255.0;
        set2.fillAlpha = 65 / 255.0;
        set1.fillColor = [UIColor whiteColor];
        set2.fillColor = [UIColor whiteColor];
        set2.highlightColor = [[UIColor whiteColor] colorWithAlphaComponent:0.f];
        set1.highlightColor = [[UIColor whiteColor] colorWithAlphaComponent:0.f];
        set2.drawCircleHoleEnabled = true;
        set2.mode = LineChartModeCubicBezier;
        set1.mode = LineChartModeLinear;
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
        if(yVals2.count > 0){
            _lineChartView.data = data;
            _nodata.hidden = YES;
        }else{
            _nodata.hidden = NO;
        }
        _lineChartView.rightAxis.enabled = NO;
        [_lineChartView animateWithXAxisDuration:1.5];
    }
    
    //Media da Tag
    _mediaTag.text = [[NSNumber numberWithDouble:average] stringValue];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   
    return pickerData[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerData[row] isEqualToString:[pickerData objectAtIndex:1]]){
        [self setCharData: 85.0 valor2:arrayEstudos];
        
    }
    if ([pickerData[row] isEqualToString:[pickerData objectAtIndex:0]]){
        [self setCharData: 85.0 valor2:arrayAutoexposicao];
        
    }
    if ([pickerData[row] isEqualToString: [pickerData objectAtIndex:2]]){
        [self setCharData: 85.0 valor2:arrayTrabalho];
        
    }
    if ([pickerData[row] isEqualToString:[pickerData objectAtIndex:3]]){
        [self setCharData: 85.0 valor2:arrayInteracaoSocial];
        
    }
    if ([pickerData[row] isEqualToString:[pickerData objectAtIndex:4]]){
        [self setCharData: 85.0 valor2:arrayOutros];
        
    }
   
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextColor:[UIColor whiteColor]];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        //[pickerLabel setFont:[UIFont fontWithName:@"SF-Compact-Display-Regular.otf" size: 17]];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    }
    [pickerLabel setText:[pickerData objectAtIndex:row]];
    return pickerLabel;
}

-(void)ordenaPickerView{
    //PikerView
    //inicializaçao
    pickerData = @[tags[0], tags[1], tags[2], tags[3], tags[4]];
    
    //Connect data
    _pickerTag.dataSource = self;
    _pickerTag.delegate = self;

    
}

-(void)inicializaVetoresTag{
    arrayAutoexposicao = [dataBD fetchStepsWithTag: NSLocalizedString(@"Self-exposure", "")];
    arrayEstudos = [dataBD fetchStepsWithTag: NSLocalizedString(@"Studies", "")];
    arrayInteracaoSocial = [dataBD fetchStepsWithTag: NSLocalizedString(@"Social interaction", "")];
    arrayTrabalho = [dataBD fetchStepsWithTag: NSLocalizedString(@"Work", "")];
    arrayOutros = [dataBD fetchStepsWithTag: NSLocalizedString(@"Others", "")];
    tagsMedia = @{
                  NSLocalizedString(@"Self-exposure", "") : [NSDecimalNumber numberWithDouble:[self calculateAverange:arrayAutoexposicao]],
                  NSLocalizedString(@"Studies", "") : [NSDecimalNumber numberWithDouble:[self calculateAverange:arrayEstudos]],
                  NSLocalizedString(@"Social interaction", "") : [NSDecimalNumber numberWithDouble:[self calculateAverange:arrayInteracaoSocial]],
                  NSLocalizedString(@"Work", "") : [NSDecimalNumber numberWithDouble:[self calculateAverange:arrayTrabalho]],
                  NSLocalizedString(@"Others", "") : [NSDecimalNumber numberWithDouble:[self calculateAverange:arrayOutros]],};
    tags = [tagsMedia keysSortedByValueUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
               return [obj2 compare:obj1];
           }];
    NSLog(@"%@", tags);
    [self ordenaPickerView];
}


- (IBAction)back:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

-(double)calculateAverange:(NSArray*)array{
    double media = 0;
    int j = 0;
    for (int i = 0; i <array.count; i++) {
        currentStep = array[array.count-i-1];
        if([currentStep.avgHeartRate integerValue] > 0){
            media = media + [currentStep.avgHeartRate doubleValue];
        }else{
            j++;
        }
        
    }

    return media/(array.count-j);
}
@end




