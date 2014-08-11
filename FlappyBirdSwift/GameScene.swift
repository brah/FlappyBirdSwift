//
//  GameScene.swift
//  FlappyBirdSwift
//
//  Created by Quincy Babin on 8/10/14.
//  Copyright (c) 2014 Quincy Babin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    var bird = SKSpriteNode();
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var PipesMoveAndRemove = SKAction()
    
    let pipeGap = 150.0
    
    override func didMoveToView(view: SKView) {
  

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
            let location = touch.locationInNode(self)

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
}
