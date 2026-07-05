//
//  ViewController.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import Combine
import UIKit
import SwiftUI

enum FetchCase {
    /// I. 無好友畫面:request API 2-(5)
    case noFriend
    /// II. 只有好友列表:request API 2-(2)、2-(3)
    case friendListNoInvitation
    /// III. 好友列表含邀請:request API 2-(4)
    case friendListWithFriends
}

class FriendViewController: UIViewController {
    /// ⬇️ 調整這邊～
    private let fetchCase: FetchCase = .friendListNoInvitation
    private let vm = FriendViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteTwo
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerSV: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainInfoView: FriendMainInfoView = {
        let view = FriendMainInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var invitedFriendSV: InvitedFriendSV = {
        let view = InvitedFriendSV()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onExpandChanged = { [weak self] _ in
            self?.sizeHeaderToFit()
            self?.tableView.reloadData()
        }
        return view
    }()
    
    private lazy var segmentView: SegmentsView = {
        let view = SegmentsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .veryLightPink2
        return view
    }()
    
    private lazy var searchView: FriendSearchView = {
        let view = FriendSearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "\(FriendTableViewCell.self)", bundle: nil),
                           forCellReuseIdentifier: "\(FriendTableViewCell.self)")
        tableView.register(UINib(nibName: "\(NoFriendTableViewCell.self)", bundle: nil),
                           forCellReuseIdentifier: "\(NoFriendTableViewCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 500
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 105, bottom: 0, right: 30)
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupHeaderView()
        bindViewModel()
        bindSearchText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems()
    }
    
    @objc private func fetchItems() {
        Task {
            try? await vm.fetchItems(type: fetchCase)
            await MainActor.run {
                tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func bindViewModel() {
        vm.$mainInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mainInfo in
                guard let self = self else { return }
                self.mainInfoView.updateUI(name: mainInfo?.name ?? "",
                                           id: mainInfo?.kokoid ?? "")
            }
            .store(in: &cancellable)
        
        vm.$friends
            .receive(on: DispatchQueue.main)
            .sink { [weak self] friends in
                guard let self = self else { return }
                self.searchView.isHidden = friends.isEmpty
                self.sizeHeaderToFit()
                self.tableView.reloadData()
                self.tableView.separatorStyle = friends.isEmpty ? .none : .singleLine
                
                let friendCnt = friends.filter { $0.status == .inviting }.count
                self.segmentView.updateUI(segments: [
                    FriendSegment(title: "好友", number: friendCnt),
                    FriendSegment(title: "聊天", number: 100),
                ])
            }
            .store(in: &cancellable)
        
        vm.$displayFriends
            .receive(on: DispatchQueue.main)
            .sink { [weak self] friends in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellable)
        
        vm.$invitedFriends
            .sink { [weak self] friends in
                guard let self = self else { return }
                self.invitedFriendSV.isHidden = friends.isEmpty
                if !friends.isEmpty {
                    self.invitedFriendSV.updateUI(friends: friends)
                }
                self.headerSV.setCustomSpacing(friends.isEmpty ? 23 : 35, after: self.mainInfoView)
            }
            .store(in: &cancellable)
    }
    
    private func bindSearchText() {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification,
                       object: searchView.textField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] text in
                guard let self = self else { return }
                vm.search(text: text)
            }
            .store(in: &self.searchView.cancellables)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItems = [
            .fixedSpace(10),
            UIBarButtonItem(image: UIImage(resource: .icNavPinkWithdraw).withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(resource: .icNavPinkTransfer).withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil),
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(resource: .icNavPinkScan).withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil),
            .fixedSpace(10),
        ]
        navigationController?.navigationBar.isHidden = false
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchItems), for: .valueChanged)
    }
    
    private func sizeHeaderToFit() {
        guard let header = tableView.tableHeaderView else { return }
        header.setNeedsLayout()
        header.layoutIfNeeded()

        let targetWidth = tableView.bounds.width
        let height = header.systemLayoutSizeFitting(
            CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        if header.frame.height != height {
            header.frame.size.height = height
            tableView.tableHeaderView = header
        }
    }

    private func setupHeaderView() {
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
        ])
        
        headerView.addSubview(headerSV)
        NSLayoutConstraint.activate([
            headerSV.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerSV.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerSV.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 27),
            headerSV.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
        
        headerSV.addArrangedSubview(mainInfoView)
        NSLayoutConstraint.activate([
            mainInfoView.heightAnchor.constraint(equalToConstant: 52),
            mainInfoView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30),
            mainInfoView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30)
        ])
        
        headerSV.addArrangedSubview(invitedFriendSV)
        headerSV.setCustomSpacing(35, after: mainInfoView)
        invitedFriendSV.isHidden = true
        NSLayoutConstraint.activate([
            invitedFriendSV.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30),
            invitedFriendSV.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30)
        ])
        
        headerSV.addArrangedSubview(segmentView)
        headerSV.setCustomSpacing(15, after: invitedFriendSV)
        NSLayoutConstraint.activate([
            segmentView.heightAnchor.constraint(equalToConstant: 35),
            segmentView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 32),
            segmentView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -32)
        ])
        
        headerSV.addArrangedSubview(searchView)
        NSLayoutConstraint.activate([
            searchView.heightAnchor.constraint(equalToConstant: 60),
            searchView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30),
            searchView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30)
        ])
        
        headerView.insertSubview(separatorView, at: 0)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        headerView.insertSubview(headerBgView, at: 0)
        NSLayoutConstraint.activate([
            headerBgView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerBgView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerBgView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerBgView.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor)
        ])
    }
}

extension FriendViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return vm.friends.isEmpty ? UITableView.automaticDimension : 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.friends.isEmpty ? 1 : vm.displayFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !vm.friends.isEmpty {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(FriendTableViewCell.self)"
            ) as? FriendTableViewCell else { return UITableViewCell() }
            
            let currentFriend = vm.displayFriends[indexPath.row]
            cell.configCell(friend: currentFriend)
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(NoFriendTableViewCell.self)"
            ) as? NoFriendTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
}

struct FriendViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return FriendViewController()
    }
    
    func makeCoordinator() -> () { }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

#Preview {
    FriendViewControllerRepresentable()
        .ignoresSafeArea()
}
