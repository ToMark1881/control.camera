//
//  ParserHelper.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation

class ParserHelper {
    
    class func convertDataToArray(_ data: Data?) throws -> [NSDictionary]? {
        if let data = data {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
        } else {
            return nil
        }
    }
    
    class func convertDataToDictionary(_ data: Data?) throws -> NSDictionary? {
        if let data = data {
            return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
        } else {
            return nil
        }
    }
}
