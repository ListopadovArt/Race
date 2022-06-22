
import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - Properties
    let button = MenuButtons(constraint: 50, height: 70, distance: 10)
    var timer = Timer()
    var play = Player()
    let gameButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.roundCorners()
        var labelText = "GAME".localized
        let buttonAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        let buttonAttributesString = NSAttributedString(string: labelText, attributes: buttonAttributes)
        button.setAttributedTitle(buttonAttributesString, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.konstanting.rawValue, size: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let scoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.orange
        button.roundCorners()
        var labelText = "SCORE".localized
        let buttonAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        let buttonAttributesString = NSAttributedString(string: labelText, attributes: buttonAttributes)
        button.setAttributedTitle(buttonAttributesString, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.konstanting.rawValue, size: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.green
        button.roundCorners()
        var labelText = "SETTINGS".localized
        let buttonAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        let buttonAttributesString = NSAttributedString(string: labelText, attributes: buttonAttributes)
        button.setAttributedTitle(buttonAttributesString, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.konstanting.rawValue, size: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
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
        self.addBackGround()
        self.view.addSubview(gameButton)
        self.view.addSubview(scoreButton)
        self.view.addSubview(settingsButton)
        addGameButton()
        addScoreButton()
        addSettingsButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        self.animateMyButton(button: self.gameButton)
        self.animateMyButton(button: self.scoreButton)
        self.animateMyButton(button: self.settingsButton)
    }
    
    
    // MARK: - Configure
    private func addBackGround(){
        let backgroundImage = UIImageView(frame: self.view.frame)
        backgroundImage.image = UIImage(named: "RoadBackground.png")
        backgroundImage.addParalaxEffect()
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
    }
    
    private func addGameButton(){
        gameButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: button.constraint).isActive = true
        gameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -button.constraint).isActive = true
        gameButton.heightAnchor.constraint(equalToConstant: button.height).isActive = true
        gameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        gameButton.addTarget(self, action: #selector(buttonGameAction(_:)), for: .touchUpInside)
    }
    
    private func addScoreButton(){
        scoreButton.leftAnchor.constraint(equalTo: gameButton.leftAnchor).isActive = true
        scoreButton.rightAnchor.constraint(equalTo: gameButton.rightAnchor).isActive = true
        scoreButton.topAnchor.constraint(equalTo: gameButton.bottomAnchor, constant: button.distance).isActive = true
        scoreButton.heightAnchor.constraint(equalToConstant: button.height).isActive = true
        scoreButton.addTarget(self, action: #selector(buttonScoreAction(_:)), for: .touchUpInside)
    }
    
    private func addSettingsButton(){
        settingsButton.leftAnchor.constraint(equalTo: scoreButton.leftAnchor).isActive = true
        settingsButton.rightAnchor.constraint(equalTo: scoreButton.rightAnchor).isActive = true
        settingsButton.topAnchor.constraint(equalTo: scoreButton.bottomAnchor, constant: button.distance).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: button.height).isActive = true
        settingsButton.addTarget(self, action: #selector(buttonSettingsAction(_:)), for: .touchUpInside)
    }
    
    
    // MARK: - Actions
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
