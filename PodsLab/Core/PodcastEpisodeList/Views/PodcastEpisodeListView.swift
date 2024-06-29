//
//  PodcastEpisodeListView.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/22/24.
//

import SwiftUI

struct PodcastEpisodeListView: View {
    @Environment (PodcastEpisodeListViewModel.self) private var viewModel
    @State var showSearchFilterSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                searchFilterSection
                
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
        PodcastEpisodeListView(showSearchFilterSheet: false)
            .environment(PodcastEpisodeListViewModel())
    }
}

extension PodcastEpisodeListView {
    private var searchFilterSection: some View {
        VStack {
            HStack {
                SearchBar(showSheet: $showSearchFilterSheet)
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

