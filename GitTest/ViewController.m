//
//  ViewController.m
//  GitTest
//
//  Created by Gavin on 2020/2/24.
//  Copyright © 2020 LRanger. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>

@property(nonatomic, strong) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    
    _textView = [UITextView new];
    _textView.frame = CGRectMake(10, 100, 200, 200);
    _textView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    123
    
    1234
    
    12345
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"replacementText: \"%@\", range: %@, text: \"%@\" ", text, NSStringFromRange(range), textView.text);

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"text:\"%@\"", textView.text);
}

- (void)close {
    
}

- (void)add {
    
}

- (void)add2 {
    
}

- (void)add3 {
    
}

- (void)add4 {
    
}

@end
