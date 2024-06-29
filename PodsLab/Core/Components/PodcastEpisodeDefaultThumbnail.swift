//
//  PodcastEpisodeDefaultThumbnail.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/3/24.
//

import SwiftUI

struct PodcastEpisodeDefaultThumbnail: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color(UIColor.systemGray4))
                .frame(width: width, height: height)

            Image(systemName: "waveform")
                .resizable()
                .tint(.secondary)
                .frame(width: width / 2, height: height / 2)
        }
    }
}

#Preview {
    PodcastEpisodeDefaultThumbnail(width: 80, height: 80)
}
