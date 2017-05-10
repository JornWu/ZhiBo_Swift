//
//  LiveRoomCollectionViewCell.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/4/26.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

class LiveRoomCollectionViewCell: UICollectionViewCell {
    
    public var contentImage: UIImage! {
        didSet{
            contentImageView.image = contentImage
        }
    }
    
    public var flvLink: String!
    
    private var contentImageView: UIImageView = {
        return UIImageView()
    }()
    
    public func setupCell(withImageURLString urlString: String, flvLinkString: String) {
        self.contentView.addSubview(self.contentImageView)
        self.contentImageView.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "placeholder_head"))
        contentImageView.snp.makeConstraints { (make) in
            make.edges.height.equalToSuperview()
        }
        
        flvLink = flvLinkString
    }
}
