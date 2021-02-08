//
//  TagViewController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "TagViewController.h"

@interface TagViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UIButton *ensureSetBtn;
@property (nonatomic, weak) IBOutlet UITableView *tagTableView;
@property (nonatomic, strong) NSMutableArray *tagsArray;
@property (nonatomic, weak) IBOutlet UIView *addTagsView;
@end

@implementation TagViewController

- (NSMutableArray *)tagsArray {
    if (_tagsArray == nil) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tag设置";
    self.ensureSetBtn.layer.cornerRadius = 6;
    [self.addTagsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTagsClick)]];
}

- (void)addTagsClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加Tag" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    __weak typeof(self) weakself = self;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields[0];
        if (F_IsStringValue_GtEmpty(textField.text)) {
            [Utils AlertControllerWithTitle:@"请输入tag" andMessage:@""];
            return;
        }
        [weakself.tagsArray addObject:textField.text];
        [weakself.tagTableView reloadData];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入tags";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)ensureSetTagClick:(id)sender {
    if (self.tagsArray.count <= 0 ) {
        [Utils AlertControllerWithTitle:@"tags不能为空" andMessage:@""];
        return;
    }
    //tag只能包含中文字符、英文字母、0-9、+-*.的组合（不支持空格）
    [GeTuiSdk setTags:self.tagsArray andSequenceNum:@"seqtag-1"];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tagsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = self.tagsArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakself = self;
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself.tagsArray removeObjectAtIndex:indexPath.row];
            [weakself.tagTableView reloadData];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return NO;
}

@end
