//
//  LiveRoomAnchorInformationView.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/5/1.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

private let instance = LiveRoomAnchorInformationView()
class LiveRoomAnchorInformationView: UIView {
    
///---------------------------------------------------
///Singleton
///
    final class var shareLiveRoomAnchorInformationView: LiveRoomAnchorInformationView {
        instance.setupView()
        instance.listenSignals()
        return instance
    }
    
    private init() {
        super.init(frame: .zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
///---------------------------------------------------
///     property
///
    ///
    /// 当前主播的数据model
    /// 可以在didSet监听里重设页面
    /// 这里使用ReactiveSwift信号
    ///
    var currentAnchorModel: LiveRoomModel? = nil {
        didSet {
            reinitData()
        }
    }
    
    ///
    /// 主播头像
    ///
    private var headPortrait: UIImageView?
    
    private lazy var viewModel: LiveRoomAnchorInformationViewModel = {
        return LiveRoomAnchorInformationViewModel()
    }()
    
    ///
    /// 供外面使用，代替delegate和block
    ///
    var exitSignal: Signal<(), NoError>? {
        return self.viewModel.exitPipe.output
    }

///---------------------------------------------------
///     method
///
    private func setupView() {
        let reportBtn = { () -> UIButton in 
            let button = UIButton(type: .custom)
            button.setTitle("举报", for: .normal)
            button.setTitleColor(THEME_COLOR, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            self.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.top.left.equalTo(10)
                make.size.equalTo(CGSize(width: 30, height: 30))
            })
            return button
        }()
        
        let sealBtn = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.setTitle("封印", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            self.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.top.equalTo(reportBtn.snp.top)
                make.left.equalTo(reportBtn.snp.right).offset(10)
                make.size.equalTo(CGSize(width: 30, height: 30))
            })
            return button
        }()
        
        ///
        /// close button
        ///
        _ = { () -> UIButton in
            let closeBtn = UIButton(type: .custom)
            closeBtn.setImage(#imageLiteral(resourceName: "talk_close_40x40"), for: .normal)
            closeBtn.setTitleColor(UIColor.gray, for: .normal)
            closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            self.addSubview(closeBtn)
            closeBtn.snp.makeConstraints({ (make) in
                make.top.equalTo(sealBtn.snp.top)
                make.right.equalToSuperview().offset(-10)
                make.size.equalTo(CGSize(width: 30, height: 30))
            })
            closeBtn.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                self.viewModel.exitPipe.input.send(value: ())
            })
            return closeBtn
        }()
        
        ///
        /// head Portrait
        ///
        self.headPortrait = { () -> UIImageView in
            ///
            /// 边框效果
            /// 动图可以使用layer来实现
            ///
            let containView = UIView()
            self.addSubview(containView)
            containView.snp.makeConstraints({ (make) in
                make.top.equalTo(30)
                make.size.equalTo(CGSize(width: 120, height: 120))
                make.centerX.equalToSuperview()
            })
            containView.backgroundColor = UIColor.white
            containView.clipsToBounds = true
            containView.layer.cornerRadius = 60
            containView.layer.borderWidth = 5
            
            let view = UIImageView()
            containView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                ///
                /// make.size.equalTo(CGSize(width: 110, height: 110))
                /// make.center.equalToSuperview()
                ///
                make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, -5, -5))
                
            })
            
            view.layer.cornerRadius = 55
            view.clipsToBounds = true
            view.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "private_icon_70x70"))
            
            return view
        }()
    }
    
    private func listenSignals() {
//        self.viewModel.setCurrentAnchorModelPipe
//        reactive.trigger(for: #selector(setter: <#T##@objc property#>)).observeValues { (val) in
//            
//        }
    }
    
    private func reinitData() {
        /// set image
        self.headPortrait?.sd_setImage(with: URL(string: currentAnchorModel?.bigpic ??
            currentAnchorModel?.photo ?? ""), placeholderImage: #imageLiteral(resourceName: "private_icon_70x70"))
    }
    

}
