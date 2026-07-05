//
//  FriendMainInfoView.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2026/7/5.
//

import UIKit
import Combine

class FriendMainInfoView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var imageView: UIImageView!
        
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
        let nib = UINib(nibName: "FriendMainInfoView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.backgroundColor = .clear
        self.contentView = view
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupUI() {
        self.statusView.layer.cornerRadius = self.statusView.frame.size.height / 2
        self.statusView.clipsToBounds = true
    }
    
    func updateUI(name: String, id: String) {
        DispatchQueue.main.async {
            self.nameLabel.text = name
            self.idLabel.text = "KOKO ID: \(id)"
        }
    }
}
