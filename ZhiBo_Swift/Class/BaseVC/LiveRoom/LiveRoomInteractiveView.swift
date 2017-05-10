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
        intance.setupToolBar()
        intance.setupAnchorIconButton()
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
    
    private lazy var interactiveViewModel: LiveRoomInteractiveViewModel = {
        return LiveRoomInteractiveViewModel()
    }()
    
///---------------------------------------------------
   
    func setupToolBar() {
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
            
            if preSignal == nil {
                preSignal = toolBtn.reactive.controlEvents(.touchUpInside)
            }
            else {
                preSignal = Signal<UIButton, NoError>.merge(preSignal!, toolBtn.reactive.controlEvents(.touchUpInside))
            }
        }
        
        preSignal?.observeValues { (button) in
            switch button.tag {
            case BUTTON_TAG_EXIT:
                LiveRoomViewController.shareLiveRoomViewController.dismiss(animated: true, completion: {
                    print("Have leave the live room.")
                })
            default: break
            }
        }
    }
    
    func setupAnchorIconButton() {
        let unfoldBtn = UIButton()
        self.addSubview(unfoldBtn)
        unfoldBtn.snp.makeConstraints { (make) in
            make.left.top.equalTo(5)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
    }

}
