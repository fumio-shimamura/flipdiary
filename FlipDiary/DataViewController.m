//
//  DataViewController.m
//  FlipDiary
//
//  Created by shima on 2015/08/26.
//  Copyright (c) 2015年 shimashimasoft. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 記事データをセットする
    self.dataLabel.text = self.articleObject.yyyymmddAndHhss;
    self.articleTitle.text = self.articleObject.title;
    self.articleBody.text = self.articleObject.body;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 変更を反映する
    self.articleObject.title = self.articleTitle.text;
    self.articleObject.body = self.articleBody.text;
}

- (IBAction)viewTapped:(id)sender {
    // キーボードを隠す
    [self.view endEditing: YES];
}

@end
