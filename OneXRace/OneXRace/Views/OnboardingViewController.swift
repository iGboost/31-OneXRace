import UIKit

class OnboardingViewController: UIViewController {
    
    private let backgroundGradientLayer = CAGradientLayer()
    
    private let logoView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple.withAlphaComponent(0.3)
        view.roundCorners(radius: 40)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "🏁"
        label.font = UIFont.systemFont(ofSize: 100)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to OneX Racing"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Experience the ultimate thrill of championship racing"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Racing", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
        startButton.layer.sublayers?.first?.frame = startButton.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundDark
        
        // Animated gradient background
        backgroundGradientLayer.colors = [
            UIColor.backgroundDark.cgColor,
            UIColor.primaryPurple.withAlphaComponent(0.4).cgColor,
            UIColor.primaryBlue.withAlphaComponent(0.3).cgColor,
            UIColor.backgroundDark.cgColor
        ]
        backgroundGradientLayer.locations = [0, 0.3, 0.7, 1]
        backgroundGradientLayer.frame = view.bounds
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
        
        view.addSubview(logoView)
        logoView.addSubview(logoLabel)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(startButton)
        
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        startButton.setGoldStyle()
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 160),
            logoView.heightAnchor.constraint(equalToConstant: 160),
            
            logoLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupAnimations() {
        // Initial state
        logoView.alpha = 0
        logoView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        startButton.alpha = 0
        
        // Animate appearance
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0) {
            self.logoView.alpha = 1
            self.logoView.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.5) {
            self.titleLabel.alpha = 1
            self.subtitleLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.8) {
            self.startButton.alpha = 1
        }
        
        // Add pulse animation to button
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
                self.startButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }
    }
    
    @objc private func startTapped() {
        startButton.animatePress()
        
        let mainTabBarController = MainTabBarController()
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            UIView.transition(with: sceneDelegate.window!, duration: 0.8, options: .transitionCrossDissolve) {
                sceneDelegate.window?.rootViewController = mainTabBarController
            }
        }
    }
}