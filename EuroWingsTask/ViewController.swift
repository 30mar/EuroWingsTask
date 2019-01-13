//
//  ViewController.swift
//  EuroWingsTask
//
//  Created by Omar Abdelaziz on 1/12/19.
//  Copyright © 2019 Omar Abdelaziz. All rights reserved.
//

import UIKit
import WebKit
class ImgurViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        authorize()
    }

    func authorize(){
        var request = URLRequest(url: URL(string: "https://api.imgur.com/oauth2/authorize?client_id=fd48670caa33809&response_type=token&state=ok")!)
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        webView.load(request)
    }

}

extension ImgurViewController: WKNavigationDelegate{
    
}

