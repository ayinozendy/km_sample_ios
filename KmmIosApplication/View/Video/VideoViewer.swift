import Foundation
import SwiftUI
import AVKit
import shared

struct VideoViewer: View {
    var video: Video
    var player : AVPlayer?
    
    init(video: Video) {
        self.video = video
        player = AVPlayer(url:  URL(string: video.videoUrl)!)
    }

    var body: some View {
        VStack(alignment: .leading) {
            VideoPlayer(player: player)
                .frame(maxHeight: 256)
            Text("by "+video.author)
                .padding(8)
            Text(video.description_)
                .padding(8)
                .lineLimit(7)
                .truncationMode(.tail)
        }
        .onDisappear() {
            player?.pause()
        }
        .navigationTitle(Text(video.title))
    }
}
