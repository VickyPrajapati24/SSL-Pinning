//
//  ViewController.swift
//  SSLPinningSwift
//
//  Created by Vicky  on 14/07/20.
//  Copyright © 2020 Vicky . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.callDemoAPI()
    }
    
    func callDemoAPI() {
        var dicJSON = [String: Any]()
        dicJSON["title"] = "foo"
        dicJSON["body"] = "bar"
        dicJSON["userId"] = 1

        var dicHeaderField = [String: String]()
        dicHeaderField["Content-Type"] = "application/json; charset=utf-8"

        self.callAPI(strURL: "https://jsonplaceholder.typicode.com/posts", dicJSON: dicJSON, headerField: dicHeaderField)
    }
    
    func callAPI(strURL: String, dicJSON: [String: Any], headerField: [String: String]) {
        let dicJSONData: Data? = try? JSONSerialization.data(withJSONObject: dicJSON, options: .prettyPrinted)
        let jsonString: String = String(data: dicJSONData ?? Data(), encoding: String.Encoding.utf8)!
        print(jsonString)
        
        let fileURL = URL(string: strURL)!
        let fileRequest:NSMutableURLRequest = NSMutableURLRequest(url: fileURL)
        fileRequest.httpMethod = "POST"
        
        for (key, value) in headerField {
            fileRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        fileRequest.timeoutInterval = 120
        fileRequest.httpBody = dicJSONData
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: NSURLSessionPinningDelegate(), delegateQueue: nil)
        
        let dataTask = session.dataTask(with: fileRequest as URLRequest) {
            data,response,error in

            if error == nil {
                if data != nil {
                    if let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                        print("Received data:\n\(str)")
                    } else {
                        print("Unable to convert data to text")
                    }
                }
            }else{
                print("error: \(error!.localizedDescription): \(error!)")
            }
        }
        dataTask.resume()
    }
}

