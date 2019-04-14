//
//  HomeViewController.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/10.
//  Copyright © 2019 xingxing. All rights reserved.
//

import UIKit
import ToastSwiftFramework

struct HomeViewStrings {
    static let InputPlaceholder = LocalizedStrings.HomeView.SearchPlaceholder
    static let Title = LocalizedStrings.HomeView.Title
    static let CellName = "HomeViewController.UITableViewCell"
    static let SectionHeaderCellName = "HomeViewController.SectionHeaderUITableView
    static let SwipeDeleteTitle = NSLocalizedString("HomeView.DeleteTitle", comment: "swipe left delete")
}
struct HomeViewUX {
    static let BackgroundColor = UIColor.White100
    static let SearchViewBackground = UIConstants.systemColor
    static let TableHeaderViewHeight: CGFloat = 120
    static let SearchBarHeight: CGFloat = 35
    static let GoButtonDefaultImage: UIImage? = UIImage(named: "go")
    static let GoButtonHeight: CGFloat = 35
    static let GoButtonWidth: CGFloat  = 50
    static let verticalPadding: CGFloat = 17
    static let SpaceBetweenSearchTextAndGoButton: CGFloat = 15
    static let RecordListCellHeight: CGFloat = 55
    static let IconHistory = "history"

}

class HomeViewController: UIViewController, SearchRecordManagerDelegate {
    var searchDataProvider: HomeViewOutputProtocol?
    var recordListDataManager: SearchRecordManager {
        let manager = SearchRecordManager.shared
        manager.delegate = self
        return manager
    }
    var searchView: SearchInputView = {
       let view  = SearchInputView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: HomeViewUX.TableHeaderViewHeight)
        return view
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = HomeViewUX.BackgroundColor
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = HomeViewStrings.Title
        addSubview()
        searchView.searchBar.delegate = self
        searchDataProvider = HomeViewDataProvider(view: self)
        view.backgroundColor = HomeViewUX.BackgroundColor
        searchView.goButton.addTarget(self, action: #selector(goQuery), for: .touchUpInside)
        setMenuButton()
        debugPrint(SearchRecordManager.shared.allRecords())

    }
    func addSubview() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view)
            maker.leading.trailing.bottom.equalTo(self.view)
        }
        tableView.tableHeaderView = searchView
    }
    
    func setMenuButton() {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        let image = UIImage(named: "nav_menu")
        button.setImage(image, for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    @objc func showMenu() {
        self.present(UINavigationController(rootViewController: SettingsViewController()), animated: true, completion: nil)
    }
    @objc func goQuery() {
        self.view.endEditing(true)
        guard let text = searchView.searchBar.text?.trim(), !text.isEmpty else {
            return
        }
        searchDataProvider?.searchAction(searchBarText: text)
    }
    
    //MARK: SearchRecordManagerDelegate
    func recordListDidChange(dataManager: SearchRecordManager) {
        tableView.reloadData()
    }
    
    func picPageFrom(record: SearchRecord) -> FlickrSearchApiResponseModel.Photos? {
        var page: FlickrSearchApiResponseModel.Photos?
        let jsonDecoder = JSONDecoder()
        if let jsonData = record.firstPageJson,
            let model = try? jsonDecoder.decode(FlickrSearchApiResponseModel.Photos.self, from: jsonData) {
            page = model
        }
        return page
    }
}
extension HomeViewController: HomeViewInputProtocol {
    func pushSuccessView(searchText: String, firstPage: FlickrSearchApiResponseModel.Photos) {
        let vc = SearchSuccessListViewController(searchText: searchText, firstPage: firstPage)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateView(viewModel: HomeViewModel) {
        if viewModel.isLoading {
            searchView.showLoading()
        } else {
            searchView.hideLoading()
        }
    }
    
    func updateErrorInfo(errorDescription: String) {
        self.view.makeToast(errorDescription, duration: 3.0, position: .center)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        goQuery()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordListDataManager.allRecords().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewStrings.CellName) ?? UITableViewCell(style: .subtitle, reuseIdentifier: HomeViewStrings.CellName)
        let record = recordListDataManager.object(at: indexPath)
        cell.textLabel?.text = record.searchkeyWord
        cell.accessoryType = .disclosureIndicator
        if let page = picPageFrom(record: record) {
            cell.detailTextLabel?.text = "Total picture count: " + page.total
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HomeViewUX.RecordListCellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let record = recordListDataManager.object(at: indexPath)
        if let page = picPageFrom(record: record), let key = record.searchkeyWord {
            pushSuccessView(searchText: key, firstPage: page)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewStrings.CellName) ?? UITableViewCell(style: .default, reuseIdentifier: HomeViewStrings.SectionHeaderCellName)
        cell.imageView?.image = UIImage(named: HomeViewUX.IconHistory)
        cell.contentView.backgroundColor = UIColor.Grey20
        return cell

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return HomeViewStrings.SwipeDeleteTitle
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        recordListDataManager.removeObject(at: indexPath)
    }
    
}

class SearchInputView: UIView {
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.returnKeyType = .search
        bar.backgroundImage = UIImage()
        bar.placeholder = HomeViewStrings.InputPlaceholder
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit() {
        self.backgroundColor = HomeViewUX.SearchViewBackground
        self.addSubview(goButton)
        goButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.safeAreaLayoutGuide)
            maker.trailing.equalTo(self.safeAreaLayoutGuide).offset(-HomeViewUX.verticalPadding)
            maker.height.equalTo(HomeViewUX.GoButtonHeight)
            maker.width.equalTo(HomeViewUX.GoButtonWidth)
        }
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.safeAreaLayoutGuide).offset(HomeViewUX.verticalPadding)
            maker.centerY.equalTo(goButton)
            maker.height.equalTo(HomeViewUX.SearchBarHeight)
            maker.trailing.equalTo(goButton.snp.leading).offset(-HomeViewUX.SpaceBetweenSearchTextAndGoButton)
        }
    }
    func showLoading() {
        goButton.showLoadingFace()
    }
    
    func hideLoading() {
        goButton.hideLoadingFace()
    }
}
