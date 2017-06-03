//
//  BaseViewController.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2016/12/13.
//  Copyright © 2016年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// default setup navigation bar background image.
        self.setupNavigationBar()
        /// default is hidden.
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBar_bg_414x70"), for: UIBarMetrics.default)
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
