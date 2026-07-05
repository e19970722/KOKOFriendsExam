//
//  NoFriendTableViewCell.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/6.
//

import UIKit

class NoFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var setIDBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            self?.applyAddBtnGradient()
        }
    }
    
    private func setupUI() {
        self.addFriendBtn.layer.cornerRadius = 20
        self.addFriendBtn.layer.masksToBounds = false
        self.addFriendBtn.layer.shadowRadius = 8
        self.addFriendBtn.layer.shadowOpacity = 1
        self.addFriendBtn.layer.shadowColor = UIColor.appleGreen40.cgColor
        self.addFriendBtn.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        let setIDBtnAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.hotPink,
            .font: UIFont.systemFont(ofSize: 13)
        ]
        
        let setIDBtnAttributedTitle = NSAttributedString(string: "設定 KOKO ID", attributes: setIDBtnAttributes)
        setIDBtn.setAttributedTitle(setIDBtnAttributedTitle, for: .normal)
    }
    
    private func applyAddBtnGradient() {
        self.addFriendBtn.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.addFriendBtn.bounds
        gradientLayer.colors = [
            UIColor.frogGreen.cgColor,
            UIColor.b.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = self.addFriendBtn.layer.cornerRadius

        self.addFriendBtn.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}
