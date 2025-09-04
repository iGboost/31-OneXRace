import UIKit

class AchievementsViewController: UIViewController {
    
    private let gameManager = GameManager.shared
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Achievements"
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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCoinsDisplay()
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Achievements"
        view.backgroundColor = .backgroundDark
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.backgroundDark.cgColor,
            UIColor.accentGold.withAlphaComponent(0.1).cgColor,
            UIColor.backgroundDark.cgColor
        ]
        gradientLayer.locations = [0, 0.3, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(titleLabel)
        view.addSubview(coinsLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            coinsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            coinsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: coinsLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AchievementTableViewCell.self, forCellReuseIdentifier: "AchievementCell")
    }
    
    private func updateCoinsDisplay() {
        coinsLabel.text = "Coins: \(gameManager.coins)"
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension AchievementsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameManager.achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementTableViewCell
        let achievement = gameManager.achievements[indexPath.row]
        cell.configure(with: achievement)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - AchievementTableViewCell
class AchievementTableViewCell: UITableViewCell {
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardDark
        view.roundCorners(radius: 15)
        view.addShadow(color: .primaryPurple, opacity: 0.2, radius: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .textLight
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .textSecondary
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rewardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .accentGold
        view.roundCorners(radius: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rewardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(rewardContainerView)
        rewardContainerView.addSubview(rewardLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            emojiLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: rewardContainerView.leadingAnchor, constant: -10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 15),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            descriptionLabel.trailingAnchor.constraint(equalTo: rewardContainerView.leadingAnchor, constant: -10),
            
            rewardContainerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            rewardContainerView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            rewardContainerView.widthAnchor.constraint(equalToConstant: 60),
            rewardContainerView.heightAnchor.constraint(equalToConstant: 30),
            
            rewardLabel.centerXAnchor.constraint(equalTo: rewardContainerView.centerXAnchor),
            rewardLabel.centerYAnchor.constraint(equalTo: rewardContainerView.centerYAnchor)
        ])
    }
    
    func configure(with achievement: Achievement) {
        let iconMap = ["trophy": "1", "dollarsign": "2", "star": "3", "book": "4"]
        emojiLabel.text = iconMap[achievement.iconName] ?? "0"
        
        titleLabel.text = achievement.title
        descriptionLabel.text = achievement.description
        rewardLabel.text = "+\(achievement.reward)"
        
        if achievement.isUnlocked {
            titleLabel.textColor = .textLight
            descriptionLabel.textColor = .textSecondary
            rewardContainerView.backgroundColor = .systemGreen
            cardView.alpha = 1.0
        } else {
            titleLabel.textColor = .textSecondary
            descriptionLabel.textColor = .textSecondary.withAlphaComponent(0.7)
            rewardContainerView.backgroundColor = .textSecondary
            cardView.alpha = 0.6
        }
    }
}