
import UIKit
import SpriteKit
import CoreMotion

class GameViewController: UIViewController {
    
    let userCar = Car(name: "car.png", driver: "Name", coins: 0, speed: 1.0, date: "")
    let settingCar = UserDefaults.standard.value(Car.self, forKey: UserDefaultsKeys.settings.rawValue )
    
    
    // MARK: - Properties
    var motionManager = CMMotionManager()
    var sumCoins = 0
    private let animationView = SKView()
    let rightButton = makeGameButton(withName: GameButton.right.rawValue)
    let leftButton = makeGameButton(withName: GameButton.left.rawValue)
    let coinsImage: UIView = {
        let coin = UIView()
        coin.layer.contents = UIImage(named: "Coins.png")?.cgImage
        coin.layer.contentsGravity = CALayerContentsGravity.resize
        coin.layer.masksToBounds = true
        coin.translatesAutoresizingMaskIntoConstraints = false
        return coin
    }()
    let coinsLabel: UILabel = {
        let coin = UILabel()
        coin.translatesAutoresizingMaskIntoConstraints = false
        coin.font = UIFont.systemFont(ofSize: 20, weight: .light)
        return coin
    }()
    let menu = ButtonMenu()
    let road = UIView()
    let car = UIView()
    var timer = Timer()
    let play = Player()
    let sounds = gameSounds.self
    let volume = UserDefaults.standard.value(forKey: UserDefaultsKeys.volume.rawValue)
    var flag = true
    let carsBarrier = Barriers()
    let barrier = Barriers()
    let trees = Barriers()
    let freguency = Barriers()
    let wallWidth = 40
    let wallHeight = 70
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gyroscope()
        self.accelerometer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(self.coinsImage)
        self.view.addSubview(self.coinsLabel)
        self.addCoinsImage(coin: self.coinsImage)
        self.addCoinsLabel(coin: self.coinsLabel)
        if flag {
            self.animatedGameScene()
            self.addCar()
        }
        self.addBackGround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.coinsLabel.text = String("x\(self.sumCoins)")
        if flag {
            self.presentGameScene()
            animationView.center.x = view.bounds.midX
            animationView.center.y = view.bounds.midY
        }
        self.view.addSubview(self.menu.menuButton)
        self.menu.addMenuButton(button: self.menu.menuButton, view: self.view)
        self.menu.menuButton.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(animationView)
        let scene = makeScene()
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        animationView.presentScene(scene)
        animationView.allowsTransparency = true
        animationView.showsFPS = true
        animationView.showsNodeCount = true
        animationView.ignoresSiblingOrder = true
        animationView.frame.size = scene.size
        animationView.presentScene(scene)
        addBlackCat(scene: scene)
    }
    
    
    // MARK: - Configure
    func addCoinsImage(coin: UIView){
        coin.rightAnchor.constraint(equalTo:self.view.rightAnchor, constant: -80).isActive = true
        coin.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 40).isActive = true
        coin.heightAnchor.constraint(equalToConstant: 30).isActive = true
        coin.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func addCoinsLabel(coin: UILabel){
        coin.leftAnchor.constraint(equalTo: self.coinsImage.rightAnchor, constant: 5).isActive = true
        coin.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 40).isActive = true
        coin.heightAnchor.constraint(equalToConstant: 30).isActive = true
        coin.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func addBackGround(){
        self.view.layer.contents = UIImage(named: "RoadScene.jpg")?.cgImage
        self.view.layer.contentsGravity = CALayerContentsGravity.resize
        self.view.layer.masksToBounds = true
    }
    
    func presentGameScene(){
        self.leftButton.frame = CGRect(x: self.view.frame.width/14, y: self.view.frame.size.height - self.view.frame.size.height/7, width: 100, height: 100)
        self.leftButton.layer.cornerRadius = self.leftButton.frame.size.width/2
        
        self.leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.view.addSubview(leftButton)
        self.rightButton.frame = CGRect(x: self.view.frame.width/2+75, y: self.view.frame.size.height - self.view.frame.size.height/7, width: 100, height: 100)
        self.rightButton.layer.cornerRadius = self.rightButton.frame.size.width/2
        
        self.rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        self.view.addSubview(rightButton)
    }
    
    private func addRoadLine() -> UIView {
        let line = UIView()
        line.layer.frame.size.width = self.car.frame.width / 5
        line.layer.frame.size.height = line.frame.size.width * 2
        line.layer.frame.origin.x = self.view.frame.width / 2 - line.frame.size.width / 2
        line.layer.frame.origin.y = 0
        line.backgroundColor = .white
        self.view.addSubview(line)
        return line
    }
    
    private  func addCar(){
        if let name = self.settingCar?.name {
            self.car.layer.contents = UIImage(named: name)?.cgImage
        } else {
            self.car.layer.contents = UIImage(named: "car.png")?.cgImage
        }
        
        self.car.layer.contentsGravity = CALayerContentsGravity.resize
        self.car.layer.masksToBounds = true
        self.car.layer.frame.origin.x = self.view.frame.width / 2
        self.car.layer.frame.origin.y = self.view.frame.height - 150
        self.car.layer.frame.size.width = self.view.frame.size.width/10
        self.car.layer.frame.size.height = self.car.frame.size.width*1.7
        self.view.addSubview(self.car)
    }
    
    private func addPlants() -> UIView {
        let barrier = UIView()
        barrier.frame = CGRect(x: Int.random(in: 5...70), y: 0, width: 50, height: 70)
        barrier.contentMode = .scaleAspectFill
        barrier.layer.contentsGravity = CALayerContentsGravity.resize
        barrier.layer.contents = UIImage(named: self.barrier.barriers[Int.random(in: 0..<self.barrier.barriers.count)])?.cgImage
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            if let currentFrame = barrier.layer.presentation()?.frame {
                if currentFrame.intersects(self.car.frame){
                    self.play.playSoundWav(soundName: self.sounds.crash.rawValue)
                    self.play.volumeMusic(volume: self.volume as? Float ?? 0.5)
                    self.animateExplosion(self.addExplosion(frame: self.car.frame))
                    
                    self.nukeAllAnimations()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.gameOverMenu()
                    }
                }
            }
        })
        timer.fire()
        self.view.addSubview(barrier)
        return barrier
    }
    
    private func addCars() -> UIView {
        let car = UIView()
        car.frame = CGRect(x: Int.random(in: 120...245) , y: 30, width: 40, height: 70)
        car.contentMode = .scaleAspectFill
        car.layer.contentsGravity = CALayerContentsGravity.resize
        car.layer.contents = UIImage(named: self.carsBarrier.cars[Int.random(in: 0..<self.carsBarrier.cars.count)])?.cgImage
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            if self.motionManager.isDeviceMotionAvailable {
                self.motionManager.gyroUpdateInterval = 0.3
                self.motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
                    if let rate = data?.rotationRate {
                        if rate.x >= 2 {
                            UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {
                                self?.car.layer.frame.size.width = (self?.view.frame.size.width)!/10 * 1.3
                                self?.car.layer.frame.size.height = (self?.car.frame.size.width)!*1.7 * 1.25
                            }) { (_) in
                                self?.car.layer.frame.size.width = (self?.view.frame.size.width)!/10
                                self?.car.layer.frame.size.height = (self?.car.frame.size.width)!*1.7
                            }
                        } else if rate.x < 2 {
                            if let currentFrame = car.layer.presentation()?.frame {
                                if currentFrame.intersects((self?.car.frame)!){
                                    self!.play.playSoundWav(soundName: (self?.sounds.crash.rawValue)!)
                                    self!.play.volumeMusic(volume: self?.volume as? Float ?? 0.5)
                                    self!.animateExplosion((self?.addExplosion(frame: currentFrame))!)
                                    self!.animateExplosion((self?.addExplosion(frame: (self?.car.frame)!))!)
                                    self?.nukeAllAnimations()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self?.gameOverMenu()
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                if let currentFrame = car.layer.presentation()?.frame {
                    if currentFrame.intersects((self.car.frame)){
                        self.play.playSoundWav(soundName: (self.sounds.crash.rawValue))
                        self.play.volumeMusic(volume: self.volume as? Float ?? 0.5)
                        self.animateExplosion((self.addExplosion(frame: currentFrame)))
                        self.animateExplosion((self.addExplosion(frame: (self.car.frame))))
                        self.nukeAllAnimations()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.gameOverMenu()
                        }
                    }
                }
            }
            
        })
        timer.fire()
        self.view.addSubview(car)
        return car
    }
    
    private func addFruitTrees() -> UIView {
        let barrier = UIView()
        barrier.frame = CGRect(x: Int.random(in: 280...380), y: 0, width: 50, height: 70)
        barrier.contentMode = .scaleAspectFill
        barrier.layer.contentsGravity = CALayerContentsGravity.resize
        barrier.layer.contents = UIImage(named: self.trees.fruitTrees[Int.random(in: 0..<self.trees.fruitTrees.count)])?.cgImage
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            if let currentFrame = barrier.layer.presentation()?.frame {
                if currentFrame.intersects(self.car.frame){
                    self.play.playSoundWav(soundName: self.sounds.crash.rawValue)
                    self.play.volumeMusic(volume: self.volume as? Float ?? 0.5)
                    self.animateExplosion(self.addExplosion(frame: self.car.frame))
                    self.nukeAllAnimations()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.gameOverMenu()
                    }
                }
            }
        })
        timer.fire()
        self.view.addSubview(barrier)
        return barrier
    }
    
    private func addWallLeft() -> UIView {
        let wall = UIView()
        wall.frame = CGRect(x: Int(self.view.frame.origin.x) - 15 , y: 0, width: self.wallWidth, height: self.wallHeight)
        wall.contentMode = .scaleAspectFill
        wall.layer.contentsGravity = CALayerContentsGravity.resize
        wall.layer.contents = UIImage(named: "Wall.png")?.cgImage
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            if let currentFrame = wall.layer.presentation()?.frame {
                if currentFrame.intersects(self.car.frame){
                    self.play.playSoundWav(soundName: self.sounds.crash.rawValue)
                    self.play.volumeMusic(volume: self.volume as? Float ?? 0.5)
                    self.animateExplosion(self.addExplosion(frame: self.car.frame))
                    self.nukeAllAnimations()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.gameOverMenu()
                    }
                }
            }
        })
        timer.fire()
        self.view.addSubview(wall)
        return wall
    }
    
    private func addWallRight() -> UIView {
        let wall = UIView()
        wall.frame = CGRect(x: Int(self.view.frame.size.width) - 25 , y: 0, width: self.wallWidth, height: self.wallHeight)
        wall.contentMode = .scaleAspectFill
        wall.layer.contentsGravity = CALayerContentsGravity.resize
        wall.layer.contents = UIImage(named: "Wall.png")?.cgImage
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            if let currentFrame = wall.layer.presentation()?.frame {
                if currentFrame.intersects(self.car.frame){
                    self.play.playSoundWav(soundName: self.sounds.crash.rawValue)
                    self.play.volumeMusic(volume: self.volume as? Float ?? 0.5)
                    self.animateExplosion(self.addExplosion(frame: self.car.frame))
                    self.nukeAllAnimations()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.gameOverMenu()
                        
                    }
                }
            }
        })
        timer.fire()
        self.view.addSubview(wall)
        return wall
    }
    
    private func addCoin() -> UIView {
        let coin = UIView()
        coin.frame = CGRect(x: Int.random(in: 100...300), y: 10, width: 30, height: 30)
        coin.contentMode = .scaleAspectFill
        coin.layer.contentsGravity = CALayerContentsGravity.resize
        coin.layer.contents = UIImage(named: "Coin.png")?.cgImage
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            if let currentFrame = coin.layer.presentation()?.frame {
                if currentFrame.intersects(self.car.frame){
                    coin.removeFromSuperview()
                    self.play.playSoundWav(soundName: self.sounds.coin.rawValue)
                    self.play.volumeMusic(volume: self.volume as? Float ?? 0.5)
                    self.sumCoins += 1
                }
            }
        })
        timer.fire()
        self.view.addSubview(coin)
        return coin
    }
    
    private func addExplosion(frame: CGRect) -> UIView {
        let explosion = UIView()
        explosion.frame = frame
        explosion.contentMode = .scaleAspectFill
        explosion.layer.contentsGravity = CALayerContentsGravity.resize
        explosion.layer.contents = UIImage(named: "Explosion.png")?.cgImage
        self.view.addSubview(explosion)
        return explosion
    }
    
    private func addBlackCat(scene: SKScene){
        self.timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { (timer) in
            self.createSceneBlackCat(for: scene)
        })
        timer.fire()
    }
    
    
    // MARK: - Actions
    private  func animate(_ image: UIView) {
        if flag {
            UIView.animate(withDuration: 4, delay: 0, options: .curveLinear, animations: {
                image.transform = CGAffineTransform(translationX: 0 , y: self.view.frame.size.height)
                image.layer.timeOffset = image.layer.convertTime(CACurrentMediaTime(), from: nil)
                image.layer.beginTime = CACurrentMediaTime()
            }) { (_) in
                image.removeFromSuperview()
                self.timer.fire()
            }
            if let speed = self.settingCar?.speed {
                image.layer.speed = speed
            } else {
                image.layer.speed = 1.0
            }
        }
    }
    
    private  func animateCars(_ image: UIView) {
        if flag {
            UIView.animate(withDuration: 3, delay: 0, options: .curveLinear, animations: {
                image.transform = CGAffineTransform(translationX: 0 , y: self.view.frame.size.height)
                image.layer.timeOffset = image.layer.convertTime(CACurrentMediaTime(), from: nil)
                image.layer.beginTime = CACurrentMediaTime()
            }) { (_) in
                image.removeFromSuperview()
                self.timer.fire()
            }
            if let speed = self.settingCar?.speed {
                image.layer.speed = speed
            } else {
                image.layer.speed = 1.0
            }
        }
    }
    
    private func animatedGameScene(){
        if let freguency = freguency.sceneElements["RoadLine"]{
            self.timer = Timer.scheduledTimer(withTimeInterval: freguency, repeats: true, block: { (timer) in
                self.animate(self.addRoadLine())
            })
            timer.fire()
        }
        if let freguency = freguency.sceneElements["Plants"]{
            self.timer = Timer.scheduledTimer(withTimeInterval: freguency, repeats: true, block: { (timer) in
                self.animate(self.addPlants())
            })
            timer.fire()
        }
        if let freguency = freguency.sceneElements["Cars"]{
            self.timer = Timer.scheduledTimer(withTimeInterval: freguency, repeats: true, block: { (timer) in
                self.animateCars(self.addCars())
            })
            timer.fire()
        }
        if let freguency = freguency.sceneElements["Coin"]{
            self.timer = Timer.scheduledTimer(withTimeInterval: freguency, repeats: true, block: { (timer) in
                self.animate(self.addCoin())
            })
            timer.fire()
        }
        if let freguency = freguency.sceneElements["WallLeft"]{
            self.timer = Timer.scheduledTimer(withTimeInterval: freguency, repeats: true, block: { (timer) in
                self.animate(self.addWallLeft())
            })
            timer.fire()
        }
        if let freguency = freguency.sceneElements["WallRight"]{
            self.timer = Timer.scheduledTimer(withTimeInterval: freguency, repeats: true, block: { (timer) in
                self.animate(self.addWallRight())
            })
            timer.fire()
        }
        if let freguency = freguency.sceneElements["FruitTrees"]{
            self.timer = Timer.scheduledTimer(withTimeInterval: freguency, repeats: true, block: { (timer) in
                self.animate(self.addFruitTrees())
            })
            timer.fire()
        }
    }
    
    private func animateExplosion(_ image: UIView){
        UIView.animate(withDuration: 1, delay: 0, options:[.allowUserInteraction] ,animations: {
            image.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (_) in
            UIView.animate(withDuration: 1, animations: {
                image.transform = CGAffineTransform(scaleX: 3, y: 3)
            })
        }
    }
    
    @objc func leftButtonAction(_ sender:UIButton!) {
        self.animateMoveLeft(self.car)
    }
    
    @objc func rightButtonAction(_ sender:UIButton!) {
        self.animateMoveRight(self.car)
    }
    
    @objc func menuButtonAction(_ sender:UIButton!) {
        self.nukeAllAnimations()
        guard let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func gameOverMenu(){
        self.nukeAllAnimations()
        self.userCar.coins = self.sumCoins
        
        if let name = self.settingCar?.name {
            self.userCar.name = name
        } else {
            self.userCar.name = "car.png"
        }
        
        if let speed = self.settingCar?.speed {
            self.userCar.speed = speed
        } else {
            self.userCar.speed = 1.0
        }
        
        if let driver = self.settingCar?.driver {
            self.userCar.driver = driver
        } else {
            self.userCar.driver = "Name"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = formatter.string(from: Date())
        self.userCar.date = date
        UserDefaults.standard.set(encodable: userCar, forKey: UserDefaultsKeys.result.rawValue)
        guard let controller = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameOverViewController") as? GameOverViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func animateMoveLeft(_ image: UIView) {
        UIView.animate(withDuration: 0.1) {
            self.car.frame.origin.x -= self.car.frame.width
        }
    }
    
    private  func animateMoveRight(_ image: UIView) {
        UIView.animate(withDuration: 0.1) {
            self.car.frame.origin.x += self.car.frame.width
        }
    }
    
    func nukeAllAnimations() {
        self.view.subviews.forEach({$0.layer.removeAllAnimations()})
        self.view.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
        self.timer.fire()
        self.timer.invalidate()
        self.flag = false
        self.animationView.endEditing(true)
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }
    
    
    //MARK: -SpriteKit functions
    func makeScene() -> SKScene {
        let minimumDimension = max(view.frame.width, view.frame.height)
        let size = CGSize(width: minimumDimension, height: minimumDimension)
        let scene = SKScene(size: size)
        scene.backgroundColor = .clear
        scene.scaleMode = .aspectFill
        return scene
    }
    
    func animationFrames(forImageNamePrefix baseImageName: String,
                         frameCount count: Int) -> [SKTexture] {
        var array = [SKTexture]()
        for index in 1...count {
            let imageName = String(format: "%@%0d.png", baseImageName, index)
            let texture = SKTexture(imageNamed: imageName)
            array.append(texture)
        }
        
        return array
    }
    
    func createSceneBlackCat(for scene: SKScene) {
        let defaultNumberOfWalkFrames: Int = 12
        let characterFramesOverOneSecond: TimeInterval = 3 / TimeInterval(defaultNumberOfWalkFrames)
        let walkFrames = animationFrames(forImageNamePrefix: "sprite_",
                                         frameCount: defaultNumberOfWalkFrames)
        let sprite = SKSpriteNode(texture: walkFrames.first)
        sprite.scale(to: CGSize(width: self.car.frame.width, height: self.car.frame.width/2))
        sprite.position = CGPoint(x: animationView.frame.origin.x,
                                  y: animationView.frame.midY + animationView.frame.width/1.5)
        scene.addChild(sprite)
        let animateFramesAction: SKAction = .animate(with: walkFrames,
                                                     timePerFrame: characterFramesOverOneSecond,
                                                     resize: true,
                                                     restore: false)
        let newPositionX: CGFloat = animationView.frame.origin.x + animationView.frame.width
        let newPositionY: CGFloat = animationView.frame.midY - animationView.frame.width
        let moveDuration: TimeInterval = 3
        sprite.run(.repeatForever(
            .sequence(
                [.group([
                    animateFramesAction,
                    .moveBy(x: newPositionX, y: newPositionY, duration: moveDuration)]),
                ])
        ))
    }
    
    
    //MARK: - Accelerometer & Gyroscope functions
    func gyroscope(){
        if motionManager.isDeviceMotionAvailable {
            motionManager.gyroUpdateInterval = 0.2
            motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
                if let rate = data?.rotationRate {
                    if rate.x >= 3 {
                        UIView.animate(withDuration: 1.5, delay: 0, options: .curveLinear, animations: {
                            self?.car.layer.frame.size.width = (self?.view.frame.size.width)!/10 * 1.2
                            self?.car.layer.frame.size.height = (self?.car.frame.size.width)!*1.7 * 1.2
                        }) { (_) in
                            self?.car.layer.frame.size.width = (self?.view.frame.size.width)!/10
                            self?.car.layer.frame.size.height = (self?.car.frame.size.width)!*1.7
                        }
                    }
                }
            }
        }
    }
    
    func accelerometer(){
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    if acceleration.x <= -0.4 {
                        self?.animateMoveLeft(self!.car)
                    }
                    if acceleration.x >= 0.4 {
                        self?.animateMoveRight(self!.car)
                    }
                }
            }
        }
    }
}


