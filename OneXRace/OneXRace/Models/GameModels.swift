import Foundation

// MARK: - Driver Model
struct Driver {
    let id: Int
    let name: String
    let country: String
    let odds: Double
    let avatar: String
    let carColor: String
}

// MARK: - Race Model
struct Race {
    let id: UUID
    let drivers: [Driver]
    let betAmount: Int
    let selectedDriver: Driver?
    let isFinished: Bool
    let winner: Driver?
    
    init(drivers: [Driver], betAmount: Int = 0) {
        self.id = UUID()
        self.drivers = drivers
        self.betAmount = betAmount
        self.selectedDriver = nil
        self.isFinished = false
        self.winner = nil
    }
}

// MARK: - Story Model
struct RaceStory {
    let id: Int
    let title: String
    let content: String
    let isFree: Bool
    let price: Int
    let imageUrl: String
}

// MARK: - Achievement Model
struct Achievement {
    let id: Int
    let title: String
    let description: String
    let isUnlocked: Bool
    let iconName: String
    let reward: Int
}

// MARK: - Chest Model
enum ChestType: CaseIterable {
    case daily, weekly, monthly
    
    var title: String {
        switch self {
        case .daily: return "Daily Chest"
        case .weekly: return "Weekly Chest"
        case .monthly: return "Monthly Chest"
        }
    }
    
    var interval: TimeInterval {
        switch self {
        case .daily: return 24 * 60 * 60
        case .weekly: return 3 * 24 * 60 * 60
        case .monthly: return 7 * 24 * 60 * 60
        }
    }
    
    var reward: Int {
        switch self {
        case .daily: return 100
        case .weekly: return 300
        case .monthly: return 1000
        }
    }
}

struct Chest {
    let type: ChestType
    let lastOpened: Date?
    
    var isAvailable: Bool {
        guard let lastOpened = lastOpened else { return true }
        return Date().timeIntervalSince(lastOpened) >= type.interval
    }
    
    var nextAvailable: Date {
        guard let lastOpened = lastOpened else { return Date() }
        return lastOpened.addingTimeInterval(type.interval)
    }
}