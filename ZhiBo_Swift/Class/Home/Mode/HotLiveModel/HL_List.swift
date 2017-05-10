//
//	HL_List.swift
//
//	Create by JornWu on 21/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class HL_List{

	var allnum : Int!
	var bigpic : String!
	var curexp : Int!
	var distance : Int!
	var familyName : String!
	var flv : String!
	var gender : Int!
	var gps : String!
	var grade : Int!
	var isSign : Int!
	var level : Int!
	var myname : String!
	var nation : String!
	var nationFlag : String!
	var pos : Int!
	var realuidx : Int!
	var roomid : Int!
	var serverid : Int!
	var signatures : String!
	var smallpic : String!
	var starlevel : Int!
	var userId : String!
	var useridx : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		allnum = dictionary["allnum"] as? Int
		bigpic = dictionary["bigpic"] as? String
		curexp = dictionary["curexp"] as? Int
		distance = dictionary["distance"] as? Int
		familyName = dictionary["familyName"] as? String
		flv = dictionary["flv"] as? String
		gender = dictionary["gender"] as? Int
		gps = dictionary["gps"] as? String
		grade = dictionary["grade"] as? Int
		isSign = dictionary["isSign"] as? Int
		level = dictionary["level"] as? Int
		myname = dictionary["myname"] as? String
		nation = dictionary["nation"] as? String
		nationFlag = dictionary["nationFlag"] as? String
		pos = dictionary["pos"] as? Int
		realuidx = dictionary["realuidx"] as? Int
		roomid = dictionary["roomid"] as? Int
		serverid = dictionary["serverid"] as? Int
		signatures = dictionary["signatures"] as? String
		smallpic = dictionary["smallpic"] as? String
		starlevel = dictionary["starlevel"] as? Int
		userId = dictionary["userId"] as? String
		useridx = dictionary["useridx"] as? Int
	}

}