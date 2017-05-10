//
//	HL_HotLiveModel.swift
//
//	Create by JornWu on 21/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class HL_HotLiveModel{

	var code : String!
	var data : HL_Data!
	var msg : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		code = dictionary["code"] as? String
		if let dataData = dictionary["data"] as? [String:Any]{
			data = HL_Data(fromDictionary: dataData)
		}
		msg = dictionary["msg"] as? String
	}

}