
// MARK: - Extensions
import Foundation
import UIKit

@IBDesignable
extension UIView {
    func roundCorners(radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 9, height: 9)
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        layer.shouldRasterize = false
    }
    
    func addParalaxEffect(amount: Int = 5) {
          let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
          horizontal.minimumRelativeValue = -amount
          horizontal.maximumRelativeValue = amount
          let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
          vertical.minimumRelativeValue = -amount
          vertical.maximumRelativeValue = amount
          let group = UIMotionEffectGroup()
          group.motionEffects = [horizontal, vertical]
          addMotionEffect(group)
      }
}
