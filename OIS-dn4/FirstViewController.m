//
//  FirstViewController.m
//  OIS-dn4
//
//  Created by Klemen Kosir on 11. 12. 14.
//  Copyright (c) 2014 Lonely Cappuccino. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {
    NSURL *url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_webView setDelegate:self];
    url = [NSURL URLWithString:@"http://imestr.github.io/ois-dn4/"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
    
}

-(void)viewWillAppear:(BOOL)animated {
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
    
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    //[_webView.scrollView setBounces:NO];
    [_webView.scrollView setDirectionalLockEnabled:YES];
    [_webView.scrollView setContentMode:UIViewContentModeScaleAspectFit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
