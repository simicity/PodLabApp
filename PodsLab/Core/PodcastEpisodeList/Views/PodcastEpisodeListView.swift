//
//  PodcastEpisodeListView.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/22/24.
//

import SwiftUI
import SwiftData

struct PodcastEpisodeListView: View {
    @Environment (PodcastEpisodeListViewModel.self) private var viewModel
    @Environment(\.modelContext) private var context
    @Query var savedEpisodes: [SavedPodcastEpisode]
    @Query var savedSeries: [SavedPodcastSeries]
    @State var showSearchFilterSheet: Bool = false
    @State var currentPage: Int = 1
    @State var isLoading: Bool = false
    
    func isSavedEpisode(episodeId: String) -> Bool {
        return !savedEpisodes.filter { $0.id == episodeId }.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                searchFilterSection
                
                if viewModel.podcastEpisodes.isEmpty {
                    if isLoading {
                        Spacer()
                        ProgressView("Loading")
                        Spacer()
                    } else {
                        ContentUnavailableView("Discover Podcasts", systemImage: "sparkle.magnifyingglass", description: Text("Search by word or category"))
                    }
                } else {
                    List {
                        ForEach(Array(viewModel.podcastEpisodes.enumerated()), id: \.offset) { index, episode in
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
                                    if isSavedEpisode(episodeId: episode.id) {
                                        let episodeToDelete: SavedPodcastEpisode = savedEpisodes.filter { $0.id == episode.id }[0]
                                        let seriesIdToSearch: String = episode.podcastSeries.id
                                        context.delete(episodeToDelete)
                                        var hasEpisodeOfSeries = false
                                        savedEpisodes.forEach { savedEpisode in
                                            if let id = savedEpisode.podcastSeries?.id {
                                                if id == seriesIdToSearch {
                                                    hasEpisodeOfSeries = true
                                                }
                                            }
                                        }
                                        if !hasEpisodeOfSeries {
                                            let seriesToDelete: SavedPodcastSeries = savedSeries.filter { $0.id == seriesIdToSearch }[0]
                                            context.delete(seriesToDelete)
                                        }
                                    } else {
                                        let seriesIdToSearch: String = episode.podcastSeries.id
                                        let fetchedSeries = savedSeries.filter { $0.id == seriesIdToSearch }
                                        let episodeToSave = SavedPodcastEpisode(
                                            id: episode.id,
                                            name: episode.name,
                                            episodeDescription: episode.description,
                                            audioUrl: episode.audioUrl,
                                            subtitle: episode.subtitle,
                                            datePublished: episode.datePublished,
                                            duration: episode.duration,
                                            podcastSeries: fetchedSeries.isEmpty ? SavedPodcastSeries(
                                                id: episode.podcastSeries.id,
                                                name: episode.podcastSeries.name,
                                                seriesDescription: episode.podcastSeries.description,
                                                imageUrl: episode.podcastSeries.imageUrl) : fetchedSeries[0],
                                            playbackProgress: episode.playbackProgress, playbackProgressRatio: episode.playbackProgressRatio)
                                        context.insert(episodeToSave)
                                    }
                                } label: {
                                    VStack {
                                        Image(systemName: isSavedEpisode(episodeId: episode.id) ? "bookmark.slash" : "bookmark")

                                        Text(isSavedEpisode(episodeId: episode.id) ? "Unsave" : "Save")
                                    }
                                }
                                .tint(.accent)
                            }
                            .onAppear {
                                if index == viewModel.podcastEpisodes.count - 2 && currentPage < PodcastDataServiceConstants.maxSearchPageNum {
                                    currentPage += 1
                                    viewModel.searchPodcastEpisodes(page: currentPage)
                                }
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
            .navigationTitle("Discover Podcasts")
            .refreshable {
                viewModel.resetEpisodeList()
                currentPage = 1
//                viewModel.searchPodcastEpisodes(page: currentPage)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PodcastEpisodeListView(showSearchFilterSheet: false)
            .environment(PodcastEpisodeListViewModel())
            .modelContainer(for: SavedPodcastEpisode.self, inMemory: true)
    }
}

extension PodcastEpisodeListView {
    private var searchFilterSection: some View {
        VStack {
            HStack {
                SearchBar(showSheet: $showSearchFilterSheet, isLoading: $isLoading)
                    .environment(viewModel)
                
                Button {
                    withAnimation(.snappy) {
                        showSearchFilterSheet.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .tint(.primary)
                }
            }
            
            if showSearchFilterSheet {
                SearchFilter()
                    .environment(viewModel)
                    .padding(.top)
            }
        }
        .padding(.horizontal)
    }
}

