
import UIKit

final class GameOverViewController: UIViewController {
    
    let result = UserDefaults.standard.value(Car.self, forKey: UserDefaultsKeys.result.rawValue)
    var arrayResult: [Car]  =  UserDefaults.standard.value([Car].self, forKey: UserDefaultsKeys.arrayResults.rawValue) ?? []
    
    // MARK: - Properties
    var menu = ButtonMenu()
    let play = Player()
    let sounds = gameSounds.self
    let volume = UserDefaults.standard.value(forKey: UserDefaultsKeys.volume.rawValue)
    let labelGameOver = makeTitleLabel(withTitle: "GAME OVER".localized)
    let labelResult = UILabel()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        style()
    }
    
}

//MARK: - Configure
extension GameOverViewController {
    private func  style(){
        play.playSoundMp3(soundName: self.sounds.gameOver.rawValue)
        play.volumeMusic(volume: self.volume as? Float ?? 0.5)
        menu.addMenuButton(button: menu.menuButton, view: self.view)
        menu.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        
        labelResult.translatesAutoresizingMaskIntoConstraints = false
        labelResult.font = UIFont.systemFont(ofSize: 30, weight: .light)
        labelResult.numberOfLines = 0
        labelResult.textAlignment = .center
        labelResult.font = .italicSystemFont(ofSize: 20)
        guard let result = self.result else {
            return
        }
        labelResult.text = "You result".localized + "\(result.coins)" + "coins".localized
        arrayResult.append(result)
        UserDefaults.standard.set(encodable: arrayResult, forKey: UserDefaultsKeys.arrayResults.rawValue)
    }
    
    private func layout(){
        view.addSubview(labelGameOver)
        view.addSubview(labelResult)
        view.addSubview(menu.menuButton)
        
        NSLayoutConstraint.activate([
            labelGameOver.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            labelGameOver.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            labelGameOver.heightAnchor.constraint(equalToConstant: 100),
            labelGameOver.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            labelResult.topAnchor.constraint(equalTo: labelGameOver.bottomAnchor, constant: 20),
            labelResult.centerXAnchor.constraint(equalTo: labelGameOver.centerXAnchor),
        ])
    }
}


//MARK: - Actions
extension GameOverViewController {
    @objc func menuButtonAction(_ sender:UIButton!) {
        guard let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {
            return
        }
        play.audioPlayer?.stop()
        navigationController?.pushViewController(controller, animated: true)
    }
}
