//
//  SavedPodcastEpisodeList.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/29/24.
//

import SwiftUI

struct SavedPodcastEpisodeList: View {
//    @Environment (PodcastEpisodeListViewModel.self) private var viewModel
    let 
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.podcastEpisodes.isEmpty {
                    ContentUnavailableView("Discover Podcasts", systemImage: "sparkle.magnifyingglass", description: Text("Search by word or category"))
                } else {
                    List {
                        ForEach(viewModel.podcastEpisodes) { episode in
                            NavigationLink(value: episode) {
                                PodcastEpisodeListItemView(episode: episode)
                                    .environment(viewModel)
                            }
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    
                                } label: {
                                    VStack {
                                        Image(systemName: "bookmark")

                                        Text("Save")
                                    }
                                }
                                .tint(.accent)
                            }
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .listStyle(.plain)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .navigationDestination(for: PodcastEpisode.self) { episode in
                        PodcastEpisodeView(episode: episode)
                            .navigationBarBackButtonHidden()
                    }
                }
            }
            .background(Color(UIColor.background))
            .refreshable {
//                viewModel.searchPodcastEpisodes()
            }
        }
        .onAppear {
//            viewModel.searchPodcastEpisodes()
        }
    }
}

#Preview {
    NavigationStack {
        SavedPodcastEpisodeList()
//            .environment(PodcastEpisodeListViewModel())
    }
}
