//
//  LiveRoomInteractiveViewMode.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/5/3.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LiveRoomInteractiveViewModel: NSObject {
    
    ///
    /// 用于聚合工具栏中所有按钮发出的信号
    ///
    lazy var toolBarButtonSignal: Signal<UIButton, NoError> = {
        return Signal<UIButton, NoError>({_ in return nil})
    }()
    
    override init() {
        super.init()
    }
    
    
    

}
