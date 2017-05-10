//
//  RootController.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2016/12/13.
//  Copyright © 2016年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class RootController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.isTranslucent = false
        self.setupViewControllers()
    }
    
    func setupViewControllers() {
        self.creatChildViewControllers(WithChildViewController: HomeViewController(), tabBarItemImageName: "toolbar_home")
        self.creatChildViewControllers(WithChildViewController: LiveViewController(), tabBarItemImageName: "toolbar_live")
        self.creatChildViewControllers(WithChildViewController: MineViewController(), tabBarItemImageName: "toolbar_me")
    }
    
    func creatChildViewControllers(WithChildViewController childViewcontroller: BaseViewController, tabBarItemImageName imageName: String) {
        let navController = BaseNavigationViewController(rootViewController: childViewcontroller)
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.tabBarItem.selectedImage = UIImage(named: imageName + "_sel")
        navController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        self.addChildViewController(navController)
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
