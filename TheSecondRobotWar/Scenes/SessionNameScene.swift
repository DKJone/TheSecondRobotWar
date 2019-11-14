//
//  SessionNameScene.swift
//  TheSecondRobotWar
//
//  Created by 朱德坤 on 2019/11/13.
//  Copyright © 2019 DKJone. All rights reserved.
//

import SpriteKit
import SwiftyJSON

class SessionNameScene: SKScene {
    let nameNodel = SKLabelNode()
    let indexNode = SKLabelNode()
    var sessionName = ""
    var session = 0
    var bgm = SKAudioNode(fileNamed: "bgm_session_title.mp3")
    init(session: Int, size: CGSize) {
        super.init(size: size)
        self.session = session
        addChilds(childs: [indexNode, nameNodel])
        let path = Bundle.main.url(forResource: "SessionName", withExtension: "json")!
        DispatchQueue.global().async {
            self.sessionName = JSON(parseJSON: try! String(contentsOf: path))
                .arrayValue[session].stringValue
        }
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        indexNode.fontName = "HelveticaNeue-Bold"
        indexNode.fontSize = 20
        indexNode.position = CGPoint(x: 0, y: 30)
        nameNodel.fontName = "HelveticaNeue-Bold"
        nameNodel.fontSize = 20
        nameNodel.position = CGPoint(x: 0, y: 0)
        backgroundColor = .black
        bgm.autoplayLooped = false
        addChild(bgm)
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        run(.sequence([.wait(forDuration: 0.5), .run {
            self.indexNode.text = "第\(self.session)篇"
            self.nameNodel.text = self.sessionName
        }]))
        bgm.run(.play())

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchToSession()
    }

    private func switchToSession() {
        if let scene = Session1Scene(fileNamed: "Session1Scene") {
            view?.presentScene(scene)
        }
    }
}
