//
//  LoveView.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/3/2.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class LoveView: UIView {

    private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        imageView = UIImageView()
        //imageView.backgroundColor = UIColor.gray
        imageView.image = #imageLiteral(resourceName: "no_follow_250x247")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            //make.top.left.equalTo(100)
            make.size.equalTo(CGSize(width: 300, height: 350))
            make.centerX.equalToSuperview()
            make.top.equalTo(40)
        }
        
        let tipsLB = UILabel()
        tipsLB.text = "你关注的主播还没有开播"
        tipsLB.textColor = UIColor.gray
        tipsLB.textAlignment = .center
        tipsLB.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(tipsLB)
        tipsLB.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
        
        let toWatchHotLiveBtn = UIButton()
        self.addSubview(toWatchHotLiveBtn)
        toWatchHotLiveBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tipsLB.snp.bottom).offset(10)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(50)
        }
        toWatchHotLiveBtn.setTitle("去看看当前热门的直播", for: .normal)
        toWatchHotLiveBtn.setTitleColor(THEME_COLOR, for: .normal)
        toWatchHotLiveBtn.layer.cornerRadius = 25 ///height = 50
        toWatchHotLiveBtn.layer.borderWidth = 2
        toWatchHotLiveBtn.layer.borderColor = THEME_COLOR.cgColor
    }

}
