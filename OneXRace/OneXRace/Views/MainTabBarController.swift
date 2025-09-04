import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .cardDark
        tabBar.tintColor = .accentGold
        tabBar.unselectedItemTintColor = .textSecondary
        tabBar.barStyle = .black
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.backgroundDark.cgColor, UIColor.cardDark.cgColor]
        gradientLayer.frame = tabBar.bounds
        tabBar.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupViewControllers() {
        let raceVC = RaceViewController()
        let raceNav = UINavigationController(rootViewController: raceVC)
        raceNav.tabBarItem = UITabBarItem(title: "Race", image: UIImage(systemName: "car.fill"), tag: 0)
        
        let storiesVC = StoriesViewController()
        let storiesNav = UINavigationController(rootViewController: storiesVC)
        storiesNav.tabBarItem = UITabBarItem(title: "Stories", image: UIImage(systemName: "book.fill"), tag: 1)
        
        let achievementsVC = AchievementsViewController()
        let achievementsNav = UINavigationController(rootViewController: achievementsVC)
        achievementsNav.tabBarItem = UITabBarItem(title: "Awards", image: UIImage(systemName: "trophy.fill"), tag: 2)
        
        let chestsVC = ChestsViewController()
        let chestsNav = UINavigationController(rootViewController: chestsVC)
        chestsNav.tabBarItem = UITabBarItem(title: "Chests", image: UIImage(systemName: "gift.fill"), tag: 3)
        
        viewControllers = [raceNav, storiesNav, achievementsNav, chestsNav]
        
        // Setup navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundDark
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}