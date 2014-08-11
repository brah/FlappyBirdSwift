//
//  GameScene.swift
//  FlappyBirdSwift
//
//  Created by Quincy Babin on 8/10/14.
//  Copyright (c) 2014 Quincy Babin. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    
    var bird = SKSpriteNode();
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var PipesMoveAndRemove = SKAction()
    var backgroundMusicPlayer: AVAudioPlayer!
    let pipeGap = 150.0
    
    override func didMoveToView(view: SKView) {
        var error: NSError?

        let backgroundMusicURL = NSBundle.mainBundle().URLForResource("background-music", withExtension: "aiff")
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: &error)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.play()

        
        /* Setup your scene here */
        //        let myLabel = SKLabelNode()
        //        myLabel.text = "Hello, World!";
        //        myLabel.fontSize = 100;
        //        myLabel.position = CGPoint(x:CGRectGetMaxX(self.frame), y:CGRectGetMaxY(self.frame));
        //
        //        self.addChild(myLabel)
        
        
        //Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0);
        
        
        //Bird (BirdTexture is using the image named spaceship in the folder)
        // (BirdTexture helps render the image into the app)
        
        var BirdTexture = SKTexture(imageNamed:"Spaceship")
        BirdTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        

        
        bird = SKSpriteNode(texture: BirdTexture)
        
        //scale and size of image
        
        bird.setScale(0.5)
        
        //Setting where the image position begins
        bird.position = CGPoint(x: self.frame.width * 0.35, y: self.frame.size.height * 0.6)
        
        
        //Physics of the bird
        // Physics body creates a radius around the bird so it allows it to hit things
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2.0)
        
        //Dynamic allows it to move (drop, fall, etc)
        bird.physicsBody.dynamic = true
        
        //don't want it to rotate
        bird.physicsBody.allowsRotation = false
        
        
        //calls bird object to be added to scene
        self.addChild(bird)
        
        
        //ground
        
        var groundTexture = SKTexture(imageNamed:"Image")
        
        var sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
        sprite.position = CGPointMake(self.size.width/2, sprite.size.height/2.0)
        self.addChild(sprite)
        
        
        
        //creating ground physics
        
        var ground = SKNode()
        
        
        
        //setting position of where the gravity 'aura' is ??
        ground.position = CGPointMake(0, groundTexture.size().height)
        //how big the gravity 'aura' is
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0))
        
        
        ground.physicsBody.dynamic = false
        self.addChild(ground)
        
        
        
        
        let skyTexture = SKTexture(imageNamed: "stars")
        skyTexture.filteringMode = .Nearest
        
        let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.001 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( skyTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.runAction(moveSkySpritesForever)
           self.addChild(sprite)
        }
        
        //Building
        
        //Creating the pipes
        pipeUpTexture = SKTexture(imageNamed:"Upbuilding")
        pipeDownTexture = SKTexture(imageNamed:"Downbuilding")
        
        // movement of pipes
        // creates a smooth movment for the pipes
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        
        //grabbing the distance it needs to move and certain time interval
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.01 * distanceToMove))
        //grabbing a sequence so it moves the pipes and remove the pipes
        let removePipes = SKAction.removeFromParent()
        PipesMoveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        //spawn pipes
        
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
    }
    
    func spawnPipes(){
        
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 2, 0)
        // if you had a background it would be -15
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0, CGFloat(y) + pipeDown.size.height + CGFloat(pipeGap))
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize:pipeDown.size)
        pipeDown.physicsBody.dynamic = false
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody.dynamic = false
        pipePair.addChild(pipeUp)
        
        pipePair.runAction(PipesMoveAndRemove)
        self.addChild(pipePair)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            //Location of where you click  (its set to self)
      
            
            let touch = touches.anyObject() as UITouch
            let touchLocation = touch.locationInNode(self)
            
            // Reject any shots that are below the ship, or directly to the right or left
//            let targetingVector = touchLocation - bird.position
            
            bird.physicsBody.velocity = CGVectorMake(0,0)
            
            bird.physicsBody.applyImpulse(CGVectorMake(0, 25))
            
            //            let sprite = SKSpriteNode(imageNamed:"Image")
            //
            //
            //            sprite.position = location
            //
            //            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:5)
            //
            //            sprite.runAction(SKAction.repeatActionForever(action))
            //        
            //            self.addChild(sprite)
        }
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    
    func fireMissile(targetingVector: CGPoint) {
        // Now that we've confirmed that the shot is "legal", FIRE ZE MISSILES!
        
        // Play shooting sound
        runAction(SKAction.playSoundFileNamed("missile.mp3", waitForCompletion: false))
        
        // Create the missile sprite at the ship's location
        let missile = SKSpriteNode(imageNamed: "missile")
        missile.position.x = bird.position.x
        missile.position.y = bird.position.y + (bird.size.height / 2)
        
        // Give the missile sprite a physics body
        missile.physicsBody = SKPhysicsBody(circleOfRadius: missile.size.width / 2)
        missile.physicsBody.dynamic = true
        missile.physicsBody.collisionBitMask = 0
        missile.physicsBody.usesPreciseCollisionDetection = true
        
        addChild(missile)
        
//        // Calculate the missile's speed and final destination
//        let direction = targetingVector.normalized
//        let missileVector = direction * 1000
//        let missileEndPos = missileVector + missile.position
//        let missileSpeed: CGFloat = 500
//        let missileMoveTime = size.width / missileSpeed
//        
//        // Send the missile on its way
//        let actionMove = SKAction.moveTo(missileEndPos, duration: NSTimeInterval(missileMoveTime))
//        let actionMoveDone = SKAction.removeFromParent()
//        missile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }

}