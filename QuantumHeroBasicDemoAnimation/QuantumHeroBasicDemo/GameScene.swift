

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
//    private var player : SKSpriteNode?
    private var player : Character?
//    private var clone : SKSpriteNode?
    private var clone : Character?
//    private var clone2 : SKSpriteNode?
    private var clone2 : Character?
    private var door : SKSpriteNode?
    private var plate : SKSpriteNode?
//    private var characters : Array<SKSpriteNode> = []
    private var moves : Array<Int> = []
    private var moveTiming : Array<Double> = []
    private let serialQueue = DispatchQueue(label: "com.serial.queue")
    private var finishedAnimation : Bool = true
    private var swipes : Double = 0
    private var doorOpen : Bool = true
    private var startX : Double = -300.0
    private var startY : Double = 0.0
    private var selectedChar : Character?
    private var playerSwitch : SKSpriteNode?
    private var clone1Switch : SKSpriteNode?
    private var clone2Switch : SKSpriteNode?
    private var submitSwitch : SKSpriteNode?
    private var characters : Array<Character> = []
    private var startedAnimation : Bool = false
    private var walls : Array<SKSpriteNode> = []
    private var bluewalls : Array<SKSpriteNode> = []
    private var redwalls : Array<SKSpriteNode> = []
    private var cyanWallPlate : SKSpriteNode?
    private var pinkWallPlate : SKSpriteNode?
    private var blueWallsMoved : Bool = false
    private var redWallsMoved : Bool = false
    private var onMazeLevel : Bool = false
    private var playerNode : SKSpriteNode?
    private var cloneNode : SKSpriteNode?
    private var clone1Node : SKSpriteNode?
    private var randomInt = 0
    private var plate2 : SKSpriteNode?
    private var laser1 : SKSpriteNode?
    private var laser2 : SKSpriteNode?
    var levelThree = false
    private var levelOneNodes : Array<SKSpriteNode> = []
    private var mazeNodes : Array<SKSpriteNode> = []
    private var laser1Moved : Bool = false
    private var laser2Moved : Bool = false
    private var laser1Vert : Bool = false
    private var laser2Vert : Bool = false
    private var timeLBL : SKLabelNode?
    private var scoreLBL : SKLabelNode?
    let defaults = UserDefaults.standard
    private var score = 0
    
    override func didMove(to view: SKView)   {
//        loadMazeLevel()
        
//        self.player = Character.init(node: (self.childNode(withName: "player") as? SKSpriteNode)!)
//        self.clone = Character.init(node: (self.childNode(withName: "clone") as? SKSpriteNode)!)
//        self.clone2 = Character.init(node: (self.childNode(withName: "clone2") as? SKSpriteNode)!)
        self.player = Character.init(node: SKSpriteNode(imageNamed: "Samus.png"))
        self.clone = Character.init(node: SKSpriteNode(imageNamed: "Samustaint.png"))
        self.clone2 = Character.init(node: SKSpriteNode(imageNamed: "Samustaint.png"))
        self.label = self.childNode(withName: "moveListLabel") as? SKLabelNode
//        self.door = self.childNode(withName: "door") as? SKSpriteNode
        self.plate = self.childNode(withName: "pressurePlate") as? SKSpriteNode
        self.playerSwitch = self.childNode(withName: "switchToPlayer") as? SKSpriteNode
        self.clone1Switch = self.childNode(withName: "switchToClone1") as? SKSpriteNode
        self.clone2Switch = self.childNode(withName: "switchToClone2") as? SKSpriteNode
        self.submitSwitch = self.childNode(withName: "confirmMoves") as? SKSpriteNode
        
        self.timeLBL = self.childNode(withName: "timeLBL") as? SKLabelNode
        self.scoreLBL = self.childNode(withName: "scoreLBL") as? SKLabelNode
        
//        defaults.set(0, forKey: "score")
        score = defaults.integer(forKey: "score")
        
        selectedChar = player
        characters = [clone!, clone2!]
        
        generateLevelOne()
//        loadRandomLevel()
    }
    
//MARK: MOVEMENT
    
    func handleSwipesDPad(direction: Int) {
        if(firstMove) {
                   timer?.invalidate()
                   runCount = 0.0
                   timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
                   firstMove = false;
               }
               swipes += 1
               
        if(direction == 4 && (selectedChar?.getSprite()?.position.x)! > -350) {
            selectedChar!.getSprite()!.position.x -= 50
            if canMove() {
                moves.append(0)
                moveTiming.append(runCount-timeOfLastMove)
            }
            else {
                selectedChar?.getSprite()?.position.x += 50
            }
        }
               
        if(direction == 3 && (selectedChar?.getSprite()?.position.x)! < 350) {
            selectedChar!.getSprite()!.position.x += 50
//            selectedChar!.addMove(move: 1, time: runCount)
            if canMove() {
                moves.append(1)
                moveTiming.append(runCount-timeOfLastMove)
            }
            else {
                selectedChar?.getSprite()?.position.x -= 50
            }
        }
               
        if(direction == 1 && (selectedChar?.getSprite()?.position.y)! < 300) {
            selectedChar!.getSprite()!.position.y += 50
//            selectedChar!.addMove(move: 2, time: runCount)
            if canMove() {
                moves.append(2)
                moveTiming.append(runCount-timeOfLastMove)
            }
            else {
                selectedChar?.getSprite()?.position.y -= 50
            }
        }
               
        if(direction == 2 && (selectedChar?.getSprite()?.position.y)! > -300) {
            selectedChar!.getSprite()!.position.y -= 50
//            selectedChar!.addMove(move: 3, time: runCount)
            if canMove() {
                moves.append(3)
                moveTiming.append(runCount-timeOfLastMove)
            }
            else {
                selectedChar?.getSprite()?.position.x += 50
            }
        }
//        print(runCount)
        timer?.invalidate()
//        runCount = 0
        timeOfLastMove = runCount
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func canMove() -> Bool {
        let nodesAtPlayerPos = nodes(at: (selectedChar?.getSprite()!.position)!)
        for node in walls {
            if nodesAtPlayerPos.contains(node) {
                return false
            }
        }
        return true
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {

    }
    
//  MARK: CLONE ANIMATION
    
    func doubleTapped() {
        runCount = 12
        selectedChar?.resetMoves()
        selectedChar?.addMoves(newMoves: moves, newTimes: moveTiming)
        firstMove = true
        reset()
    }
    
    func animateCharacter(index: Int, char: Character) {
        if(index < char.moves.count) {
            Timer.scheduledTimer(withTimeInterval: char.moveTiming[index], repeats: false, block: { timer in
                self.moveChar(move: char.moves[index], char: char)
                self.animateCharacter(index: index+1, char: char)
                timer.invalidate()
            })
        }
        else{
//            char.resetMoves()
            char.finishedAnimation = true
            checkAllAnimationsFinished()
        }
    }
    
    func moveChar(move: Int, char: Character) {
        switch move {
            case 0:
                char.sprite?.position.x -= 50
                print("move left")
                break
            case 1:
                char.sprite?.position.x += 50
                print("move right")
                break
            case 2:
                char.sprite?.position.y += 50
                print("move up")
                break
            case 3:
                char.sprite?.position.y -= 50
                print("move down")
                break
            default:
                break
        }
    }
    
    func checkAllAnimationsFinished() {
        var allFinished : Bool = true
        for character in characters {
            if !character.finishedAnimation {
                allFinished = false
                break
            }
        }
        
        if allFinished {
            startedAnimation = false
            for character in characters {
                character.finishedAnimation = false
            }
        }
        
    }
    
    var firstMove = true
    var timer: Timer?
    var runCount = 0.0
    var timeOfLastMove = 0.0
    
    @objc func fireTimer() {
//        runCount += 0.05
//
//        if runCount >= 15 {
//            timer?.invalidate()
//            reset()
//            runCount = 0.0
//        }
        timeLBL?.text = "Time: " + String(round(1000*(12-runCount))/1000)
        runCount += 0.05
        if runCount >= 12 {
            timer?.invalidate()
            reset()
            runCount = 0.0
        }
    }
    
//MARK: COLLISION
    
    func checkPressurePlateCollision() {
        if (onMazeLevel){
            if ((player?.getSprite()?.position == cyanWallPlate?.position || clone?.getSprite()?.position == cyanWallPlate?.position || clone2?.getSprite()?.position == cyanWallPlate?.position) && !blueWallsMoved){
                blueWallsMoved = true
                for wall in bluewalls {
                    wall.position.y += 1000
                }
            }
            else {
                if (!(player?.getSprite()?.position == cyanWallPlate?.position || clone?.getSprite()?.position == cyanWallPlate?.position || clone2?.getSprite()?.position == cyanWallPlate?.position) && blueWallsMoved){
                    for wall in bluewalls {
                        wall.position.y -= 1000
                    }
                    blueWallsMoved = false
                }
            }
            
            if ((player?.getSprite()?.position == pinkWallPlate?.position || clone?.getSprite()?.position == pinkWallPlate?.position || clone2?.getSprite()?.position == pinkWallPlate?.position) && !redWallsMoved){
                redWallsMoved = true
                for wall in redwalls {
                    wall.position.y += 1000
                }
            }
            else {
                if (!(player?.getSprite()?.position == pinkWallPlate?.position || clone?.getSprite()?.position == pinkWallPlate?.position || clone2?.getSprite()?.position == pinkWallPlate?.position) && redWallsMoved){
                    for wall in redwalls {
                        wall.position.y -= 1000
                    }
                    redWallsMoved = false
                }
            }
        }
        
        else{
            if((player?.getSprite()?.position == plate?.position || clone?.getSprite()?.position == plate?.position ||
                clone2?.getSprite()?.position == plate?.position) && !laser1Moved) {
                laser1?.position.y += 1000
                laser1?.position.x += 2000
                laser1Moved = true
            }
            else if(!(player?.getSprite()?.position == plate?.position || clone?.getSprite()?.position == plate?.position || clone2?.getSprite()?.position == plate?.position) && laser1Moved){
                laser1?.position.y -= 1000
                laser1?.position.x -= 2000
                laser1Moved = false
            }
            if ((player?.getSprite()?.position == plate2?.position || clone?.getSprite()?.position == plate2?.position || clone2?.getSprite()?.position == plate2?.position) && !laser2Moved) {
                laser2?.position.y += 1000
                laser2?.position.x += 2000
                laser2Moved = true
            }
            else if(!(player?.getSprite()?.position == plate2?.position || clone?.getSprite()?.position == plate2?.position || clone2?.getSprite()?.position == plate2?.position) && laser2Moved) {
                laser2?.position.y -= 1000
                laser2?.position.x -= 2000
                laser2Moved = false
            }
        }
        
    }
    
    func checkDoorCollision() {
        if (player?.getSprite()!.position.x == door?.position.x && player?.getSprite()!.position.y == door?.position.y && doorOpen){
            startNextLevel()
        }
    }
    
    func checkWallCollision() {
        for wall in walls {
            if player?.getSprite()?.position == wall.position {
                player?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone?.getSprite()?.position == wall.position {
                clone?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone2?.getSprite()?.position == wall.position {
                clone2?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
        }
    }
    
    func checkLaserCollision() {
        if laser1Vert {
            if player?.getSprite()?.position.x == laser1?.position.x {
                player?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone?.getSprite()?.position.x == laser1?.position.x {
                clone?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone2?.getSprite()?.position.x == laser1?.position.x {
                clone2?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
        }
        else if !laser1Vert{
            if player?.getSprite()?.position.y == laser1?.position.y {
                player?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone?.getSprite()?.position.y == laser1?.position.y {
                clone?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone2?.getSprite()?.position.y == laser1?.position.y {
                clone2?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
        }
        
        if laser2Vert {
            if player?.getSprite()?.position.x == laser2?.position.x {
                player?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone?.getSprite()?.position.x == laser2?.position.x {
                clone?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone2?.getSprite()?.position.x == laser2?.position.x {
                clone2?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
        }
        else if !laser2Vert{
            if player?.getSprite()?.position.y == laser2?.position.y {
                player?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone?.getSprite()?.position.y == laser2?.position.y {
                clone?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
            if clone2?.getSprite()?.position.y == laser2?.position.y {
                clone2?.getSprite()?.position = CGPoint(x: startX, y: startY)
                score -= 15
            }
        }
    }
    
//MARK: NEXT LEVEL
    
    func startNextLevel() {
        reset()
        
        runCount = 12
        
        score += 10
        defaults.set(score, forKey: "score")
        if onMazeLevel {
            for wall in walls{
                wall.removeFromParent()
            }
            redwalls.removeAll()
            bluewalls.removeAll()
            walls.removeAll()
            door?.removeFromParent()
            playerNode?.removeFromParent()
            cloneNode?.removeFromParent()
            clone1Node?.removeFromParent()
            pinkWallPlate?.position.y += 1000
            cyanWallPlate?.position.y += 1000
            generateLevelOne()
            onMazeLevel = false
            laser1Moved = false
            laser2Moved = false
        }
        else{
            for node in levelOneNodes{
                node.removeFromParent()
            }
            levelOneNodes.removeAll()
            loadMazeLevel()
            onMazeLevel = true
            blueWallsMoved = false
            redWallsMoved = false
        }
        reset()
        player?.resetMoves()
        clone?.resetMoves()
        clone2?.resetMoves()
    }
    
    func addChildren() {
        self.addChild(plate!)
        self.addChild(plate2!)
        
        self.addChild(laser1!)
        self.addChild(laser2!)
        
        self.addChild(playerNode!)
        self.addChild(cloneNode!)
        self.addChild(clone1Node!)
        self.addChild(door!)
        
        self.player = Character.init(node: playerNode!)
        self.clone = Character.init(node: cloneNode!)
        self.clone2 = Character.init(node: clone1Node!)
        selectedChar = player
        characters = [clone!, clone2!]
    }
    
    func reset() {
        if onMazeLevel{
            player?.getSprite()?.position.x = CGFloat(startX)
            player?.getSprite()?.position.y = CGFloat(startY)
            clone?.getSprite()?.position.x = CGFloat(startX)
            clone?.getSprite()?.position.y = CGFloat(startY)
            clone2?.getSprite()?.position.x = CGFloat(startX)
            clone2?.getSprite()?.position.y = CGFloat(startY)
            moves.removeAll()
            moveTiming.removeAll()
            selectedChar = player
        }
        else{
            if(randomInt == 1) {
                    playerNode?.position = CGPoint(x: startX,y: startY)
                    cloneNode?.position = CGPoint(x: startX,y: startY)
                    clone1Node?.position = CGPoint(x: startX,y: startY)
                }
                if(randomInt == 2) {
                    playerNode?.position = CGPoint(x: startX,y: startY)
                    cloneNode?.position = CGPoint(x: startX,y: startY)
                    clone1Node?.position = CGPoint(x: startX,y: startY)
                }
                if(randomInt == 3) {
                    playerNode?.position = CGPoint(x: startX,y: startY)
                    cloneNode?.position = CGPoint(x: startX,y: startY)
                    clone1Node?.position = CGPoint(x: startX,y: startY)
                }
            moves.removeAll()
            moveTiming.removeAll()
            selectedChar = player
        }
    }
    
//MARK: SWITCH CHARACTER
    
    func switchToPlayer() {
        moves.removeAll()
        moveTiming.removeAll()
        selectedChar?.getSprite()?.position.x = CGFloat(startX)
        selectedChar?.getSprite()?.position.y = CGFloat(startY)
        selectedChar = player
        firstMove = true
    }
    func switchToCloneOne() {
        moves.removeAll()
        moveTiming.removeAll()
        selectedChar?.getSprite()?.position.x = CGFloat(startX)
        selectedChar?.getSprite()?.position.y = CGFloat(startY)
        selectedChar = clone
        firstMove = true
    }
    func switchToCloneTwo() {
        moves.removeAll()
        moveTiming.removeAll()
        selectedChar?.getSprite()?.position.x = CGFloat(startX)
        selectedChar?.getSprite()?.position.y = CGFloat(startY)
        selectedChar = clone2
        firstMove = true
    }
    
//MARK: LEVEL GENERATION
    
    func loadRandomLevel() {
        let randNum = Int.random(in: 1..<3)
        
        if randNum == 1 {
            onMazeLevel = false
            generateLevelOne()
        }
        else{
            onMazeLevel = true
            loadMazeLevel()
        }
    }
    
    func generateLevelOne() {
        levelThree = false
    
        randomInt = Int.random(in: 1..<4)
        if(randomInt == 1) {
            typeOneLevelOne()
        }
        if(randomInt == 2) {
            typeOneLevelTwo()
        }
        if(randomInt == 3) {
            typeOneLevelThree()
        }
    }
    
    //crossed bars
    func typeOneLevelOne() {
        addStartNodes()
        laser1 = SKSpriteNode(imageNamed: "laserVert.png")
        laser2 = SKSpriteNode(imageNamed: "laser.png")
        laser1?.position = CGPoint(x:200, y:0)
        laser1?.size = CGSize(width: 20, height: 660)
        laser2?.position = CGPoint(x:0, y:200)
        laser2?.size = CGSize(width: 768, height: 20)
        
        laser1Vert = true
        laser2Vert = false
        
        plate = SKSpriteNode(imageNamed: "plate.png")
        plate?.size = CGSize(width: 50, height: 50)
        plate?.position = CGPoint(x: 300,y:-250)
        
        plate2 = SKSpriteNode(imageNamed: "plate.png")
        plate2?.size = CGSize(width: 50, height: 50)
        plate2?.position = CGPoint(x: -300, y: -100)
        
        playerNode?.position = CGPoint(x: 300,y: 0)
        cloneNode?.position = CGPoint(x: 300,y: 0)
        clone1Node?.position = CGPoint(x: 300,y: 0)
        
        addChildren()
        levelOneNodes.append(plate!)
        levelOneNodes.append(plate2!)
        levelOneNodes.append(laser1!)
        levelOneNodes.append(laser2!)
        
        startX = 300
        startY = 0
    }
    
    //horizontal bars
    func typeOneLevelTwo() {
        addStartNodes()
        laser1 = SKSpriteNode(imageNamed: "laser.png")
        laser2 = SKSpriteNode(imageNamed: "laser.png")
        laser1?.position = CGPoint(x:0, y:-150)
        laser1?.size = CGSize(width: 768, height: 20)
        laser2?.position = CGPoint(x:0, y:150)
        laser2?.size = CGSize(width: 768, height: 20)
        
        laser1Vert = false
        laser2Vert = false
        
        plate = SKSpriteNode(imageNamed: "plate.png")
        plate?.size = CGSize(width: 50, height: 50)
        plate?.position = CGPoint(x: 250,y:-250)
        
        plate2 = SKSpriteNode(imageNamed: "plate.png")
        plate2?.size = CGSize(width: 50, height: 50)
        plate2?.position = CGPoint(x: 250, y: -50)
        
        playerNode?.position = CGPoint(x: 0,y: -200)
        cloneNode?.position = CGPoint(x: 0,y: -200)
        clone1Node?.position = CGPoint(x: 0,y: -200)

        addChildren()
        levelOneNodes.append(plate!)
        levelOneNodes.append(plate2!)
        levelOneNodes.append(laser1!)
        levelOneNodes.append(laser2!)
    
        startX = 0
        startY = -200
    }
    
    //vertical bars, activate both lasers in order to activate the door
    func typeOneLevelThree() {
        addStartNodes()
        levelThree = true
        laser1 = SKSpriteNode(imageNamed: "laserVert.png")
        laser2 = SKSpriteNode(imageNamed: "laserVert.png")
        laser1?.position = CGPoint(x:150, y:0)
        laser1?.size = CGSize(width: 20, height: 660)
        laser2?.position = CGPoint(x:-150, y:0)
        laser2?.size = CGSize(width: 20, height: 660)
        
        laser1Vert = true
        laser2Vert = true
        
        plate = SKSpriteNode(imageNamed: "plate.png")
        plate?.size = CGSize(width: 50, height: 50)
        plate?.position = CGPoint(x: 300,y:-250)
               
        plate2 = SKSpriteNode(imageNamed: "plate.png")
        plate2?.size = CGSize(width: 50, height: 50)
        plate2?.position = CGPoint(x: 250, y: -50)
        
        playerNode?.position = CGPoint(x: 300,y: 0)
        cloneNode?.position = CGPoint(x: 300,y: 0)
        clone1Node?.position = CGPoint(x: 300,y: 0)
        
        door?.position = CGPoint(x: -300, y: 0)
        
        addChildren()
        levelOneNodes.append(plate!)
        levelOneNodes.append(plate2!)
        levelOneNodes.append(laser1!)
        levelOneNodes.append(laser2!)

        startX = 300
        startY = 0
    }
    
    func addStartNodes() {
        door = SKSpriteNode(imageNamed: "portal.png")
        door?.size = CGSize(width: 70, height: 70)
        door?.position = CGPoint(x:0, y:250)
               
        playerNode = SKSpriteNode(imageNamed: "Samus.png")
        playerNode?.position = CGPoint(x: -100,y: -300)
        playerNode?.size = CGSize(width: 50, height: 50)
        cloneNode = SKSpriteNode(imageNamed: "Samustaint.png")
        cloneNode?.position = CGPoint(x: -200,y: -300)
        cloneNode?.size = CGSize(width: 50, height: 50)
        clone1Node = SKSpriteNode(imageNamed: "Samustaint.png")
        clone1Node?.position = CGPoint(x: -300,y: -300)
        clone1Node?.size = CGSize(width: 50, height: 50)
               
           
        laser1?.physicsBody?.isDynamic = false
        laser2?.physicsBody?.isDynamic = false
        door?.physicsBody?.isDynamic = false
    }
    
    func loadMazeLevel(){
        startX = -300
        startY = 0
        for wall in walls{
            wall.removeFromParent()
        }
        redwalls.removeAll()
        bluewalls.removeAll()
        walls.removeAll()
        generateMaze()
        cyanWallPlate = SKSpriteNode(color: .cyan, size: CGSize(width: 30, height: 30))
        cyanWallPlate!.position = CGPoint(x: -300, y: 250)
        pinkWallPlate = SKSpriteNode(color: .systemPink, size: CGSize(width: 30, height: 30))
        pinkWallPlate!.position = CGPoint(x: -300, y: -250)
        addChild(cyanWallPlate!)
        addChild(pinkWallPlate!)
        door?.position.x = 300
        door?.position.y = 0
        doorOpen = true
        door?.color = .green
    }
    
    private var mazePoints : Array<Array<Int>> = []
    private var mazePointsVisited : Array<Array<Bool>> = []
    
    func generateMaze() {
        mazePoints.removeAll()
        mazePointsVisited.removeAll()
        for _ in Range(0...12){
            mazePoints.append([0, 0, 0, 0, 0, 0, 0, 0, 0])
            mazePointsVisited.append([false, false, false, false, false, false, false, false, false])
        }
        
        formPath(x: 1, y: 7)
        mazePoints[3][0] = 1
        mazePoints[7][0] = 1
        mazePoints[5][8] = 1
        mazePoints[9][8] = 1
        printMaze()
        displayMaze()
    }
    
    func formPath(x: Int, y: Int) {
        print(x, y)
        mazePointsVisited [y][x] = true
        var possibleDirections : Array<Int> = [0, 1, 2, 3]
        
        if (x-2 < 1) { //left
            possibleDirections.remove(at: possibleDirections.firstIndex(of: 0)!)
        }
        if (x+2 > 7) { //right
            possibleDirections.remove(at: possibleDirections.firstIndex(of: 1)!)
        }
        if (y-2 < 1) { //up
            possibleDirections.remove(at: possibleDirections.firstIndex(of: 2)!)
        }
        if (y+2 > 11) { //down
            possibleDirections.remove(at: possibleDirections.firstIndex(of: 3)!)
        }
        
        while possibleDirections.count > 0{
            let direction = possibleDirections.randomElement()
            switch (direction) {
                case 0:
                    if !mazePointsVisited[y][x-2] {
//                        mazeEdges[y*2][x-1] = 0
                        mazePoints[y][x] = Int.random(in: 1...4)
                        mazePoints[y][x-1] = 1
                        mazePoints[y][x-2] = 1
                        formPath(x: x-2, y: y)
                    }
                    break
                case 1:
                    if !mazePointsVisited[y][x+2] {
//                        mazeEdges[y*2][x] = 0
                        mazePoints[y][x] = Int.random(in: 1...4)
                        mazePoints[y][x+1] = 1
                        mazePoints[y][x+2] = 1
                        formPath(x: x+2, y: y)
                    }
                case 2:
                    if !mazePointsVisited[y-2][x] {
//                        mazeEdges[y*2-1][x] = 0
                        mazePoints[y][x] = Int.random(in: 1...4)
                        mazePoints[y-1][x] = 1
                        mazePoints[y-2][x] = 1
                        formPath(x: x, y: y-2)
                    }
                case 3:
                    if !mazePointsVisited[y+2][x] {
//                        mazeEdges[y*2+1][x] = 0
                        mazePoints[y][x] = Int.random(in: 1...4)
                        mazePoints[y+1][x] = 1
                        mazePoints[y+2][x] = 1
                        formPath(x: x, y: y+2)
                    }
                default:
                    break
            }
            possibleDirections.remove(at: possibleDirections.firstIndex(of: direction!)!)
        }
        
    }
    
    func displayMaze() {
        print("displaying maze")
        var newPointX = -200
        var newPointY = 300
        for line in mazePoints {
            newPointX = -200
            for point in line {
                if point == 0 {
                    let newNode = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 50))
                    newNode.position.x = CGFloat(newPointX)
                    newNode.position.y = CGFloat(newPointY)
                    addChild(newNode)
                    walls.append(newNode)
                }
                if point == 2 {
                    let newNode = SKSpriteNode(color: .cyan, size: CGSize(width: 50, height: 50))
                    newNode.position.x = CGFloat(newPointX)
                    newNode.position.y = CGFloat(newPointY)
                    addChild(newNode)
                    walls.append(newNode)
                    bluewalls.append(newNode)
                }
                if point == 3 {
                    let newNode = SKSpriteNode(color: .systemPink, size: CGSize(width: 50, height: 50))
                    newNode.position.x = CGFloat(newPointX)
                    newNode.position.y = CGFloat(newPointY)
                    addChild(newNode)
                    walls.append(newNode)
                    redwalls.append(newNode)
                }
                newPointX += 50
            }
            newPointY -= 50
        }
    }
    
    func printMaze() {
        for line in mazePoints{
            print(line)
        }
    }
    
//MARK: TOUCH FUNCTIONS
    
    func touchDown(atPoint pos : CGPoint) {
//        if(!startedAnimation){
            switch atPoint(pos).name {
            case "switchToPlayer":
                switchToPlayer()
                break
            case "switchToClone1":
                switchToCloneOne()
                break
            case "switchToClone2":
                switchToCloneTwo()
                break
            case "confirmMoves":
                doubleTapped()
                break
            case "startAnimation":
                reset()
                startedAnimation = true
                for character in characters {
                    animateCharacter(index: 0, char: character)
                }
                break
            case "skipLevel":
                startNextLevel()
                score -= 25
                break
            default:
                break
            }
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self))
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            
//            if(!startedAnimation){
                if touchedNode.name == "up" {
                    handleSwipesDPad(direction: 1)
                }
                if touchedNode.name == "down" {
                    handleSwipesDPad(direction: 2)
                }
                if touchedNode.name == "right" {
                handleSwipesDPad(direction: 3)
                }
                if touchedNode.name == "left" {
                handleSwipesDPad(direction: 4)
                }
//            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        checkDoorCollision()
        checkPressurePlateCollision()
        if onMazeLevel {
            checkWallCollision()
        }
        else {
            checkLaserCollision()
        }
    
        scoreLBL?.text = "Score: " + String(score)
    }
}

//MARK: CHARACTER CLASS

class Character {
    public var moves : Array<Int> = []
    public var moveTiming : Array<Double> = []
    public var sprite : SKSpriteNode?
    public var finishedAnimation : Bool = false
    
    init(node : SKSpriteNode) {
        sprite = node
    }
    
    func addMove(move: Int, time: Double){
        moves.append(move)
        moveTiming.append(time)
    }
    func addMoves(newMoves: Array<Int>, newTimes: Array<Double>){
        var i = 0
        while i < newMoves.count {
            moves.append(newMoves[i])
            moveTiming.append(newTimes[i])
            i += 1
        }
    }
    
    func resetMoves() {
        moves.removeAll()
        moveTiming.removeAll()
    }
    
    func changeSpriteNode(node: SKSpriteNode){
        sprite = node
    }
    
    func getSprite() -> SKSpriteNode? {
        return sprite
    }
    
}
