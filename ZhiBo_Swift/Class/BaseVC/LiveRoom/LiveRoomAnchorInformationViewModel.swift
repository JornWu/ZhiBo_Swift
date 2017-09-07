//
//  LiveRoomAnchorInformationViewModel.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/9.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class LiveRoomAnchorInformationViewModel: NSObject {
    
    /// 使用懒加载，不能多次创建
    lazy var exitPipe: (output: Signal<(), NoError>, input: Signal<(), NoError>.Observer) = {
        return Signal<(), NoError>.pipe()
    }()
		

}
