//
//  NewsfeedPresenter.swift
//  VKNews
//
//  Created by Elena Igumenova on 15.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
  func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
  weak var viewController: NewsfeedDisplayLogic?
  
  func presentData(response: Newsfeed.Model.Response.ResponseType) {
    
    switch response {
    case .presentNewsfeed(let feed):
        
        let cells = feed.items.map { (feedItem) in
            cellViewModel(from: feedItem)
        }
        let feedViewModel = FeedViewModel.init(cells: cells)
        viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
    }
  }
    
    private func cellViewModel(from feedItem: FeedItem) -> FeedViewModel.Cell {
        return FeedViewModel.Cell.init(iconUrlString: "",
                                       name: "name",
                                       date: "date",
                                       text: feedItem.text,
                                       like: String(feedItem.likes?.count ?? 0),
                                       comment: String(feedItem.comments?.count ?? 0),
                                       shared: String(feedItem.reposts?.count ?? 0),
                                       view: String(feedItem.views?.count ?? 0))
    }
}
