//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import AVKit

var videoPlayer: AVPlayer?

class VideoPlayerHelper {
    
    private var videoURL: URL?
    
    init(videoURL: URL) {
        self.videoURL = videoURL
    }
    
    func playVideo() -> AVPlayer? {
        
        guard let videoURL = self.videoURL else {
            print("Video url not found")
            return nil
        }
        print("Playing video at: \(videoURL.absoluteString)")
        let player = AVPlayer(url: videoURL)
        player.play()
        return player
        
    }
}
