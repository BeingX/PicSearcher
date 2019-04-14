
//
//  HomeViewDataProvider.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation
import UIKit

class HomeViewDataProvider: NSObject {
    weak var view: HomeViewInputProtocol?
    let apiService = FlickrSearchApiService()
    var currentViewModel = HomeViewModel() {
        didSet {
            view?.updateView(viewModel: currentViewModel)
        }
    }
    init(view: HomeViewInputProtocol) {
        self.view = view
        super.init()
    }
    func outputLoadingStatus(isLoading: Bool) {
        var model = HomeViewModel()
        model.isLoading = isLoading
        currentViewModel = model
    }
    func outputErrorString(error: String) {
        view?.updateErrorInfo(errorDescription: error)
    }
    func handleError(error: NSError) {
        outputErrorString(error: error.localizedDescription)
    }
    func searchByTags(tags: String) {
        if currentViewModel.isLoading {
            return
        }
        outputLoadingStatus(isLoading: true)
        apiService.searchByTags(tags: tags, page: 1) { [weak self] (responseModel, error) in
            self?.outputLoadingStatus(isLoading: false)
            guard let error = error else {
                self?.handleResponseModel(searchText: tags, responseModel: responseModel)
                return
            }
            self?.handleError(error: error as NSError)
        }
    }
    
    func handleResponseModel(searchText: String, responseModel: FlickrSearchApiResponseModel?) {
        if let response = responseModel, let firstPage = response.photos, firstPage.photo.count > 0 {
            view?.pushSuccessView(searchText: searchText, firstPage: firstPage)
            SearchRecordManager.shared.saveRecord(searchKeyWord: searchText, firstPage: firstPage)
        } else {
            outputErrorString(error: LocalizedStrings.HomeView.TagHasNoPics)
        }
    }
}
extension HomeViewDataProvider: HomeViewOutputProtocol {
    func searchAction(searchBarText: String) {
        searchByTags(tags: searchBarText)
    }
}
