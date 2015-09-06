//
//  TableViewController.m
//  FlipDiary
//
//  Created by shima on 2015/08/26.
//  Copyright (c) 2015年 shimashimasoft. All rights reserved.
//

#import "TableViewController.h"
#import "AppDelegate.h"
#import "Article.h"

#define CONST_CELLHEIGHT   50.00


@interface TableViewController ()

// 検索文字列
@property (strong, nonatomic) NSString *searchingText;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // ロード時のビュー変更処理
    if ([[AppDelegate appDelegate].articles count] == 0) {
        //データ0件の場合は編集ボタン、検索行を表示しない
    }else{
        [self configureView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[AppDelegate appDelegate].articles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleCell" forIndexPath:indexPath];
    
    // Configure the cell...
    // indexの記事をセットする
    Article *article = [AppDelegate appDelegate].articles[indexPath.row];
    // 整形された日付とタイトルをSPACEで連結して返す
    NSString *cellText = [article dateAndTitle];
    cell.textLabel.text = cellText;
    
    return cell;
}


// 編集ボタン押下時の処理
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[AppDelegate appDelegate].articles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if ([AppDelegate appDelegate].articles ) {
        Article *saveArticle = [[AppDelegate appDelegate].articles  objectAtIndex:fromIndexPath.row];
        [[AppDelegate appDelegate].articles  removeObjectAtIndex:fromIndexPath.row];
        [[AppDelegate appDelegate].articles  insertObject:saveArticle atIndex:toIndexPath.row];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
// テーブルコントロールから詳細画面に遷移する際に呼ばれる
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // セルを選択した場合
        // 選択したindexをセットする
        [AppDelegate appDelegate].articleIndex = [[self.tableView indexPathForSelectedRow]row];

    }else if([[segue identifier] isEqualToString:@"addArticle"]){
        // プラスボタンを押下した場合
        // 編集ボタンを使用可能にする
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        // 検索終了する
        [[AppDelegate appDelegate] searchEnd];
        // 新規記事を追加する
        [[AppDelegate appDelegate] pushNewArticle];
    }
}

// 詳細画面からテーブルコントロールに遷移する際に呼ばれる
-(IBAction)ReturnActionForSegue:(UIStoryboardSegue *)segue
{
}


// ロード時のビュー変更処理
-(void)configureView{

    // 左上に編集ボタンを追加する
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // 一番下に検索ボックスを追加する
    UISearchBar *sb = [UISearchBar new];
    sb.frame = CGRectMake(0, 0, self.view.bounds.size.width ,50);
    sb.delegate = self;
    sb.showsCancelButton = YES;
    sb.placeholder = @"search";
    self.tableView.tableFooterView = sb;
}


// テーブルコントロール表示時の処理
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //ここで呼ぶ事で詳細画面の変更が即時反映される

    // テーブルコントロールを再描画する
    [self.tableView reloadData];
    
    if ([AppDelegate appDelegate].articleIndex == 0) {
        // テーブルコントロールの一番下のデータを表示する
        [self scrollToBottom];
    }else{
        // 指定したIndexのデータを表示する
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[AppDelegate appDelegate].articleIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:0 animated:YES];
    }
}


// テーブルコントロールの一番下のデータを表示する
- (void)scrollToBottom{
    

    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        // 検索セルは表示しない
        offset.y -= CONST_CELLHEIGHT;
        [self.tableView setContentOffset:offset animated:YES];
    }
}


// 検索時（文字変更時）の処理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.searchingText = [NSString new];
    self.searchingText = searchText;
    
    // 編集ボタンを使用不可にする
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    // 編集中の状態を解除する
    self.tableView.editing = NO;
    // 検索開始する
    [[AppDelegate appDelegate] searchStart];
    // 検索文字列を受け取って検索する
    [[AppDelegate appDelegate] searching:searchText];
    // テーブルコントロールを再描画する
    [self.tableView reloadData];
}


// 検索キャンセル時の処理
- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar{
    
    // 検索終了する
    [[AppDelegate appDelegate] searchEnd];
    // 編集ボタンを使用可能にする
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    // キーボードを隠す
    [self.view endEditing: YES];
    // テーブルコントロールを再描画する
    [self.tableView reloadData];
    // テーブルコントロールの一番下のデータを表示する
    [self scrollToBottom];
}

@end
