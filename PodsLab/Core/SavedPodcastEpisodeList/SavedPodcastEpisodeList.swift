//
//  SavedPodcastEpisodeList.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/29/24.
//

import SwiftUI
import SwiftData

struct SavedPodcastEpisodeList: View {
    @Environment (PodcastEpisodeListViewModel.self) private var viewModel
    @Environment(\.modelContext) private var context
    @Query var episodes: [SavedPodcastEpisode]
    @Query var series: [SavedPodcastSeries]

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.savedPodcastEpisodes.isEmpty {
                    ContentUnavailableView("Saved Podcasts", systemImage: "mic.fill", description: Text("No saved episode"))
                } else {
                    List {
                        ForEach(Array(viewModel.savedPodcastEpisodes.enumerated()), id: \.offset) { index, episode in
                            ZStack {
                                PodcastEpisodeListItemView(episode: episode)
                                    .environment(viewModel)

                                NavigationLink(value: episode) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    let episodeToDelete: SavedPodcastEpisode = episodes.filter { $0.id == episode.id }[0]
                                    let seriesIdToSearch: String = episode.podcastSeries.id
                                    withAnimation {
                                        viewModel.savedPodcastEpisodes.remove(at: index)
                                        context.delete(episodeToDelete)
                                    }
                                    var hasEpisodeOfSeries = false
                                    episodes.forEach { episode in
                                        if let id = episode.podcastSeries?.id {
                                            if id == seriesIdToSearch {
                                                hasEpisodeOfSeries = true
                                            }
                                        }
                                    }
                                    if !hasEpisodeOfSeries {
                                        let seriesToDelete: SavedPodcastSeries = series.filter { $0.id == seriesIdToSearch }[0]
                                        context.delete(seriesToDelete)
                                    }
                                } label: {
                                    VStack {
                                        Image(systemName: "bookmark.slash")

                                        Text("Unsave")
                                    }
                                }
                                .tint(.accent)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .navigationDestination(for: PodcastEpisode.self) { episode in
                        PodcastEpisodeView(episode: episode)
                            .navigationBarBackButtonHidden()
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .background(Color(UIColor.background))
            .navigationTitle("Saved Episodes")
        }
    }
}

#Preview {
    NavigationStack {
        SavedPodcastEpisodeList()
            .environment(PodcastEpisodeListViewModel())
            .modelContainer(for: SavedPodcastEpisode.self, inMemory: true)
    }
}
