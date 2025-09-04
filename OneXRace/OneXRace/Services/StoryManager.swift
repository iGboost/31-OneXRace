import Foundation

// MARK: - Enhanced Story Model
struct RacingLegend {
    let id: Int
    let title: String
    let subtitle: String
    let content: String
    let extendedContent: String
    let year: String
    let location: String
    let driver: String
    let team: String
    let achievement: String
    let funFact: String
    let isFree: Bool
    let price: Int
    let rarity: StoryRarity
    let category: StoryCategory
    let imageUrl: String
    let tags: [String]
}

enum StoryRarity: String, CaseIterable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: String {
        switch self {
        case .common: return "systemGray"
        case .rare: return "systemBlue"
        case .epic: return "primaryPurple"
        case .legendary: return "accentGold"
        }
    }
    
    var priceMultiplier: Double {
        switch self {
        case .common: return 1.0
        case .rare: return 1.5
        case .epic: return 2.0
        case .legendary: return 3.0
        }
    }
}

enum StoryCategory: String, CaseIterable {
    case championship = "Championship"
    case rivalry = "Rivalry"
    case record = "Record"
    case tragedy = "Tragedy"
    case comeback = "Comeback"
    case innovation = "Innovation"
    
    var emoji: String {
        switch self {
        case .championship: return "🏆"
        case .rivalry: return "⚔️"
        case .record: return "📊"
        case .tragedy: return "💔"
        case .comeback: return "🔥"
        case .innovation: return "⚡"
        }
    }
}

class StoryManager: ObservableObject {
    static let shared = StoryManager()
    
    @Published var allStories: [RacingLegend] = []
    
    private init() {
        setupStories()
    }
    
    private func setupStories() {
        allStories = [
            // Free story
            RacingLegend(
                id: 0,
                title: "The Legend Begins",
                subtitle: "Birth of Formula 1",
                content: "In 1950, the first Formula 1 World Championship began at Silverstone Circuit in England.",
                extendedContent: "On May 13, 1950, history was made at Silverstone Circuit. Giuseppe Farina, driving for Alfa Romeo, became the first-ever Formula 1 World Champion. The race was attended by King George VI and Queen Elizabeth, marking the beginning of motorsport's most prestigious championship. The grid featured legendary names like Juan Manuel Fangio and Nino Farina, setting the stage for decades of racing excellence.",
                year: "1950",
                location: "Silverstone, England",
                driver: "Giuseppe Farina",
                team: "Alfa Romeo",
                achievement: "First F1 World Champion",
                funFact: "The race was attended by royalty and established the foundation of modern motorsport",
                isFree: true,
                price: 0,
                rarity: .common,
                category: .championship,
                imageUrl: "🏁",
                tags: ["Historic", "Championship", "Alfa Romeo"]
            ),
            
            // Rare Stories
            RacingLegend(
                id: 1,
                title: "Monaco Magic",
                subtitle: "The Jewel of F1",
                content: "Monaco Grand Prix is the most prestigious race in Formula 1 calendar.",
                extendedContent: "The Monaco Grand Prix transforms the streets of Monte Carlo into the most glamorous racing circuit in the world. Since 1929, drivers have navigated the narrow 3.337km circuit with its famous Casino Corner, Tunnel, and Swimming Pool sections. The race demands absolute precision - there's no room for error. Ayrton Senna holds the record with six victories, earning him the title 'King of Monaco'. The race is part of motorsport's Triple Crown alongside Indianapolis 500 and 24 Hours of Le Mans.",
                year: "1929-Present",
                location: "Monte Carlo, Monaco",
                driver: "Ayrton Senna",
                team: "Multiple",
                achievement: "6 Monaco GP Wins (Record)",
                funFact: "The slowest circuit on the F1 calendar but the most prestigious victory",
                isFree: false,
                price: 500,
                rarity: .rare,
                category: .championship,
                imageUrl: "🏰",
                tags: ["Prestige", "Street Circuit", "Monaco"]
            ),
            
            RacingLegend(
                id: 2,
                title: "Senna vs Prost",
                subtitle: "The Greatest Rivalry",
                content: "The legendary rivalry between two racing giants that defined an era.",
                extendedContent: "The rivalry between Ayrton Senna and Alain Prost transcended sports. As McLaren teammates from 1988-1989, they won 30 out of 32 races but their relationship deteriorated into one of F1's most intense feuds. Their contrasting styles - Senna's raw emotion and aggressive driving versus Prost's calculated precision - created legendary moments. The 1989 Japanese GP collision and 1990 championship-deciding crash at Suzuka remain controversial. Despite their rivalry, both respected each other's incredible talent.",
                year: "1988-1993",
                location: "Worldwide",
                driver: "Senna & Prost",
                team: "McLaren/Ferrari",
                achievement: "Combined 7 World Championships",
                funFact: "They won 30 out of 32 races as teammates in 1988",
                isFree: false,
                price: 750,
                rarity: .epic,
                category: .rivalry,
                imageUrl: "⚔️",
                tags: ["Rivalry", "McLaren", "Championship"]
            ),
            
            RacingLegend(
                id: 3,
                title: "Rain Master",
                subtitle: "Senna's Wet Weather Genius",
                content: "Ayrton Senna's legendary mastery of racing in wet conditions.",
                extendedContent: "Ayrton Senna possessed an almost supernatural ability to drive in wet weather conditions. His most famous wet-weather performance came at the 1984 Monaco Grand Prix, where he started 13th in a Toleman and carved through the field in torrential rain. He caught race leader Alain Prost and would have won if the race hadn't been stopped. His 1985 Portuguese GP victory and 1993 European GP at Donington Park are considered masterclasses in wet-weather driving. Senna claimed he felt a spiritual connection when driving in the rain.",
                year: "1984-1994",
                location: "Various Circuits",
                driver: "Ayrton Senna",
                team: "Toleman/McLaren",
                achievement: "Master of Wet Weather Racing",
                funFact: "Gained 4 positions on the first lap at Donington in the wet",
                isFree: false,
                price: 600,
                rarity: .rare,
                category: .record,
                imageUrl: "🌧️",
                tags: ["Senna", "Wet Weather", "Skill"]
            ),
            
            // Epic Stories
            RacingLegend(
                id: 4,
                title: "The Comeback King",
                subtitle: "Niki Lauda's Miracle Return",
                content: "After a horrific crash and near-death experience, Niki Lauda returned to racing.",
                extendedContent: "On August 1, 1976, at the Nürburgring, Niki Lauda's Ferrari crashed and burst into flames. Trapped in the burning car, he suffered severe burns and inhaled toxic gases. Doctors gave him last rites. Remarkably, just 42 days later, he returned to racing at Monza, his face still bandaged. He lost the 1976 championship by just one point to James Hunt but came back to win again in 1977 and 1984. His courage and determination redefined what was possible in motorsport.",
                year: "1976-1977",
                location: "Nürburgring, Germany",
                driver: "Niki Lauda",
                team: "Ferrari",
                achievement: "Survived Near-Fatal Crash, Won 3 Championships",
                funFact: "Returned to racing just 42 days after receiving last rites",
                isFree: false,
                price: 900,
                rarity: .epic,
                category: .comeback,
                imageUrl: "🔥",
                tags: ["Courage", "Ferrari", "Comeback"]
            ),
            
            RacingLegend(
                id: 5,
                title: "Speed of Sound",
                subtitle: "Breaking Barriers",
                content: "The quest for ultimate speed in Formula 1 racing.",
                extendedContent: "Formula 1 has always pushed the boundaries of speed. The fastest recorded speed belongs to Valtteri Bottas at 372.6 km/h during the 2016 Mexican Grand Prix. However, speed records tell only part of the story. The 2004 Italian GP saw cars regularly exceed 360 km/h on Monza's straights. Juan Pablo Montoya holds the official race speed record at 372.6 km/h. Modern F1 cars could theoretically go much faster, but safety regulations and circuit designs prioritize driver welfare over pure speed.",
                year: "2004-2016",
                location: "Monza, Mexico",
                driver: "Valtteri Bottas",
                team: "Williams/Mercedes",
                achievement: "372.6 km/h Top Speed Record",
                funFact: "Modern F1 cars could exceed 400 km/h without regulations",
                isFree: false,
                price: 450,
                rarity: .rare,
                category: .record,
                imageUrl: "⚡",
                tags: ["Speed", "Record", "Technology"]
            ),
            
            RacingLegend(
                id: 6,
                title: "The Perfect Lap",
                subtitle: "Jim Clark's Mastery",
                content: "Jim Clark's incredible dominance and the pursuit of perfection.",
                extendedContent: "Jim Clark was considered by many as the greatest natural talent in F1 history. His 1963 season was virtually flawless - winning 7 out of 10 races and clinching the championship with races to spare. At the 1965 Indianapolis 500, he became the first foreign winner since 1916. Clark's smooth, effortless driving style made impossible moves look routine. Tragically, his career was cut short in a Formula 2 accident at Hockenheim in 1968. Jackie Stewart called him 'the best racing driver that ever lived.'",
                year: "1960-1968",
                location: "Worldwide",
                driver: "Jim Clark",
                team: "Lotus",
                achievement: "25 GP Wins, 2 Championships, Indy 500 Winner",
                funFact: "Won Indianapolis 500 and F1 Championship in the same year (1965)",
                isFree: false,
                price: 800,
                rarity: .epic,
                category: .championship,
                imageUrl: "👑",
                tags: ["Perfection", "Lotus", "Natural Talent"]
            ),
            
            // Legendary Stories
            RacingLegend(
                id: 7,
                title: "Rush",
                subtitle: "Hunt vs Lauda 1976",
                content: "The most dramatic championship fight in F1 history.",
                extendedContent: "The 1976 season epitomized everything dramatic about Formula 1. James Hunt, the charismatic British playboy, battled Niki Lauda, the methodical Austrian perfectionist. After Lauda's horrific Nürburgring crash, Hunt closed the championship gap. The season climaxed at a rain-soaked Japanese GP where Lauda withdrew due to safety concerns while Hunt drove through the storm to claim his only championship. Their story became the Hollywood film 'Rush,' cementing their legendary status in motorsport folklore.",
                year: "1976",
                location: "Worldwide",
                driver: "James Hunt & Niki Lauda",
                team: "McLaren & Ferrari",
                achievement: "Most Dramatic Championship Battle",
                funFact: "Hunt won the championship by just 1 point after Lauda's withdrawal",
                isFree: false,
                price: 1200,
                rarity: .legendary,
                category: .rivalry,
                imageUrl: "🎭",
                tags: ["Drama", "Championship", "1976"]
            ),
            
            RacingLegend(
                id: 8,
                title: "The Black Weekend",
                subtitle: "Imola 1994 Tragedy",
                content: "The darkest weekend in Formula 1 history that changed everything.",
                extendedContent: "The 1994 San Marino Grand Prix at Imola was Formula 1's darkest weekend. Roland Ratzenberger died in qualifying, followed by Ayrton Senna's fatal crash during the race. Senna, leading the race, crashed at Tamburello corner on lap 7. His death shocked the world and led to massive safety reforms. Professor Sid Watkins, F1's safety chief, worked tirelessly to ensure such tragedies would never happen again. Senna's death marked the end of F1's most dangerous era and the beginning of modern safety standards.",
                year: "1994",
                location: "Imola, Italy",
                driver: "Ayrton Senna",
                team: "Williams",
                achievement: "Catalyst for Modern F1 Safety",
                funFact: "Led to the creation of the FIA Institute and modern safety protocols",
                isFree: false,
                price: 1500,
                rarity: .legendary,
                category: .tragedy,
                imageUrl: "🕊️",
                tags: ["Safety", "Tragedy", "Change"]
            ),
            
            RacingLegend(
                id: 9,
                title: "The Professor",
                subtitle: "Alain Prost's Calculated Genius",
                content: "The strategic mastermind who revolutionized racing intelligence.",
                extendedContent: "Alain Prost earned the nickname 'The Professor' for his analytical approach to racing. Unlike the raw speed merchants, Prost won through strategy, tire management, and racecraft. His four world championships came through consistency rather than spectacular drives. Prost pioneered the concept of winning at the slowest possible speed, conserving his car while others retired. His technical feedback helped develop some of the greatest F1 cars ever built. He remains the benchmark for intelligent, calculated racing.",
                year: "1980-1993",
                location: "Worldwide",
                driver: "Alain Prost",
                team: "McLaren/Ferrari",
                achievement: "4 World Championships, 51 Race Wins",
                funFact: "Won championships with the minimum effort required",
                isFree: false,
                price: 700,
                rarity: .epic,
                category: .championship,
                imageUrl: "🧠",
                tags: ["Strategy", "Intelligence", "Championships"]
            ),
            
            RacingLegend(
                id: 10,
                title: "Ground Effect Revolution",
                subtitle: "The Lotus Innovation",
                content: "How Lotus revolutionized aerodynamics and changed racing forever.",
                extendedContent: "In 1977, Lotus introduced ground effect technology with the Type 78 'Wing Car.' Designer Colin Chapman discovered that shaping the car's floor could create massive downforce, essentially sucking the car to the track. The following year's Type 79 dominated completely. Mario Andretti won the 1978 championship, with Lotus taking the constructors' title. Other teams scrambled to copy the technology, leading to an aerodynamic arms race. Ground effects were eventually banned due to safety concerns, but their influence on modern F1 aerodynamics remains profound.",
                year: "1977-1982",
                location: "Worldwide",
                driver: "Mario Andretti",
                team: "Lotus",
                achievement: "Revolutionary Aerodynamic Design",
                funFact: "Increased downforce by 300% without additional drag",
                isFree: false,
                price: 650,
                rarity: .epic,
                category: .innovation,
                imageUrl: "🔬",
                tags: ["Innovation", "Aerodynamics", "Lotus"]
            ),
            
            RacingLegend(
                id: 11,
                title: "The Flying Finn",
                subtitle: "Mika Häkkinen's Precision",
                content: "Finland's ice-cool champion who battled Michael Schumacher.",
                extendedContent: "Mika Häkkinen represented the new generation of F1 drivers - technically superior and mentally unbreakable. His rivalry with Michael Schumacher from 1998-2000 produced some of F1's greatest racing. Häkkinen's back-to-back championships for McLaren showcased his ability to perform under intense pressure. His spa 2000 overtake on Schumacher at 300+ km/h remains one of F1's greatest moves. Known for his Finnish stoicism and devastating one-lap pace, Häkkinen proved that raw speed combined with mental strength could overcome any challenge.",
                year: "1998-2001",
                location: "Worldwide",
                driver: "Mika Häkkinen",
                team: "McLaren",
                achievement: "2 World Championships, Schumacher Rival",
                funFact: "Once overtook Schumacher around the outside at 300+ km/h",
                isFree: false,
                price: 850,
                rarity: .epic,
                category: .rivalry,
                imageUrl: "🇫🇮",
                tags: ["Finland", "Precision", "McLaren"]
            ),
            
            RacingLegend(
                id: 12,
                title: "Schumacher Era",
                subtitle: "The Red Baron's Dominance",
                content: "Michael Schumacher's unprecedented success that redefined excellence.",
                extendedContent: "Michael Schumacher didn't just win races - he revolutionized what it meant to be a Formula 1 driver. His seven world championships (2 with Benetton, 5 with Ferrari) established him as the most successful driver in F1 history. Schumacher's relentless work ethic, technical knowledge, and ability to extract performance from any car set new standards. His partnership with Ferrari from 2000-2004 created one of the most dominant periods in F1. Beyond statistics, Schumacher's influence on driver fitness, team integration, and professional approach transformed the sport forever.",
                year: "1991-2006",
                location: "Worldwide",
                driver: "Michael Schumacher",
                team: "Benetton/Ferrari",
                achievement: "7 World Championships, 91 Race Wins",
                funFact: "Won 5 consecutive championships with Ferrari (2000-2004)",
                isFree: false,
                price: 1000,
                rarity: .legendary,
                category: .championship,
                imageUrl: "👑",
                tags: ["Dominance", "Ferrari", "Records"]
            ),
            
            RacingLegend(
                id: 13,
                title: "Silver Arrows Return",
                subtitle: "Mercedes Modern Dominance",
                content: "How Mercedes returned to F1 and created a new dynasty.",
                extendedContent: "Mercedes' return to Formula 1 as a works team in 2010 initially struggled, but the 2014 hybrid era changed everything. With Lewis Hamilton and Nico Rosberg, Mercedes won 8 consecutive constructors' championships (2014-2021). Their W11 car won 13 out of 17 races in 2020. The Hamilton-Rosberg rivalry peaked in 2016, creating internal tension that ultimately led to Rosberg's retirement after winning his championship. Mercedes' technical excellence, combined with exceptional drivers, created the most successful period in their F1 history.",
                year: "2014-2021",
                location: "Worldwide",
                driver: "Lewis Hamilton",
                team: "Mercedes",
                achievement: "8 Consecutive Constructors' Championships",
                funFact: "Won 74% of all races during their dominant period",
                isFree: false,
                price: 550,
                rarity: .rare,
                category: .championship,
                imageUrl: "🏹",
                tags: ["Mercedes", "Hybrid Era", "Dominance"]
            ),
            
            RacingLegend(
                id: 14,
                title: "Brazil 2008",
                subtitle: "Hamilton's Miracle Championship",
                content: "The most dramatic final lap championship win in F1 history.",
                extendedContent: "The 2008 Brazilian Grand Prix delivered the most dramatic championship conclusion ever. Lewis Hamilton needed to finish 5th to win his first title, but Felipe Massa was leading his home race with championship hopes alive. As rain began falling in the final laps, Hamilton dropped to 6th - losing the championship. With just corners remaining, Sebastian Vettel's spin promoted Hamilton to 5th. The crowd went silent as Hamilton crossed the line to claim his first world championship by just one point. Massa's heartbreak and Hamilton's euphoria created an unforgettable moment.",
                year: "2008",
                location: "São Paulo, Brazil",
                driver: "Lewis Hamilton",
                team: "McLaren",
                achievement: "First World Championship in Final Corners",
                funFact: "Won the championship in the final corners of the final race",
                isFree: false,
                price: 950,
                rarity: .epic,
                category: .championship,
                imageUrl: "🏁",
                tags: ["Drama", "Championship", "Brazil"]
            ),
            
            RacingLegend(
                id: 15,
                title: "The Iceman Cometh",
                subtitle: "Kimi Räikkönen's Cool Victory",
                content: "The most laid-back champion in F1 history and his incredible 2007 season.",
                extendedContent: "Kimi Räikkönen's 2007 championship win was the stuff of legends. Joining Ferrari after McLaren's reliability issues, the Finnish 'Iceman' remained characteristically calm despite trailing by 17 points with 2 races remaining. His victories in Belgium and Japan, combined with McLaren's internal struggles, created one of F1's greatest comebacks. Known for his minimal communication and maximum speed, Räikkönen's championship celebration was typically understated: 'It's nice, but tomorrow is another day.' His pure driving talent and unique personality made him a fan favorite.",
                year: "2007",
                location: "Worldwide",
                driver: "Kimi Räikkönen",
                team: "Ferrari",
                achievement: "Comeback Championship from 17 Points Behind",
                funFact: "Famous for his minimal radio communications and maximum speed",
                isFree: false,
                price: 750,
                rarity: .epic,
                category: .comeback,
                imageUrl: "🧊",
                tags: ["Comeback", "Ferrari", "Finland"]
            ),
            
            RacingLegend(
                id: 16,
                title: "Turbocharged Era",
                subtitle: "The 1980s Power Revolution",
                content: "When F1 engines produced over 1400 horsepower in qualifying trim.",
                extendedContent: "The 1980s turbo era produced the most powerful F1 cars ever built. Qualifying engines generated over 1400 horsepower, with BMW's M12/13 engine reaching an estimated 1500+ hp. Drivers like Nelson Piquet, Alain Prost, and Niki Lauda mastered these brutal machines that could accelerate from 0-200 km/h in under 7 seconds. The era featured legendary cars like the McLaren MP4/2, Ferrari 156/85, and Williams FW11. However, the immense power made cars difficult to drive and extremely dangerous, leading to the eventual ban of turbocharged engines in 1988.",
                year: "1977-1988",
                location: "Worldwide",
                driver: "Nelson Piquet",
                team: "Brabham/BMW",
                achievement: "Most Powerful F1 Era - 1500+ HP",
                funFact: "Qualifying engines lasted only a few laps before requiring rebuilds",
                isFree: false,
                price: 1100,
                rarity: .legendary,
                category: .innovation,
                imageUrl: "💨",
                tags: ["Turbo", "Power", "1980s"]
            ),
            
            RacingLegend(
                id: 17,
                title: "Canada 2011",
                subtitle: "Jenson Button's Impossible Win",
                content: "The greatest comeback drive in wet weather F1 history.",
                extendedContent: "The 2011 Canadian Grand Prix became an instant classic. After multiple rain delays and chaos, Jenson Button found himself last after an early collision with teammate Lewis Hamilton. In treacherous conditions, Button systematically carved through the field, making brilliant tactical decisions and stunning overtakes. His final-lap pass on Sebastian Vettel for victory was pure artistry. The race lasted over 4 hours due to red flag delays. Button's drive from last to first in changing conditions is considered one of the greatest wet-weather performances ever witnessed.",
                year: "2011",
                location: "Montreal, Canada",
                driver: "Jenson Button",
                team: "McLaren",
                achievement: "Last to First Victory in Wet Conditions",
                funFact: "Made his winning pass on the final lap after 4+ hours of racing",
                isFree: false,
                price: 1300,
                rarity: .legendary,
                category: .comeback,
                imageUrl: "🌧️",
                tags: ["Comeback", "Wet Weather", "Canada"]
            )
        ]
    }
    
    func getStoryById(_ id: Int) -> RacingLegend? {
        return allStories.first { $0.id == id }
    }
    
    func getStoriesByCategory(_ category: StoryCategory) -> [RacingLegend] {
        return allStories.filter { $0.category == category }
    }
    
    func getStoriesByRarity(_ rarity: StoryRarity) -> [RacingLegend] {
        return allStories.filter { $0.rarity == rarity }
    }
}