//
//  TabBarController.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/1/23.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        self.delegate = self
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .black
        self.tabBar.tintColor = .white
        
    }
    
    func setupViewControllers() {
        
        let hvc = MarvelHeroViewController()
        hvc.tabBarItem = UITabBarItem(title: "Heroes", image: UIImage(named:
                                                                        "figure.run.circle.fill"), selectedImage: UIImage(named: "figure.run.circle.fill"))
        hvc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21)], for: .normal)
        hvc.tabBarItem.badgeColor = .white
        let heroNavigation = UINavigationController(rootViewController: hvc)
        
        let comicVc = MarvelComicViewController()
        comicVc.tabBarItem = UITabBarItem(title: "Comics", image: UIImage(named: "book.circle.fill"), selectedImage: UIImage(named: "book.circle.fill"))
        comicVc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21)], for: .normal)
        let comicsNavigation = UINavigationController(rootViewController: comicVc)
        
        let creatorVc = CreatorViewController()
        creatorVc.tabBarItem = UITabBarItem(title: "Creators", image: UIImage(named: "brain.head.profile"), selectedImage: UIImage(named: "brain.head.profile"))
        creatorVc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21)], for: .normal)
        let creatorNavigation = UINavigationController(rootViewController: creatorVc)
        
        viewControllers = [heroNavigation, comicsNavigation, creatorNavigation]
        
    }
    
}
