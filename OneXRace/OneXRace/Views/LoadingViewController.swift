import UIKit

class LoadingViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "OneX RACE"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Racing Championship"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .accentGold
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .accentGold
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startLoading()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundDark
        
        // Add animated gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.backgroundDark.cgColor,
            UIColor.primaryPurple.withAlphaComponent(0.3).cgColor,
            UIColor.primaryBlue.withAlphaComponent(0.2).cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    private func startLoading() {
        loadingIndicator.startAnimating()
        
        // Animate logo appearance
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 0.5) {
            self.titleLabel.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.8) {
                self.subtitleLabel.alpha = 1
            } completion: { _ in
                // Wait a moment then transition
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.transitionToNextScreen()
                }
            }
        }
    }
    
    private func transitionToNextScreen() {
        // Always go to onboarding
        let onboardingVC = OnboardingViewController()
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = onboardingVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}