//
//  SearchSuccessListViewController.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import UIKit
import MJRefresh
import SKPhotoBrowser
import ToastSwiftFramework

struct SearchSuccessListViewUX {
    static let CollectionBackgroundColor = UIColor.White100
    static let CollectionInteritemSpacing: CGFloat = 5
    static let CollectionLineSpacing: CGFloat = 5
    static let collectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    static let CollectionCellName = "PhotoCollectionViewCell"
}
class SearchSuccessListViewController: UIViewController {
    var dataProvider: SearchSuccessListDataProvider?
    var viewModel = SearchSuccessListViewModel() {
        didSet {
            photoCountIndicatorLabel.text = viewModel.progressString
            photoCountIndicatorLabel.sizeToFit()
            collectionView.reloadData()
        }
    }
    // pull refresh
    let footer = MJRefreshAutoNormalFooter()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = SearchSuccessListViewUX.CollectionLineSpacing
        layout.minimumInteritemSpacing = SearchSuccessListViewUX.CollectionInteritemSpacing
        layout.sectionInset = SearchSuccessListViewUX.collectionInsets
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.mj_footer = footer
        view.backgroundColor = SearchSuccessListViewUX.CollectionBackgroundColor
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: SearchSuccessListViewUX.CollectionCellName)
        return view
    }()
    lazy var photoCountIndicatorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(searchText: String, firstPage: FlickrSearchApiResponseModel.Photos) {
        super.init(nibName: nil, bundle: nil)
        dataProvider = SearchSuccessListDataProvider(searchText: searchText, firstPage: firstPage, view: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.searchKey
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        let item = UIBarButtonItem(customView: photoCountIndicatorLabel)
        navigationItem.rightBarButtonItem = item
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if collectionView.contentSize.height <= collectionView.frame.size.height {
            collectionView.mj_footer = nil
        } else {
            collectionView.mj_footer = footer
        }
    }
    @objc func footerRefresh() {
        dataProvider?.requestNextPage()
    }
    func browsePicsFullScreen(beginIndex: Int) {
        let images: [SKPhoto] = viewModel.photos.map { (photo) -> SKPhoto in
            let skPhoto = SKPhoto.photoWithImageURL(photo.imageUrl!)
            skPhoto.shouldCachePhotoURLImage = true
            return skPhoto
        }
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(beginIndex)
        present(browser, animated: true, completion: {})
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.collectionView.reloadData()
        }
    }
}

extension SearchSuccessListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchSuccessListViewUX.CollectionCellName, for: indexPath)
        let photo = viewModel.photos[indexPath.item]
        if let photoCell: PhotoCollectionViewCell =  cell as? PhotoCollectionViewCell {
            photoCell.photo = photo
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        browsePicsFullScreen(beginIndex: indexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeSize = self.view.safeAreaLayoutGuide.layoutFrame.size
        var collectionCol: CGFloat = 3
        if  self.traitCollection.horizontalSizeClass == .regular || self.traitCollection.verticalSizeClass == .compact {
            collectionCol = 5
        }
        let collectionItemWidth: CGFloat = floor((safeSize.width - (collectionCol-1)*SearchSuccessListViewUX.CollectionInteritemSpacing)/collectionCol)
        let collectionItemHeight: CGFloat = collectionItemWidth * 1.3
        return CGSize(width: collectionItemWidth, height: collectionItemHeight)
    }
    
}
extension SearchSuccessListViewController: SuccessListViewInputProtocol {
    func noMorePhotos() {
        collectionView.mj_footer.endRefreshingWithNoMoreData()
    }
    
    func updateView(viewModel: SearchSuccessListViewModel) {
        collectionView.mj_footer.endRefreshing()
        self.viewModel = viewModel
    }
    
    func updateErrorInfo(errorDescription: String) {
        collectionView.mj_footer.endRefreshing()
        view.makeToast(errorDescription, duration: 3.0, position: .center)
    }
}
