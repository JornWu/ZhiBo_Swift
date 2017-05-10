//
//	NR_Data.swift
//
//	Create by JornWu on 24/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class NR_Data{

	var list : [NR_List]!
	var totalPage : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		list = [NR_List]()
		if let listArray = dictionary["list"] as? [[String:Any]]{
			for dic in listArray{
				let value = NR_List(fromDictionary: dic)
				list.append(value)
			}
		}
		totalPage = dictionary["totalPage"] as? Int
	}

}