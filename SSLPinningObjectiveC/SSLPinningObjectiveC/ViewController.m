//
//  ViewController.m
//  SSLPinningObjectiveC
//
//  Created by Vicky  on 14/07/20.
//  Copyright © 2020 Vicky . All rights reserved.
//

#import "ViewController.h"
#import "NSURLSessionPinningDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self callDemoAPI];
    // Do any additional setup after loading the view.
}

- (void)callDemoAPI {
    NSError *error;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSessionPinningDelegate *obj = [[NSURLSessionPinningDelegate alloc] init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:obj delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/posts"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *jsonDictionary = [[NSMutableDictionary alloc] init];
    [jsonDictionary setValue:@"foo" forKey:@"title"];
    [jsonDictionary setValue:@"bar" forKey:@"body"];
    [jsonDictionary setValue:@"1" forKey:@"userId"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    [request setHTTPBody:postData];


    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *aStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"ResponseString:%@",aStr);
    }];

    [postDataTask resume];
}

@end
