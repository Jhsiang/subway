//
//  ViewController.swift
//  subway
//
//  Created by Jim Chuang on 2018/10/8.
//  Copyright © 2018年 nhr. All rights reserved.
//

import UIKit
import WebKit

class ShowViewController: UIViewController,WKNavigationDelegate,WKUIDelegate{

    @IBOutlet var myWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        myWebView.configuration.allowsInlineMediaPlayback = true
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidDisappear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {

        if let urlStr = MyHttp.share.getURL(),let myURL = URL(string: urlStr+"?playsinline=1"){
            myWebView.configuration.allowsInlineMediaPlayback = true
            let myRequest = URLRequest(url: myURL)
            myWebView.load(myRequest)
        }else{
            let alert = UIAlertController(title: "讀取不到資料", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func letfBtnClick(_ sender: UIBarButtonItem) {
        if myWebView.canGoBack{
            myWebView.goBack()
        }
    }

    @IBAction func rightBtnClick(_ sender: UIBarButtonItem) {
        if myWebView.canGoForward{
            myWebView.goForward()
        }
    }

    @IBAction func addBtnClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "add", message: "", preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "name"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let name = alert.textFields?[0].text,let url = self.myWebView.url?.absoluteString{
                MyHttp.share.addUrl(name: name, url: url)
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (action) in

        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func refreshBtnClick(_ sender: UIBarButtonItem) {
        print("myWebView.url = ",myWebView.url)
        if let url = myWebView.url {

            myWebView.reload()
        } else {
            print("fail")
        }
    }

    func runTimer(){
        var aa = Timer()
        aa = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (myTimer) in
            NSLog("progress = \(self.myWebView.estimatedProgress)")

            if self.myWebView.estimatedProgress != 1{
                let w = self.view.bounds.width * CGFloat(self.myWebView.estimatedProgress)
                let y = self.myWebView.frame.minY

                let myView = self.view.subviews.filter{$0.tag == 999}
                if myView.count == 0{
                    let myAddView = UIView(frame: CGRect(x: 0, y: y, width: w, height: 10))
                    myAddView.backgroundColor = .yellow
                    myAddView.tag = 999
                    self.view.addSubview(myAddView)
                }else if myView.count == 1{
                    myView[0].frame.size.width = self.view.bounds.width * CGFloat(self.myWebView.estimatedProgress)
                }
            }else{
                for myView in self.view.subviews{
                    if myView.tag == 999{
                        myView.removeFromSuperview()
                    }
                }
                aa.invalidate()
            }
        })
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        myWebView.isHidden = true
        runTimer()
        print("start")

    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("commit")

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        myWebView.isHidden = false
        print("finish")

    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("fail")

    }

}

