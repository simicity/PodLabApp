//
//  PodcastEpisodeListItemView.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/22/24.
//

import SwiftUI
import SwiftData

struct PodcastEpisodeListItemView: View {
    @Environment (PodcastEpisodeListViewModel.self) private var viewModel
    @Query var savedEpisodes: [SavedPodcastEpisode]
    let episode: PodcastEpisode
    let thumbnailSize: CGFloat = 80

    func updateSavedEpisode() {
        guard let selectedEpisode = viewModel.selectedPodcastEpisode else { return }
        for savedEpisode in savedEpisodes {
            if savedEpisode.id == selectedEpisode.id {
                savedEpisode.playbackProgress = selectedEpisode.playbackProgress
                savedEpisode.playbackProgressRatio = selectedEpisode.playbackProgressRatio
                break
            }
        }
    }

    var body: some View {
        HStack(spacing: 20) {
            if episode.podcastSeries.imageUrl.isEmpty {
                PodcastEpisodeDefaultThumbnail(width: thumbnailSize, height: thumbnailSize)
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
                .frame(width: thumbnailSize, height: thumbnailSize)
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
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

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
                        viewModel.playSelectedEpisode()
                    case .play:
                        viewModel.pauseSelectedEpisode()
                        updateSavedEpisode()
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
                .padding(.vertical, 4)
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
