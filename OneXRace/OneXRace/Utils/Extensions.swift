import UIKit

// MARK: - UIView Extensions
extension UIView {
    func addGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addShadow(color: UIColor = .black, opacity: Float = 0.2, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func animatePress() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
    func slideInFromBottom() {
        self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    func fadeIn(duration: TimeInterval = 0.3) {
        self.alpha = 0
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }
}

// MARK: - UIColor Extensions
extension UIColor {
    static let primaryPurple = UIColor(red: 0.4, green: 0.2, blue: 0.8, alpha: 1.0)
    static let primaryBlue = UIColor(red: 0.2, green: 0.4, blue: 0.9, alpha: 1.0)
    static let accentGold = UIColor(red: 1.0, green: 0.7, blue: 0.0, alpha: 1.0)
    static let accentOrange = UIColor(red: 1.0, green: 0.5, blue: 0.1, alpha: 1.0)
    static let backgroundDark = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0)
    static let cardDark = UIColor(red: 0.12, green: 0.12, blue: 0.18, alpha: 1.0)
    static let textLight = UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1.0)
    static let textSecondary = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)
}

// MARK: - UIButton Extensions
extension UIButton {
    func setPrimaryStyle() {
        self.backgroundColor = .clear
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.roundCorners(radius: 16)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.primaryPurple.cgColor, UIColor.primaryBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 16
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        self.addShadow(color: .primaryPurple, opacity: 0.3, radius: 8)
    }
    
    func setGoldStyle() {
        self.backgroundColor = .clear
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.roundCorners(radius: 16)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.accentGold.cgColor, UIColor.accentOrange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 16
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        self.addShadow(color: .accentGold, opacity: 0.4, radius: 8)
    }
}

// MARK: - String Extensions
extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}