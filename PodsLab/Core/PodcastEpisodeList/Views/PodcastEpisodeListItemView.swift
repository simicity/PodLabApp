//
//  PodcastEpisodeListItemView.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/22/24.
//

import SwiftUI

struct PodcastEpisodeListItemView: View {
    @Environment (PodcastEpisodeListViewModel.self) private var viewModel
    let episode: PodcastEpisode

    var body: some View {
        HStack(spacing: 20) {
            if episode.podcastSeries.imageUrl.isEmpty {
                PodcastEpisodeDefaultThumbnail(width: 80, height: 80)
            } else {
                AsyncImage(url: URL(string: episode.podcastSeries.imageUrl)) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: "waveform")
                            .resizable()
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            
            VStack(alignment: .leading) {
                Text(episode.datePublished.asPublishedDateString())
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .tint(.primary)
                
                Text(episode.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .truncationMode(.tail)
                    .lineLimit(2)
                    .tint(.primary)
                
                Text(episode.subtitle)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .tint(.secondary)

                Button {
                    if let currentEpisode = viewModel.selectedPodcastEpisode {
                        if currentEpisode.playbackStatus == .play && currentEpisode != episode {
                            AudioManager.shared.pause()
                            viewModel.stopPlaybackProgressMonitor()
                            currentEpisode.playbackStatus = .pause
                        }
                    }
                    viewModel.selectedPodcastEpisode = episode
                    switch viewModel.selectedPodcastEpisode!.playbackStatus {
                    case .stop, .pause:
                        do {
                            try AudioManager.shared.play(url: viewModel.selectedPodcastEpisode!.audioUrl, seekTo: viewModel.selectedPodcastEpisode!.playbackProgress)
                            viewModel.startPlaybackProgressMonitor()
                            viewModel.selectedPodcastEpisode!.playbackStatus = .play
                        } catch {
                            print("Failed playing the audio url")
                        }
                    case .play:
                        AudioManager.shared.pause()
                        viewModel.stopPlaybackProgressMonitor()
                        viewModel.selectedPodcastEpisode!.playbackStatus = .pause
                    }
                } label: {
                    HStack {
                        Image(systemName: episode.playbackStatus.icon)

                        if episode.playbackStatus != .stop {
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .frame(width: 40, height: 8)
                                    .foregroundStyle(Color(UIColor.systemGray6))
                                
                                Capsule()
                                    .frame(width: 40 * episode.playbackProgressRatio, height: 8)
                                    .foregroundStyle(.darkAccent)
                            }
                        }
                        
                        Text(episode.playbackStatus != .stop ? episode.playbackProgress.asDurationString() : episode.duration.asDurationString())
                    }
                    .font(.footnote)
                    .tint(.secondary)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color(UIColor.systemGray5))
                .clipShape(Capsule())
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PodcastEpisodeListItemView(episode: MockData.mockPodcastEpisodes[1])
        .environment(PodcastEpisodeListViewModel())
}
