//
//	NR_NewRoomOnlineModel.swift
//
//	Create by JornWu on 24/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class NR_NewRoomOnlineModel{

	var code : String!
	var data : NR_Data!
	var msg : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		code = dictionary["code"] as? String
		if let dataData = dictionary["data"] as? [String:Any]{
			data = NR_Data(fromDictionary: dataData)
		}
		msg = dictionary["msg"] as? String
	}

}