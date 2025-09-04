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
    private var currentLossStreak: Int = 0
    private var highestBet: Int = 0
    private var totalBetsAmount: Int = 0
    private var chestsOpenedCount: Int = 0
    private var lastPlayDate: Date?
    private var consecutiveDays: Int = 0
    
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
    private let lossStreakKey = "loss_streak"
    private let totalBetsKey = "total_bets"
    private let chestsCountKey = "chests_count"
    private let lastPlayKey = "last_play_date"
    private let consecutiveDaysKey = "consecutive_days"
    
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
                // Basic achievements
                Achievement(id: 0, title: "First Win", description: "Win your first race", isUnlocked: false, iconName: "trophy", reward: 200),
                Achievement(id: 1, title: "High Roller", description: "Bet 500 coins in a single race", isUnlocked: false, iconName: "dollarsign", reward: 300),
                Achievement(id: 2, title: "Lucky Streak", description: "Win 3 races in a row", isUnlocked: false, iconName: "star", reward: 500),
                Achievement(id: 3, title: "Story Collector", description: "Unlock 5 race stories", isUnlocked: false, iconName: "book", reward: 400),
                
                // Win achievements
                Achievement(id: 4, title: "Champion", description: "Win 10 races", isUnlocked: false, iconName: "trophy", reward: 600),
                Achievement(id: 5, title: "Legend", description: "Win 25 races", isUnlocked: false, iconName: "trophy", reward: 1000),
                Achievement(id: 6, title: "Perfect Week", description: "Win 7 races in a row", isUnlocked: false, iconName: "star", reward: 800),
                
                // Betting achievements  
                Achievement(id: 7, title: "Penny Pincher", description: "Win with a 10 coin bet", isUnlocked: false, iconName: "dollarsign", reward: 150),
                Achievement(id: 8, title: "All In", description: "Win with maximum bet", isUnlocked: false, iconName: "dollarsign", reward: 500),
                Achievement(id: 9, title: "Risk Taker", description: "Total bets over 5000 coins", isUnlocked: false, iconName: "dollarsign", reward: 700),
                
                // Collection achievements
                Achievement(id: 10, title: "Historian", description: "Unlock 10 race stories", isUnlocked: false, iconName: "book", reward: 800),
                Achievement(id: 11, title: "Librarian", description: "Unlock all race stories", isUnlocked: false, iconName: "book", reward: 1500),
                Achievement(id: 12, title: "Chest Hunter", description: "Open 20 chests", isUnlocked: false, iconName: "box", reward: 600),
                
                // Special achievements
                Achievement(id: 13, title: "Comeback Kid", description: "Win after 3 losses in a row", isUnlocked: false, iconName: "bolt", reward: 400),
                Achievement(id: 14, title: "Money Bags", description: "Have 10,000 coins at once", isUnlocked: false, iconName: "dollarsign", reward: 1000),
                Achievement(id: 15, title: "Dedicated Racer", description: "Play for 7 days in a row", isUnlocked: false, iconName: "calendar", reward: 700)
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
        // Track total bets
        totalBetsAmount += betAmount
        checkAndUnlockAchievements(for: .totalBets(amount: totalBetsAmount))
        
        // Track highest bet
        if betAmount > highestBet {
            highestBet = betAmount
            checkAndUnlockAchievements(for: .highBet(amount: betAmount))
        }
        
        // Check daily play
        checkDailyPlay()
        
        let winner = drivers.randomElement()!
        let winnings = winner.id == betDriver.id ? Int(Double(betAmount) * 6.7) : 0
        
        if winnings > 0 {
            addCoins(winnings)
            totalWins += 1
            currentWinStreak += 1
            
            // Check for comeback win
            if currentLossStreak >= 3 {
                checkAndUnlockAchievements(for: .comebackWin)
            }
            currentLossStreak = 0
            
            // Check win achievements
            if totalWins == 1 {
                checkAndUnlockAchievements(for: .firstWin)
            }
            checkAndUnlockAchievements(for: .totalWins(count: totalWins))
            
            if currentWinStreak >= 3 {
                checkAndUnlockAchievements(for: .winStreak(count: currentWinStreak))
            }
            
            // Check bet-specific wins
            if betAmount <= 10 {
                checkAndUnlockAchievements(for: .lowBetWin(amount: betAmount))
            }
            if betAmount >= 500 {
                checkAndUnlockAchievements(for: .maxBetWin)
            }
        } else {
            currentWinStreak = 0
            currentLossStreak += 1
            checkAndUnlockAchievements(for: .lossStreak(count: currentLossStreak))
        }
        
        // Check money achievement
        checkAndUnlockAchievements(for: .richPlayer(amount: coins))
        
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
        chestsOpenedCount += 1
        checkAndUnlockAchievements(for: .chestsOpened(count: chestsOpenedCount))
        
        saveGameData()
        
        return reward
    }
    
    // MARK: - Daily Play Tracking
    private func checkDailyPlay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastPlay = lastPlayDate {
            let lastPlayDay = calendar.startOfDay(for: lastPlay)
            let daysDiff = calendar.dateComponents([.day], from: lastPlayDay, to: today).day ?? 0
            
            if daysDiff == 1 {
                consecutiveDays += 1
                checkAndUnlockAchievements(for: .dailyPlayer(days: consecutiveDays))
            } else if daysDiff > 1 {
                consecutiveDays = 1
            }
        } else {
            consecutiveDays = 1
        }
        
        lastPlayDate = Date()
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
            case .storyUnlock(let count):
                if (achievement.id == 3 && count >= 5) ||
                   (achievement.id == 10 && count >= 10) ||
                   (achievement.id == 11 && count >= 18) {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .winStreak(let count):
                if (achievement.id == 2 && count >= 3) ||
                   (achievement.id == 6 && count >= 7) {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .totalWins(let count):
                if (achievement.id == 4 && count >= 10) ||
                   (achievement.id == 5 && count >= 25) {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .lowBetWin(let amount):
                if achievement.id == 7 && amount <= 10 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .maxBetWin:
                if achievement.id == 8 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .totalBets(let amount):
                if achievement.id == 9 && amount >= 5000 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .chestsOpened(let count):
                if achievement.id == 12 && count >= 20 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .comebackWin:
                if achievement.id == 13 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .richPlayer(let amount):
                if achievement.id == 14 && amount >= 10000 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .dailyPlayer(let days):
                if achievement.id == 15 && days >= 7 {
                    achievements[index] = Achievement(id: achievement.id, title: achievement.title, description: achievement.description, isUnlocked: true, iconName: achievement.iconName, reward: achievement.reward)
                    addCoins(achievement.reward)
                    unlocked = true
                }
            case .lossStreak:
                // No achievement for loss streaks currently
                break
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
        userDefaults.set(currentLossStreak, forKey: lossStreakKey)
        userDefaults.set(totalBetsAmount, forKey: totalBetsKey)
        userDefaults.set(chestsOpenedCount, forKey: chestsCountKey)
        userDefaults.set(consecutiveDays, forKey: consecutiveDaysKey)
        if let lastPlayDate = lastPlayDate {
            userDefaults.set(lastPlayDate, forKey: lastPlayKey)
        }
        
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
        currentLossStreak = userDefaults.integer(forKey: lossStreakKey)
        totalBetsAmount = userDefaults.integer(forKey: totalBetsKey)
        chestsOpenedCount = userDefaults.integer(forKey: chestsCountKey)
        consecutiveDays = userDefaults.integer(forKey: consecutiveDaysKey)
        lastPlayDate = userDefaults.object(forKey: lastPlayKey) as? Date
        
        let storiesArray = userDefaults.array(forKey: unlockedStoriesKey) as? [Int] ?? [0]
        unlockedStories = Set(storiesArray)
        
        // Load achievements data
        if let achievementsData = userDefaults.array(forKey: achievementsKey) as? [[String: Any]] {
            var loadedAchievements: [Achievement] = []
            let defaultAchievements = [
                // Basic achievements
                Achievement(id: 0, title: "First Win", description: "Win your first race", isUnlocked: false, iconName: "trophy", reward: 200),
                Achievement(id: 1, title: "High Roller", description: "Bet 500 coins in a single race", isUnlocked: false, iconName: "dollarsign", reward: 300),
                Achievement(id: 2, title: "Lucky Streak", description: "Win 3 races in a row", isUnlocked: false, iconName: "star", reward: 500),
                Achievement(id: 3, title: "Story Collector", description: "Unlock 5 race stories", isUnlocked: false, iconName: "book", reward: 400),
                
                // Win achievements
                Achievement(id: 4, title: "Champion", description: "Win 10 races", isUnlocked: false, iconName: "trophy", reward: 600),
                Achievement(id: 5, title: "Legend", description: "Win 25 races", isUnlocked: false, iconName: "trophy", reward: 1000),
                Achievement(id: 6, title: "Perfect Week", description: "Win 7 races in a row", isUnlocked: false, iconName: "star", reward: 800),
                
                // Betting achievements  
                Achievement(id: 7, title: "Penny Pincher", description: "Win with a 10 coin bet", isUnlocked: false, iconName: "dollarsign", reward: 150),
                Achievement(id: 8, title: "All In", description: "Win with maximum bet", isUnlocked: false, iconName: "dollarsign", reward: 500),
                Achievement(id: 9, title: "Risk Taker", description: "Total bets over 5000 coins", isUnlocked: false, iconName: "dollarsign", reward: 700),
                
                // Collection achievements
                Achievement(id: 10, title: "Historian", description: "Unlock 10 race stories", isUnlocked: false, iconName: "book", reward: 800),
                Achievement(id: 11, title: "Librarian", description: "Unlock all race stories", isUnlocked: false, iconName: "book", reward: 1500),
                Achievement(id: 12, title: "Chest Hunter", description: "Open 20 chests", isUnlocked: false, iconName: "box", reward: 600),
                
                // Special achievements
                Achievement(id: 13, title: "Comeback Kid", description: "Win after 3 losses in a row", isUnlocked: false, iconName: "bolt", reward: 400),
                Achievement(id: 14, title: "Money Bags", description: "Have 10,000 coins at once", isUnlocked: false, iconName: "dollarsign", reward: 1000),
                Achievement(id: 15, title: "Dedicated Racer", description: "Play for 7 days in a row", isUnlocked: false, iconName: "calendar", reward: 700)
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
    case totalWins(count: Int)
    case lowBetWin(amount: Int)
    case maxBetWin
    case totalBets(amount: Int)
    case chestsOpened(count: Int)
    case comebackWin
    case richPlayer(amount: Int)
    case dailyPlayer(days: Int)
    case lossStreak(count: Int)
}