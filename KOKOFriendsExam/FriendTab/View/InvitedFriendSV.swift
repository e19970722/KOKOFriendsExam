//
//  InvitedFriendSV.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/6.
//

import UIKit

class InvitedFriendSV: UIView {
    var onExpandChanged: ((Bool) -> Void)?

    private var isExpand: Bool = false

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 10
        return view
    }()

    private lazy var peekView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.masksToBounds = false
        return view
    }()

    private var peekConstraints: [NSLayoutConstraint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        clipsToBounds = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func updateUI(friends: [Friend]) {
        stackView.arrangedSubviews.forEach { [weak self] view in
            guard let self = self else { return }
            self.stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        var firstCardView: UIView?

        for (index, friend) in friends.enumerated() {
            if let name = friend.name {
                let view = InvitedFriendView()
                view.tag = index
                view.translatesAutoresizingMaskIntoConstraints = false
                view.updateUI(name: name)
                stackView.addArrangedSubview(view)
                NSLayoutConstraint.activate([
                    view.widthAnchor.constraint(equalTo: widthAnchor),
                    view.heightAnchor.constraint(equalToConstant: 70)
                ])

                if index == 0 {
                    firstCardView = view
                    let onTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapExpand(_:)))
                    view.addGestureRecognizer(onTapGesture)
                    view.isUserInteractionEnabled = true

                } else {
                    view.isHidden = true
                }
            }
        }

        setupPeekView(behind: firstCardView, hasMoreThanOne: friends.count > 1)
    }

    private func setupPeekView(behind frontCard: UIView?, hasMoreThanOne: Bool) {
        NSLayoutConstraint.deactivate(peekConstraints)
        peekConstraints.removeAll()
        peekView.removeFromSuperview()

        guard let frontCard = frontCard, hasMoreThanOne else { return }

        insertSubview(peekView, belowSubview: stackView)
        peekView.isHidden = isExpand

        peekConstraints = [
            peekView.leadingAnchor.constraint(equalTo: frontCard.leadingAnchor, constant: 12),
            peekView.trailingAnchor.constraint(equalTo: frontCard.trailingAnchor, constant: -12),
            peekView.topAnchor.constraint(equalTo: frontCard.topAnchor, constant: 10),
            peekView.bottomAnchor.constraint(equalTo: frontCard.bottomAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(peekConstraints)
    }

    @objc func onTapExpand(_ sender: UITapGestureRecognizer) {
        self.isExpand.toggle()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.peekView.isHidden = self.isExpand
            self.stackView.arrangedSubviews.forEach { view in
                if view.tag != 0 {
                    view.isHidden = !self.isExpand
                }
            }
            
        } completion: { [weak self] isComplete in
            guard let self = self else { return }
            if isComplete {
                self.onExpandChanged?(self.isExpand)
            }
        }
    }
}
