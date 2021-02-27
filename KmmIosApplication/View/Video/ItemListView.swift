import Foundation
import SwiftUI
import shared

struct ItemListView: View {
    var video: Video
    var body: some View {
        HStack {
            ItemImageView(imageUrlString: video.thumbnailUrl)
            VStack(alignment: .leading) {
                Text(video.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(video.author)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .truncationMode(.tail)
                Text(video.description_)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .truncationMode(.tail)
            }
            .layoutPriority(1)
        }
    }
}
