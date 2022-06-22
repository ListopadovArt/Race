
import Foundation
import UIKit

struct MenuButtons {
    let constraint: CGFloat
    let height: CGFloat
    let distance: CGFloat
}

enum GameButton: String {
    case left = "Left.png"
    case right = "Right.png"
    case menu = "menu.png"
}

struct ButtonMenu {
    let menuButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = button.frame.size.width/2
        button.layer.contents = UIImage(named: GameButton.menu.rawValue)?.cgImage
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func addMenuButton(button: UIButton, view: UIView){
        button.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 30).isActive = true
        button.topAnchor.constraint(equalTo:view.topAnchor, constant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
