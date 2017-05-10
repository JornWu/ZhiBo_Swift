//
//	NR_List.swift
//
//	Create by JornWu on 24/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class NR_List{

	var allnum : Int!
	var flv : String!
	var isOnline : Int!
	var lianMaiStatus : Int!
	var newField : Int!
	var nickname : String!
	var phonetype : Int!
	var photo : String!
	var position : String!
	var roomid : Int!
	var serverid : Int!
	var sex : Int!
	var starlevel : Int!
	var useridx : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		allnum = dictionary["allnum"] as? Int
		flv = dictionary["flv"] as? String
		isOnline = dictionary["isOnline"] as? Int
		lianMaiStatus = dictionary["lianMaiStatus"] as? Int
		newField = dictionary["new"] as? Int
		nickname = dictionary["nickname"] as? String
		phonetype = dictionary["phonetype"] as? Int
		photo = dictionary["photo"] as? String
		position = dictionary["position"] as? String
		roomid = dictionary["roomid"] as? Int
		serverid = dictionary["serverid"] as? Int
		sex = dictionary["sex"] as? Int
		starlevel = dictionary["starlevel"] as? Int
		useridx = dictionary["useridx"] as? Int
	}

}