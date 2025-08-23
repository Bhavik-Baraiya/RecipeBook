//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import AVKit

var videoPlayer: AVPlayer?

class VideoPlayerHelper {
    
    private var videoURL: String?
    
    init(videoURL: String? = nil) {
        self.videoURL = videoURL
    }
    
    func playVideo(fileName: URL) -> AVPlayer? {
        
        let player = AVPlayer(url: fileName)
        player.play()
        return player
        
    }
}
