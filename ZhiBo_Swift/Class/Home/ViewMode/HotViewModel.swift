//
//  HotViewModel.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/4/21.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class HotViewModel: NSObject {
    
    var getADSignale: Signal<[AD_Data]?, AnyError>!
    var getHotListSignal: Signal<[HL_List]?, AnyError>!
    
    
    override init() {
        super.init()
        setupADSignal(withURLString: NetworkAPI.advertisementURLString.getUrlString())
        setupHotListSignal(withURLString: NetworkAPI.hotDataURLString.getUrlString())
    }
    
    private func setupADSignal(withURLString urlString: String) {
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.reactive.data(with: request)
            .map { (data, response) -> [AD_Data]? in
                
                let dataDic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                guard dataDic != nil else {
                    print("get advertising data error, data is nil.")
                    return nil
                }
                
                let advertisementModel = AD_AdvertisementModel(fromDictionary: dataDic as! [String : Any])
                return advertisementModel.data
            }
            .observe(on: QueueScheduler(qos: .default, name: "getADData", targeting: nil))
            .startWithSignal{signle, _ in
               getADSignale = signle
        }
    }
    
    private func setupHotListSignal(withURLString urlString: String) {
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.reactive.data(with: request)
            .map { (data, response) -> [HL_List]? in
                
                let dataDic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                guard dataDic != nil else {
                    print("get hot list data error, data is nil.")
                    return nil
                }
                
                let hotLiveModel = HL_HotLiveModel(fromDictionary: dataDic as! [String : Any])
                return hotLiveModel.data.list
            }
            .observe(on: QueueScheduler(qos: .default, name: "getHotListData", targeting: nil))
            .startWithSignal{signle, _ in
                getHotListSignal = signle
        }
    }
}
