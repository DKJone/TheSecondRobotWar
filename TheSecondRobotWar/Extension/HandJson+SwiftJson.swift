//
//  HandJson+SwiftJson.swift
//  roadbed
//
//  Created by 朱德坤 on 2018/9/29.
//  Copyright © 2018 DKJone. All rights reserved.
//


import HandyJSON
import SwiftyJSON


protocol JsonInit {
   static func from(json:JSON) -> Self
}

extension HandyJSON{
    static func from(json:JSON) -> Self{
      return  Self.deserialize(from: json.rawString()) ?? Self()
    }
}

