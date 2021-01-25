//
//  ViewController.m
//  OCProjectTools
//
//  Created by chao on 2021/1/24.
//

#import "ViewController.h"
#import "ECDialogSelectionViewViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *MenuBtn;
@property (copy, nonatomic) NSArray *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.MenuBtn.backgroundColor = UIColor.orangeColor;
    self.items = @[@"C语言",@"Java",@"Python",@"C++",@"C#",@"Visual Basic"];
}
- (IBAction)menuClick:(UIButton *)sender {
    
    ECDialogSelectionViewViewController *dialogViewController = ECDialogSelectionViewViewController.new;
    dialogViewController.navTitle = @"类别选择";
    dialogViewController.items = self.items;
    dialogViewController.allowsTheSameResponse = YES;
    dialogViewController.selectedItemIndex = [self.items indexOfObject:self.MenuBtn.currentTitle];
    dialogViewController.heightForItemBlock = ^CGFloat (ECDialogSelectionViewViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    dialogViewController.didSelectItemBlock = ^(ECDialogSelectionViewViewController *aDialogViewController, NSUInteger itemIndex) {
        [self.MenuBtn setTitle:self.items[itemIndex] forState:UIControlStateNormal];
        [aDialogViewController hide];
    };
    [self centerPresentController:dialogViewController presentedSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) completeHandle:nil];
}


@end
