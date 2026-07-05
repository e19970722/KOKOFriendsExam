//
//  SingleSegmentView.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import UIKit

final class PillView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

class SingleSegmentView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var flagLabelSV: UIStackView!
    @IBOutlet weak var flagBgView: UIView!
    @IBOutlet weak var underlineView: UIView!
    
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
    
    convenience init(isSelected: Bool, title: String, flagNumber: Int) {
        self.init(frame: .zero)
        updateUI(isSelected: isSelected, title: title, flagNumber: flagNumber)
    }

    private func loadFromNib() {
        let nib = UINib(nibName: "SingleSegmentView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        self.contentView = view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func setupUI() {
        self.flagBgView.clipsToBounds = true
        self.flagBgView.widthAnchor.constraint(
            greaterThanOrEqualTo: self.flagBgView.heightAnchor
        ).isActive = true
        self.underlineView.layer.cornerRadius = 2
        self.underlineView.clipsToBounds = true
    }

    func updateUI(isSelected: Bool, title: String? = nil, flagNumber: Int? = nil) {
        DispatchQueue.main.async {
            if let title = title {
                self.titleLabel.text = title
            }
            self.titleLabel.font = .systemFont(ofSize: 13, weight: isSelected ? .medium : .regular)
            self.underlineView.alpha = isSelected ? 1 : 0
            
            if let flagNumber = flagNumber {
                self.flagLabel.text = (flagNumber > 99) ? "99+" : "\(flagNumber)"
            }
            let currentFlagText = self.flagLabel.text ?? "0"
            self.flagBgView.backgroundColor = currentFlagText != "0" ? isSelected ? .hotPink: .veryLightPink : .clear
            self.flagLabelSV.isHidden = currentFlagText == "0"
        }
    }
}
