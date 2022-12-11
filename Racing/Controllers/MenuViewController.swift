
import UIKit

final class MenuViewController: UIViewController {
    
    
    // MARK: - Properties
    let button = MenuButtons(constraint: 50, height: 70, distance: 10)
    var timer = Timer()
    var play = Player()
    let gameButton = makeMenuButton(withText: "GAME", color: .red)
    let scoreButton = makeMenuButton(withText: "SCORE", color: .orange)
    let settingsButton = makeMenuButton(withText: "SETTINGS", color: .green)
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.play.playSoundMp3(soundName: gameSounds.menu.rawValue)
        let volume = UserDefaults.standard.value(forKey: UserDefaultsKeys.volume.rawValue)
        self.play.volumeMusic(volume: volume as? Float ?? 0.5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameButton.dropShadow()
        scoreButton.dropShadow()
        settingsButton.dropShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBackGround()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateMyButton(button: self.gameButton)
        self.animateMyButton(button: self.scoreButton)
        self.animateMyButton(button: self.settingsButton)
    }
    
    private func addBackGround(){
        let backgroundImage = UIImageView(frame: self.view.frame)
        backgroundImage.image = UIImage(named: "RoadBackground.png")
        backgroundImage.addParalaxEffect()
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
    }
}


//MARK: - Configure
extension MenuViewController {
    private func layout(){
        self.view.addSubview(gameButton)
        self.view.addSubview(scoreButton)
        self.view.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            gameButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: button.constraint),
            gameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -button.constraint),
            gameButton.heightAnchor.constraint(equalToConstant: button.height),
            gameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            scoreButton.leftAnchor.constraint(equalTo: gameButton.leftAnchor),
            scoreButton.rightAnchor.constraint(equalTo: gameButton.rightAnchor),
            scoreButton.topAnchor.constraint(equalTo: gameButton.bottomAnchor, constant: button.distance),
            scoreButton.heightAnchor.constraint(equalToConstant: button.height),
            
            settingsButton.leftAnchor.constraint(equalTo: scoreButton.leftAnchor),
            settingsButton.rightAnchor.constraint(equalTo: scoreButton.rightAnchor),
            settingsButton.topAnchor.constraint(equalTo: scoreButton.bottomAnchor, constant: button.distance),
            settingsButton.heightAnchor.constraint(equalToConstant: button.height),
        ])
        gameButton.addTarget(self, action: #selector(buttonGameAction(_:)), for: .touchUpInside)
        scoreButton.addTarget(self, action: #selector(buttonScoreAction(_:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(buttonSettingsAction(_:)), for: .touchUpInside)
    }
}


// MARK: - Actions
extension MenuViewController {
    @objc func buttonGameAction(_ sender:UIButton!) {
        guard let controller = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
            return
        }
        self.nukeAllAnimations()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonScoreAction(_ sender:UIButton!) {
        guard let controller = UIStoryboard(name: "Score", bundle: nil).instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController else {
            return
        }
        self.nukeAllAnimations()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonSettingsAction(_ sender:UIButton!) {
        guard let controller = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            return
        }
        self.nukeAllAnimations()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - Animation
extension MenuViewController {
    private func animateMyButton(button: UIButton){
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true, block: { (timer) in
            UIView.animate(withDuration: 0.6, delay: 0, options:[.allowUserInteraction] ,animations: {
                button.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            }) { (_) in
                UIView.animate(withDuration: 0.6, animations: {
                    button.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
        })
        timer.fire()
    }
    
    private func nukeAllAnimations() {
        self.view.subviews.forEach({$0.layer.removeAllAnimations()})
        self.view.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
        self.timer.invalidate()
        self.play.audioPlayer?.stop()
    }
}
