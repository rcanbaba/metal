//
//  GameScene.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 27.10.2022.
//

import MetalKit

class GameScene: Scene {
    
    enum Constants {
        static let gameHeight: Float = 48
        static let gameWidth: Float = 27
        static let bricksPerRow = 8
        static let bricksPerColumn = 8
    }
    
    let ball: Model
    let paddle: Model
    
    let bricks: Instance
    
    var previousTouchLocation: CGPoint = .zero
    
    var ballVelocityX: Float = 0
    var ballVelocityY: Float = 0
    
    override init(device: MTLDevice, size: CGSize) {
        ballVelocityX = 20
        ballVelocityY = 15
        ball = Model(device: device, modelName: "ball")
        paddle = Model(device: device, modelName: "paddle")
        bricks = Instance(device: device, modelName: "brick", instances: Constants.bricksPerRow * Constants.bricksPerColumn)
        super.init(device: device, size: size)
        camera.position.z = -sceneOffset(height: Constants.gameHeight, fov: camera.fovRadians)
        camera.position.x = -Constants.gameWidth / 2
        camera.position.y = -Constants.gameHeight / 2
        camera.rotation.x = radians(fromDegrees: 20)
        camera.position.y = -Constants.gameHeight / 2 + 4
        
        light.color = SIMD3<Float>(repeating: 1)
        light.ambientIntensity = 0.3
        light.diffuseIntensity = 0.8
        light.direction = SIMD3<Float>(0, -1, -1)
        setupScene()
    }
    
    override func update(deltaTime: Float) {
        var bounced = false
        for brick in bricks.nodes {
            brick.rotation.x += π / 4 * deltaTime
            brick.rotation.y += π / 4 * deltaTime
            brick.rotation.z += π / 4 * deltaTime
        }
        
        ball.position.x += ballVelocityX * deltaTime
        ball.position.y += ballVelocityY * deltaTime
        //ball.position.z += 10 * deltaTime
        if ball.position.y > Constants.gameHeight {
            ball.position.y = Constants.gameHeight
            ballVelocityY = -ballVelocityY
            bounced = true
        }
        if ball.position.x < 0 {
            ball.position.x = 0
            ballVelocityX = -ballVelocityX
            bounced = true
        }
        if ball.position.x > Constants.gameWidth {
            ball.position.x = Constants.gameWidth
            ballVelocityX = -ballVelocityX
            bounced = true
        }
        if ball.position.y < 0 {
            endGame(win: false)
        }
        
        // checks paddle-ball collision
        let ballRect = ball.boundingBox(camera.viewMatrix)
        let paddleRect = paddle.boundingBox(camera.viewMatrix)
        
        if ballRect.intersects(paddleRect) {
            ballVelocityY = -ballVelocityY
            bounced = true
        }
        
        // checks bircks-ball collision
        for (index, brick) in bricks.nodes.enumerated() {
            let brickRect = brick.boundingBox(camera.viewMatrix)
            
            if ballRect.intersects(brickRect) {
                ballVelocityY = -ballVelocityY
                bricks.remove(instance: index)
                break
            }
        }
        
        if bricks.nodes.count == 0 {
          endGame(win: true)
        }
        
        if bounced {
            SoundController.shared.playPopEffect()
        }
    }
    
    func sceneOffset(height: Float, fov: Float) -> Float {
        return (height / 2) / tan(fov / 2)
    }
    
    func setupScene() {
        ball.position.x = Constants.gameWidth / 2
        ball.position.y = Constants.gameHeight * 0.1
        ball.materialColor = SIMD4<Float>(0.5, 0.9, 0, 1)
        add(childNode: ball)
        
        paddle.position.x = Constants.gameWidth / 2
        paddle.position.y = Constants.gameHeight * 0.05
        paddle.materialColor = SIMD4<Float>(1, 0, 0, 1)
        add(childNode: paddle)
        
        let border = Model(device: device, modelName: "border")
        border.position.x = Constants.gameWidth/2
        border.position.y = Constants.gameHeight/2
        border.materialColor = SIMD4<Float>(0.5, 0.25, 0, 1)
        add(childNode: border)
        
        let colors = generateColors(number: Constants.bricksPerRow)
        
        let margin = Constants.gameWidth * 0.11
        let topInset = Constants.gameHeight * 0.5
        
        for row in 0..<Constants.bricksPerRow {
            for column in 0..<Constants.bricksPerColumn {
                var position = SIMD3<Float>(repeating: 0)
                position.x = margin + (margin * Float(row))
                position.y = topInset + (margin * Float(column))
                let index = row * Constants.bricksPerColumn + column
                bricks.nodes[index].position = position
                bricks.nodes[index].materialColor = colors[row]
            }
        }
        
        add(childNode: bricks )
    }
    
    func endGame(win: Bool) {
        let gameOverScene = GameOverScene(device: device, size: size)
        gameOverScene.win = win
        sceneTransitionDelegate?.transition(to: gameOverScene)
    }
    
    override func touchesBegan(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        previousTouchLocation = touch.location(in: view)
    }
    
    override func touchesMoved(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: view)
        let delta = CGPoint(x: touchLocation.x - previousTouchLocation.x, y: touchLocation.y - previousTouchLocation.y)
        let deltaX = Float(delta.x) * (Constants.gameWidth / Float(size.width))
        
        var newX = paddle.position.x + deltaX
        newX = min(max(newX, paddle.width/2), Constants.gameWidth - paddle.width/2)
        paddle.position.x = newX
        
        previousTouchLocation = touchLocation
    }
    
}

