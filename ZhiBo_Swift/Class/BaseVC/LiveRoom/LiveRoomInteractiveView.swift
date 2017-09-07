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

private let instance = LiveRoomInteractiveView()
class LiveRoomInteractiveView: UIView {
    
//MARK: - Singleton
///---------------------------------------------------
/// Singleton
///
    
    final class var shareLiveRoomInteractiveView: LiveRoomInteractiveView {
        instance.setupToolBar()
        instance.setupAnchorIconButton()
        instance.setupAnchorInfoView()
        instance.setupAnchorSearchView()
        instance.listenSignals()
        instance.listenGesture()
        return instance
    }
    
    private init() {
        super.init(frame: .zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - property
///---------------------------------------------------
///     property
///
    ///
    ///     view model
    ///
    private lazy var viewModel: LiveRoomInteractiveViewModel = {
        return LiveRoomInteractiveViewModel()
    }()
    
    ///
    ///     当前主播的数据model
    ///
    var currentAnchorModel: LiveRoomModel? = nil {
        didSet {
            reinitData()
        }
    }
    
    ///
    ///     当前主播头像按钮，点击显示信息
    ///
    private var iconButton: LinkButton?
    
    ///
    ///     当前主播的昵称
    ///
    private var titleLabel: UILabel?
    
    ///
    ///     当前主播的观众数量
    ///
    private var numberLabel: UILabel?
    
    ///
    ///     主播信息详情视图
    ///
    private var anchorInfoView: LiveRoomAnchorInformationView?
    
    ///
    ///     主播搜索视图
    ///
    private var anchorSearchView: LiveRoomAnchorSearchView?
    
//MARK: - method
///---------------------------------------------------
///     method
///
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideAnchorInfoView()
    }
    
    private func listenSignals() {
        //TODO: 监听所有信号
        /// eg:
        /// reactive.trigger(for: #selector(touchesBegan(_:with:))).observeValues { (val) in
        ///
        /// }
        ///
    }
    
    private func listenGesture() {
        //TODO: 监听所有手势
    }
    
    ///
    ///     根据所给的model重新初始化一些数据
    ///
    private func reinitData() {
        self.iconButton?.imageLink = currentAnchorModel?.smallpic ?? currentAnchorModel?.photo ?? ""
        self.anchorInfoView?.currentAnchorModel = currentAnchorModel
        self.titleLabel?.text = currentAnchorModel?.myname ?? currentAnchorModel?.nickname ?? "未知昵称"
        self.numberLabel?.text = "\(String(describing: currentAnchorModel?.allnum ?? 0))" + "人"
    }
   
    ///
    ///     底部的工具栏
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
    ///     创建左上角的主播的信息和关注列表展开按钮
    ///
    private func setupAnchorIconButton() {
        ///
        ///     展开按钮
        ///
        let unfoldBtn = { () -> UIButton in
            let button = UIButton()
            button.backgroundColor = UIColor.gray
            self.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.equalTo(18)
                make.left.equalTo(15)
                make.width.equalTo(160)
                make.height.equalTo(40)
            }
            
            button.layer.cornerRadius = 20
            button.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                self.showAnchorSearchView()
            })
            return button
        }()
        
        ///
        ///     关注按钮
        ///
        let subscribeBtn = { () -> UIButton in
            let button = UIButton()
            button.backgroundColor = THEME_COLOR
            button.alpha = 0.7
            button.setTitle("关注", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            unfoldBtn.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.equalTo(5)
                make.bottom.right.equalTo(-5)
                make.width.equalTo(40)
            }
            
            button.layer.cornerRadius = 15
            button.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                //TODO: “关注”未实现
                print("你已经成功关注了该主播。")
            })
            
            return button
        }()
        
        ///
        /// 主播头像按钮
        ///
        let headPortraitBtn = { () -> LinkButton in
            
            let button = LinkButton()
            unfoldBtn.addSubview(button)
            
            button.snp.makeConstraints { (make) in
                make.top.left.equalTo(3)
                make.bottom.equalTo(-3)
                make.width.equalTo(34)
            }
            
            button.imageLink = currentAnchorModel?.smallpic ?? currentAnchorModel?.photo ?? ""
            button.backgroundColor = THEME_COLOR
            button.isHighlighted = false
            button.clipsToBounds = true
            button.layer.cornerRadius = 17
            self.iconButton = button
            
            button.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                self.showAnchorInfoView()
            })
            return button
        }()
        
        ///
        /// 昵称
        ///
        let titleLabel = { () -> UILabel in 
            let label = UILabel()
            unfoldBtn.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(headPortraitBtn.snp.right).offset(5)
                make.right.equalTo(subscribeBtn.snp.left).offset(-5)
                make.top.equalToSuperview().offset(3)
                make.height.equalToSuperview().dividedBy(2.5)
            })
            
            label.font = UIFont.systemFont(ofSize: 13)
            label.textAlignment = .center
            label.textColor = THEME_COLOR
            label.text = "xxxxx"
            self.titleLabel = label
            return label
        }()
        
        ///
        /// 观众数量
        ///
        _ = { () -> UILabel in
            let label = UILabel()
            unfoldBtn.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(headPortraitBtn.snp.right).offset(5)
                make.right.equalTo(subscribeBtn.snp.left).offset(-5)
                make.top.equalTo(titleLabel.snp.bottom)
                make.bottom.equalToSuperview().offset(-3)
            })
            
            label.font = UIFont.systemFont(ofSize: 13)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.text = "--- 人"
            self.numberLabel = label
            return label
        }()
    }
    
    
//MARK: - anchor search view
    ///
    ///     用户搜索视图
    ///
    private func setupAnchorSearchView() {
        _ = { () -> LiveRoomAnchorSearchView in
            let view = LiveRoomAnchorSearchView.shareLiveRoomAnchorSearchView
            self.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.size.equalToSuperview()
                make.bottom.equalTo(self.snp.top)
            })
            
            view.isHidden = true
            view.backSignal?.observeValues({
                self.hideAnchorSearchView()
            })
            self.anchorSearchView = view
            return view
        }()
    }
    
    private func showAnchorSearchView() {
        UIView.animate(withDuration: 0.2, animations: {
            //TODO: 动画先简单处理
            self.anchorSearchView?.isHidden = false
            self.anchorSearchView?.frame.origin = CGPoint(x: 0, y: 0)
        }) { (isCompleted) in
            print("用户搜索视图已打开。")
        }
    }
    
    private func hideAnchorSearchView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.anchorSearchView?.isHidden = true
            self.anchorSearchView?.frame.origin.y = -1 * (self.anchorSearchView?.frame.height)!
        }, completion: { (isCompleted) in
            if isCompleted {
                print("用户搜索视图已经关闭。")
            }
        })
    }
    
    
//MARK: - anchor information view
    ///
    ///     创建主播信息详情视图
    ///
    private func setupAnchorInfoView() {
        self.anchorInfoView = { () -> LiveRoomAnchorInformationView in
            let view = LiveRoomAnchorInformationView.shareLiveRoomAnchorInformationView
            view.backgroundColor = UIColor.lightGray
            view.currentAnchorModel = self.currentAnchorModel
            self.addSubview(view)
            view.snp.makeConstraints{ (make) in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.height.equalToSuperview().multipliedBy(0.67)
                make.centerX.equalToSuperview()
                make.top.equalTo(self.snp.bottom)
            }
            
            view.layer.cornerRadius = 10
            view.isHidden = true
            view.exitSignal?.observeValues({ (val) in
                view.frame.origin.y = self.frame.height
            })
            
            return view
        }()
    }
    
    private func showAnchorInfoView() {
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModeLinear, animations: {
            //TODO: 动画先简单处理
            self.anchorInfoView?.isHidden = false
            self.anchorInfoView?.center = self.center
        }, completion: nil)
    }
    
    private func hideAnchorInfoView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.anchorInfoView?.frame.origin.y = self.frame.height
            self.anchorInfoView?.isHidden = true
        })
    }
}
