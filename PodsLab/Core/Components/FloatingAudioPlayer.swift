//
//  FloatingAudioPlayer.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/3/24.
//

import SwiftUI

struct FloatingAudioPlayer: View {
    @Environment (PodcastEpisodeListViewModel.self) private var viewModel

    var body: some View {        
        @Bindable var viewModel = viewModel

        HStack {
            if let episode = viewModel.selectedPodcastEpisode {
                if episode.podcastSeries.imageUrl.isEmpty {
                    PodcastEpisodeDefaultThumbnail(width: 55, height: 55)
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
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }

                VStack(alignment: .leading) {
                    Text(viewModel.selectedPodcastEpisode!.name)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text((viewModel.selectedPodcastEpisode?.playbackProgress ?? 0).asDurationString())
                        .foregroundStyle(.secondary)
                }
                .padding(.leading, 5)

                Spacer()
                
                Button {
                    switch episode.playbackStatus {
                    case .stop, .pause:
                        do {
                            try AudioManager.shared.play(url: viewModel.selectedPodcastEpisode!.audioUrl, seekTo: viewModel.selectedPodcastEpisode!.playbackProgress)
                            viewModel.startPlaybackProgressMonitor()
                            episode.playbackStatus = .play
                        } catch {
                            print("Failed playing the audio url")
                        }
                    case .play:
                        AudioManager.shared.pause()
                        viewModel.stopPlaybackProgressMonitor()
                        episode.playbackStatus = .pause
                    }
                } label: {
                    Image(systemName: episode.playbackStatus.icon)
                        .font(.title2)
                        .tint(.primary)
                }
                .padding(5)
                
                Button {
                    AudioManager.shared.fastForward(by: 30)
                } label: {
                    Image(systemName: "goforward.30")
                        .font(.title2)
                        .tint(.primary)
                }
            } else {
                Spacer()
                Text("No Podcast selected")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color(UIColor.systemGray).opacity(0.2), radius: 30, x: 0, y: 0)
        )
        .padding(10)
        .onTapGesture {
            viewModel.showBigAudioPlayer = true
        }
        .sheet(isPresented: $viewModel.showBigAudioPlayer) {
            bigAudioPlayer
        }
    }
}

#Preview {
    FloatingAudioPlayer()
        .environment(PodcastEpisodeListViewModel())
}

extension FloatingAudioPlayer {
    var bigAudioPlayer: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                if viewModel.selectedPodcastEpisode == nil || viewModel.selectedPodcastEpisode!.podcastSeries.imageUrl.isEmpty {
                    PodcastEpisodeDefaultThumbnail(width: 150, height: 150)
                } else {
                    AsyncImage(url: URL(string: viewModel.selectedPodcastEpisode!.podcastSeries.imageUrl)) { phase in
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
                }
                
                Text(viewModel.selectedPodcastEpisode?.name ?? "No Podcast selected")
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .padding(.bottom, 2)
                    .padding(.top)
                
                Text(viewModel.selectedPodcastEpisode?.podcastSeries.name ?? "")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Spacer()
                
                if let episode = viewModel.selectedPodcastEpisode {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .frame(height: 10)
                            .foregroundStyle(Color(UIColor.systemGray6))
                        
                        Capsule()
                            .frame(width: geometry.size.width * episode.playbackProgressRatio, height: 10)
                            .foregroundStyle(.darkAccent)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text(episode.playbackProgress.asDurationString())
                        
                        Spacer()
                        
                        Text(episode.duration.asDurationString())
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Button {
                            AudioManager.shared.rewind(by: 15)
                        } label: {
                            Image(systemName: "gobackward.15")
                        }
                        
                        Button {
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
                                episode.playbackStatus = .pause
                            }
                        } label: {
                            Image(systemName: episode.playbackStatus.icon)
                        }
                        .padding(.horizontal)
                        
                        Button {
                            AudioManager.shared.fastForward(by: 30)
                        } label: {
                            Image(systemName: "goforward.30")
                        }
                    }
                    .font(.largeTitle)
                    .tint(.primary)
                    .padding(.vertical)
                }

                Spacer()
            }
            .padding()
            .background(Color(UIColor.background))
            .presentationDragIndicator(.visible)
        }
    }
}
