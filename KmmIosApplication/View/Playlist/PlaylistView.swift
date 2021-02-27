import SwiftUI

import SwiftUI
import URLImage
import shared

struct PlaylistView: View {
    @ObservedObject var viewModel = PlaylistViewModel()
    
    var body: some View {
        switchView()
            .navigationTitle(Text("Video Playlist"))
    }
}

extension PlaylistView {
    
    func switchView() -> AnyView {
        switch viewModel.playlistState.state {
        case .initial:
            return initialView()
        case .doneLoading:
            return doneLoadingView()
        case .loading:
            return loadView()
        case .success(let playlist):
            return successView(playlist)
        case .errorLoading:
            return errorView("Error Loading")
        case .errorShowing:
            return errorView("Error Showing")
        }
    }
    
    func initialView() -> AnyView {
        AnyView(
            Text("Initial View")
                .onAppear(perform: {
                    viewModel.accept(intent: .loadList)
                })
        )
    }
    
    func loadView() -> AnyView {
        AnyView(Text("Loading"))
    }
    
    func doneLoadingView() -> AnyView {
        AnyView(
            Text("Done Loading")
                .onAppear(perform: {
                    viewModel.accept(intent: .showList)
                })
        )
    }
    
    func successView(_ playlist: Playlist) -> AnyView {
        AnyView(
            List {
                ForEach (playlist.videos) {vid in
                    NavigationLink(destination: VideoViewer(video: vid)) {
                        ItemListView(video: vid)
                    }
                }
            }.navigationTitle(Text(Greeting().greeting()))
        )
    }
    
    func errorView(_ message: String) -> AnyView {
        AnyView(Text(message))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}

extension Video : Identifiable {}
