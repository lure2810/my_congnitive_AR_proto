//
//  VirtualFaceContent.swift
//  cognitive_dissonance_AR_demo
//
//  Created by 福嶋稜 on 2020/11/18.
//
import UIKit
import SceneKit
import ARKit

protocol VirtualFaceContent {
    func update(withFaceAnchor: ARFaceAnchor)
}

typealias VirtualFaceNode = VirtualFaceContent & SCNNode

