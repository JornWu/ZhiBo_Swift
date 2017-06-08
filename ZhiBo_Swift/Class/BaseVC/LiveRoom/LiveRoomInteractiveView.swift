//
//  LiveRoomInteractiveView.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/5/1.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

private let intance = LiveRoomInteractiveView()
class LiveRoomInteractiveView: UIView {
    
///---------------------------------------------------
///Singleton
///
    
    final class var shareLiveRoomInteractiveView: LiveRoomInteractiveView {
        return intance;
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
///---------------------------------------------------
///     property
///
    ///
    /// view model
    ///
    private lazy var interactiveViewModel: LiveRoomInteractiveViewModel = {
        return LiveRoomInteractiveViewModel()
    }()
    
    ///
    /// 当前主播的数据model
    ///
    var currentAnchorModel: LiveRoomModel? = nil {
        didSet {
            initData()
        }
    }
    
///---------------------------------------------------
///     method
///
    ///
    /// 根据所给的model初始化页面
    ///
    private func initData() {
        setupToolBar()
        setupAnchorIconButton()
    }
   
    ///
    /// 底部的工具栏
    ///
    private func setupToolBar() {
        let toolbar = UIView()
        toolbar.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.addSubview(toolbar)
        toolbar.snp.makeConstraints { (make) in
            make.height.equalTo(self.snp.height).dividedBy(10)
            make.left.bottom.right.equalToSuperview()
        }
        
        let toolNames = ["private", "public", "sendgift", "rank", "share", "close"]
        var preBtn: UIButton? = nil
        var preSignal: Signal<UIButton, NoError>? = nil
        for index in 0 ..< 6 {
            let toolBtn = UIButton(type: .custom)
            toolBtn.setImage(UIImage(named: "talk_\(toolNames[index])_40x40"), for: .normal)
            toolBtn.adjustsImageWhenHighlighted = false
            toolBtn.tag = index
            toolbar.addSubview(toolBtn)
            
            if preBtn == nil {
                toolBtn.snp.makeConstraints({ (make) in
                    make.left.equalTo(12)
                    make.top.equalTo(5)
                    make.bottom.equalTo(-5)
                    make.width.equalTo(40)
                })
            }
            else {
                toolBtn.snp.makeConstraints({ (make) in
                    make.left.equalTo(preBtn!.snp.right).offset(30)///bug:offet暂时未计算,写死
                    make.top.equalTo(5)
                    make.bottom.equalTo(-5)
                    make.width.equalTo(40)
                })
            }
            preBtn = toolBtn
            
            ///
            /// 聚合所有的按钮信号，只要有一个按钮点击就会发出
            ///
            if preSignal == nil {
                preSignal = toolBtn.reactive.controlEvents(.touchUpInside)
            }
            else {
                preSignal = Signal<UIButton, NoError>
                    .merge(preSignal!, toolBtn
                        .reactive
                        .controlEvents(.touchUpInside))
            }
        }
        
        preSignal?.observeValues { (button) in
            switch button.tag {
            case BUTTON_TAG_EXIT:/// 退出直播间
                LiveRoomViewController.shareLiveRoomViewController.dismiss(animated: true, completion: {
                    print("Have leave the live room.")
                })
            default: break
            }
        }
    }
    
    ///
    /// 创建左上角的主播的信息和关注列表展开按钮
    ///
    private func setupAnchorIconButton() {
        
        ///
        /// 展开按钮
        ///
        let unfoldBtn = { () -> UIButton in
            let button = UIButton()
            button.backgroundColor = UIColor.gray
            self.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.equalTo(18)
                make.left.equalTo(15)
                make.width.equalTo(140)
                make.height.equalTo(50)
            }
            button.layer.cornerRadius = 25
            return button
        }()
        
        ///
        /// 关注按钮
        ///
        _ = { () -> UIButton in
            let button = UIButton()
            button.backgroundColor = THEME_COLOR
            button.setTitle("关注", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            unfoldBtn.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.equalTo(5)
                make.bottom.right.equalTo(-5)
                make.width.equalTo(50)
            }
            button.layer.cornerRadius = 20
            
            button.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                //do something
                print("你已经成功关注了该主播。")
            })
            
            return button
        }()
        
        ///
        /// 主播头像按钮
        ///
        _ = { () -> UIButton in
            let button = UIButton()
            button.backgroundColor = THEME_COLOR
            button.setTitle("关注", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            unfoldBtn.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.left.equalTo(3)
                make.bottom.equalTo(-3)
                make.width.equalTo(50)
            }
            button.layer.cornerRadius = 22
            
            button.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                //do something
            })
            
            return button
        }()
        
    }
}
