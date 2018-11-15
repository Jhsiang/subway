//
//  TestViewController.swift
//  subway
//
//  Created by Jim Chuang on 2018/11/14.
//  Copyright © 2018 nhr. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var myWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.delegate = self
        myWebView.allowsInlineMediaPlayback = true
        

        let doubleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(whenDTap))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
    }

    override func viewDidAppear(_ animated: Bool) {
        if let urlStr = MyHttp.share.getURL(),let myURL = URL(string: urlStr){
            let myRequest = URLRequest(url: myURL)
            myWebView.loadRequest(myRequest)
        }else{
            let alert = UIAlertController(title: "讀取不到資料", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }

    //MARK: - Gesture
    @objc func whenDTap(){
        let myView = UIView(frame: self.view.frame)
        myView.backgroundColor = .black
        myView.tag = 888
        if let viewTag = self.view.viewWithTag(888){
            self.navigationController?.navigationBar.isHidden = false
            viewTag.removeFromSuperview()
        }else{
            self.navigationController?.navigationBar.isHidden = true
            self.view.addSubview(myView)
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
            if let urlStr = self.myWebView.request?.url?.absoluteString{
                tf.placeholder = urlStr
            }
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let name = alert.textFields?[0].text,let url = self.myWebView.request?.url?.absoluteString{
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
        print("myWebView.url = ",self.myWebView.request?.url?.absoluteString)
        if let url = self.myWebView.request?.url?.absoluteString {
            myWebView.reload()
        } else {
            print("fail")
        }
    }

}
