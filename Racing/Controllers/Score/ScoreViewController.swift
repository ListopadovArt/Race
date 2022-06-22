import UIKit

class ScoreViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var arrayResult: [Car] = UserDefaults.standard.value([Car].self,forKey: UserDefaultsKeys.arrayResults.rawValue) ?? []
    var sorteArray: [Car] = [Car]()
    var menu = ButtonMenu()
    let play = Player()
    let sounds = gameSounds.self
    let volume = UserDefaults.standard.value(forKey: UserDefaultsKeys.volume.rawValue)
    let labelScore: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let labelAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        let labelAttributesString = NSAttributedString(string: "SCORE".localized, attributes: labelAttributes)
        label.attributedText = labelAttributesString
        label.font = UIFont(name: Fonts.konstanting.rawValue, size: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(menu.menuButton)
        self.view.addSubview(labelScore)
        self.addLabelScore()
        self.play.playSoundMp3(soundName: self.sounds.score.rawValue)
        self.play.volumeMusic(volume: volume as? Float ?? 0.5)
        self.menu.addMenuButton(button: menu.menuButton, view: self.view)
        self.menu.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        self.sortShows()
    }
    
    private func addLabelScore(){
        self.labelScore.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        self.labelScore.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        self.labelScore.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
    }
    
    @objc func menuButtonAction(_ sender:UIButton!) {
        guard let controller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {
            return
        }
        self.play.audioPlayer?.stop()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func sortShows() {
        self.sorteArray = arrayResult.sorted{ $0.coins > $1.coins}
        tableView.reloadData()
    }
}


// MARK: - Extensions
extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sorteArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 0, width: headerView.frame.width-20, height: headerView.frame.height-10)
        label.backgroundColor = .black
        label.text = "header".localized
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreTableViewCell", for: indexPath) as? ScoreTableViewCell else {
            //Как правило не срабатывает, но для исключения краша, возвращаем:
            return UITableViewCell()
        }
        cell.configureCell(with: self.sorteArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.sorteArray.remove(at: indexPath.row)
            self.tableView.reloadData()
            UserDefaults.standard.set(encodable: self.sorteArray, forKey: UserDefaultsKeys.arrayResults.rawValue)
        }
    }
}




