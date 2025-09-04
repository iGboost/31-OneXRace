import UIKit

class ChestsViewController: UIViewController {
    
    private let gameManager = GameManager.shared
    private var timer: Timer?
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Rewards"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .textLight
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coinsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .accentGold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Collect amazing rewards every day"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chestsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupChests()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCoinsDisplay()
        updateChestsDisplay()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func setupUI() {
        title = "Daily Chests"
        view.backgroundColor = .backgroundDark
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.backgroundDark.cgColor,
            UIColor.accentGold.withAlphaComponent(0.15).cgColor,
            UIColor.primaryPurple.withAlphaComponent(0.1).cgColor,
            UIColor.backgroundDark.cgColor
        ]
        gradientLayer.locations = [0, 0.3, 0.7, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(titleLabel)
        view.addSubview(coinsLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(chestsStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            coinsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            coinsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: coinsLabel.bottomAnchor, constant: 10),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chestsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            chestsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            chestsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            chestsStackView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupChests() {
        let chestEmojis = ["1", "2", "3"]
        let chestColors = [UIColor.primaryBlue, UIColor.primaryPurple, UIColor.accentGold]
        
        for (index, chestType) in ChestType.allCases.enumerated() {
            let chestCard = createChestCard(for: chestType, emoji: chestEmojis[index], color: chestColors[index])
            chestsStackView.addArrangedSubview(chestCard)
        }
    }
    
    private func createChestCard(for chestType: ChestType, emoji: String, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = .cardDark
        card.roundCorners(radius: 20)
        card.addShadow(color: color, opacity: 0.3, radius: 10)
        
        let chestEmojiLabel = UILabel()
        chestEmojiLabel.text = emoji
        chestEmojiLabel.font = UIFont.systemFont(ofSize: 50)
        chestEmojiLabel.textAlignment = .center
        chestEmojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = chestType.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .textLight
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let rewardLabel = UILabel()
        rewardLabel.text = "+\(chestType.reward)"
        rewardLabel.font = UIFont.boldSystemFont(ofSize: 16)
        rewardLabel.textColor = .accentGold
        rewardLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let statusContainerView = UIView()
        statusContainerView.roundCorners(radius: 12)
        statusContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let statusLabel = UILabel()
        statusLabel.font = UIFont.boldSystemFont(ofSize: 12)
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusContainerView.addSubview(statusLabel)
        
        card.addSubview(chestEmojiLabel)
        card.addSubview(titleLabel)
        card.addSubview(rewardLabel)
        card.addSubview(statusContainerView)
        
        NSLayoutConstraint.activate([
            chestEmojiLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 25),
            chestEmojiLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            chestEmojiLabel.widthAnchor.constraint(equalToConstant: 70),
            
            titleLabel.leadingAnchor.constraint(equalTo: chestEmojiLabel.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            
            rewardLabel.leadingAnchor.constraint(equalTo: chestEmojiLabel.trailingAnchor, constant: 20),
            rewardLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            statusContainerView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -25),
            statusContainerView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            statusContainerView.widthAnchor.constraint(equalToConstant: 80),
            statusContainerView.heightAnchor.constraint(equalToConstant: 35),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusContainerView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusContainerView.centerYAnchor)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chestTapped(_:)))
        card.addGestureRecognizer(tapGesture)
        
        return card
    }
    
    private func updateCoinsDisplay() {
        coinsLabel.text = "Coins: \(gameManager.coins)"
    }
    
    private func updateChestsDisplay() {
        for (index, chestType) in ChestType.allCases.enumerated() {
            guard index < chestsStackView.arrangedSubviews.count else { continue }
            
            let card = chestsStackView.arrangedSubviews[index]
            let chest = gameManager.chests[chestType]!
            
            let statusContainerView = card.subviews.last!
            let statusLabel = statusContainerView.subviews.first as! UILabel
            
            if chest.isAvailable {
                statusLabel.text = "OPEN"
                statusLabel.textColor = .white
                statusContainerView.backgroundColor = .systemGreen
                card.alpha = 1.0
                card.isUserInteractionEnabled = true
                
                // Add glow effect for available chests
                card.layer.shadowColor = UIColor.systemGreen.cgColor
                card.layer.shadowOpacity = 0.4
                card.layer.shadowRadius = 15
            } else {
                let timeRemaining = chest.nextAvailable.timeIntervalSince(Date())
                statusLabel.text = formatTimeRemaining(timeRemaining)
                statusLabel.textColor = .white
                statusContainerView.backgroundColor = .textSecondary
                card.alpha = 0.6
                card.isUserInteractionEnabled = false
                
                card.layer.shadowColor = UIColor.primaryPurple.cgColor
                card.layer.shadowOpacity = 0.2
                card.layer.shadowRadius = 8
            }
        }
    }
    
    private func formatTimeRemaining(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "Soon"
        }
    }
    
    @objc private func chestTapped(_ gesture: UITapGestureRecognizer) {
        guard let cardView = gesture.view else { return }
        
        let chestType = ChestType.allCases[chestsStackView.arrangedSubviews.firstIndex(of: cardView)!]
        
        if let reward = gameManager.openChest(type: chestType) {
            cardView.animatePress()
            showChestReward(reward: reward, chestType: chestType)
            updateCoinsDisplay()
            updateChestsDisplay()
        }
    }
    
    private func showChestReward(reward: Int, chestType: ChestType) {
        let alert = UIAlertController(
            title: "Reward Unlocked!",
            message: "Amazing! You found \(reward) coins in your \(chestType.title)!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default))
        present(alert, animated: true)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.updateChestsDisplay()
        }
    }
}