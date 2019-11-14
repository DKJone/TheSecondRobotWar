//
//  GameScene.swift
//  TheSecondRobotWar
//
//  Created by 朱德坤 on 2019/11/11.
//  Copyright © 2019 DKJone. All rights reserved.
//

import AVFoundation
import GameplayKit
import SpriteKit
class GameScene: SKScene {
    /** frame
     (0,frame.height)              (frame.height,frame.width)

     (0,0)                         (frame.width,0)
     */

    /// 游戏名称
    private lazy var titleNode: SKSpriteNode = {
        let titleNode = SKSpriteNode()
        let subTitle1 = SKSpriteNode(imageNamed: "pic_name_1")
        let subTitle2 = SKSpriteNode(imageNamed: "pic_name_2")
        titleNode.addChild(subTitle1)
        titleNode.addChild(subTitle2)
        subTitle1.name = "title1"
        let rate: CGFloat = 2205.0 / 265
        let imageWidth = subTitle1.size.width
        let imageHeight = subTitle1.size.height
        let title1Position = CGPoint(x: 0, y: imageHeight / 2)
        let title2Position = CGPoint(x: 0, y: -imageHeight / 2)

        titleNode.position = CGPoint(x: frame.width / 2, y: frame.height - imageHeight - 20)
        subTitle1.position = CGPoint(x: frame.width, y: imageHeight / 2)
        subTitle2.position = CGPoint(x: -frame.width, y: -imageHeight / 2)
        titleNode.size = CGSize(width: imageWidth, height: imageHeight * 2)
        let moveAction1 = SKAction.sequence([.move(to: CGPoint(x: -imageWidth / 4, y: title1Position.y), duration: 0.4), .move(to: title1Position, duration: 0.3)])
        let moveAction2 = SKAction.sequence([.move(to: CGPoint(x: imageWidth / 4, y: title2Position.y), duration: 0.4), .move(to: title2Position, duration: 0.3)])
        subTitle1.run(moveAction1)
        subTitle2.run(moveAction2)

        let shadow1 = SKSpriteNode(imageNamed: "pic_name_1")
        shadow1.zPosition = -1
        shadow1.isHidden = true
        titleNode.addChild(shadow1)
        let transForm = CGAffineTransform(a: 1.05, b: 0, c: 0, d: 1, tx: 1, ty: 1)
        shadow1.size = subTitle1.size.applying(transForm)
        shadow1.position = title1Position
        let shadow2 = SKSpriteNode(imageNamed: "pic_name_2")
        shadow2.zPosition = -1
        shadow2.position = title2Position
        titleNode.addChild(shadow2)
        shadow2.size = subTitle2.size.applying(transForm)

        let lightBlue = UIColor(hex: 0x0123af)!
        let img2 = UIImage(named: "pic_name_2")! // UIImage(cgImage: shadow2.texture!.cgImage())
        let img1 = UIImage(named: "pic_name_1")! // UIImage(cgImage: shadow1.texture!.cgImage())
        let img2w = img2.filled(withColor: .white)
        let img2b = img2.filled(withColor: lightBlue)
        let img1w = img1.filled(withColor: .white)
        let img1b = img1.filled(withColor: lightBlue)
        shadow2.position = title2Position
        shadow2.isHidden = true
        shadow2.run(.sequence([.wait(forDuration: 1.2), .unhide(),
                               .setTexture(.init(image: img2w)),
                               .wait(forDuration: 0.1),
                               .setTexture(.init(image: img2b))]))
        addChild(bgm)
        shadow1.run(.sequence([.wait(forDuration: 1.2), .unhide(),
                               .setTexture(.init(image: img1w)),
                               .wait(forDuration: 0.1),
                               .setTexture(.init(image: img1b))])) {
            self.bgm.run(.play())
        }

        return titleNode
    }()

    /// 背景音乐
    private lazy var bgm: SKAudioNode = {
        let bgm = SKAudioNode(fileNamed: "bgm_home.mp3")
        bgm.autoplayLooped = false
        return bgm
    }()

    /// 矩形框
    private lazy var rectNode: SKSpriteNode = {
        let rectNode = SKSpriteNode(imageNamed: "pic_rectbg")
        rectNode.size = CGSize(width: titleNode.size.width + 80, height: 120)
        rectNode.position = CGPoint(x: frame.width / 2, y: rectNode.frame.height / 2 + 15)
        return rectNode
    }()

    let startMenu = SKSpriteNode(imageNamed: "pic_home_menu1")
    let continueMenu = SKSpriteNode(imageNamed: "pic_home_menu2")
    let loadMenu = SKSpriteNode(imageNamed: "pic_home_menu3")
    let menuPoint = SKSpriteNode(imageNamed: "icon_menuPoint")

    /// 菜单区域
    private lazy var menuNode: SKSpriteNode = {
        let menu = SKSpriteNode()
        menu.addChilds(childs: [self.startMenu, self.continueMenu, self.loadMenu, self.menuPoint])
        menu.size = CGSize(width: self.startMenu.size.width, height: self.startMenu.size.height * 3)
        menu.position = self.view!.center
//        menu.color = .white
        let width = self.startMenu.size.width
        let height = self.startMenu.size.height
        self.startMenu.position = CGPoint(x: 0, y: height / 2 + 15)
        self.loadMenu.position = CGPoint(x: 0, y: -height / 2 - 15)
        self.menuPoint.position = CGPoint(x: -width / 2 - 20, y: height / 2 + 15)
        return menu
    }()

    override func didMove(to view: SKView) {
        backgroundColor = .black
        scaleMode = .aspectFit
        addChild(self.titleNode)
        addChilds(childs: [rectNode, menuNode])
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: menuNode) else{return}
        if startMenu.frame.contains(touchPoint){
            let switchScenne = SwitchSessionScene(toSession: 1,size:self.view!.size)
            self.view?.presentScene(switchScenne, transition: SKTransition.fade(with: .black, duration: 1))
            print("start")
        }else if continueMenu.frame.contains(touchPoint){
            print("continue")
        }else if loadMenu.frame.contains(touchPoint){
            print("load")
        }else{
            self.view?.presentScene(GameScene(size: self.size))
        }
    }
}
