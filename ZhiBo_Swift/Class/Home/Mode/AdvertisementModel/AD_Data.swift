//
//	AD_Data.swift
//
//	Create by JornWu on 21/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AD_Data{

	var addTime : String!
	var adsmallpic : String!
	var bigpic : AnyObject!
	var contents : String!
	var cutTime : Int!
	var flv : AnyObject!
	var gps : AnyObject!
	var hiddenVer : Int!
	var imageUrl : String!
	var link : String!
	var lrCurrent : Int!
	var myname : String!
	var orderid : Int!
	var roomid : Int!
	var serverid : Int!
	var signatures : AnyObject!
	var smallpic : AnyObject!
	var state : Int!
	var title : String!
	var useridx : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		addTime = dictionary["addTime"] as? String
		adsmallpic = dictionary["adsmallpic"] as? String
		bigpic = dictionary["bigpic"] as? AnyObject
		contents = dictionary["contents"] as? String
		cutTime = dictionary["cutTime"] as? Int
		flv = dictionary["flv"] as? AnyObject
		gps = dictionary["gps"] as? AnyObject
		hiddenVer = dictionary["hiddenVer"] as? Int
		imageUrl = dictionary["imageUrl"] as? String
		link = dictionary["link"] as? String
		lrCurrent = dictionary["lrCurrent"] as? Int
		myname = dictionary["myname"] as? String
		orderid = dictionary["orderid"] as? Int
		roomid = dictionary["roomid"] as? Int
		serverid = dictionary["serverid"] as? Int
		signatures = dictionary["signatures"] as? AnyObject
		smallpic = dictionary["smallpic"] as? AnyObject
		state = dictionary["state"] as? Int
		title = dictionary["title"] as? String
		useridx = dictionary["useridx"] as? Int
	}

}