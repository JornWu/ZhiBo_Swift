//
//  HotListCell.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/4/23.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import SDWebImage
import ReactiveCocoa
import ReactiveSwift
import Result

class HotListCell: UICollectionViewCell {
    private var nickNameLabel: UILabel! ///昵称
    private var hierarchyImgView: UIImageView!  ///等级
    private var categoryLabel: UILabel!  ///家族
    private var liveMarkImgView: UIImageView!  ///直播标签
    private var numberLabel: UILabel!  ///观看人数
    private var backgroundImgView: UIImageView!  ///封面（可以用Button backgroundimage）
    private var actionBtn: LinkButton!  ///响应点击的按钮（可以直接使用backgroundImagView的点击手势)
    var actionSignal: Signal<LinkButton, NoError> {
        return actionBtn.reactive.controlEvents(.touchUpInside)
    }
    
    public func setupCell(nickName: String?, starLevel: Int?, category: String?, liveMark: UIImage?, number: Int?, backgroundImagURLString: String?, roomLink: String) {
        backgroundImgView = UIImageView()
        backgroundImgView.isUserInteractionEnabled = true ///使用imageView一定注意将用户交互设为true
        backgroundImgView.sd_setImage(with: URL(string: backgroundImagURLString!), placeholderImage: #imageLiteral(resourceName: "no_follow_250x247"))
        self.contentView.addSubview(backgroundImgView)
        backgroundImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        ///其他控件都放到这里
        let infoContainerView = UIView()
        infoContainerView.backgroundColor = UIColor.clear
        self.backgroundImgView.addSubview(infoContainerView)
        infoContainerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-5)
            make.height.equalTo(self.contentView).dividedBy(5)///高度等于cell的1/4
        }
        
        nickNameLabel = UILabel()
        nickNameLabel.text = nickName
        nickNameLabel.textColor = UIColor.white
        infoContainerView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(infoContainerView).dividedBy(2)
        }
        
        hierarchyImgView = UIImageView()
        hierarchyImgView.image = UIImage(named: "girl_star" + String(describing: starLevel!) + "_40x19")
        infoContainerView.addSubview(hierarchyImgView)
        hierarchyImgView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(nickNameLabel.snp.bottom)
            make.width.equalTo(infoContainerView).dividedBy(5)
        }
        
        numberLabel = UILabel()
        numberLabel.textAlignment = .right
        numberLabel.text = String(describing: number!) + "人"
        numberLabel.textColor = UIColor.white
        infoContainerView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(hierarchyImgView.snp.right)
            make.top.bottom.equalTo(hierarchyImgView)
            make.right.equalTo(infoContainerView)
        }
        
        categoryLabel = UILabel()
        categoryLabel.text = category
        categoryLabel.textColor = UIColor.white
        self.backgroundImgView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { (make) in
            make.topMargin.leftMargin.equalTo(10)
            make.size.equalTo(CGSize(width: 50, height: 20))
        }
        
        liveMarkImgView = UIImageView()
        liveMarkImgView.image = liveMark
        self.backgroundImgView.addSubview(liveMarkImgView)
        liveMarkImgView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 40, height: 20))
        }
        
        actionBtn = LinkButton(type: .custom)
        actionBtn.link = roomLink
        self.backgroundImgView.addSubview(actionBtn)
        actionBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }
    }
}
