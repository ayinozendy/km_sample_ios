import Foundation
import URLImage
import shared

class PlaylistViewModel: ObservableObject {
    @Published public var playlistState = PlaylistState(state: .initial)
    static var playlistCache : Playlist?
    
    var database = DatabaseFactory().createDatabase()
    var repository : PlaylistRepository?
    
    init() {
        self.repository = PlaylistRepositoryFactory(
            database: self.database
        ).create()
    }
    
    func accept(intent : Intent) {
        switch intent {
        case .loadList:
            URLImageService.shared.cleanup()
            fetchPlaylist()
        case .showList:
            getPlaylist()
        }
    }
    
    func fetchPlaylist() {
        self.playlistState = PlaylistState(state: .loading)
        let handler : (KotlinUnit?, Error?) -> Void = {k, e in
            if (e != nil) {
                self.playlistState = PlaylistState(state: .errorLoading)
            } else {
                self.playlistState = PlaylistState(state: .doneLoading)
            }
        }
        self.repository?.fetchPlaylist(completionHandler: handler)
    }
    
    func getPlaylist() {
        let handler : (Playlist?, Error?) -> Void = {p, e in
            if (p != nil) {
                PlaylistViewModel.playlistCache = p
            } else {
                self.playlistState = PlaylistState(state: .errorShowing)
            }
        }
        repository?.getPlaylist(completionHandler:handler)
        
        self.dispatchMain {
            guard let data = PlaylistViewModel.playlistCache else {
                self.playlistState = PlaylistState(state: .errorShowing)
                return
            }
            self.playlistState = PlaylistState(state: .success(data))
        }
    }
    
    func dispatchMain(action: @escaping () -> Void) {
        DispatchQueue.main.async {
            action()
        }
    }
}

struct PlaylistState {
    var state: State
}

enum Intent {
    case loadList
    case showList
}

enum State {
    case initial
    case loading
    case doneLoading
    case success(_ playlist: Playlist)
    case errorLoading
    case errorShowing
}
