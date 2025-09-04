import UIKit

class RaceViewController: UIViewController {
    
    private let gameManager = GameManager.shared
    private var selectedDriver: Driver?
    private var betAmount = 50
    
    private let drivers = [
        Driver(id: 0, name: "Max Thunder", country: "🇳🇱", odds: 6.7, avatar: "🏎️", carColor: "systemBlue"),
        Driver(id: 1, name: "Speed Racer", country: "🇺🇸", odds: 6.7, avatar: "🏁", carColor: "systemRed"),
        Driver(id: 2, name: "Lightning", country: "🇬🇧", odds: 6.7, avatar: "⚡", carColor: "systemGreen"),
        Driver(id: 3, name: "Turbo King", country: "🇩🇪", odds: 6.7, avatar: "🔥", carColor: "systemOrange")
    ]
    
    private let coinsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .accentGold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Your Champion"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .textLight
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let driversStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let betContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardDark
        view.roundCorners(radius: 20)
        view.addShadow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let betAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Bet Amount"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .textLight
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let betAmountValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .accentGold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let betSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 10
        slider.maximumValue = 500
        slider.value = 50
        slider.tintColor = .accentGold
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let raceButton: UIButton = {
        let button = UIButton()
        button.setTitle("START RACE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDriverCards()
        updateCoinsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCoinsDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update gradient frames
        view.layer.sublayers?.first?.frame = view.bounds
        raceButton.layer.sublayers?.first?.frame = raceButton.bounds
    }
    
    private func setupUI() {
        title = "Racing"
        view.backgroundColor = .backgroundDark
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.backgroundDark.cgColor,
            UIColor.primaryPurple.withAlphaComponent(0.2).cgColor,
            UIColor.backgroundDark.cgColor
        ]
        gradientLayer.locations = [0, 0.3, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(titleLabel)
        view.addSubview(coinsLabel)
        view.addSubview(driversStackView)
        view.addSubview(betContainerView)
        betContainerView.addSubview(betAmountLabel)
        betContainerView.addSubview(betAmountValueLabel)
        betContainerView.addSubview(betSlider)
        
        view.addSubview(raceButton)
        
        betSlider.addTarget(self, action: #selector(betAmountChanged), for: .valueChanged)
        raceButton.addTarget(self, action: #selector(startRace), for: .touchUpInside)
        
        raceButton.setGoldStyle()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            coinsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            coinsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            driversStackView.topAnchor.constraint(equalTo: coinsLabel.bottomAnchor, constant: 20),
            driversStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            driversStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            driversStackView.heightAnchor.constraint(equalToConstant: 280),
            
            betContainerView.topAnchor.constraint(equalTo: driversStackView.bottomAnchor, constant: 30),
            betContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            betContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            betContainerView.heightAnchor.constraint(equalToConstant: 120),
            
            betAmountLabel.topAnchor.constraint(equalTo: betContainerView.topAnchor, constant: 20),
            betAmountLabel.leadingAnchor.constraint(equalTo: betContainerView.leadingAnchor, constant: 20),
            
            betAmountValueLabel.centerYAnchor.constraint(equalTo: betAmountLabel.centerYAnchor),
            betAmountValueLabel.trailingAnchor.constraint(equalTo: betContainerView.trailingAnchor, constant: -20),
            
            betSlider.topAnchor.constraint(equalTo: betAmountLabel.bottomAnchor, constant: 15),
            betSlider.leadingAnchor.constraint(equalTo: betContainerView.leadingAnchor, constant: 20),
            betSlider.trailingAnchor.constraint(equalTo: betContainerView.trailingAnchor, constant: -20),
            betSlider.bottomAnchor.constraint(equalTo: betContainerView.bottomAnchor, constant: -20),
            
            raceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            raceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            raceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            raceButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        updateBetDisplay()
    }
    
    private func setupDriverCards() {
        for driver in drivers {
            let card = createDriverCard(for: driver)
            driversStackView.addArrangedSubview(card)
        }
    }
    
    private func createDriverCard(for driver: Driver) -> UIView {
        let card = UIView()
        card.backgroundColor = .cardDark
        card.roundCorners(radius: 15)
        card.addShadow(color: .primaryPurple, opacity: 0.2, radius: 6)
        
        let avatarLabel = UILabel()
        avatarLabel.text = driver.avatar
        avatarLabel.font = UIFont.systemFont(ofSize: 32)
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = driver.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .textLight
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let countryLabel = UILabel()
        countryLabel.text = driver.country
        countryLabel.font = UIFont.systemFont(ofSize: 16)
        countryLabel.textColor = .textSecondary
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let oddsContainer = UIView()
        oddsContainer.backgroundColor = .primaryPurple
        oddsContainer.roundCorners(radius: 12)
        oddsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let oddsLabel = UILabel()
        oddsLabel.text = "×\(driver.odds)"
        oddsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        oddsLabel.textColor = .white
        oddsLabel.textAlignment = .center
        oddsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        oddsContainer.addSubview(oddsLabel)
        
        card.addSubview(avatarLabel)
        card.addSubview(nameLabel)
        card.addSubview(countryLabel)
        card.addSubview(oddsContainer)
        
        NSLayoutConstraint.activate([
            avatarLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            avatarLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            avatarLabel.widthAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarLabel.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            
            countryLabel.leadingAnchor.constraint(equalTo: avatarLabel.trailingAnchor, constant: 15),
            countryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            oddsContainer.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            oddsContainer.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            oddsContainer.widthAnchor.constraint(equalToConstant: 70),
            oddsContainer.heightAnchor.constraint(equalToConstant: 35),
            
            oddsLabel.centerXAnchor.constraint(equalTo: oddsContainer.centerXAnchor),
            oddsLabel.centerYAnchor.constraint(equalTo: oddsContainer.centerYAnchor)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(driverSelected(_:)))
        card.addGestureRecognizer(tapGesture)
        card.tag = driver.id
        
        return card
    }
    
    @objc private func driverSelected(_ gesture: UITapGestureRecognizer) {
        guard let cardView = gesture.view else { return }
        
        // Remove selection from all cards
        driversStackView.arrangedSubviews.forEach { view in
            view.layer.borderWidth = 0
        }
        
        // Select this card with gradient border
        cardView.layer.borderColor = UIColor.accentGold.cgColor
        cardView.layer.borderWidth = 3
        cardView.animatePress()
        
        selectedDriver = drivers.first { $0.id == cardView.tag }
    }
    
    @objc private func betAmountChanged() {
        betAmount = Int(betSlider.value)
        updateBetDisplay()
    }
    
    private func updateBetDisplay() {
        betAmountValueLabel.text = "\(betAmount)"
        
        if betAmount > gameManager.coins {
            betAmountValueLabel.textColor = .systemRed
            raceButton.isEnabled = false
            raceButton.alpha = 0.6
        } else {
            betAmountValueLabel.textColor = .accentGold
            raceButton.isEnabled = true
            raceButton.alpha = 1.0
        }
    }
    
    private func updateCoinsDisplay() {
        coinsLabel.text = "Coins: \(gameManager.coins)"
        updateBetDisplay()
    }
    
    @objc private func startRace() {
        guard let selectedDriver = selectedDriver else {
            showAlert(title: "Select Driver", message: "Please select a driver before starting the race!")
            return
        }
        
        guard gameManager.spendCoins(betAmount) else {
            showAlert(title: "Insufficient Coins", message: "You don't have enough coins for this bet!")
            return
        }
        
        raceButton.animatePress()
        performRace(selectedDriver: selectedDriver)
    }
    
    private func performRace(selectedDriver: Driver) {
        // Disable UI during race
        raceButton.isEnabled = false
        driversStackView.isUserInteractionEnabled = false
        
        // Show race animation
        let raceResultVC = RaceResultViewController(drivers: drivers, selectedDriver: selectedDriver, betAmount: betAmount)
        raceResultVC.modalPresentationStyle = .fullScreen
        
        present(raceResultVC, animated: true) { [weak self] in
            // Re-enable UI after race
            self?.raceButton.isEnabled = true
            self?.driversStackView.isUserInteractionEnabled = true
            self?.updateCoinsDisplay()
            
            // Remove selection
            self?.driversStackView.arrangedSubviews.forEach { view in
                view.layer.borderWidth = 0
            }
            self?.selectedDriver = nil
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}