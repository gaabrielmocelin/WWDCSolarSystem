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

public extension SCNNode {
    public func addChild(_ node: SCNNode) {
        if node.parent != nil {
            node.removeFromParentNode()
        }
        self.addChildNode(node)
    }
    
    public func distance(ofAnchor anchor: ARAnchor) -> Float {
        return simd_distance(self.simdTransform.columns.3, anchor.transform.columns.3)
    }
}

public extension UIView {
    public func fadeIn(completion: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    public func fadeOut(completion: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
   public  func addSubviewWithSameAnchors(_ view: UIView?) {
        guard let view = view else { return }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    }
}

public extension Float{
    public var radians: Float{
        return self * Float(Double.pi) / 180
    }
}

public extension SCNGeometry{
   public  func setMaterial(with content: Any?, constant: Bool = false) {
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

public extension float4x4 {
    /**
     Treats matrix as a (right-hand column-major convention) transform matrix
     and factors out the translation component of the transform.
     */
    public var translation: float3 {
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
    public init(uniformScale scale: Float) {
        self = matrix_identity_float4x4
        columns.0.x = scale
        columns.1.y = scale
        columns.2.z = scale
    }
}
