//
//  H5ViewController.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/7.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class H5ViewController: BaseViewController, UIWebViewDelegate {
    /// URL
    var URLString: String = "" {
       didSet {
            loadNetworkData()
        }
    }
    
    /// webView
    private lazy var webVeiw: UIWebView = {
        let view = UIWebView()
        view.autoresizesSubviews = true
        view.scalesPageToFit = true
        return view
    }()
    
    /// activityView
    private lazy var activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = .gray
        view.hidesWhenStopped = true
        return view
    }()
    
    
    private var controlView: UIView?
    
    var isShowControlView: Bool = false {
        didSet {
            showControlView()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.hidesBottomBarWhenPushed = true
        setupNavigationBar()
        setupWebView()
        
        
    }
    
    private func setupNavigationBar() {
        _ = {
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.setImage(#imageLiteral(resourceName: "privatechat_back_19x19_"), for: .normal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            
            button.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                self.navigationController?.popViewController(animated: true)
            })
        }()
    }
    
    private func showControlView() {
        if self.controlView == nil {
            let controlView = { () -> UIView in 
                let view = UIView()
                self.view.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.left.bottom.right.equalToSuperview()
                    make.height.equalTo(50)
                })
                view.isHidden = true
                view.backgroundColor = UIColor.gray
                self.controlView = view
                return view
            }()
            
            
            let forwardBtn = { () -> UIButton in
                let button = UIButton(type: .custom)
                controlView.addSubview(button)
                button.setImage( #imageLiteral(resourceName: "forward_19x19_"), for: .normal)
                button.snp.makeConstraints {(make) in
                    make.top.left.bottom.equalToSuperview()
                    make.width.equalToSuperview().dividedBy(2)
                }
                button.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
                    self.webVeiw.goForward()
                }
                return button
            }()
            
            _ = { () -> UIButton in
                let button = UIButton(type: .custom)
                controlView.addSubview(button)
                button.setImage(#imageLiteral(resourceName: "backwards_19x19_"), for: .normal)
                button.snp.makeConstraints {(make) in
                    make.top.bottom.right.equalToSuperview()
                    make.left.equalTo(forwardBtn.snp.right)
                }
                button.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
                    self.webVeiw.goBack()
                }
                return button
            }()
        }
        
        self.controlView?.isHidden = !self.isShowControlView
    }
    
    private func setupWebView() {
        self.webVeiw.delegate = self
        self.view.addSubview(webVeiw)
        self.webVeiw.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        }
        
        self.view.addSubview(activityView)
        self.activityView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.center.equalTo(self.view.center)
        }
    }
    
    private func loadNetworkData() {
        let url = { () -> URL? in
            let url = URL(string: self.URLString)
            guard url != nil else {
                print("Load data error with url is nil.")
                return nil
            }
            
            return url
        }()
        
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 6000)
        
        self.webVeiw.loadRequest(request)
    }
    
    
    /// 
    /// UIWebViewDelegate
    ///
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        activityView.startAnimating()
        return true
    }
    
    ///
    /// UIWebViewDelegate
    ///
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityView.stopAnimating()
    }
    
    ///
    /// UIWebViewDelegate
    ///
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityView.startAnimating()
    }
    
    ///
    /// UIWebViewDelegate
    ///
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityView.stopAnimating()
        self.title = "排行"
        print("=======================\n", webView.stringByEvaluatingJavaScript(from: "JSON.stringify(document)") ?? "")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
