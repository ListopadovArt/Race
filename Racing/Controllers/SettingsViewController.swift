
import UIKit

class SettingsViewController: UIViewController {
    
    
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
    let labelSettings: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let labelAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        let labelAttributesString = NSAttributedString(string: "SETTINGS".localized, attributes: labelAttributes)
        label.attributedText = labelAttributesString
        label.font = UIFont(name: Fonts.konstanting.rawValue, size: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let textFieldSettings: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter your name".localized
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 30, weight: .light)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let selectCar: UIView = {
        let car = UIView()
        car.layer.contentsGravity = CALayerContentsGravity.resize
        car.layer.masksToBounds = true
        car.translatesAutoresizingMaskIntoConstraints = false
        return car
    }()
    let rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.layer.contents = UIImage(named: "Right.png")?.cgImage
        rightButton.layer.contentsGravity = CALayerContentsGravity.resize
        rightButton.layer.masksToBounds = true
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        return rightButton
    }()
    let leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.layer.contents = UIImage(named: "Left.png")?.cgImage
        leftButton.layer.contentsGravity = CALayerContentsGravity.resize
        leftButton.layer.masksToBounds = true
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        return leftButton
    }()
    let saveButton: UIButton = {
        let save = UIButton(type: .system)
        save.layer.borderWidth = 1
        save.tintColor = UIColor.black
        save.roundCorners(radius: 5)
        save.setTitle("SAVE".localized, for: .normal)
        save.translatesAutoresizingMaskIntoConstraints = false
        return save
    }()
    let labelSpeed: UILabel = {
        let label = UILabel()
        label.text = "Speed:".localized
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let firstSpeedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("x1.0", for: .normal)
        button.roundCorners(radius: 5)
        button.layer.borderWidth = 1
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let secondSpeedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("x1.5", for: .normal)
        button.roundCorners(radius: 5)
        button.layer.borderWidth = 1
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let thirdSpeedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("x2.0", for: .normal)
        button.roundCorners(radius: 5)
        button.layer.borderWidth = 1
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldSettings.delegate = self
        self.view.addSubview(labelSettings)
        self.view.addSubview(textFieldSettings)
        self.view.addSubview(selectCar)
        self.view.addSubview(rightButton)
        self.view.addSubview(leftButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(labelSpeed)
        self.view.addSubview(firstSpeedButton)
        self.view.addSubview(secondSpeedButton)
        self.view.addSubview(thirdSpeedButton)
        self.view.addSubview(self.menu.menuButton)
        self.addLabelSettings()
        self.addTextFieldSettings()
        self.addCar()
        self.addLeftButton()
        self.addRightButton()
        self.addLabelSpeed()
        self.addSaveButton()
        self.addFirstSpeedButton()
        self.addSecondSpeedButton()
        self.addThirdSpeedButton()
        self.menu.addMenuButton(button: menu.menuButton, view: self.view)
        self.menu.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        self.leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        self.firstSpeedButton.addTarget(self, action: #selector(speedButtonAction), for: .touchUpInside)
        self.secondSpeedButton.addTarget(self, action: #selector(speedButtonAction), for: .touchUpInside)
        self.thirdSpeedButton.addTarget(self, action: #selector(speedButtonAction), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.play.playSoundMp3(soundName: self.sounds.settings.rawValue)
        let volume = UserDefaults.standard.value(forKey: UserDefaultsKeys.volume.rawValue) as? Float ?? 0.5
        volumeSlider.value = volume
        self.play.volumeMusic(volume: volume)
    }
    
    
    // MARK: - Configure
    private func addLabelSettings(){
        labelSettings.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        labelSettings.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        labelSettings.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
    }
    
    private func addTextFieldSettings(){
        self.textFieldSettings.leftAnchor.constraint(equalTo: self.labelSettings.leftAnchor, constant: -20).isActive = true
        self.textFieldSettings.rightAnchor.constraint(equalTo: self.labelSettings.rightAnchor, constant: 20).isActive = true
        self.textFieldSettings.topAnchor.constraint(equalTo: self.labelSettings.bottomAnchor, constant: 30).isActive = true
        self.textFieldSettings.centerXAnchor.constraint(equalTo: self.labelSettings.centerXAnchor).isActive = true
        
        let driver = resultCar?.driver
        self.textFieldSettings.text = driver
    }
    
    private func addCar(){
        self.selectCar.topAnchor.constraint(equalTo: self.textFieldSettings.bottomAnchor, constant: 30).isActive = true
        self.selectCar.centerXAnchor.constraint(equalTo: self.textFieldSettings.centerXAnchor).isActive = true
        self.selectCar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.selectCar.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        if let name = self.settingsCar?.name {
            self.selectCar.layer.contents = UIImage(named: name)?.cgImage
        } else {
            self.selectCar.layer.contents = UIImage(named: "car.png")?.cgImage
        }
    }
    
    private func addLeftButton(){
        self.leftButton.centerYAnchor.constraint(equalTo: self.selectCar.centerYAnchor).isActive = true
        self.leftButton.rightAnchor.constraint(equalTo: self.selectCar.leftAnchor, constant: -20).isActive = true
        self.leftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func addRightButton(){
        self.rightButton.centerYAnchor.constraint(equalTo: self.selectCar.centerYAnchor).isActive = true
        self.rightButton.leftAnchor.constraint(equalTo: self.selectCar.rightAnchor, constant: 20).isActive = true
        self.rightButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func addLabelSpeed(){
        self.labelSpeed.topAnchor.constraint(equalTo: self.selectCar.bottomAnchor, constant: 30).isActive = true
        self.labelSpeed.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.labelSpeed.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -310).isActive = true
    }
    
    private func addFirstSpeedButton(){
        self.firstSpeedButton.centerYAnchor.constraint(equalTo:  self.labelSpeed.centerYAnchor).isActive = true
        self.firstSpeedButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.firstSpeedButton.leftAnchor.constraint(equalTo: self.labelSpeed.rightAnchor, constant: 20).isActive = true
        
    }
    
    private func addSecondSpeedButton(){
        self.secondSpeedButton.centerYAnchor.constraint(equalTo:  self.firstSpeedButton.centerYAnchor).isActive = true
        self.secondSpeedButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.secondSpeedButton.leftAnchor.constraint(equalTo: self.firstSpeedButton.rightAnchor, constant: 20).isActive = true
    }
    
    private func addThirdSpeedButton(){
        self.thirdSpeedButton.centerYAnchor.constraint(equalTo:  self.secondSpeedButton.centerYAnchor).isActive = true
        self.thirdSpeedButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.thirdSpeedButton.leftAnchor.constraint(equalTo: self.secondSpeedButton.rightAnchor, constant: 20).isActive = true
    }
    
    private func addSaveButton(){
        self.saveButton.centerXAnchor.constraint(equalTo: self.labelSpeed.centerXAnchor).isActive = true
        self.saveButton.topAnchor.constraint(equalTo: self.labelSpeed.bottomAnchor, constant: 30).isActive = true
        self.saveButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        self.saveButton.rightAnchor.constraint(equalTo: self.view.rightAnchor , constant: -100).isActive = true
    }
    
    
    // MARK: - Actions
    @objc func leftButtonAction(_ sender:UIButton!) {
        self.nameCar = garage.removeFirst()
        self.selectCar.layer.contents = UIImage(named: self.nameCar)?.cgImage
        garage.append(self.nameCar)
    }
    @objc func rightButtonAction(_ sender:UIButton!) {
        self.nameCar = garage.removeLast()
        self.selectCar.layer.contents = UIImage(named: self.nameCar)?.cgImage
        garage.insert(self.nameCar, at: 0)
    }
    
    @objc func saveButtonAction(_ sender:UIButton!) {
        if let text = self.textFieldSettings.text {
            self.car.driver = text
        } else {
            self.car.driver = "Name".localized
        }
        self.car.name = self.nameCar
        UserDefaults.standard.set(encodable: self.car, forKey: UserDefaultsKeys.settings.rawValue)
    }
    
    @objc func speedButtonAction(_ sender:UIButton!) {
        switch sender {
        case self.firstSpeedButton:
            self.car.speed = 1.0
        case self.secondSpeedButton:
            self.car.speed = 1.5
        case self.thirdSpeedButton:
            self.car.speed = 2.0
        default:
            break
        }
    }
    
    @objc func menuButtonAction(_ sender:UIButton!) {
        guard let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {
            return
        }
        self.play.audioPlayer?.stop()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - IBActions
    @IBAction func volumeSliderPress(_ sender: UISlider) {
        let volume = sender.value
        self.play.volumeMusic(volume: volume)
        UserDefaults.standard.setValue(volume, forKey: UserDefaultsKeys.volume.rawValue)
    }
}


// MARK: - Extensions
extension SettingsViewController: UITextFieldDelegate  {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
