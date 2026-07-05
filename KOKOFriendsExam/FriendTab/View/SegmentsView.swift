//
//  SegmentsView.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import UIKit
import SwiftUI

class SegmentsView: UIView {
    
    var selectIndex = 0
    
    let segments: [FriendSegment] = [
        FriendSegment(title: "好友", number: 0),
        FriendSegment(title: "聊天", number: 100),
    ]
    
    private var segmentViews: [SingleSegmentView] = []
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 36
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        selectIndex = tappedView.tag
        segmentViews.forEach { view in
            view.updateUI(isSelected: view.tag == selectIndex)
        }
    }
    
    func updateUI(segments: [FriendSegment]) {
        stackView.arrangedSubviews.forEach { [weak self] view in
            self?.stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for (index, value) in segments.enumerated() {
            let singleSegmentView = SingleSegmentView(
                isSelected: index == selectIndex,
                title: value.title,
                flagNumber: value.number
            )
            singleSegmentView.translatesAutoresizingMaskIntoConstraints = false
            singleSegmentView.backgroundColor = .clear
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
            singleSegmentView.tag = index
            singleSegmentView.addGestureRecognizer(tapGesture)
            singleSegmentView.isUserInteractionEnabled = true
            
            stackView.addArrangedSubview(singleSegmentView)
            segmentViews.append(singleSegmentView)
        }
        
        let emptyView = UIView()
        emptyView.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        emptyView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        stackView.addArrangedSubview(emptyView)
    }
}

struct SegmentsViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> SegmentsView {
        SegmentsView()
    }
    
    func updateUIView(_ uiView: SegmentsView, context: Context) {
        
    }
}

#Preview {
    SegmentsViewRepresentable()
        .frame(height: 200)
}
