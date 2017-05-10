//
//  NewRoomOnlineCell.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/4/25.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import SDWebImage
import ReactiveCocoa
import ReactiveSwift
import Result

class NewRoomOnlineCell: UICollectionViewCell {
    
    private var nickNameLabel: UILabel! ///昵称
    private var hierarchyImgView: UIImageView!  ///等级
    private var newMark: UIImageView!  ///直播标签
    private var positionLable: UIButton!  ///所在城市
    //private var backgroundImgView: UIImageView!  ///封面
    private var actionBtn: LinkButton!  ///响应点击的按钮
    var actionSignal: Signal<LinkButton, NoError> {
        return actionBtn.reactive.controlEvents(.touchUpInside)
    }
    
    public func setupCell(nickName: String?, isNew: Int?, position: String, starLevel: Int?, backgroundImagURLString: String?, roomLink: String) {
        
        actionBtn = LinkButton(type: .custom)
        actionBtn.link = roomLink
        actionBtn.adjustsImageWhenHighlighted = false
        actionBtn.sd_setBackgroundImage(with: URL(string: backgroundImagURLString!), for: .normal, placeholderImage: #imageLiteral(resourceName: "no_follow_250x247"))
        self.contentView.addSubview(actionBtn)
        actionBtn.snp.makeConstraints { (make) in
            make.edges.size.equalToSuperview()
        }
        
        newMark = UIImageView()
        if isNew! == 1 {
            newMark.image = #imageLiteral(resourceName: "flag_new_33x17_")
        }
        actionBtn.addSubview(newMark)
        newMark.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 40, height: 20))
        }
        
        positionLable = UIButton(type: .custom)
        positionLable.setTitle(position, for: .normal)
        positionLable.setTitleColor(.white, for: .normal)
        positionLable.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        positionLable.setImage(#imageLiteral(resourceName: "location_white_8x9_"), for: .normal)
        positionLable.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0)
        positionLable.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0)
        actionBtn.addSubview(positionLable)
        positionLable.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.right.equalTo(newMark.snp.left)
            make.height.equalTo(20)
        }
        
        hierarchyImgView = UIImageView()
        hierarchyImgView.image = UIImage(named: "girl_star" + String(describing: starLevel!) + "_40x19")
        actionBtn.addSubview(hierarchyImgView)
        hierarchyImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(-5)
            make.size.equalTo(CGSize(width: 34, height: 15))
        }
        
        nickNameLabel = UILabel()
        nickNameLabel.text = nickName
        nickNameLabel.font = UIFont.systemFont(ofSize: 13)
        nickNameLabel.textColor = UIColor.white
        actionBtn.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.bottom.equalTo(-5)
            make.right.equalTo(hierarchyImgView.snp.left)
            make.height.equalTo(15)
        }
    }
    
}
