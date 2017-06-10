//
//  LiveRoomAnchorSearchViewModel.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/10.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class LiveRoomAnchorSearchViewModel: NSObject {
    /// 使用懒加载，不能多次创建
    lazy var backPipe: (output: Signal<(), NoError>, input: Signal<(), NoError>.Observer) = {
        return Signal<(), NoError>.pipe()
    }()
}
