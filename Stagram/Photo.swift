//
//  ResponsePhoto.swift
//  Stagram
//
//  Created by Dongri Jin on 3/20/16.
//  Copyright © 2016 Dongri Jin. All rights reserved.
//

import Foundation

class Photo: NSObject {
    
    var smallImageURL: String
    var bigImageURL: String
    
    init(smallImageURL: String, bigImageURL: String) {
        self.smallImageURL = smallImageURL
        self.bigImageURL = bigImageURL
        super.init()
    }
    
    func SmallImageURL() -> String! {
        return smallImageURL
    }

    func BigImageURL() -> String! {
        return bigImageURL
    }

}
