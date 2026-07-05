//
//  FriendNavigationController.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import UIKit

class FriendNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        viewControllers = [
            FriendViewController()
        ]
        view.backgroundColor = .whiteTwo

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .whiteTwo
        appearance.shadowColor = .clear
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
