//
//	AD_AdvertisementModel.swift
//
//	Create by JornWu on 21/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AD_AdvertisementModel{

	var code : String!
	var data : [AD_Data]!
	var msg : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		code = dictionary["code"] as? String
		data = [AD_Data]()
		if let dataArray = dictionary["data"] as? [[String:Any]]{
			for dic in dataArray{
				let value = AD_Data(fromDictionary: dic)
				data.append(value)
			}
		}
		msg = dictionary["msg"] as? String
	}

}