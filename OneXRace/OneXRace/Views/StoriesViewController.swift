import UIKit

class StoriesViewController: UIViewController {
    
    private let gameManager = GameManager.shared
    private let storyManager = StoryManager.shared
    
    private var stories: [RacingLegend] {
        return storyManager.allStories
    }
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Racing Legends"
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
        title = "Racing Stories"
        view.backgroundColor = .backgroundDark
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.backgroundDark.cgColor,
            UIColor.primaryBlue.withAlphaComponent(0.15).cgColor,
            UIColor.backgroundDark.cgColor
        ]
        gradientLayer.locations = [0, 0.4, 1]
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
        tableView.register(StoryTableViewCell.self, forCellReuseIdentifier: "StoryCell")
    }
    
    private func updateCoinsDisplay() {
        coinsLabel.text = "Coins: \(gameManager.coins)"
    }
    
    private func purchaseStory(_ story: RacingLegend) {
        let alert = UIAlertController(
            title: "Purchase Legend",
            message: "Unlock '\(story.title)' (\(story.rarity.rawValue)) for \(story.price) coins?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Purchase", style: .default) { [weak self] _ in
            if self?.gameManager.unlockStory(id: story.id, price: story.price) == true {
                self?.updateCoinsDisplay()
                self?.tableView.reloadData()
                self?.showStory(story)
            } else {
                self?.showInsufficientCoinsAlert()
            }
        })
        
        present(alert, animated: true)
    }
    
    private func showStory(_ story: RacingLegend) {
        let storyVC = StoryDetailViewController(legend: story)
        navigationController?.pushViewController(storyVC, animated: true)
    }
    
    private func showInsufficientCoinsAlert() {
        let alert = UIAlertController(
            title: "Insufficient Coins",
            message: "You need more coins! Win races or open chests to earn more.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension StoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryTableViewCell
        let story = stories[indexPath.row]
        let isUnlocked = story.isFree || gameManager.isStoryUnlocked(id: story.id)
        cell.configure(with: story, isUnlocked: isUnlocked)
        
        // Add entrance animation
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.3, delay: Double(indexPath.row) * 0.02, usingSpringWithDamping: 0.9, initialSpringVelocity: 0) {
            cell.alpha = 1
            cell.transform = CGAffineTransform.identity
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let story = stories[indexPath.row]
        
        if story.isFree || gameManager.isStoryUnlocked(id: story.id) {
            showStory(story)
        } else {
            purchaseStory(story)
        }
    }
}

// MARK: - StoryTableViewCell
class StoryTableViewCell: UITableViewCell {
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardDark
        view.roundCorners(radius: 15)
        view.addShadow(color: .primaryPurple, opacity: 0.2, radius: 8)
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
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .textSecondary
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = .accentGold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceContainerView: UIView = {
        let view = UIView()
        view.roundCorners(radius: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
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
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(categoryLabel)
        cardView.addSubview(priceContainerView)
        priceContainerView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            emojiLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: priceContainerView.leadingAnchor, constant: -15),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 15),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: priceContainerView.leadingAnchor, constant: -15),
            
            categoryLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 15),
            categoryLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            
            priceContainerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            priceContainerView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            priceContainerView.widthAnchor.constraint(equalToConstant: 80),
            priceContainerView.heightAnchor.constraint(equalToConstant: 35),
            
            priceLabel.centerXAnchor.constraint(equalTo: priceContainerView.centerXAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: priceContainerView.centerYAnchor)
        ])
    }
    
    func configure(with story: RacingLegend, isUnlocked: Bool) {
        emojiLabel.text = story.imageUrl
        titleLabel.text = story.title
        subtitleLabel.text = story.subtitle
        categoryLabel.text = "\(story.category.emoji) \(story.rarity.rawValue)"
        
        if story.isFree {
            priceLabel.text = "FREE"
            priceLabel.textColor = .white
            priceContainerView.backgroundColor = .systemGreen
        } else if isUnlocked {
            priceLabel.text = "OWNED"
            priceLabel.textColor = .white
            priceContainerView.backgroundColor = .systemGreen
        } else {
            priceLabel.text = "\(story.price)"
            priceLabel.textColor = .white
            priceContainerView.backgroundColor = UIColor(named: story.rarity.color) ?? .accentGold
        }
        
        // Add rarity glow effect
        if !isUnlocked {
            cardView.addShadow(color: UIColor(named: story.rarity.color) ?? .primaryPurple, opacity: 0.4, radius: 10)
        } else {
            cardView.addShadow(color: .systemGreen, opacity: 0.3, radius: 8)
        }
        
        cardView.alpha = isUnlocked ? 1.0 : 0.9
        titleLabel.textColor = isUnlocked ? .textLight : .textSecondary
    }
}