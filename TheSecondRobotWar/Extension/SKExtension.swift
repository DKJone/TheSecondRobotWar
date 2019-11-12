//
//  SKExtension.swift
//  TheSecondRobotWar
//
//  Created by 朱德坤 on 2019/11/12.
//  Copyright © 2019 DKJone. All rights reserved.
//

import SpriteKit

extension SKNode{
    func addChilds(childs: [SKNode]){
        childs.forEach(addChild(_:))
    }
}
