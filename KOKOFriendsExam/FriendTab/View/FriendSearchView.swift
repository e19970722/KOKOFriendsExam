//
//  FriendSearchView.swift
//  KOKOFriends
//
//  Created by Yen Lin on 2026/7/5.
//

import UIKit
import Combine

class FriendSearchView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchBackgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    var cancellables = Set<AnyCancellable>()
    
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
        let nib = UINib(nibName: "FriendSearchView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.backgroundColor = .clear
        self.contentView = view
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupUI() {
        self.searchBackgroundView.layer.cornerRadius = 10
        self.searchBackgroundView.clipsToBounds = true
    }

}
