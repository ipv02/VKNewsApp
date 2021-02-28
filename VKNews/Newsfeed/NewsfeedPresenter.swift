
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
        let feedViewModel = FeedViewModel.init(cells: cells)
        viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
        
    case .presentUserInfo(let user):
        let userViewModel = UserViewModel.init(photoUrlString: user?.photo100)
        viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayUser(userViewModel: userViewModel))
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
        
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconUrlString: profile?.photo ?? "",
                                       name: profile?.name ?? "",
                                       date: dateTitle,
                                       text: feedItem.text,
                                       like: String(feedItem.likes?.count ?? 0),
                                       comment: String(feedItem.comments?.count ?? 0),
                                       shared: String(feedItem.reposts?.count ?? 0),
                                       view: String(feedItem.views?.count ?? 0),
                                       photoAttachments: photoAttachments,
                                       size: sizes)
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
