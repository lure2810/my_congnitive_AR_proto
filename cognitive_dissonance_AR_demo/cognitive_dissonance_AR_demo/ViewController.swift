//
//  ViewController.swift
//  cognitive_dissonance_AR_demo
//
//  Created by 福嶋稜 on 2020/11/18.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController,ARSCNViewDelegate, ARSessionDelegate{

    @IBOutlet var sceneView: ARSCNView!
    
    var session: ARSession {
        return sceneView.session
    }
    
    let contentUpdater = VirtualContentUpdater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sceneView.delegate = contentUpdater
        sceneView.delegate = contentUpdater
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true //シーンの照明を更新するかどうか

        contentUpdater.virtualFaceNode = createFaceNode()
        
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true //デバイスの自動光調節をOFF
        startSession()
        
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//
//        // Run the view's session
//        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause() //セッション停止
        
//        // Pause the view's session
//        sceneView.session.pause()
    }
    
    //マスクを生成
    public func createFaceNode() -> VirtualFaceNode? {
        guard
            let device = sceneView.device,
            let geometry = ARSCNFaceGeometry(device : device) else {
            return nil
        }

        return Mask(geometry: geometry)
    }

    //セッション開始
    func startSession() {
        print("STARTING A NEW SESSION")
        guard ARFaceTrackingConfiguration.isSupported else { return } //ARFaceTrackingをサポートしているか
        let configuration = ARFaceTrackingConfiguration() //顔の追跡を実行するための設定
        configuration.isLightEstimationEnabled = true //オブジェクトにシーンのライティングを提供するか
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        guard error is ARError else { return }
        print("SESSION ERROR")
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("SESSION INTERRUPTED")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        DispatchQueue.main.async {
            self.startSession() //セッション再開
        }
    }
}
