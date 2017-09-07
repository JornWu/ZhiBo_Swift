//
//  LiveRoomAnchorSearchView.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/10.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

private let instance = LiveRoomAnchorSearchView()
class LiveRoomAnchorSearchView: UIView {

///---------------------------------------------------
/// Singleton
///
    
    final class var shareLiveRoomAnchorSearchView: LiveRoomAnchorSearchView {
        instance.backgroundColor = VIEW_BACKGROUND_COLOR
        instance.setupNavigationBar()
        return instance;
    }
    
    ///
    ///     私有化构造方法，避免外部调用
    ///
    private init() {
        super.init(frame: .zero)
    }
    
    ///
    ///     私有化构造方法，避免外部调用
    ///
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    ///
    ///     私有化构造方法，避免外部调用
    ///
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
///---------------------------------------------------
///     property
///
    
    ///
    ///     view model
    ///
    private lazy var viewModel: LiveRoomAnchorSearchViewModel = {
        return LiveRoomAnchorSearchViewModel()
    }()
    
    ///
    /// 供外面使用，代替delegate和block
    ///
    var backSignal: Signal<(), NoError>? {
        return self.viewModel.backPipe.output
    }
    
///---------------------------------------------------
    
    func setupNavigationBar() {
        let bar = UINavigationBar()
        self.addSubview(bar)
        bar.snp.makeConstraints({ (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(64)
        })
        bar.setBackgroundImage(#imageLiteral(resourceName: "navBar_bg_414x70"), for: UIBarMetrics.default)
        
        let item = UINavigationItem()
        item.title = "选择用户"
        bar.setItems([item], animated: false)
        
        let backBtn = { () -> UIButton in 
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "back_9x16"), for: .normal)
            button.isHighlighted = false
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                /// 这里也可以这样写（加动画）
                /// self.frame.origin.y = -self.frame.height
                ///
                self.viewModel.backPipe.input.send(value: ())
            })
            return button
        }()
        item.leftBarButtonItem =  UIBarButtonItem(customView: backBtn)
        
        let filterBtn = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.setTitle("筛选", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.isHighlighted = false
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            button.reactive.controlEvents(.touchUpInside).observeValues({ (btn) in
                //TODO: “筛选”未实现
            })
            return button
        }()
        item.rightBarButtonItem =  UIBarButtonItem(customView: filterBtn)
    }
    

}
