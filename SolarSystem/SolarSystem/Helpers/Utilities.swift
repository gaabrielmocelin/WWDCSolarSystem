//
//  Utilities.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 21/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

extension SCNNode {
    func addChild(_ node: SCNNode) {
        if node.parent != nil {
            node.removeFromParentNode()
        }
        self.addChildNode(node)
    }
}

extension UIView {
    func fadeIn(completion: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(completion: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func addSubviewWithSameAnchors(_ view: UIView?) {
        guard let view = view else { return }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    }
}

extension Float{
    var radians: Float{
        return self * Float(Double.pi) / 180
    }
}

extension SCNGeometry{
    func setMaterial(with content: Any?, constant: Bool = false) {
        let material = SCNMaterial()
        
        if constant{
            material.lightingModel = .constant
        }
        
        if let content = content as? UIImage{
            material.diffuse.contents = content
            self.firstMaterial = material
        }else if let content = content as? UIColor{
            material.diffuse.contents = content
            self.firstMaterial = material
        }
    }
}

// MARK: - float4x4 extensions

extension float4x4 {
    /**
     Treats matrix as a (right-hand column-major convention) transform matrix
     and factors out the translation component of the transform.
     */
    var translation: float3 {
        get {
            let translation = columns.3
            return float3(translation.x, translation.y, translation.z)
        }
        set(newValue) {
            columns.3 = float4(newValue.x, newValue.y, newValue.z, columns.3.w)
        }
    }
    
    /**
     Creates a transform matrix with a uniform scale factor in all directions.
     */
    init(uniformScale scale: Float) {
        self = matrix_identity_float4x4
        columns.0.x = scale
        columns.1.y = scale
        columns.2.z = scale
    }
}
