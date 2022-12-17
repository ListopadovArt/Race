
import UIKit

final class SettingsViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    // MARK: - Properties
    var car = Car(name: "", driver: "", coins: 0, speed: 1.0, date: "")
    let resultCar = UserDefaults.standard.value(Car.self, forKey: UserDefaultsKeys.result.rawValue)
    let settingsCar = UserDefaults.standard.value(Car.self, forKey: UserDefaultsKeys.settings.rawValue)
    var nameCar = "car.png"
    let menu = ButtonMenu()
    var garage = ["car.png","car0.png","car00.png"]
    let play = Player()
    let sounds = gameSounds.self
    let labelSettings = makeTitleLabel(withTitle: "SETTINGS".localized)
    let textFieldSettings = UITextField()
    let selectCar = UIView()
    let rightButton = makeCarSelectionButton(withDirection: "Right.png")
    let leftButton = makeCarSelectionButton(withDirection: "Left.png")
    let firstSpeedButton = makeSpeedButton(withSpeed: "x1.0")
    let secondSpeedButton = makeSpeedButton(withSpeed: "x1.5")
    let thirdSpeedButton = makeSpeedButton(withSpeed: "x2.0")
    let saveButton = UIButton(type: .system)
    let labelSpeed = UILabel()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.play.playSoundMp3(soundName: self.sounds.settings.rawValue)
        let volume = UserDefaults.standard.value(forKey: UserDefaultsKeys.volume.rawValue) as? Float ?? 0.5
        volumeSlider.value = volume
        self.play.volumeMusic(volume: volume)
    }
}

extension SettingsViewController {
    private func style() {
        
        menu.addMenuButton(button: menu.menuButton, view: self.view)
        menu.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        
        volumeSlider.addTarget(self, action: #selector(volumeSliderPress), for: .touchUpInside)
        
        leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        firstSpeedButton.addTarget(self, action: #selector(speedButtonAction), for: .touchUpInside)
        secondSpeedButton.addTarget(self, action: #selector(speedButtonAction), for: .touchUpInside)
        thirdSpeedButton.addTarget(self, action: #selector(speedButtonAction), for: .touchUpInside)
        
        saveButton.layer.borderWidth = 1
        saveButton.tintColor = UIColor.black
        saveButton.roundCorners(radius: 5)
        saveButton.setTitle("SAVE".localized, for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        
        labelSpeed.text = "Speed:".localized
        labelSpeed.textAlignment = .center
        labelSpeed.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldSettings.placeholder = "Enter your name".localized
        textFieldSettings.textAlignment = .center
        textFieldSettings.font = UIFont.systemFont(ofSize: 30, weight: .light)
        textFieldSettings.translatesAutoresizingMaskIntoConstraints = false
        
        let driver = resultCar?.driver
        textFieldSettings.text = driver
        
        selectCar.layer.contentsGravity = CALayerContentsGravity.resize
        selectCar.layer.masksToBounds = true
        selectCar.translatesAutoresizingMaskIntoConstraints = false
        
        if let name = settingsCar?.name {
            selectCar.layer.contents = UIImage(named: name)?.cgImage
        } else {
            selectCar.layer.contents = UIImage(named: nameCar)?.cgImage
        }
    }
    
    private func layout() {
        view.addSubview(labelSettings)
        view.addSubview(textFieldSettings)
        view.addSubview(selectCar)
        view.addSubview(rightButton)
        view.addSubview(leftButton)
        view.addSubview(saveButton)
        view.addSubview(labelSpeed)
        view.addSubview(firstSpeedButton)
        view.addSubview(secondSpeedButton)
        view.addSubview(thirdSpeedButton)
        view.addSubview(menu.menuButton)
        
        NSLayoutConstraint.activate([
            labelSettings.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            labelSettings.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            labelSettings.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            textFieldSettings.leftAnchor.constraint(equalTo: labelSettings.leftAnchor, constant: -20),
            textFieldSettings.rightAnchor.constraint(equalTo: labelSettings.rightAnchor, constant: 20),
            textFieldSettings.topAnchor.constraint(equalTo: labelSettings.bottomAnchor, constant: 30),
            textFieldSettings.centerXAnchor.constraint(equalTo: labelSettings.centerXAnchor),
            
            selectCar.topAnchor.constraint(equalTo: textFieldSettings.bottomAnchor, constant: 30),
            selectCar.centerXAnchor.constraint(equalTo: textFieldSettings.centerXAnchor),
            selectCar.widthAnchor.constraint(equalToConstant: 50),
            selectCar.heightAnchor.constraint(equalToConstant: 90),
            
            leftButton.centerYAnchor.constraint(equalTo: selectCar.centerYAnchor),
            leftButton.rightAnchor.constraint(equalTo: selectCar.leftAnchor, constant: -20),
            leftButton.widthAnchor.constraint(equalToConstant: 50),
            
            rightButton.centerYAnchor.constraint(equalTo: selectCar.centerYAnchor),
            rightButton.leftAnchor.constraint(equalTo: selectCar.rightAnchor, constant: 20),
            rightButton.widthAnchor.constraint(equalToConstant: 50),
            
            saveButton.centerXAnchor.constraint(equalTo: labelSpeed.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: labelSpeed.bottomAnchor, constant: 30),
            saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            saveButton.rightAnchor.constraint(equalTo: view.rightAnchor , constant: -100),
            
            labelSpeed.topAnchor.constraint(equalTo: selectCar.bottomAnchor, constant: 30),
            labelSpeed.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            labelSpeed.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -310),
            
            firstSpeedButton.centerYAnchor.constraint(equalTo: labelSpeed.centerYAnchor),
            firstSpeedButton.widthAnchor.constraint(equalToConstant: 50),
            firstSpeedButton.leftAnchor.constraint(equalTo: labelSpeed.rightAnchor, constant: 20),
            
            secondSpeedButton.centerYAnchor.constraint(equalTo: firstSpeedButton.centerYAnchor),
            secondSpeedButton.widthAnchor.constraint(equalToConstant: 50),
            secondSpeedButton.leftAnchor.constraint(equalTo: firstSpeedButton.rightAnchor, constant: 20),
            
            thirdSpeedButton.centerYAnchor.constraint(equalTo: secondSpeedButton.centerYAnchor),
            thirdSpeedButton.widthAnchor.constraint(equalToConstant: 50),
            thirdSpeedButton.leftAnchor.constraint(equalTo: secondSpeedButton.rightAnchor, constant: 20),
        ])
    }
}


// MARK: - Actions
extension SettingsViewController: UITextFieldDelegate  {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SettingsViewController {
    @objc func leftButtonAction(_ sender:UIButton!) {
        nameCar = garage.removeFirst()
        selectCar.layer.contents = UIImage(named: nameCar)?.cgImage
        garage.append(nameCar)
    }
    @objc func rightButtonAction(_ sender:UIButton!) {
        nameCar = garage.removeLast()
        selectCar.layer.contents = UIImage(named: nameCar)?.cgImage
        garage.insert(nameCar, at: 0)
    }
    
    @objc func saveButtonAction(_ sender:UIButton!) {
        textFieldSettings.delegate = self
        if let text = textFieldSettings.text {
            car.driver = text
        } else {
            car.driver = "Name".localized
        }
        car.name = nameCar
        UserDefaults.standard.set(encodable: car, forKey: UserDefaultsKeys.settings.rawValue)
    }
    
    @objc func speedButtonAction(_ sender:UIButton!) {
        switch sender {
        case firstSpeedButton:
            car.speed = 1.0
        case secondSpeedButton:
            car.speed = 1.5
        case thirdSpeedButton:
            car.speed = 2.0
        default:
            break
        }
    }
    
    @objc func menuButtonAction(_ sender:UIButton!) {
        guard let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {
            return
        }
        play.audioPlayer?.stop()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func volumeSliderPress(_ sender: UISlider) {
        let volume = sender.value
        play.volumeMusic(volume: volume)
        UserDefaults.standard.setValue(volume, forKey: UserDefaultsKeys.volume.rawValue)
    }
}

