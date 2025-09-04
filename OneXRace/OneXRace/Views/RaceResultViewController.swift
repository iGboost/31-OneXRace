import UIKit

class RaceResultViewController: UIViewController {
    
    private let drivers: [Driver]
    private let selectedDriver: Driver
    private let betAmount: Int
    private var winner: Driver!
    private var winnings: Int = 0
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let raceAnimationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var driverAnimationViews: [UILabel] = []
    
    private let resultCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardDark
        view.roundCorners(radius: 25)
        view.addShadow(color: .primaryPurple, opacity: 0.4, radius: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let resultEmojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resultTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let winnerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple
        view.roundCorners(radius: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let winnerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let winningsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue Racing", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(drivers: [Driver], selectedDriver: Driver, betAmount: Int) {
        self.drivers = drivers
        self.selectedDriver = selectedDriver
        self.betAmount = betAmount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        simulateRace()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.layer.sublayers?.first?.frame = closeButton.bounds
    }
    
    private func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(raceAnimationView)
        view.addSubview(resultCardView)
        
        resultCardView.addSubview(resultEmojiLabel)
        resultCardView.addSubview(resultTitleLabel)
        resultCardView.addSubview(winnerContainerView)
        resultCardView.addSubview(winningsLabel)
        resultCardView.addSubview(closeButton)
        
        winnerContainerView.addSubview(winnerLabel)
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.setPrimaryStyle()
        
        setupRaceAnimation()
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            raceAnimationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            raceAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            raceAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            raceAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            resultCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            resultCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            resultCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            resultCardView.heightAnchor.constraint(equalToConstant: 450),
            
            resultEmojiLabel.topAnchor.constraint(equalTo: resultCardView.topAnchor, constant: 40),
            resultEmojiLabel.centerXAnchor.constraint(equalTo: resultCardView.centerXAnchor),
            
            resultTitleLabel.topAnchor.constraint(equalTo: resultEmojiLabel.bottomAnchor, constant: 20),
            resultTitleLabel.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor, constant: 20),
            resultTitleLabel.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor, constant: -20),
            
            winnerContainerView.topAnchor.constraint(equalTo: resultTitleLabel.bottomAnchor, constant: 30),
            winnerContainerView.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor, constant: 30),
            winnerContainerView.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor, constant: -30),
            winnerContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            winnerLabel.centerXAnchor.constraint(equalTo: winnerContainerView.centerXAnchor),
            winnerLabel.centerYAnchor.constraint(equalTo: winnerContainerView.centerYAnchor),
            
            winningsLabel.topAnchor.constraint(equalTo: winnerContainerView.bottomAnchor, constant: 25),
            winningsLabel.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor, constant: 20),
            winningsLabel.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor, constant: -20),
            
            closeButton.bottomAnchor.constraint(equalTo: resultCardView.bottomAnchor, constant: -30),
            closeButton.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor, constant: -30),
            closeButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupRaceAnimation() {
        // Add background track image
        let trackBackground = UIView()
        trackBackground.backgroundColor = UIColor.primaryPurple.withAlphaComponent(0.1)
        trackBackground.roundCorners(radius: 15)
        trackBackground.addShadow(color: .primaryPurple, opacity: 0.3, radius: 10)
        trackBackground.translatesAutoresizingMaskIntoConstraints = false
        
        raceAnimationView.addSubview(trackBackground)
        
        NSLayoutConstraint.activate([
            trackBackground.topAnchor.constraint(equalTo: raceAnimationView.topAnchor),
            trackBackground.leadingAnchor.constraint(equalTo: raceAnimationView.leadingAnchor),
            trackBackground.trailingAnchor.constraint(equalTo: raceAnimationView.trailingAnchor),
            trackBackground.bottomAnchor.constraint(equalTo: raceAnimationView.bottomAnchor)
        ])
        
        // Add start line at bottom
        let startLine = UILabel()
        startLine.text = "START"
        startLine.font = UIFont.boldSystemFont(ofSize: 16)
        startLine.textColor = .systemGreen
        startLine.textAlignment = .center
        startLine.translatesAutoresizingMaskIntoConstraints = false
        
        trackBackground.addSubview(startLine)
        
        // Add finish line at top
        let finishLine = UILabel()
        finishLine.text = "FINISH"
        finishLine.font = UIFont.boldSystemFont(ofSize: 18)
        finishLine.textColor = .accentGold
        finishLine.textAlignment = .center
        finishLine.translatesAutoresizingMaskIntoConstraints = false
        
        trackBackground.addSubview(finishLine)
        
        NSLayoutConstraint.activate([
            startLine.bottomAnchor.constraint(equalTo: trackBackground.bottomAnchor, constant: -10),
            startLine.centerXAnchor.constraint(equalTo: trackBackground.centerXAnchor),
            
            finishLine.topAnchor.constraint(equalTo: trackBackground.topAnchor, constant: 15),
            finishLine.centerXAnchor.constraint(equalTo: trackBackground.centerXAnchor)
        ])
        
        // Создаем вертикальные линии и машинки
        let carWidth: CGFloat = 44
        let spacing: CGFloat = 30
        let totalCars = drivers.count
        let totalWidth = (CGFloat(totalCars) * carWidth) + (CGFloat(totalCars - 1) * spacing)
        
        // Создаем контейнер для центрирования
        let raceLanesContainer = UIView()
        raceLanesContainer.translatesAutoresizingMaskIntoConstraints = false
        trackBackground.addSubview(raceLanesContainer)
        
        NSLayoutConstraint.activate([
            raceLanesContainer.centerXAnchor.constraint(equalTo: trackBackground.centerXAnchor),
            raceLanesContainer.topAnchor.constraint(equalTo: finishLine.bottomAnchor, constant: 10),
            raceLanesContainer.bottomAnchor.constraint(equalTo: startLine.topAnchor, constant: -10),
            raceLanesContainer.widthAnchor.constraint(equalToConstant: totalWidth)
        ])
        
        for (index, driver) in drivers.enumerated() {
            let xPosition = CGFloat(index) * (carWidth + spacing)
            
            // Создаем линию для каждой дорожки
            let raceLine = UIView()
            raceLine.backgroundColor = UIColor.primaryBlue.withAlphaComponent(0.3)
            raceLine.translatesAutoresizingMaskIntoConstraints = false
            raceLanesContainer.addSubview(raceLine)
            
            NSLayoutConstraint.activate([
                raceLine.leadingAnchor.constraint(equalTo: raceLanesContainer.leadingAnchor, constant: xPosition + carWidth/2 - 3),
                raceLine.topAnchor.constraint(equalTo: raceLanesContainer.topAnchor),
                raceLine.bottomAnchor.constraint(equalTo: raceLanesContainer.bottomAnchor),
                raceLine.widthAnchor.constraint(equalToConstant: 6)
            ])
            
            // Добавляем градиент на линию
            let gradient = CAGradientLayer()
            gradient.colors = [
                UIColor.systemGreen.withAlphaComponent(0.6).cgColor,
                UIColor.accentGold.withAlphaComponent(0.8).cgColor,
                UIColor.systemRed.withAlphaComponent(0.6).cgColor
            ]
            gradient.startPoint = CGPoint(x: 0.5, y: 1)
            gradient.endPoint = CGPoint(x: 0.5, y: 0)
            gradient.frame = CGRect(x: 0, y: 0, width: 6, height: 1000)
            raceLine.layer.insertSublayer(gradient, at: 0)
            raceLine.clipsToBounds = true
            raceLine.layer.cornerRadius = 3
            
            // Создаем машинку
            let driverIcon = UILabel()
            driverIcon.text = driver.avatar
            driverIcon.font = UIFont.systemFont(ofSize: 35)
            driverIcon.textAlignment = .center
            driverIcon.backgroundColor = UIColor.cardDark
            driverIcon.roundCorners(radius: 22)
            driverIcon.addShadow(color: UIColor(named: driver.carColor) ?? .primaryBlue, opacity: 0.8, radius: 12)
            driverIcon.translatesAutoresizingMaskIntoConstraints = false
            
            trackBackground.addSubview(driverIcon)
            driverAnimationViews.append(driverIcon)
            
            NSLayoutConstraint.activate([
                driverIcon.centerXAnchor.constraint(equalTo: raceLine.centerXAnchor),
                driverIcon.bottomAnchor.constraint(equalTo: raceAnimationView.bottomAnchor, constant: -60),
                driverIcon.widthAnchor.constraint(equalToConstant: carWidth),
                driverIcon.heightAnchor.constraint(equalToConstant: carWidth)
            ])
        }
    }
    
    private func simulateRace() {
        // Pre-determine winner for animation
        let result = GameManager.shared.simulateRace(drivers: drivers, betDriver: selectedDriver, betAmount: betAmount)
        winner = result.winner
        winnings = result.winnings
        
        // Initial state
        resultEmojiLabel.text = ""
        resultTitleLabel.text = "RACING IN PROGRESS..."
        resultTitleLabel.textColor = .accentGold
        winnerLabel.text = ""
        winningsLabel.text = ""
        
        // Initially hide result card and show animation
        resultCardView.isHidden = true
        raceAnimationView.isHidden = false
        
        // Start race animation after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.animateRacing()
        }
        
        // Show result after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
            self.showRaceResult()
        }
    }
    
    private func animateRacing() {
        resultCardView.isHidden = true
        raceAnimationView.isHidden = false
        
        for (index, driverIcon) in driverAnimationViews.enumerated() {
            let isWinner = index == winner.id
            let finishLineY = raceAnimationView.bounds.minY + 60
            let totalDistance = driverIcon.frame.midY - finishLineY
            
            let baseDuration: TimeInterval = 6.0
            let speedVariation = Double.random(in: 0.8...1.2)
            let duration = isWinner ? baseDuration * 0.9 : baseDuration * speedVariation
            
            animateSmoothRacing(for: driverIcon, totalDistance: totalDistance, duration: duration, isWinner: isWinner)
        }
    }
    
    private func animateSmoothRacing(for driverIcon: UILabel, totalDistance: CGFloat, duration: TimeInterval, isWinner: Bool) {
        let finalPosition = isWinner ? -totalDistance : -totalDistance * Double.random(in: 0.75...0.9)
        
        UIView.animate(withDuration: duration, delay: 0.2, options: [.curveEaseInOut]) {
            driverIcon.transform = CGAffineTransform(translationX: 0, y: finalPosition)
        } completion: { _ in
            if isWinner {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
                    driverIcon.transform = CGAffineTransform(translationX: 0, y: finalPosition).scaledBy(x: 1.3, y: 1.3)
                })
                driverIcon.addShadow(color: .systemGreen, opacity: 1.0, radius: 20)
            }
        }
        
        // Pulsing race title
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .autoreverse]) {
            self.resultEmojiLabel.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }
    }
    
    private func showRaceResult() {
        // Stop all animations
        view.layer.removeAllAnimations()
        driverAnimationViews.forEach { icon in
            icon.layer.removeAllAnimations()
        }
        
        // Hide race animation with fade out
        UIView.animate(withDuration: 0.5) {
            self.raceAnimationView.alpha = 0
        } completion: { _ in
            self.raceAnimationView.isHidden = true
            
            // Reset for next race
            self.driverAnimationViews.forEach { icon in
                icon.transform = CGAffineTransform.identity
            }
            self.raceAnimationView.alpha = 1
        }
        
        let didWin = winner.id == selectedDriver.id
        
        // Show result card with dramatic animation
        resultCardView.isHidden = false
        resultCardView.alpha = 0
        resultCardView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8) {
            self.resultCardView.alpha = 1
            self.resultCardView.transform = CGAffineTransform.identity
        }
        
        resultEmojiLabel.text = didWin ? "WIN" : "LOSE"
        resultTitleLabel.text = didWin ? "VICTORY!" : "DEFEAT"
        resultTitleLabel.textColor = didWin ? .systemGreen : .systemRed
        
        winnerLabel.text = "\(winner.name) \(winner.country)"
        
        if didWin {
            winningsLabel.text = "+\(winnings) COINS!"
            winningsLabel.textColor = .systemGreen
            
            // Add celebration animation
            UIView.animate(withDuration: 0.3, delay: 0.5, options: [.repeat, .autoreverse]) {
                self.winningsLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
        } else {
            winningsLabel.text = "Better luck next time!"
            winningsLabel.textColor = .textSecondary
        }
        
        // Animate result with spring
        resultTitleLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0) {
            self.resultTitleLabel.transform = CGAffineTransform.identity
        }
        
        winnerContainerView.slideInFromBottom()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.winningsLabel.fadeIn(duration: 0.8)
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}