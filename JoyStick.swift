//
//  JoyStick.swift
//  RogueGameStarkAliens
//
//  Created by claudio Cavalli on 07/04/2019.
//  Copyright © 2019 claudio Cavalli. All rights reserved.
//
/*joystik reference utili:
 https://www.youtube.com/watch?v=O6TPHgq0Ryo
 https://cartoonsmart.com/how-to-create-a-virtual-ios-joystick-with-swift-and-sprite-kit/
 https://github.com/Ishawn-Gullapalli/SpritekitJoystick
 */

import SpriteKit

class Joystick: SKNode {
    // MARK: - inizializza la base del joyStick.
    let base: SKSpriteNode = {
        let shape = SKSpriteNode(imageNearest: "joystickBase")
        shape.size = CGSize(width: screenSize.height * 0.15 * 2, height: screenSize.height * 0.15 * 2)
        shape.name = "base"
        shape.alpha = 1
        return shape
    }()
    // MARK: - inizializza lo stick del joyStick.
    let stick: SKSpriteNode = {
        let shape = SKSpriteNode(imageNearest: "joystickTop")
        shape.size = CGSize(width: screenSize.height * 0.08 * 2, height: screenSize.height * 0.08 * 2)
        shape.name = "stick"
        shape.alpha = 1
        return shape
    }()
    //MARK: - velocità player
    var velocity  = CGPoint.zero
    //MARK: - distanza dal centro
    var distance  = CGFloat()
    //MARK: - radius massimo
    private let maxRadius = CGFloat(screenSize.height * 0.15)
    var isMovible  = false
    var isSelected = false
    // MARK: init
    override init() {
        super.init()
        self.isUserInteractionEnabled = true
        self.addChild(self.base)
        stick.zPosition = base.zPosition+1
        self.addChild(self.stick)
    }
    // MARK: required init
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: quando il touch si muove cambia la posizione dello stick e la velocità
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isUserInteractionEnabled = true
        self.alpha = 1
        self.stick.position = touches.first!.location(in: self)
        distance = distanceValue(point: stick.position)
        let angleDistance = atan2(stick.position.y, stick.position.x)
        let velocityDistance = CGPoint(x: cos(angleDistance)*distance, y: sin(angleDistance)*distance)
        checkMove(distance: distance)
        let x = screenSize.height * 0.15 / 64
        let proportionalDistance = distance/x
        let angle = atan2(stick.position.y, stick.position.x)
        self.velocity = CGPoint(x: cos(angle)*proportionalDistance, y: sin(angle)*proportionalDistance)
        stick.position = velocityDistance
        distance = proportionalDistance
    }
    // MARK: riposiziona stick e resetta la velocità
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resetStick()
        let fade = SKAction.fadeAlpha(to: 0, duration: 0.2)
        self.run(fade)
        self.isUserInteractionEnabled = false
    }
    // MARK: controlla se il joystick deve muoversi o no
    private func checkMove(distance: CGFloat) {
        if distance == maxRadius {
            isMovible = true
        } else {
            isMovible = false
        }
    }
    // MARK: distanza stick
    private func distanceValue(point: CGPoint) -> CGFloat {
        let distance = (sqrt((point.x * point.x) + (point.y * point.y)))
        return (distance > maxRadius) ?  maxRadius : distance
    }
    // MARK: reset stick
    private func resetStick() {
        self.velocity = .zero
        let easeOut = SKAction.move(to: .zero, duration: 0.3)
        easeOut.timingMode = SKActionTimingMode.easeOut
        self.stick.run(easeOut)
    }
}
