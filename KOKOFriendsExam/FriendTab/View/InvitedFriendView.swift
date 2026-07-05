//
//  InvitedFriendView.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2026/7/5.
//

import UIKit
import SwiftUI

class InvitedFriendView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
        setupUI()
    }

    private func loadFromNib() {
        let nib = UINib(nibName: "InvitedFriendView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.backgroundColor = .clear
        self.contentView = view
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupUI() {
        self.cardView.backgroundColor = .white
        self.cardView.layer.cornerRadius = 6
        self.cardView.layer.shadowColor = UIColor.black.cgColor
        self.cardView.layer.shadowOpacity = 0.1
        self.cardView.layer.shadowRadius = 16
        self.cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.cardView.layer.masksToBounds = false

        self.contentView.backgroundColor = .clear
        self.contentView.layer.masksToBounds = false
    }
    
    func updateUI(name: String, image: UIImage? = nil) {
        DispatchQueue.main.async {
            self.nameLabel.text = name
            if let image = image {
                self.imageView.image = image
            }
        }
    }
}
