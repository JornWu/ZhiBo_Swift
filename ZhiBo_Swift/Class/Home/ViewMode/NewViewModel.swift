//
//  NewViewModel.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/4/21.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class NewViewModel: NSObject {
    
    var getNewRoomOnlineSignal: Signal<[NR_List]?, AnyError>!
    
    override init() {
        super.init()
        setupNewRoomOnlineSignal(withURLString: NetworkAPI.newRoomOnline.getUrlString())
    }
    
    private func setupNewRoomOnlineSignal(withURLString urlString: String) {
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.reactive.data(with: request)
            .map { (data, response) -> [NR_List]? in
                
                let dataDic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                guard dataDic != nil else {
                    print("get new room onlines data error, data is nil.")
                    return nil
                }
                
                let newRoomOnlineModel = NR_NewRoomOnlineModel(fromDictionary: dataDic as! [String : Any])
                return newRoomOnlineModel.data.list
            }
            .observe(on: QueueScheduler(qos: .default, name: "getNewRoomOnlineData", targeting: nil))
            .startWithSignal{signle, _ in
                getNewRoomOnlineSignal = signle
        }
    }
}
