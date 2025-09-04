import UIKit

class StoryDetailViewController: UIViewController {
    
    private let legend: RacingLegend
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let heroImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple.withAlphaComponent(0.3)
        view.roundCorners(radius: 25)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rarityBadge: UIView = {
        let view = UIView()
        view.roundCorners(radius: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rarityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardDark
        view.roundCorners(radius: 20)
        view.addShadow(color: .primaryPurple, opacity: 0.3, radius: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let storyCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardDark
        view.roundCorners(radius: 20)
        view.addShadow(color: .primaryBlue, opacity: 0.3, radius: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .textLight
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(legend: RacingLegend) {
        self.legend = legend
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContent()
        setupAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.sublayers?.first?.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundDark
        navigationItem.largeTitleDisplayMode = .never
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.backgroundDark.cgColor,
            UIColor(named: legend.rarity.color)?.withAlphaComponent(0.2).cgColor ?? UIColor.primaryPurple.withAlphaComponent(0.2).cgColor,
            UIColor.backgroundDark.cgColor
        ]
        gradientLayer.locations = [0, 0.4, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(heroImageView)
        heroImageView.addSubview(emojiLabel)
        heroImageView.addSubview(rarityBadge)
        rarityBadge.addSubview(rarityLabel)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(infoCardView)
        contentView.addSubview(storyCardView)
        contentView.addSubview(tagsStackView)
        
        setupInfoCard()
        setupStoryCard()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            heroImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heroImageView.widthAnchor.constraint(equalToConstant: 140),
            heroImageView.heightAnchor.constraint(equalToConstant: 140),
            
            emojiLabel.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: heroImageView.centerYAnchor),
            
            rarityBadge.topAnchor.constraint(equalTo: heroImageView.topAnchor, constant: 10),
            rarityBadge.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: -10),
            rarityBadge.widthAnchor.constraint(equalToConstant: 60),
            rarityBadge.heightAnchor.constraint(equalToConstant: 24),
            
            rarityLabel.centerXAnchor.constraint(equalTo: rarityBadge.centerXAnchor),
            rarityLabel.centerYAnchor.constraint(equalTo: rarityBadge.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            infoCardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoCardView.heightAnchor.constraint(equalToConstant: 320),
            
            storyCardView.topAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: 25),
            storyCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            storyCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            tagsStackView.topAnchor.constraint(equalTo: storyCardView.bottomAnchor, constant: 25),
            tagsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            tagsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            tagsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupInfoCard() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let infoItems = [
            ("Year", legend.year),
            ("Location", legend.location),
            ("Driver", legend.driver),
            ("Team", legend.team),
            ("Achievement", legend.achievement)
        ]
        
        for (icon, info) in infoItems {
            let itemView = createInfoItem(icon: icon, text: info)
            stackView.addArrangedSubview(itemView)
        }
        
        infoCardView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createInfoItem(icon: String, text: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = icon
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = .accentGold
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = text
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .textLight
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func setupStoryCard() {
        let storyTitleLabel = UILabel()
        storyTitleLabel.text = "The Story"
        storyTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        storyTitleLabel.textColor = .accentGold
        storyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        storyCardView.addSubview(storyTitleLabel)
        storyCardView.addSubview(contentLabel)
        
        let funFactView = UIView()
        funFactView.backgroundColor = .primaryBlue.withAlphaComponent(0.2)
        funFactView.roundCorners(radius: 15)
        funFactView.translatesAutoresizingMaskIntoConstraints = false
        
        let funFactTitleLabel = UILabel()
        funFactTitleLabel.text = "💡 Fun Fact"
        funFactTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        funFactTitleLabel.textColor = .accentGold
        funFactTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let funFactLabel = UILabel()
        funFactLabel.text = legend.funFact
        funFactLabel.font = UIFont.systemFont(ofSize: 14)
        funFactLabel.textColor = .textLight
        funFactLabel.numberOfLines = 0
        funFactLabel.translatesAutoresizingMaskIntoConstraints = false
        
        funFactView.addSubview(funFactTitleLabel)
        funFactView.addSubview(funFactLabel)
        storyCardView.addSubview(funFactView)
        
        NSLayoutConstraint.activate([
            storyTitleLabel.topAnchor.constraint(equalTo: storyCardView.topAnchor, constant: 20),
            storyTitleLabel.leadingAnchor.constraint(equalTo: storyCardView.leadingAnchor, constant: 20),
            storyTitleLabel.trailingAnchor.constraint(equalTo: storyCardView.trailingAnchor, constant: -20),
            
            contentLabel.topAnchor.constraint(equalTo: storyTitleLabel.bottomAnchor, constant: 15),
            contentLabel.leadingAnchor.constraint(equalTo: storyCardView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: storyCardView.trailingAnchor, constant: -20),
            
            funFactView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20),
            funFactView.leadingAnchor.constraint(equalTo: storyCardView.leadingAnchor, constant: 15),
            funFactView.trailingAnchor.constraint(equalTo: storyCardView.trailingAnchor, constant: -15),
            funFactView.bottomAnchor.constraint(equalTo: storyCardView.bottomAnchor, constant: -20),
            
            funFactTitleLabel.topAnchor.constraint(equalTo: funFactView.topAnchor, constant: 15),
            funFactTitleLabel.leadingAnchor.constraint(equalTo: funFactView.leadingAnchor, constant: 15),
            funFactTitleLabel.trailingAnchor.constraint(equalTo: funFactView.trailingAnchor, constant: -15),
            
            funFactLabel.topAnchor.constraint(equalTo: funFactTitleLabel.bottomAnchor, constant: 8),
            funFactLabel.leadingAnchor.constraint(equalTo: funFactView.leadingAnchor, constant: 15),
            funFactLabel.trailingAnchor.constraint(equalTo: funFactView.trailingAnchor, constant: -15),
            funFactLabel.bottomAnchor.constraint(equalTo: funFactView.bottomAnchor, constant: -15)
        ])
    }
    
    private func configureContent() {
        emojiLabel.text = legend.imageUrl
        titleLabel.text = legend.title
        subtitleLabel.text = legend.subtitle
        contentLabel.text = legend.extendedContent
        
        // Configure rarity badge
        rarityLabel.text = legend.rarity.rawValue.uppercased()
        rarityBadge.backgroundColor = UIColor(named: legend.rarity.color) ?? .primaryPurple
        
        // Setup tags
        setupTags()
    }
    
    private func setupTags() {
        // Add category tag first
        let categoryTag = createTagView(text: "\(legend.category.emoji) \(legend.category.rawValue)")
        categoryTag.backgroundColor = .accentGold.withAlphaComponent(0.3)
        
        // Create first horizontal row
        let firstRow = UIStackView()
        firstRow.axis = .horizontal
        firstRow.spacing = 8
        firstRow.distribution = .fillProportionally
        firstRow.translatesAutoresizingMaskIntoConstraints = false
        
        firstRow.addArrangedSubview(categoryTag)
        
        // Add up to 2 more tags in first row
        let firstRowTags = Array(legend.tags.prefix(2))
        for tag in firstRowTags {
            let tagView = createTagView(text: tag)
            firstRow.addArrangedSubview(tagView)
        }
        
        tagsStackView.addArrangedSubview(firstRow)
        
        // Create second row if needed
        let remainingTags = Array(legend.tags.dropFirst(2))
        if !remainingTags.isEmpty {
            let secondRow = UIStackView()
            secondRow.axis = .horizontal
            secondRow.spacing = 8
            secondRow.distribution = .fillProportionally
            secondRow.translatesAutoresizingMaskIntoConstraints = false
            
            for tag in remainingTags {
                let tagView = createTagView(text: tag)
                secondRow.addArrangedSubview(tagView)
            }
            
            tagsStackView.addArrangedSubview(secondRow)
        }
    }
    
    private func createTagView(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .primaryPurple.withAlphaComponent(0.3)
        container.roundCorners(radius: 12)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .textLight
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            container.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        return container
    }
    
    private func setupAnimations() {
        // Initial state for animations
        heroImageView.alpha = 0
        heroImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        infoCardView.alpha = 0
        storyCardView.alpha = 0
        tagsStackView.alpha = 0
        
        // Animate appearance
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.heroImageView.alpha = 1
            self.heroImageView.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.4) {
            self.titleLabel.alpha = 1
            self.subtitleLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.9, initialSpringVelocity: 0) {
            self.infoCardView.alpha = 1
            self.infoCardView.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.8, usingSpringWithDamping: 0.9, initialSpringVelocity: 0) {
            self.storyCardView.alpha = 1
            self.storyCardView.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 1.0) {
            self.tagsStackView.alpha = 1
        }
        
        // Add subtle pulsing to hero image
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
                self.heroImageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }
    }
}