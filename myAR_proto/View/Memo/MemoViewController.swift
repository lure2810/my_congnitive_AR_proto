//
//  MemoViewController.swift
//  ARKit-Emperor
//
//  Created by 福嶋稜 on 2020/07/29.
//  Copyright © 2020 福嶋稜. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

let texts: [String] = [
    "ゴゴゴ・・・",
    "ガタガタ",
    "ガヤガヤ",
    "どんどん",
    "ざわ。。ざわ。。",
    "ざあざあ",
    "ぺちゃくちゃ",
    "ヒソヒソ",
    "どーーん",
    "イライラ"
]

class MemoViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let defaultCOnfiguration:ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultCOnfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let size = Float.random(in: 0.001..<0.005)
        let depth = Float.random(in: 0.3..<0.7)
        let text = Int.random(in: 0..<10)
        let textGeometry = SCNText(string: texts[text], extrusionDepth: 5)
        let node = SCNNode(geometry: textGeometry)
        node.scale = SCNVector3(size, size, size)
        
        //カメラ座標系で30cm前
        let infrontCamera = SCNVector3Make(-0.1, 0, -depth)
           
        guard let cameraNode = sceneView.pointOfView else{
            return
        }
        
        //ワールド座標系
        let pointInWorld = cameraNode.convertPosition(infrontCamera, to: nil)
        
        var screenPosition = sceneView.projectPoint(pointInWorld)
        
        guard let location: CGPoint = touches.first?.location(in: sceneView) else {
            return
        }
        screenPosition.x = Float(location.x)
        screenPosition.y = Float(location.y)
        
        let finalPosition = sceneView.unprojectPoint(screenPosition)
        
        if let camera = sceneView.pointOfView{
            node.eulerAngles = camera.eulerAngles
            node.rotation = camera.rotation
        }
           
        node.position = finalPosition
        sceneView.scene.rootNode.addChildNode(node)
        
    }
}


