//
//  FlagButton.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/4/24.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class LinkButton: UIButton {
    
    ///
    ///     要存储的链接
    ///
    var link: String?
    
    ///
    ///     通过url string 设置按钮图片
    ///
    var imageLink: String? = "" {
        didSet {
            self.sd_setImage(with: URL(string: imageLink ?? ""),
                              for: .normal,
                 placeholderImage: #imageLiteral(resourceName: "private_icon_70x70"))
        }
    }
    
    ///
    ///     通过url string 设置按钮背景图片
    ///
    var backgroundImageLink: String? = "" {
        didSet {
            self.sd_setBackgroundImage(with: URL(string: imageLink ?? ""),
                                        for: .normal,
                           placeholderImage: #imageLiteral(resourceName: "private_icon_70x70"))
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
