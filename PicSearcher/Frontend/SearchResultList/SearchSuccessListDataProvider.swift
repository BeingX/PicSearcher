
//
//  SearchSuccessListDataProvider.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation

class SearchSuccessListDataProvider: NSObject {
    weak var view: SuccessListViewInputProtocol?
    var searchText: String
    var isRequesting = false
    let apiService = FlickrSearchApiService()
    var currentViewModel = SearchSuccessListViewModel() {
        didSet {
            view?.updateView(viewModel: currentViewModel)
        }
    }
    var picTotalCountForCurrentkeyWord: Int {
        get {
            var total = 0
            if let firstPage = pages.first, let all = Int(firstPage.total) {
                total = all
            }
            return total
        }
    }
    var pages = [FlickrSearchApiResponseModel.Photos]()
    
    init(searchText: String, firstPage: FlickrSearchApiResponseModel.Photos, view: SuccessListViewInputProtocol) {
        self.view = view
        self.searchText = searchText
        super.init()
        self.apendNewPage(newPage: firstPage)

    }
    
    func requestNextPage() {
        if self.hasMorePhoto() {
            self.getData(page: pages.count + 1)
        } else {
            view?.noMorePhotos()
        }
    }
    
    func getData(page: Int) {
        if isRequesting {return}
        isRequesting = true
        apiService.searchByTags(tags: searchText, page: page) {[weak self] (responseModel, error) in
            self?.isRequesting = false
            guard let error = error else {
                self?.handleResponseModel(responseModel: responseModel)
                return
            }
            self?.handleError(error: error as NSError)
        }
    }
    
    func handleResponseModel(responseModel: FlickrSearchApiResponseModel?) {
        if let response = responseModel, let page = response.photos, page.photo.count > 0 {
            apendNewPage(newPage: page)
        } else {
            outputErrorString(error: LocalizedStrings.HomeView.TagHasNoPics)
        }
    }
    
    func outputErrorString(error: String) {
        view?.updateErrorInfo(errorDescription: error)
    }
    
    func handleError(error: NSError) {
        outputErrorString(error: error.localizedDescription)
    }

    func apendNewPage(newPage: FlickrSearchApiResponseModel.Photos) {
        guard newPage.page == pages.count + 1 else {
            return
        }
        pages.append(newPage)
        outputNewViewModel()
    }
    
    func outputNewViewModel() {
        var photos = [FlickrSearchApiResponseModel.Photos.PhotoModel]()
        for page in pages {
            photos += page.photo
        }
        let progress = String(photos.count) + "/" + String(picTotalCountForCurrentkeyWord)
        let viewModel = SearchSuccessListViewModel(photos: photos, progressString: progress, searchKey: searchText)
        currentViewModel = viewModel
    }
    
    func hasMorePhoto() -> Bool {
        if currentViewModel.photos.count >= picTotalCountForCurrentkeyWord {
            return false
        }
        return true
    }
}

extension SearchSuccessListDataProvider: SuccessListViewOutputProtocol {
    func pullUp() {
        requestNextPage()
    }
}
