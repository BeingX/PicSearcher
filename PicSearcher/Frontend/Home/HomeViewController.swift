//
//  HomeViewController.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/10.
//  Copyright © 2019 xingxing. All rights reserved.
//

import UIKit

struct HomeViewUX {
    static let BackgroundColor = UIConstants.systemColor
    static let SearchViewTop: CGFloat = 30
    static let SearchBarHeight: CGFloat = 35
    static let GoButtonDefaultImage: UIImage? = UIImage(named: "go")
    static let GoButtonHeight: CGFloat = 35
    static let GoButtonWidth: CGFloat  = 50
    static let verticalPadding: CGFloat = 17
    static let SpaceBetweenSearchTextAndGoButton: CGFloat = 15
}

class HomeViewController: UIViewController {
    var dataProvider: HomeViewOutputProtocol?
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.returnKeyType = .search
        bar.backgroundImage = UIImage()
        bar.placeholder = LocalizedStrings.HomeView.SearchPlaceholder
        return bar
    }()
    lazy var goButton: IndicatorButton = {
        let button = IndicatorButton(type: .custom)
        button.setImage(HomeViewUX.GoButtonDefaultImage, for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        searchBar.delegate = self
        dataProvider = HomeViewDataProvider(view: self)
        view.backgroundColor = HomeViewUX.BackgroundColor
       goButton.addTarget(self, action: #selector(goQuery), for: .touchUpInside)
    }
    func addSubview() {
        view.addSubview(goButton)
        goButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(HomeViewUX.SearchViewTop)
            maker.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-HomeViewUX.verticalPadding)
            maker.height.equalTo(HomeViewUX.GoButtonHeight)
            maker.width.equalTo(HomeViewUX.GoButtonWidth)
        }
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.view.safeAreaLayoutGuide).offset(HomeViewUX.verticalPadding)
            maker.centerY.equalTo(goButton)
            maker.height.equalTo(HomeViewUX.SearchBarHeight)
            maker.trailing.equalTo(goButton.snp.leading).offset(-HomeViewUX.SpaceBetweenSearchTextAndGoButton)
        }
    }
    
    @objc func goQuery() {
        self.view.endEditing(true)
        guard let text = searchBar.text?.trim(), !text.isEmpty else {
            return
        }
        dataProvider?.queryWith(keyWord: text)
    }
}
extension HomeViewController: HomeViewInputProtocol {
    func updateView(viewModel: HomeViewModel) {
        if viewModel.isLoading {
            goButton.showLoadingFace()
        } else {
            goButton.hideLoadingFace()
        }
    }
    
    func updateErrorInfo(errorDescription: String) {
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        goQuery()
    }
}
