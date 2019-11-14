//
//  Session1Scene.swift
//  TheSecondRobotWar
//
//  Created by 朱德坤 on 2019/11/13.
//  Copyright © 2019 DKJone. All rights reserved.
//

import SpriteKit
import AVFoundation
class Session1Scene: SKScene {
    private var mainCamera: SKCameraNode!
    private var mapNode: SKTileMapNode!
    private var bgm = SKAudioNode(fileNamed: "bgm_fight_01.mp3")
    var bgmPlayer : AVAudioPlayer!
    override func didMove(to view: SKView) {
        mainCamera = childNode(withName: "mainCamera") as? SKCameraNode
        mapNode = childNode(withName: "mapNode") as? SKTileMapNode
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipe(sender:))))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tape(sender:))))

        //初始视图位置为右下角
        mainCamera.position = CGPoint(x: mapNode.frame.maxX - frame.width / 2, y: mapNode.frame.minY + frame.height / 2)
        //        bgm.autoplayLooped = false
//        addChild(bgm)
        bgmPlayer = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "bgm_fight_01", withExtension: "mp3")!)
        bgmPlayer.numberOfLoops = Int.max
        bgmPlayer.play()
    }

    @objc func swipe(sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: sender.view!.superview!)
            var x = mainCamera.position.x - translation.x
            // 是否超出左侧区域
            x = max(x, mapNode.frame.minX + frame.width / 2)
            // 是否超出右侧区域
            x = min(x, mapNode.frame.maxX - frame.width / 2)

            var y = mainCamera.position.y + translation.y
            //是否超出地图顶部
            y = min(y,mapNode.frame.maxY - frame.height / 2)
            //是否超出地图底部
            y = max(y,mapNode.frame.minY + frame.height / 2)
            mainCamera.position = CGPoint(x: x, y: y)
            sender.setTranslation(CGPoint.zero, in: sender.view!.superview!)

        }
    }

    @objc func tape(sender: UITapGestureRecognizer) {
        print(sender.location(in: view!))
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(touches.first?.location(in: self))
//    }
    

}
