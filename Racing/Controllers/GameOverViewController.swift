
import UIKit

class GameOverViewController: UIViewController {
    
    let result = UserDefaults.standard.value(Car.self, forKey: UserDefaultsKeys.result.rawValue)
    var arrayResult: [Car]  =  UserDefaults.standard.value([Car].self, forKey: UserDefaultsKeys.arrayResults.rawValue) ?? []
    
    // MARK: - Properties
    var menu = ButtonMenu()
    let play = Player()
    let sounds = gameSounds.self
    let volume = UserDefaults.standard.value(forKey: UserDefaultsKeys.volume.rawValue)
    let labelGameOver: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let labelAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        let labelAttributesString = NSAttributedString(string: "GAME OVER".localized, attributes: labelAttributes)
        label.attributedText = labelAttributesString
        label.font = UIFont(name: Fonts.konstanting.rawValue, size: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let labelResult: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .light)
        return label
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(labelGameOver)
        self.view.addSubview(labelResult)
        self.view.addSubview(menu.menuButton)
        self.addLabelGameOver()
        self.addLabelResult()
        self.play.playSoundMp3(soundName: self.sounds.gameOver.rawValue)
        self.play.volumeMusic(volume: self.volume as? Float ?? 0.5)
        self.menu.addMenuButton(button: menu.menuButton, view: self.view)
        self.menu.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        guard let result = self.result else {
            return
        }
        self.labelResult.numberOfLines = 0
        self.labelResult.textAlignment = .center
        self.labelResult.font = .italicSystemFont(ofSize: 20)
        self.labelResult.text = "You result".localized + "\(result.coins)" + "coins".localized
        self.arrayResult.append(result)
        UserDefaults.standard.set(encodable: arrayResult, forKey: UserDefaultsKeys.arrayResults.rawValue)
    }
    
    private func addLabelGameOver(){
        self.labelGameOver.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        self.labelGameOver.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        self.labelGameOver.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.labelGameOver.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func addLabelResult(){
        self.labelResult.topAnchor.constraint(equalTo: self.labelGameOver.bottomAnchor, constant: 20).isActive = true
        self.labelResult.centerXAnchor.constraint(equalTo: self.labelGameOver.centerXAnchor).isActive = true
    }
    
    @objc func menuButtonAction(_ sender:UIButton!) {
        guard let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {
            return
        }
        self.play.audioPlayer?.stop()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
