//
//  NetworkAPI.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/4/21.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

enum NetworkAPI {
    case advertisementURLString
    case hotDataURLString
    case newRoomOnlineURLString
    case rankListURLString
    
    func getUrlString() -> String {
        switch self {
        case .advertisementURLString:
            return "http://live.9158.com/Living/GetAD"
        case .hotDataURLString:
            return "http://live.9158.com/Fans/GetHotLive?page=1"//%ld
        case .newRoomOnlineURLString:
            return "http://live.9158.com/Room/GetNewRoomOnline?page=1"//%ld
        case .rankListURLString:
            return "http://live.9158.com/Rank/WeekRank?Random=10"//ld
        }
    }
    
    ///根据urlString类型返回ULR对象
    static func urlWith(_ type: NetworkAPI) -> URL? {
        let url = URL(string: type.getUrlString())
        guard url != nil else {
            print("Get url by 'NetorkAPI' error.")
            return nil
        }
        return URL(string: type.getUrlString())!
    }
}
