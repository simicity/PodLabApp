//
//  FloatingAudioPlayer.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/3/24.
//

import SwiftUI
import SwiftData

struct FloatingAudioPlayer: View {
    @Environment (PodcastEpisodeListViewModel.self) private var viewModel
    @Environment(\.modelContext) private var context
    @Query var savedEpisodes: [SavedPodcastEpisode]
    @State var isDragging: Bool = false
    let thumbnailSize: CGFloat = 35

    func updateSavedEpisode() {
        guard let selectedEpisode = viewModel.selectedPodcastEpisode else { return }
        for savedEpisode in savedEpisodes {
            if savedEpisode.id == selectedEpisode.id {
                savedEpisode.playbackProgress = selectedEpisode.playbackProgress
                savedEpisode.playbackProgressRatio = selectedEpisode.playbackProgressRatio
                try? context.save()
                break
            }
        }
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        HStack {
            if let episode = viewModel.selectedPodcastEpisode {
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
                    Text(viewModel.selectedPodcastEpisode!.name)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text((viewModel.selectedPodcastEpisode?.playbackProgress ?? 0).asDurationString())
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
                .padding(.leading, 5)

                Spacer()
                
                Button {
                    switch episode.playbackStatus {
                    case .stop, .pause:
                        viewModel.playSelectedEpisode()
                    case .play:
                        viewModel.pauseSelectedEpisode()
                        updateSavedEpisode()
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
            VStack(alignment: .center) {
                Spacer()

                if let imageUrl = viewModel.selectedPodcastEpisode?.podcastSeries.imageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
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
                } else {
                    PodcastEpisodeDefaultThumbnail(width: 150, height: 150)
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
                    .scaleEffect(x: isDragging ? 1.03 : 1.0, y: isDragging ? 1.35 : 1.0)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let dragLocation = value.location.x
                                viewModel.stopPlaybackProgressMonitor()
                                episode.playbackProgressRatio = CGFloat(max(0, min(1, dragLocation / geometry.size.width)))
                                isDragging = true
                            }
                            .onEnded { _ in
                                AudioManager.shared.pause()
                                episode.playbackProgress = Double(episode.duration) * episode.playbackProgressRatio
                                do {
                                    try AudioManager.shared.play(url: episode.audioUrl, seekTo: episode.playbackProgress)
                                } catch {
                                    episode.playbackStatus = .stop
                                }
                                isDragging = false
                                viewModel.startPlaybackProgressMonitor()
                            }
                    )
                    
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
                                viewModel.playSelectedEpisode()
                            case .play:
                                viewModel.pauseSelectedEpisode()
                                updateSavedEpisode()
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
        }
        .padding()
        .background(Color(UIColor.background))
        .presentationDragIndicator(.visible)
    }
}
