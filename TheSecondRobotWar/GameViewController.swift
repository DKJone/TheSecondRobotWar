//
//  GameViewController.swift
//  TheSecondRobotWar
//
//  Created by 朱德坤 on 2019/11/11.
//  Copyright © 2019 DKJone. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            print(view.safeAreaInsets)
            let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height))
            scene.scaleMode = .aspectFit
            scene.position = CGPoint.zero
            view.presentScene(scene)
//            if let scene = Session1Scene(fileNamed: "Session1Scene") {
//                view.presentScene(scene)
//            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
