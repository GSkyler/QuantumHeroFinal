//
//  GameScreenViewController.swift
//  QuantumHeroBasicDemo
//
//  Created by Conant Mac 1931509 on 4/9/20.
//  Copyright © 2020 Skyler Gao. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameScreenViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view works")
        print(self.view.debugDescription)
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill

                // Present the scene
                view.presentScene(scene)
            }

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
