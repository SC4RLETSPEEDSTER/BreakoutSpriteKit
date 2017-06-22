//
//  GameScene.swift
//  Breakout
//
//  Created by Sai Girap on 6/21/17.
//  Copyright © 2017 Sai Girap. All rights reserved.
//

import SpriteKit
import GameplayKit

// add to use contact physics
class GameScene: SKScene, SKPhysicsContactDelegate, Alertable
{
    var ball : SKSpriteNode!
    var paddle : SKSpriteNode!
    var brick : SKSpriteNode!
    
    var blockArray : [String] = []
    var brickArray : [SKSpriteNode] = []
    
    var loseZone : SKSpriteNode!
    var life = 3
    var livesLabel : SKLabelNode!
    var levelLabel : SKLabelNode!
    var level = 1
    
    override func didMove(to view: SKView)
    {
        
        
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) //makes edge of view part of physics
        createBackground()
        generatePaddle()
        makeBall()
        constructLoseZone()
        fabricateLives()
        installLevel()
        conceiveBrick(Xpoint: Double(frame.minX + 60), Ypoint: Double(frame.maxY - 100), Name : "Sai the goat")
        conceiveBrick(Xpoint: Double(frame.minX + 65 + frame.width/6), Ypoint: Double(frame.maxY - 100), Name : "Andrew")
        conceiveBrick(Xpoint: Double(frame.minX + 70 + frame.width/3), Ypoint: Double(frame.maxY - 100), Name : "Akul")
        conceiveBrick(Xpoint: Double(frame.minX + 75 + frame.width/2), Ypoint: Double(frame.maxY - 100), Name : "Ronak is not the goat")
        conceiveBrick(Xpoint: Double(frame.minX + 80 + frame.width/1.5), Ypoint: Double(frame.maxY - 100), Name : "Aum is not the goat")
        
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    
        if ball.physicsBody?.isDynamic == false
        {
            ball.physicsBody?.isDynamic = true
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
        }
        
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        for bricks in brickArray
        {
            
            if contact.bodyA.node?.name == bricks.name || contact.bodyB.node?.name == bricks.name
            {
            print("Brick hit")
            bricks.removeFromParent()
            brickArray.remove(at: brickArray.index(of: bricks)!)
                
                if brickArray.count == 0
                {
                    nextLevelAlert(withTitle: "Nice Job!", message: "You have advanced to the next level! You now have two lives!")
                    pauseGame()
                    levelTwo()
                    fabricateLives()
                    
                }
            }
             
        }
        
        
        
            if contact.bodyA.node?.name == "Lose Zone" || contact.bodyB.node?.name == "Lose Zone"
            {
           
                
                print("\(life) before loop")
                
                if life > 1
                {
                    life -= 1
                    showAlert(withTitle: "OH NO!", message: "You have lost a life!")
                    livesLabel.text = "Lives: \(life)"
                    pauseGame()
                }
                
                else
                {
                    pauseGame()
                    gameOverAlert(withTitle: "Game Over!", message: "You have lost all of your lives!")
                
                    restartGame()
                }
                

            }
          
        
        
    }
    
    

    
    
    
    func createBackground()
    {
       let stars = SKTexture(imageNamed: "Wow")
        
        for i in 0...1 //creates 2 stars for seamless transition
        {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1  //set stacking order
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height * CGFloat(i) - CGFloat(1 * i)))
            
            addChild(starsBackground)
            
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 100)
            let reset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, reset])
            let loop = SKAction.repeatForever(moveLoop)
            
            starsBackground.run(loop)
        }
        
    }
    
    func makeBall()
    {
        let ballDiameter = frame.width/20
        ball = SKSpriteNode(color: UIColor.white, size: CGSize(width: ballDiameter, height: ballDiameter))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.name = "Ball"
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballDiameter/2)
        //applies physics body to ball
        
        ball.physicsBody?.isDynamic = false  //ignores all forces and impulses
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball)
        
    }
    
    func generatePaddle()
    {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/5, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "Paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        
        addChild(paddle)
        
    }
    
    func conceiveBrick(Xpoint : Double, Ypoint : Double, Name : String)
    {
        brick = SKSpriteNode(color: UIColor.green, size: CGSize(width: frame.width/6, height: frame.height/24.5))
        brick.position = CGPoint(x: Xpoint, y: Ypoint)
        brick.name = Name
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        blockArray.append(brick.name!)
        brickArray.append(brick)
        addChild(brick)
        
    }
    
    func constructLoseZone()
    {
        loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 100))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        loseZone.name = "Lose Zone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        
        addChild(loseZone)
    }
    
    func fabricateLives()
    {
        livesLabel = SKLabelNode(fontNamed: "Hiragino Mincho ProN W3")
        livesLabel.position = CGPoint(x: frame.minX + 70, y: frame.maxY - 45)
        livesLabel.zPosition = 100
        livesLabel.fontSize = 32.0
        livesLabel.fontColor = UIColor.white
        livesLabel.text = "Lives: \(life)"
        addChild(livesLabel)
    }
    
    func installLevel()
    {
        levelLabel = SKLabelNode(fontNamed: "Hiragino Mincho ProN W3")
        levelLabel.position = CGPoint(x: frame.maxX - 70, y: frame.maxY - 45)
        levelLabel.zPosition = 100
        levelLabel.fontSize = 32.0
        levelLabel.fontColor = UIColor.white
        levelLabel.text = "Level: \(level)"
        addChild(levelLabel)
        
    }
    
    func pauseGame(){
        scene?.view?.isPaused = true
    }
    // and for play. use this.
    
    func restartGame()
    {
        removeAllChildren()
        life = 3
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) //makes edge of view part of physics
        createBackground()
        generatePaddle()
        makeBall()
        constructLoseZone()
        fabricateLives()
        installLevel()
        conceiveBrick(Xpoint: Double(frame.minX + 60), Ypoint: Double(frame.maxY - 100), Name : "Sai the goat")
        conceiveBrick(Xpoint: Double(frame.minX + 65 + frame.width/6), Ypoint: Double(frame.maxY - 100), Name : "Andrew")
        conceiveBrick(Xpoint: Double(frame.minX + 70 + frame.width/3), Ypoint: Double(frame.maxY - 100), Name : "Akul")
        conceiveBrick(Xpoint: Double(frame.minX + 75 + frame.width/2), Ypoint: Double(frame.maxY - 100), Name : "Ronak is not the goat")
        conceiveBrick(Xpoint: Double(frame.minX + 80 + frame.width/1.5), Ypoint: Double(frame.maxY - 100), Name : "Aum is not the goat")
    }
    
    func levelTwo()
    {
        removeAllChildren()
        life = 2
        level = 2
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) //makes edge of view part of physics
        createBackground()
        generatePaddle()
        makeBall()
        constructLoseZone()
        fabricateLives()
        installLevel()
        
        conceiveBrick(Xpoint: Double(frame.minX + 60), Ypoint: Double(frame.maxY - 100), Name : "Sai the goat")
        conceiveBrick(Xpoint: Double(frame.minX + 65 + frame.width/6), Ypoint: Double(frame.maxY - 100), Name : "Andrew")
        conceiveBrick(Xpoint: Double(frame.minX + 70 + frame.width/3), Ypoint: Double(frame.maxY - 100), Name : "Akul")
        conceiveBrick(Xpoint: Double(frame.minX + 75 + frame.width/2), Ypoint: Double(frame.maxY - 100), Name : "Ronak is not the goat")
        conceiveBrick(Xpoint: Double(frame.minX + 80 + frame.width/1.5), Ypoint: Double(frame.maxY - 100), Name : "Aum is not the goat")
        
        
        
        conceiveBrick(Xpoint: Double(frame.minX + 60), Ypoint: Double(frame.maxY - 100 - frame.height/25 - 5), Name : "Sai the ghat")
        conceiveBrick(Xpoint: Double(frame.minX + 65 + frame.width/6), Ypoint: Double(frame.maxY - 100 - frame.height/25 - 5), Name : "Andrewh")
        conceiveBrick(Xpoint: Double(frame.minX + 70 + frame.width/3), Ypoint: Double(frame.maxY - 100 - frame.height/25 - 5), Name : "Akulh")
        conceiveBrick(Xpoint: Double(frame.minX + 75 + frame.width/2), Ypoint: Double(frame.maxY - 100 - frame.height/25 - 5), Name : "Ronak is not the goht")
        conceiveBrick(Xpoint: Double(frame.minX + 80 + frame.width/1.5), Ypoint: Double(frame.maxY - 100 - frame.height/25 - 5), Name : "Aum is not the goht")
    }
    
    
    
}
