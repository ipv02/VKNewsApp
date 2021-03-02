
import UIKit

protocol NewsfeedPresentationLogic {
  func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    
  weak var viewController: NewsfeedDisplayLogic?
    
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "d MMM 'в' HH:mm"
        return df
    }()
  
  func presentData(response: Newsfeed.Model.Response.ResponseType) {
    
    switch response {
    case .presentNewsfeed(let feed, let revealdePostIds):
        
        let cells = feed.items.map { (feedItem) in
            cellViewModel(from: feedItem, profoles: feed.profiles, groups: feed.groups, revealdPostIds: revealdePostIds)
        }
        
        let footerTitle = String.localizedStringWithFormat(NSLocalizedString("newsfeed cells count", comment: ""), cells.count)
        
        let feedViewModel = FeedViewModel.init(cells: cells, footerTitle: footerTitle)
        viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
        
    case .presentUserInfo(let user):
        let userViewModel = UserViewModel.init(photoUrlString: user?.photo100)
        viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayUser(userViewModel: userViewModel))
        
    case .presentFooterLoader:
        viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayFooterLoader)
    }
  }
    
    private func cellViewModel(from feedItem: FeedItem, profoles: [Profile], groups: [Group], revealdPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profiles: profoles, groups: groups)
        
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        
        let isFullSized = revealdPostIds.contains(feedItem.postId)
        
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text ?? "",
                                               photoAttachments: photoAttachments,
                                               isFullSizedPost: isFullSized)
        
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")
        
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconUrlString: profile?.photo ?? "",
                                       name: profile?.name ?? "",
                                       date: dateTitle,
                                       text: postText,
                                       like: formattedCounter(feedItem.likes?.count),
                                       comment: formattedCounter(feedItem.comments?.count),
                                       shared: formattedCounter(feedItem.reposts?.count) ?? "",
                                       view: formattedCounter(feedItem.views?.count) ?? "",
                                       photoAttachments: photoAttachments,
                                       size: sizes)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentableProtocol? {
        
        let profilesOrGroups: [ProfileRepresentableProtocol] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { (myProfileRepresentable) -> Bool in
            myProfileRepresentable.id == normalSourceId
        }
        return profileRepresentable
    }
    
    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ (attachment) in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: firstPhoto.srcBIG,
                                                          width: firstPhoto.width,
                                                          height: firstPhoto.height)
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap { (attachment) -> FeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: photo.srcBIG,
                                                              width: photo.width,
                                                              height: photo.height)
        }
    }
}
