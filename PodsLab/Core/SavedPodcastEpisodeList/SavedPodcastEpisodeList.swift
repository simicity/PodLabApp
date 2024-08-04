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

    func isSavedEpisode(episodeId: String) -> Bool {
        return !episodes.filter { $0.id == episodeId }.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack {
                if episodes.isEmpty {
                    ContentUnavailableView("Saved Podcasts", systemImage: "mic.fill", description: Text("No saved episode"))
                } else {
                    List {
                        ForEach(episodes) { episode in
                            ZStack {
                                let episodeToShow = PodcastEpisode(
                                    id: episode.id,
                                    name: episode.name,
                                    description: episode.episodeDescription,
                                    audioUrl: episode.audioUrl,
                                    subtitle: episode.subtitle,
                                    datePublished: episode.datePublished,
                                    duration: episode.duration,
                                    podcastSeries: PodcastSeries(
                                        id: episode.podcastSeries?.id ?? "0",
                                        name: episode.podcastSeries?.name ?? "",
                                        description: episode.podcastSeries?.seriesDescription ?? "",
                                        imageUrl: episode.podcastSeries?.imageUrl ?? ""
                                    )
                                )

                                PodcastEpisodeListItemView(episode: episodeToShow)
                                    .environment(viewModel)

                                NavigationLink(value: episodeToShow) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    let episodeToDelete: SavedPodcastEpisode = episodes.filter { $0.id == episode.id }[0]
                                    let seriesIdToSearch: String = episode.podcastSeries?.id ?? "0"
                                    context.delete(episodeToDelete)
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
