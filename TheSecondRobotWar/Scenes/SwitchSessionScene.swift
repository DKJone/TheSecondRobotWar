//
//  SwitchSessionScene.swift
//  TheSecondRobotWar
//
//  Created by 朱德坤 on 2019/11/12.
//  Copyright © 2019 DKJone. All rights reserved.
//

import GameKit
import SpriteKit
import SwiftyJSON
class SwitchSessionScene: SKScene {
    private var nextSession = 0
    private var redPoint = SKSpriteNode()
    private var bgm = SKAudioNode(fileNamed: "bgm_switch_sesion_01.mp3")
    private let headerNode = SKSpriteNode(imageNamed: "pic_header_qiao")

    var dialogues = [DialogueModel]()
    var currentDiaIndex = 0 {
        didSet {
            if currentDiaIndex == dialogues.count {
                switchSession()
            }
        }
    }

    /// 对话文字
    private lazy var labelNode: SKLabelNode = {
        let labelNode = SKLabelNode()
        labelNode.numberOfLines = 0
        labelNode.fontSize = 16
        labelNode.fontName = "Helvetica-Bold"
        labelNode.horizontalAlignmentMode = .left
        labelNode.verticalAlignmentMode = .top
        return labelNode
    }()

    /// 对话文字
    private lazy var shineNode: SKLabelNode = {
        let labelNode = SKLabelNode()
        labelNode.numberOfLines = 0
        labelNode.fontSize = 16
        labelNode.fontName = "Helvetica-Bold"
        labelNode.text = "▼"
        return labelNode
    }()

    /// 矩形框
    private lazy var rectNode: SKSpriteNode = {
        let rectNode = SKSpriteNode(imageNamed: "pic_rectbg")
        rectNode.size = CGSize(width: mapNode.size.width, height: 140)
        rectNode.position = CGPoint(x: frame.width / 2, y: rectNode.frame.height / 2 + 15)
        rectNode.isHidden = true

        rectNode.addChilds(childs: [headerNode, labelNode, shineNode])
        let herderX = headerNode.size.width / 2 - rectNode.size.width / 2 + 30
        headerNode.position = CGPoint(x: herderX, y: 10)
        let labelX = -rectNode.size.width / 2 + 60 + headerNode.size.width
        let labelY = rectNode.size.height / 2 - 20
        labelNode.position = CGPoint(x: labelX, y: labelY)
        self.headerNode.zPosition = 2
        self.labelNode.zPosition = 2
        self.shineNode.zPosition = 2
        self.shineNode.position = CGPoint(x: 0, y: -rectNode.size.height / 2 + 15)
        return rectNode
    }()

    init(toSession: Int, size: CGSize) {
        nextSession = toSession
        super.init(size: size)
        let path = Bundle.main.url(forResource: "Session1Dialogue", withExtension: "json")!
        DispatchQueue.global().async {
            self.dialogues = JSON(parseJSON: try! String(contentsOf: path))
                .arrayValue
                .map(DialogueModel.from(json:))
        }

        mapNode.size = CGSize(width: mapNode.size.width, height: frame.height - 160)
        mapNode.position = CGPoint(x: frame.width / 2, y: frame.height - mapNode.size.height / 2 - 5)
        redPoint.color = .red
        let rWidth = mapNode.size.width / 8
        let rHight = mapNode.size.height / 8
        redPoint.size = CGSize(width: rWidth, height: rHight)
        redPoint.zPosition = -2
        bgm.autoplayLooped = false
        mapNode.addChild(redPoint)
        let sessionPointPosiation: (CGFloat, CGFloat) = [(0, 0), (0, 2), (0, 5),
                                                         (1, 5), (2, 6), (2, 1),
                                                         (4, 3), (6, 3), (6, 2),
                                                         (5, 3)][toSession - 1]
        let rx = -rWidth * 4 + rWidth / 2 + sessionPointPosiation.0 * rWidth
        let ry = rHight * 4 - rHight / 2 - sessionPointPosiation.1 * rHight
        redPoint.position = CGPoint(x: rx, y: ry)
        rectNode.position = CGPoint(x: frame.width / 2, y: size.height / 2 - rectNode.size.height + 15)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let mapNode = SKSpriteNode(imageNamed: "pic_map1")

    override func didMove(to view: SKView) {
        addChilds(childs: [mapNode, bgm, rectNode])
        redPoint.run(.repeat(.sequence([.fadeOut(withDuration: 0.2), .playSoundFileNamed("bgm_point.mp3", waitForCompletion: false), .fadeIn(withDuration: 0.2)]), count: 3)) {
            self.bgm.run(.play())
            self.rectNode.run(.unhide())
            self.shineNode.run(.repeatForever(.sequence([.fadeOut(withDuration: 0.4), .fadeIn(withDuration: 0.4)])))
        }

        uploadDialogue()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentDiaIndex += 1
        uploadDialogue()
    }

    private func uploadDialogue() {
        let fadeWith: (SKAction) -> SKAction = { act in
            .sequence([.fadeAlpha(by: -1, duration: 0.2), act,
                       .fadeAlpha(by: 1, duration: 0.5)])
        }

        if currentDiaIndex >= dialogues.count { return }
        labelNode.run(fadeWith(.run { [unowned self] in
            self.labelNode.text = self.dialogues[self.currentDiaIndex].text
        }))
        let texture = SKTexture(imageNamed: dialogues[currentDiaIndex].header)

        headerNode.run(fadeWith(.run { [unowned self] in
            self.headerNode.texture = texture
        }))

        shineNode.run(fadeWith(.run { [unowned self] in
            self.shineNode.isHidden = !self.dialogues[self.currentDiaIndex].hasNext
        }))
    }

    private func switchSession() {
        let scene = SessionNameScene(session: nextSession, size: self.size)
        self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
    }
}
