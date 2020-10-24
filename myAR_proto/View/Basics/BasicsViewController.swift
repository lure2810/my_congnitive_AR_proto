//
//  BasicsViewController.swift
//  ARKit-Emperor
//
//  Created by 福嶋稜 on 2020/07/22.
//  Copyright © 2020 福嶋稜. All rights reserved.
//

import UIKit
import ARKit

class BasicsViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical]
        configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration, options: [])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ship = SCNScene(named: "art.scnassets/minidora_test copy.scn")!
        let shipNode = ship.rootNode.childNodes.first!
        shipNode.scale = SCNVector3(0.1,0.1,0.1)
        shipNode.rotation = SCNVector4(0, 0, 1, 1.0 * Double.pi)
        
        //カメラ座標系で30cm前
        let infrontCamera = SCNVector3Make(0, 0, -0.3)
        
        guard let cameraNode = sceneView.pointOfView else{
            return
        }
        
        //ワールド座標系
        let pointInWorld = cameraNode.convertPosition(infrontCamera, to: nil)
        
        //スクリーン座標系へ
        var screenPosition = sceneView.projectPoint(pointInWorld)
        
        //スクリーン座標系
        guard let location: CGPoint = touches.first?.location(in: sceneView) else {
            return
        }
        screenPosition.x = Float(location.x)
        screenPosition.y = Float(location.y)
        
        //ワールド座標系
        let finalPosition = sceneView.unprojectPoint(screenPosition)
        
        shipNode.position = finalPosition
        sceneView.scene.rootNode.addChildNode(shipNode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
