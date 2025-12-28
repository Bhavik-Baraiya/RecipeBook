//
//  VideoItemView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 28/12/25.
//

import SwiftUI

struct VideoItemView: View {
    let video: URL
    let onRemove: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                // Video playback action
            } label: {
                VideoThumbnailView(videoURL: video, size: 90)
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
                    .padding(4)
            }
        }
        .id(video.absoluteString)
    }
}
