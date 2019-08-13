
/*!
 @header RecommendViewController.m
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/3/13
 
 @version 1.00 16/3/13 Creation(版本信息)
 
   Copyright © 2016年 zhengwenming. All rights reserved.
 */

#import "RecommendViewController.h"
#import "HelpHeaderFile.h"
#import "anxinbao-Bridging-Header.h"
#import "Utils.h"
#import "IntAxisValueFormatter.h"
#import "DateValueFormatter.h"
#import "MyDateFormatter.h"

@interface RecommendViewController (){
    NSString* type1,*type2;
    ChartYAxis *leftAxis,*leftAxis1;
}
@property UIScrollView* contentView;
@property BarChartView* barChartView;
@property BarChartView* barChartView1;
@property UIButton* m;
@property UIButton* w;
@property UIButton* d;
@property UIButton* m1;
@property UIButton* w1;
@property UIButton* d1;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.view.frame.size.height)];
    BarChartView *barChartView = [[BarChartView alloc] initWithFrame:CGRectMake(18, 55, MainScreenWidth-27, 180)];
    [self.contentView addSubview:barChartView];
    [self.view addSubview:self.contentView];
    self.barChartView = barChartView;
    
    BarChartView *barChartView1 = [[BarChartView alloc] initWithFrame:CGRectMake(18, 340, MainScreenWidth-27, 180)];
    self.barChartView1 = barChartView1;

    [self initChart:barChartView];
    [self initChart1:barChartView1];
    [self.contentView addSubview:barChartView1];


    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(20, 15, 12.5, 13.5)];
    v.backgroundColor=RGBACOLOR(255, 91, 91, 1);
    [self.contentView addSubview:v];
    
    UIView* v2=[[UIView alloc] initWithFrame:CGRectMake(20, 300, 12.5, 13.5)];
    v2.backgroundColor=RGBACOLOR(249, 200, 81, 1);
    [self.contentView addSubview:v2];
    
    [Utils addLabel:ASLocalizedString(@"尿量")For:self.contentView withFrame:CGRectMake(37.5, 15, 150, 14) withDefineColor:RGBACOLOR(136, 136, 136, 1) withSize:14];
    
    UIButton* m=[Utils addButton:@"" For:self.contentView withFrame:CGRectMake(MainScreenWidth-139, 15, 40, 22.5) withBg:@"month" withDefineColor:ThemeColor withSize:12];
    UIButton* w=[Utils addButton:@"" For:self.contentView withFrame:CGRectMake(MainScreenWidth-99, 15, 40, 22.5) withBg:@"week" withDefineColor:ThemeColor withSize:12];
    UIButton* d=[Utils addButton:@"" For:self.contentView withFrame:CGRectMake(MainScreenWidth-59, 15, 40, 22.5) withBg:@"day" withDefineColor:ThemeColor withSize:12];
    
    [Utils addLabel:ASLocalizedString(@"用片量(片)") For:self.contentView withFrame:CGRectMake(37.5, 300, 180, 14) withDefineColor:RGBACOLOR(136, 136, 136, 1) withSize:14];
    
    UIButton* m1=[Utils addButton:@"" For:self.contentView withFrame:CGRectMake(MainScreenWidth-139, 300, 40, 22.5) withBg:@"month" withDefineColor:ThemeColor withSize:12];
    UIButton* w1=[Utils addButton:@"" For:self.contentView withFrame:CGRectMake(MainScreenWidth-99, 300, 40, 22.5) withBg:@"week" withDefineColor:ThemeColor withSize:12];
    UIButton* d1=[Utils addButton:@"" For:self.contentView withFrame:CGRectMake(MainScreenWidth-59, 300, 40, 22.5) withBg:@"day" withDefineColor:ThemeColor withSize:12];
    self.m1=m1;
    self.w1=w1;
    self.d1=d1;
    self.m=m;
    self.w=w;
    self.d=d;
    type1=type2=@"m";
    [m setBackgroundImage:[UIImage imageNamed:@"monthhigh"] forState:UIControlStateSelected];
    [m setTitle:ASLocalizedString(@"月") forState:UIControlStateNormal];
    [m setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [m setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [m1 setBackgroundImage:[UIImage imageNamed:@"monthhigh"] forState:UIControlStateSelected];
    [m1 setTitle:ASLocalizedString(@"月") forState:UIControlStateNormal];
    [m1 setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [m1 setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [w setBackgroundImage:[UIImage imageNamed:@"weekhigh"] forState:UIControlStateSelected];
    [w setTitle:ASLocalizedString(@"周") forState:UIControlStateNormal];
    [w setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [w setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [w1 setBackgroundImage:[UIImage imageNamed:@"weekhigh"] forState:UIControlStateSelected];
    [w1 setTitle:ASLocalizedString(@"周") forState:UIControlStateNormal];
    [w1 setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [w1 setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [d setBackgroundImage:[UIImage imageNamed:@"dayhigh"] forState:UIControlStateSelected];
    [d setTitle:ASLocalizedString(@"日") forState:UIControlStateNormal];
    [d setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [d setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [d1 setBackgroundImage:[UIImage imageNamed:@"dayhigh"] forState:UIControlStateSelected];
    [d1 setTitle:ASLocalizedString(@"日") forState:UIControlStateNormal];
    [d1 setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [d1 setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [m addTarget:self action:@selector(chooseMonth) forControlEvents:UIControlEventTouchDown];
    [m1 addTarget:self action:@selector(chooseMonth1) forControlEvents:UIControlEventTouchDown];
    [w addTarget:self action:@selector(chooseWeek) forControlEvents:UIControlEventTouchDown];
    [w1 addTarget:self action:@selector(chooseWeek1) forControlEvents:UIControlEventTouchDown];
    [d addTarget:self action:@selector(chooseDay) forControlEvents:UIControlEventTouchDown];
    [d1 addTarget:self action:@selector(chooseDay1) forControlEvents:UIControlEventTouchDown];
    UIView* v1=[[UIView alloc] initWithFrame:CGRectMake(0, 262.5, MainScreenWidth, 15)];
    v1.backgroundColor=RGBACOLOR(240, 240, 240, 1);
    [self.contentView addSubview:v1];
    [self.contentView setContentSize:CGSizeMake(MainScreenWidth, 550)];
    [self getData1];
    [self getData2];
    [m setSelected:YES];
    [m1 setSelected:YES];
}

-(void)chooseMonth{
    [self.m setSelected:YES];
    [self.w setSelected:NO];
    [self.d setSelected:NO];
    type1=@"m";
    [self getData1];
}

-(void)chooseWeek{
    [self.m setSelected:NO];
    [self.w setSelected:YES];
    [self.d setSelected:NO];
    type1=@"w";
    [self getData1];
}

-(void)chooseDay{
    [self.m setSelected:NO];
    [self.w setSelected:NO];
    [self.d setSelected:YES];
    type1=@"d";
    [self getData1];
}

-(void)chooseMonth1{
    [self.m1 setSelected:YES];
    [self.w1 setSelected:NO];
    [self.d1 setSelected:NO];
    type2=@"m";
    [self getData2];
}

-(void)chooseWeek1{
    [self.m1 setSelected:NO];
    [self.w1 setSelected:YES];
    [self.d1 setSelected:NO];
    type2=@"w";
    [self getData2];
}

-(void)chooseDay1{
    [self.m1 setSelected:NO];
    [self.w1 setSelected:NO];
    [self.d1 setSelected:YES];
    type2=@"d";
    [self getData2];
}

-(void) getData1{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"id"]=_pid;
    params[@"type"]=type1;
    [self.appDel getData:@"urine_statistic" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            [_barChartView clear];
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            NSArray* data=[dict objectForKey:@"data"];
            [self setDataCount:data];
        }else if(i==10){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_barChartView clear];
        }
    }];
    
}

-(void) getData2{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"id"]=_pid;
    params[@"type"]=type2;
    [self.appDel getData:@"diaper_statistic" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            [_barChartView1 clear];
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            NSArray* data=[dict objectForKey:@"data"];
            [self setDataCount1:data];
        }else if(i==10){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_barChartView1 clear];
        }
    }];
    
}

-(void)initChart:(BarChartView*)barChartView{
    //barChartView.backgroundColor = [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
    barChartView.noDataText = ASLocalizedString(@"暂无数据");//没有数据时的文字提示
    barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
    barChartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
    
    barChartView.scaleYEnabled = NO;//取消Y轴缩放
    barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    barChartView.dragEnabled = NO;//YES;//启用拖拽图表
    barChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    barChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    
    barChartView.borderLineWidth=0.5;
    barChartView.drawBordersEnabled=YES;
    barChartView.borderColor=RGBACOLOR(216, 216, 216, 1);
    
    ChartXAxis *xAxis = barChartView.xAxis;
    xAxis.axisLineWidth = 0.5;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    xAxis.granularity = 1.0; // only intervals of 1 day
    //xAxis.forceLabelsEnabled = YES;
    //xAxis.axisMinimum=0.5;
    xAxis.labelCount=12;
    //xAxis.axisMaximum=12;
    //xAxis.avoidFirstLastClippingEnabled=YES;
    xAxis.axisRange=1;
    xAxis.axisLineColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];//网格线颜色
    xAxis.labelTextColor = RGBACOLOR(136, 136, 136, 1);//label文字颜色

    leftAxis = barChartView.leftAxis;//获取左边Y轴
    leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis.axisLineWidth = 0.5;//Y轴线宽
    //leftAxis.forceLabelsEnabled = YES;
    leftAxis.axisMinimum=0;
    leftAxis.labelCount=4;
    //leftAxis.axisMaximum=4;
    leftAxis.labelTextColor = RGBACOLOR(136, 136, 136, 1);//label文字颜色
    leftAxis.axisRange=1;
    IntAxisValueFormatter* f2=[[IntAxisValueFormatter alloc] init];
    f2.unit=@"ml";
    leftAxis.valueFormatter=f2;
    //leftAxis.axisMinLabels
    leftAxis.axisLineColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];//网格线颜色
    //leftAxis.axisMinValue = 0;
    
    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
    leftAxis.gridColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];//网格线颜色
    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
    
    barChartView.rightAxis.enabled = NO;
    
    leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在柱形图的后面
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.backgroundColor = [UIColorFromRGB(0xeeeeee) CGColor];
    //指定邊線位置在view的下方
    bottomLayer.frame = CGRectMake(CGRectGetMaxX(barChartView.bounds)-1, 0, 0.5, barChartView.bounds.size.height);
    //[barChartView.layer addSublayer:bottomLayer];    //self.navigationItem.titleView = navView;
    
    barChartView.legend.enabled = NO;//不显示图例说明
    [barChartView setChartDescription:nil];//不显示，就设为空字符串即可
}

-(void)initChart1:(BarChartView*)barChartView{
    //barChartView.backgroundColor = [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
    barChartView.noDataText = ASLocalizedString(@"暂无数据");//没有数据时的文字提示
    barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
    barChartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
    
    barChartView.scaleYEnabled = NO;//取消Y轴缩放
    barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    barChartView.dragEnabled = NO;//YES;//启用拖拽图表
    barChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    barChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    
    barChartView.borderLineWidth=0.5;
    barChartView.drawBordersEnabled=YES;
    barChartView.borderColor=RGBACOLOR(216, 216, 216, 1);
    
    ChartXAxis *xAxis = barChartView.xAxis;
    xAxis.axisLineWidth = 0.5;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    xAxis.granularity = 1.0; // only intervals of 1 day
    //xAxis.forceLabelsEnabled = YES;
    //xAxis.axisMinimum=0.5;
    xAxis.labelCount=12;
    //xAxis.axisMaximum=12;
    //xAxis.avoidFirstLastClippingEnabled=YES;
    xAxis.axisRange=1;
    xAxis.axisLineColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];//网格线颜色
    xAxis.labelTextColor = RGBACOLOR(136, 136, 136, 1);//label文字颜色
    
    leftAxis1 = barChartView.leftAxis;//获取左边Y轴
    leftAxis1.forceLabelsEnabled = NO;//不强制绘制制定数量的label
    leftAxis1.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis1.axisLineWidth = 0.5;//Y轴线宽
    //leftAxis1.forceLabelsEnabled = YES;
    leftAxis1.axisMinimum=0;
    leftAxis1.labelCount=4;
    //leftAxis.axisMaximum=4;
    leftAxis1.labelTextColor = RGBACOLOR(136, 136, 136, 1);//label文字颜色
    leftAxis1.axisRange=1;
    IntAxisValueFormatter* f2=[[IntAxisValueFormatter alloc] init];
    f2.unit=ASLocalizedString(@"片");
    leftAxis1.valueFormatter=f2;
    //leftAxis.axisMinLabels
    leftAxis1.axisLineColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];//网格线颜色
    //leftAxis.axisMinValue = 0;
    
    leftAxis1.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
    leftAxis1.gridColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];//网格线颜色
    leftAxis1.gridAntialiasEnabled = YES;//开启抗锯齿
    
    barChartView.rightAxis.enabled = NO;
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.backgroundColor = [UIColorFromRGB(0xeeeeee) CGColor];
    //指定邊線位置在view的下方
    bottomLayer.frame = CGRectMake(CGRectGetMaxX(barChartView.bounds)-1, 0, 0.5, barChartView.bounds.size.height);
    //[barChartView.layer addSublayer:bottomLayer];    //self.navigationItem.titleView = navView;
    
    barChartView.legend.enabled = NO;//不显示图例说明
    [barChartView setChartDescription:nil];//不显示，就设为空字符串即可
}

- (void)setDataCount:(NSArray*)list
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSMutableArray* dd=[[NSMutableArray alloc] init];
    NSMutableArray* yvalues=[[NSMutableArray alloc] init];
    int maxy=0;
    for (int i = 0; i < list.count; i++)
    {
        /*{
         "diaper_num": "1",
         "date": "2018年04月13日",
         "time_type": "20180413"
         }*/
        NSDictionary* o=list[i];
        NSString* time=[o[@"time_type"] stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
        NSString* num=o[@"capacity_num"];
        int y=[num intValue];
        if(maxy<y){
            maxy=y;
        }
        [dd addObject:time];
        [yvalues addObject:[NSNumber numberWithInt:y]];
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yvalues[i] intValue]]];
    }
    ChartXAxis *xAxis = _barChartView.xAxis;
    MyDateFormatter* f=[[MyDateFormatter alloc] initWithDate:dd];
    xAxis.valueFormatter = f;
    xAxis.labelCount=list.count+2;
    leftAxis.axisMaximum=maxy+100;
    leftAxis.labelCount=MIN(4,maxy+1);
    BarChartDataSet *set1 = nil;
    if (_barChartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_barChartView.data.dataSets[0];
        set1.values = yVals;
        [_barChartView.data notifyDataChanged];
        [_barChartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
        [set1 setColor:RGBACOLOR(255, 91, 91, 1)];
        set1.drawValuesEnabled = NO;//是否在柱形图上面显示数值
        //[set1 setColors:ChartColorTemplates.material];
        set1.drawIconsEnabled = NO;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        //set1.barSpace = 0.5;
        data.barWidth = 0.66f;
        
        _barChartView.data = data;
    }
}

- (void)setDataCount1:(NSArray*)list
{
    //NSInteger max=8;
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSDate* min=[NSDate date];
    NSDate* max=[[NSDate alloc] initWithTimeIntervalSince1970:0];
    NSMutableArray* dd=[[NSMutableArray alloc] init];
    NSMutableArray* yvalues=[[NSMutableArray alloc] init];
    int maxy=0;
    for (int i = 0; i < list.count; i++)
    {
        NSDictionary* o=list[i];
        NSString* time=[o[@"time_type"] stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
        NSString* num=o[@"diaper_num"];
        int y=[num intValue];
        if(maxy<y){
            maxy=y;
        }
        [dd addObject:time];
        [yvalues addObject:[NSNumber numberWithInt:y]];
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yvalues[i] intValue]]];
    }
    ChartXAxis *xAxis = _barChartView1.xAxis;
    MyDateFormatter* f=[[MyDateFormatter alloc] initWithDate:dd];
    xAxis.valueFormatter = f;
    maxy=MAX(8,maxy);
    leftAxis1.axisMaximum=maxy;
    leftAxis.labelCount=MIN(8,maxy+1);
    BarChartDataSet *set1 = nil;
    if (_barChartView1.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_barChartView1.data.dataSets[0];
        set1.values = yVals;
        [_barChartView1.data notifyDataChanged];
        [_barChartView1 notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
        [set1 setColor:RGBACOLOR(255, 91, 91, 1)];
        set1.drawValuesEnabled = NO;//是否在柱形图上面显示数值
        //[set1 setColors:ChartColorTemplates.material];
        set1.drawIconsEnabled = NO;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        //set1.barSpace = 0.5;
        data.barWidth = 0.66f;
        
        _barChartView1.data = data;
    }
}

-(void)showDetailViewController:(UITapGestureRecognizer *)sender{
    //[self.navigationController pushViewController:[DetailViewController new] animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect r=_contentView.frame;
    CGRect r1=[[UIApplication sharedApplication] statusBarFrame];
    r.size.height=self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-r1.size.height;
    _contentView.frame=r;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
}

@end
