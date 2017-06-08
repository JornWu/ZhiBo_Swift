//
//  LiveRoomModel.swift
//  ZhiBo_Swift
//
//  Created by JornWu on 2017/6/8.
//  Copyright © 2017年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit

struct LiveRoomModel {
    var allnum : Int?
    var bigpic : String?
    var curexp : Int?
    var distance : Int?
    var familyName : String?
    var flv : String?
    var gender : Int?
    var gps : String?
    var grade : Int?
    var isSign : Int?
    var level : Int?
    var myname : String?
    var nation : String?
    var nationFlag : String?
    var pos : Int?
    var realuidx : Int?
    var roomid : Int?
    var serverid : Int?
    var signatures : String?
    var smallpic : String?
    var starlevel : Int?
    var userId : String?
    var useridx : Int?
    var isOnline : Int?
    var lianMaiStatus : Int?
    var newField : Int?
    var nickname : String?
    var phonetype : Int?
    var photo : String?
    var position : String?
    var sex : Int?
    
    
    static func modelWith(_ sourceMode: AnyObject) -> LiveRoomModel {
        if sourceMode is HL_List {
            let model = sourceMode as! HL_List
            return self.init(allnum: model.allnum,
                             bigpic: model.bigpic,
                             curexp: model.curexp,
                           distance: model.distance,
                         familyName: model.familyName,
                                flv: model.flv,
                             gender: model.gender,
                                gps: model.gps,
                              grade: model.grade,
                             isSign: model.isSign,
                              level: model.level,
                             myname: model.myname,
                             nation: model.nation,
                         nationFlag: model.nationFlag,
                                pos: model.pos,
                           realuidx: model.realuidx,
                             roomid: model.roomid,
                           serverid: model.serverid,
                         signatures: model.signatures,
                           smallpic: model.smallpic,
                          starlevel: model.starlevel,
                             userId: model.userId,
                            useridx: model.useridx,
                           isOnline: nil,
                      lianMaiStatus: nil,
                           newField: nil,
                           nickname: nil,
                          phonetype: nil,
                              photo: nil,
                           position: nil,
                                sex: nil)
        }
        
        if sourceMode is NR_List {
            let model = sourceMode as! NR_List
            return self.init(allnum: model.allnum,
                             bigpic: nil,
                             curexp: nil,
                           distance: nil,
                         familyName: nil,
                                flv: model.flv,
                             gender: nil,
                                gps: nil,
                              grade: nil,
                             isSign: nil,
                              level: nil,
                             myname: nil,
                             nation: nil,
                         nationFlag: nil,
                                pos: nil,
                           realuidx: nil,
                             roomid: model.roomid,
                           serverid: model.serverid,
                         signatures: nil,
                           smallpic: nil,
                          starlevel: model.starlevel,
                             userId: nil,
                            useridx: model.useridx,
                           isOnline: model.isOnline,
                      lianMaiStatus: model.lianMaiStatus,
                           newField: model.newField,
                           nickname: model.nickname,
                          phonetype: model.phonetype,
                              photo: model.photo,
                           position: model.position,
                                sex: model.sex)
        }
        
        return LiveRoomModel(allnum: nil,
                             bigpic: nil,
                             curexp: nil,
                           distance: nil,
                         familyName: nil,
                                flv: nil,
                             gender: nil,
                                gps: nil,
                              grade: nil,
                             isSign: nil,
                              level: nil,
                             myname: nil,
                             nation: nil,
                         nationFlag: nil,
                                pos: nil,
                           realuidx: nil,
                             roomid: nil,
                           serverid: nil,
                         signatures: nil,
                           smallpic: nil,
                          starlevel: nil,
                             userId: nil,
                            useridx: nil,
                           isOnline: nil,
                      lianMaiStatus: nil,
                           newField: nil,
                           nickname: nil,
                          phonetype: nil,
                              photo: nil,
                           position: nil,
                                sex: nil)
    }
}
