import Foundation

class GameManager: ObservableObject {
    static let shared = GameManager()
    
    @Published var coins: Int = 0
    @Published var isFirstLaunch: Bool = true
    @Published var completedOnboarding: Bool = false
    @Published var achievements: [Achievement] = []
    @Published var unlockedStories: Set<Int> = [0] // First story is free
    @Published var chests: [ChestType: Chest] = [:]
    
    // Achievement tracking
    private var totalWins: Int = 0
    private var currentWinStreak: Int = 0
    private var highestBet: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let coinsKey = "user_coins"
    private let firstLaunchKey = "is_first_launch"
    private let onboardingKey = "completed_onboarding"
    private let unlockedStoriesKey = "unlocked_stories"
    private let chestsKey = "chests_data"
    private let achievementsKey = "achievements_data"
    private let totalWinsKey = "total_wins"
    private let winStreakKey = "win_streak"
    private let highestBetKey = "highest_bet"
    
    private init() {
        loadGameData()
        setupInitialData()
    }
    
    // MARK: - Setup
    private func setupInitialData() {
        if isFirstLaunch {
            coins = 1000 // Initial balance
            isFirstLaunch = false
            saveGameData()
        }
        
        setupChests()
        setupAchievements()
    }
    
    private func setupChests() {
        for chestType in ChestType.allCases {
            if chests[chestType] == nil {
                chests[chestType] = Chest(type: chestType, lastOpened: nil)
            }
        }
    }
    
    private func setupAchievements() {
        // Achievements are now loaded in loadGameData
        if achievements.isEmpty {
            achievements = [
                Achievement(id: 0, title: "First Win", description: "Win your first race", isUnlocked: false, iconName: "trophy", reward: 200),
                Achievement(id: 1, title: "High Roller", description: "Bet 500 coins in a single race", isUnlocked: false, iconName: "dollarsign", reward: 300),
                Achievement(id: 2, title: "Lucky Streak", description: "Win 3 races in a row", isUnlocked: false, iconName: "star", reward: 500),
                Achievement(id: 3, title: "Story Collector", description: "Unlock 5 race stories", isUnlocked: false, iconName: "book", reward: 400)
            ]
        }
    }
    
    // MARK: - Coins Management
    func addCoins(_ amount: Int) {
        coins += amount
        saveGameData()
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        guard coins >= amount else { return false }
        coins -= amount
        saveGameData()
        return true
    }
    
    // MARK: - Race Logic
    func placeBet(amount: Int, on driver: Driver) -> Bool {
        return spendCoins(amount)
    }
    
    func simulateRace(drivers: [Driver], betDriver: Driver, betAmount: Int) -> (winner: Driver, winnings: Int) {
        // Track highest bet
        if betAmount > highestBet {
            highestBet = betAmount
            checkAndUnlockAchievements(for: .highBet(amount: betAmount))
        }
        
        let winner = drivers.randomElement()!
        let winnings = winner.id == betDriver.id ? Int(Double(betAmount) * 6.7) : 0
        
        if winnings > 0 {
            addCoins(winnings)
            totalWins += 1
            currentWinStreak += 1
            
            // Check achievements
            if totalWins == 1 {
                checkAndUnlockAchievements(for: .firstWin)
            }
            if currentWinStreak >= 3 {
                checkAndUnlockAchievements(for: .winStreak(count: currentWinStreak))
            }
        } else {
            currentWinStreak = 0
        }
        
        saveGameData()
        return (winner, winnings)
    }
    
    // MARK: - Stories Management
    func unlockStory(id: Int, price: Int) -> Bool {
        guard spendCoins(price) else { return false }
        unlockedStories.insert(id)
        
        // Check story collector achievement
        if unlockedStories.count >= 5 {
            checkAndUnlockAchievements(for: .storyUnlock(count: unlockedStories.count))
        }
        
        saveGameData()
        return true
    }
    
    func isStoryUnlocked(id: Int) -> Bool {
        return unlockedStories.contains(id)
    }
    
    // MARK: - Chests Management
    func openChest(type: ChestType) -> Int? {
        guard let chest = chests[type], chest.isAvailable else { return nil }
        
        let reward = type.reward
        addCoins(reward)
        
        chests[type] = Chest(type: type, lastOpened: Date())
        saveGameData()
        
        return reward
    }
    
    // MARK: - Achievements
    func checkAndUnlockAchievements(for event: AchievementEvent) {
        var unlocked = false
        
        for (index, achievement) in achievements.enumerated() {
            guard !achievement.isUnlocked else { continue }
            
            switch event {
            case .firstWin:
                if achievement.id == 0 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .highBet(let amount):
                if achievement.id == 1 && amount >= 500 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .winStreak(let count):
                if achievement.id == 2 && count >= 3 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .storyUnlock(let count):
                if achievement.id == 3 && count >= 5 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            }
        }
        
        if unlocked {
            saveGameData()
        }
    }
    
    // MARK: - Data Persistence
    private func saveGameData() {
        userDefaults.set(coins, forKey: coinsKey)
        userDefaults.set(isFirstLaunch, forKey: firstLaunchKey)
        userDefaults.set(completedOnboarding, forKey: onboardingKey)
        userDefaults.set(Array(unlockedStories), forKey: unlockedStoriesKey)
        userDefaults.set(totalWins, forKey: totalWinsKey)
        userDefaults.set(currentWinStreak, forKey: winStreakKey)
        userDefaults.set(highestBet, forKey: highestBetKey)
        
        // Save achievements
        var achievementsData: [[String: Any]] = []
        for achievement in achievements {
            achievementsData.append([
                "id": achievement.id,
                "isUnlocked": achievement.isUnlocked
            ])
        }
        userDefaults.set(achievementsData, forKey: achievementsKey)
        
        // Save chests data
        var chestsData: [String: [String: Any]] = [:]
        for (chestType, chest) in chests {
            let key = String(describing: chestType)
            chestsData[key] = ["lastOpened": chest.lastOpened?.timeIntervalSince1970 ?? 0]
        }
        userDefaults.set(chestsData, forKey: chestsKey)
    }
    
    private func loadGameData() {
        coins = userDefaults.integer(forKey: coinsKey)
        isFirstLaunch = userDefaults.object(forKey: firstLaunchKey) == nil ? true : userDefaults.bool(forKey: firstLaunchKey)
        completedOnboarding = userDefaults.bool(forKey: onboardingKey)
        totalWins = userDefaults.integer(forKey: totalWinsKey)
        currentWinStreak = userDefaults.integer(forKey: winStreakKey)
        highestBet = userDefaults.integer(forKey: highestBetKey)
        
        let storiesArray = userDefaults.array(forKey: unlockedStoriesKey) as? [Int] ?? [0]
        unlockedStories = Set(storiesArray)
        
        // Load achievements data
        if let achievementsData = userDefaults.array(forKey: achievementsKey) as? [[String: Any]] {
            var loadedAchievements: [Achievement] = []
            let defaultAchievements = [
                Achievement(id: 0, title: "First Win", description: "Win your first race", isUnlocked: false, iconName: "trophy", reward: 200),
                Achievement(id: 1, title: "High Roller", description: "Bet 500 coins in a single race", isUnlocked: false, iconName: "dollarsign", reward: 300),
                Achievement(id: 2, title: "Lucky Streak", description: "Win 3 races in a row", isUnlocked: false, iconName: "star", reward: 500),
                Achievement(id: 3, title: "Story Collector", description: "Unlock 5 race stories", isUnlocked: false, iconName: "book", reward: 400)
            ]
            
            for defaultAchievement in defaultAchievements {
                let isUnlocked = achievementsData.first(where: { $0["id"] as? Int == defaultAchievement.id })?["isUnlocked"] as? Bool ?? false
                loadedAchievements.append(Achievement(id: defaultAchievement.id, title: defaultAchievement.title, description: defaultAchievement.description, isUnlocked: isUnlocked, iconName: defaultAchievement.iconName, reward: defaultAchievement.reward))
            }
            achievements = loadedAchievements
        }
        
        // Load chests data
        if let chestsData = userDefaults.dictionary(forKey: chestsKey) as? [String: [String: Any]] {
            for chestType in ChestType.allCases {
                let key = String(describing: chestType)
                if let chestInfo = chestsData[key],
                   let timestamp = chestInfo["lastOpened"] as? TimeInterval,
                   timestamp > 0 {
                    chests[chestType] = Chest(type: chestType, lastOpened: Date(timeIntervalSince1970: timestamp))
                } else {
                    chests[chestType] = Chest(type: chestType, lastOpened: nil)
                }
            }
        } else {
            // Initialize chests if no saved data
            for chestType in ChestType.allCases {
                chests[chestType] = Chest(type: chestType, lastOpened: nil)
            }
        }
    }
}

// MARK: - Achievement Events
enum AchievementEvent {
    case firstWin
    case highBet(amount: Int)
    case winStreak(count: Int)
    case storyUnlock(count: Int)
}