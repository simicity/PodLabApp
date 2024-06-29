//
//  PodcastSeriesDetailView.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/16/24.
//

import SwiftUI

struct PodcastSeriesDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let series: PodcastSeries

    var body: some View {
        ScrollView {
            VStack {
                if series.imageUrl.isEmpty {
                    PodcastEpisodeDefaultThumbnail(width: 150, height: 150)
                    .padding()
                } else {
                    AsyncImage(url: URL(string: series.imageUrl)) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else if phase.error != nil {
                            Image(systemName: "waveform")
                                .resizable()
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.bottom)
                }
                
                Text(series.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .padding(.bottom)
                
                Text(series.description)
            }
            .padding()
        }
        .background(Color(UIColor.background))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.secondary)
                        .background {
                            Circle()
                                .fill(Color(UIColor.systemGray).opacity(0.2))
                                .frame(width: 35, height: 35)
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        PodcastSeriesDetailView(series: MockData.mockPodcastEpisodes[1].podcastSeries)
    }
}
