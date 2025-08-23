//
//  VideoPlayerView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 29/07/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
  // MARK: - PROPERTIES
  var recipeTitle: String?
  var recipeId: UUID?
  var videoURL: URL?
  var videoPlayerHelper: VideoPlayerHelper?
  var videoStorageManager: VideoStorageManager?

  // MARK: - BODY
    init(recipeTitle: String? = nil, recipeId: UUID? = nil, videoURL: URL) {
        self.recipeTitle = recipeTitle
        self.recipeId = recipeId
        self.videoURL = videoURL
        self.videoPlayerHelper = VideoPlayerHelper()
        self.videoStorageManager = VideoStorageManager()
    }
    
  var body: some View {
    VStack {
        if let videoURL = self.videoURL,
           let recipeVideoPlayer = self.videoPlayerHelper?.playVideo(fileName: videoURL){
            VideoPlayer(player: recipeVideoPlayer)
        } else {
            EmptyView()
                .overlay(content: {
                    Text("Unable to load the video")
                })
        }
    } //: VSTACK
    .accentColor(.accentColor)
    .navigationBarTitle(self.recipeTitle!, displayMode: .inline)
  }
}

// MARK: - PREVIEW

struct VideoPlayerView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
        VideoPlayerView(recipeTitle: "", videoURL: URL(fileURLWithPath: ""))
    }
  }
}
