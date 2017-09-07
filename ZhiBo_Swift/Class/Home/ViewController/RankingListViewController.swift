//
//  RankingListViewController.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/2/27.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class RankingListViewController: H5ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        self.URLString = NetworkAPI.rankListURLString.getUrlString()
        //self.isShowControlView = true
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
