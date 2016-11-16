//
//  API500px.swift
//  Stagram
//
//  Created by Dongri Jin on 2016/11/15.
//  Copyright © 2016 Dongri Jin. All rights reserved.
//

import Foundation

class API500px: NSObject {
    
    static let ENDPOINT = "https://api.500px.com/v1"
    
    static func today() -> String {
        let urlString = "\(ENDPOINT)/photos/?\(key())&feature=fresh_today&\(commonQuery())"
        return urlString
    }

    static func popular() -> String {
        let urlString = "\(ENDPOINT)/photos/?\(key())&feature=popular&\(commonQuery())"
        return urlString
    }

    static func upcoming() -> String {
        let urlString = "\(ENDPOINT)/photos/?\(key())&feature=upcoming&\(commonQuery())"
        return urlString
    }
    
    static func search(_ q: String) -> String{
        let urlString = "\(ENDPOINT)/photos/search/?\(key())&term=\(q)&\(commonQuery())"
        return urlString
    }
    
    static func commonQuery() -> String {
        return "image_size=600,400&rpp=100&page=%d"
    }
    
    static func consumerKey() -> String {
        return "ExogCaMMAkMUl0qsTEejezG8uGkYaEk9jL0amW1G"
    }

    static func key() -> String {
        return "consumer_key=\(consumerKey())"
    }
    
}
