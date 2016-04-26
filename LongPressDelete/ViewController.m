//
//  ViewController.m
//  LongPressDelete
//
//  Created by 黄海燕 on 16/4/26.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

{
     UITableView *_tableView;
     NSMutableArray *_dataArray;
    NSIndexPath *_indexPath;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self creatDataSource];
    [self creatTableView];
}

-(void)creatDataSource
{
    //先实例化数据源
    _dataArray = [[NSMutableArray alloc]init];
   
    for (int z = 0; z<20; z++) {
        
        NSString *string = [NSString stringWithFormat:@"title第%d行",z];
        NSString *subString = [NSString stringWithFormat:@"subTitlt第%d行",z];
        NSDictionary *dict = [[NSDictionary alloc]init];
        dict = @{@"title":string,@"subTitle":subString};
        
        [_dataArray addObject:dict];
    }
    NSLog(@"%@",_dataArray);
}

-(void)creatTableView{
    //第二个参数
    
    // UITableViewStylePlain  基本类型 只有一组
    
    //UITableViewStyleGroup   分组类型 先确定有几组 再确定每组有几个cell
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //只要创建tableview  代理方法和数据源方法 就要及时写出来 是必须的
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

//应该让这个tableview 每组显示多少行数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

//关于tableviewcell的复用机制 返回参数就是 UITableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //我创建一个静态标识符 来给每一个cell加上标记 方便我们从复用队列里面取到 名字为该标记的cell

    //    static NSString *reuseID = @"ID";

    //我创建一个cell  先从复用队列 dequeue  里面用上面创建的静态标识符来取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];

    //做一个if判断 如果队列里面没有这个cell  那我们就创建一个新的 并且 还要给这个cell 加上复用标识符

    if (!cell) {

        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];

    }


    //给tableviewcell上面加载数据

    //    indexPath.section  indexPath.row的理解 indexPath是定位用的 到底定位到 哪一组还是哪一行 根据情况来看
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row][@"title"];

    cell.detailTextLabel.text = [_dataArray objectAtIndex:indexPath.row][@"subTitle"];
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
  
    [cell addGestureRecognizer:longPressGR];
    return cell;
    
}

-(void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gesture locationInView:_tableView];
        _indexPath = [_tableView indexPathForRowAtPoint:point];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"确定删除吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",
                              nil];
        alert.tag = 1;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
        }
        else if (buttonIndex == 1)
        {
            //1.先从网络删除要删除的数据，网络删除成功之后，
            
            
            //2.再删除本地选中的数据
            [_dataArray removeObjectAtIndex:_indexPath.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

//设置每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
