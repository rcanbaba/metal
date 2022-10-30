//
//  LandscapeScene.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 30.10.2022.
//

import MetalKit

class LandscapeScene: Scene {
    
    let sun: Model
    let ground: Plane
    let grass: Instance
    let mushroom: Model
    
    override init(device: MTLDevice, size: CGSize) {
        sun = Model(device: device, modelName: "sun")
        ground = Plane(device: device)
        grass = Instance(device: device, modelName: "grass", instances: 10000)
        mushroom = Model(device: device, modelName: "mushroom")
        super.init(device: device, size: size)
         
        setupScene()
    }
    
    override func update(deltaTime: Float) {
    }
    
    func setupScene() {
        add(childNode: sun)
        add(childNode: ground)
        add(childNode: grass)
        add(childNode: mushroom)
        
        ground.materialColor = SIMD4<Float>(0.4, 0.3, 0.1, 1) // brown
        ground.scale = SIMD3<Float>(repeating: 20)
        ground.rotation.x = radians(fromDegrees: 90)
        
        camera.rotation.x = radians(fromDegrees: -10)
        camera.position.z = -20
        camera.position.y = -2
        
        //grass
        let greens = [
            SIMD4<Float>(0.34, 0.51, 0.01, 1),
            SIMD4<Float>(0.5, 0.5, 0, 1),
            SIMD4<Float>(0.29, 0.36, 0.14, 1)
        ]
        
        for row in 0..<100 {
          for column in 0..<100 {
            var position = SIMD3<Float>(repeating: 0)
            position.x = (Float(row))/4
            position.z = (Float(column))/4
            let blade = grass.nodes[row * 100 + column]
            blade.scale = SIMD3<Float>(repeating: 0.5)
            blade.position = position
            blade.materialColor = greens[Int(arc4random_uniform(3))]
            blade.rotation.y =
                radians(fromDegrees: Float(arc4random_uniform(360)))
          }
        }
        
        grass.position.x = -12
        grass.position.z = -12
        
        mushroom.position.x = -6
        mushroom.position.z = -8
        mushroom.scale = SIMD3<Float>(repeating: 2)
        
        sun.materialColor = SIMD4<Float>(1,1,0,1)
        sun.position.y = 7
        sun.position.x = 6
        sun.scale = SIMD3<Float>(repeating: 2)
        
        camera.fovDegrees = 25
    }
}
