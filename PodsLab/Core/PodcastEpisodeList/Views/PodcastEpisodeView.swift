//
//  PodcastEpisodeView.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/25/24.
//

import SwiftUI

struct PodcastEpisodeView: View {
    @Environment (PodcastEpisodeListViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    let episode: PodcastEpisode

    var body: some View {
        ScrollView {
            VStack {
                if episode.podcastSeries.imageUrl.isEmpty {
                    PodcastEpisodeDefaultThumbnail(width: 150, height: 150)
                    .padding()
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
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.bottom)
                }
                
                Text(episode.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .padding(.bottom, 2)
                
                NavigationLink {
                    PodcastSeriesDetailView(series: episode.podcastSeries)
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Text(episode.podcastSeries.name)
                            .font(.headline)
                            .tint(.secondary)
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom)
                
                Button {
                    viewModel.selectedPodcastEpisode = episode
                    switch episode.playbackStatus {
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
                        
                        Text(episode.playbackStatus == .play ? "Pause" : "Play")
                            .fontWeight(.semibold)
                    }
                    .frame(width: 280)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.accent.opacity(0.2))
                    }
                }
                .padding(.bottom)
                
                Text(episode.description)
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
        PodcastEpisodeView(episode: MockData.mockPodcastEpisodes[2])
            .environment(PodcastEpisodeListViewModel())
    }
}
