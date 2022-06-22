
import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageCarCell: UIImageView!
    @IBOutlet weak var nameLabelCell: UILabel!
    @IBOutlet weak var coinsLabelCell: UILabel!
    @IBOutlet weak var dateLabelCell: UILabel!
    @IBOutlet weak var speedLabelCell: UILabel!
    
    
    // MARK: - Configure
    func configureCell(with object: Car) {
        self.imageCarCell.image = UIImage(named: object.name)
        self.nameLabelCell.text = "\(object.driver)"
        self.coinsLabelCell.text = "\(object.coins)"
        self.speedLabelCell.text = "\(object.speed)"
        self.dateLabelCell.text = "\(object.date)"
    }
}
