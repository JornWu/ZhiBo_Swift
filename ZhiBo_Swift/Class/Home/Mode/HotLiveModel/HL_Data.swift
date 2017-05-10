//
//	HL_Data.swift
//
//	Create by JornWu on 21/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class HL_Data{

	var counts : Int!
	var list : [HL_List]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		counts = dictionary["counts"] as? Int
		list = [HL_List]()
		if let listArray = dictionary["list"] as? [[String:Any]]{
			for dic in listArray{
				let value = HL_List(fromDictionary: dic)
				list.append(value)
			}
		}
	}

}