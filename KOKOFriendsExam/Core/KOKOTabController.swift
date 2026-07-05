//
//  KOKOTabController.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import UIKit

class KOKOTabController: UITabBarController {

    private lazy var centerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(original(.icTabbarHomeOff), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onCenterButtonTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupTabs()
        setupCenterButton()
        selectedIndex = 1
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { context in
            UIColor.veryLightPink2.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.warmGrey]
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.hotPink]
        itemAppearance.normal.iconColor = .warmGrey
        itemAppearance.selected.iconColor = .hotPink
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    private func setupCenterButton() {
        view.addSubview(centerButton)
        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            centerButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -13),
        ])
    }

    @objc private func onCenterButtonTap() {
        selectedIndex = 2
    }
    
    private func original(_ resource: ImageResource) -> UIImage {
        UIImage(resource: resource).withRenderingMode(.alwaysOriginal)
    }

    private func setupTabs() {
        let moneyVC = MoneyViewController()
        moneyVC.tabBarItem = UITabBarItem(title: "錢錢", image: original(.icTabbarProductsOff), selectedImage: original(.icTabbarProductsOff))

        let friendNavVC = FriendNavigationController()
        friendNavVC.tabBarItem = UITabBarItem(title: "朋友", image: original(.icTabbarFriendsOn), selectedImage: original(.icTabbarFriendsOn))

        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "", image: nil, selectedImage: nil)

        let recordVC = RecordViewController()
        recordVC.tabBarItem = UITabBarItem(title: "記帳", image: original(.icTabbarManageOff), selectedImage: original(.icTabbarManageOff))

        let settingVC = SettingViewController()
        settingVC.tabBarItem = UITabBarItem(title: "設定", image: original(.icTabbarSettingOff), selectedImage: original(.icTabbarSettingOff))

        viewControllers = [moneyVC, friendNavVC, mainVC, recordVC, settingVC]
    }

}
