//
//  MainTabView.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/9/24.
//

import SwiftUI

enum TabItems: Int, CaseIterable{
    case home = 0
    case list
    
    var imageName: String {
        switch self {
        case .home:
            return "waveform.badge.magnifyingglass"
        case .list:
            return "bookmark"
        }
    }
}

struct MainTabView: View {
    @State var viewModel = PodcastEpisodeListViewModel()
    @State var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                PodcastEpisodeListView()
                    .environment(viewModel)
                    .tabItem {
                        Label("Discover", systemImage: TabItems.home.imageName)
                            .fontWeight(.bold)
                    }
                    .tag(0)
                
                SavedPodcastEpisodeList()
                    .tabItem {
                        Label("Saved", systemImage: TabItems.list.imageName)
                            .fontWeight(.bold)
                            .environment(\.symbolVariants, selectedTab == TabItems.list.rawValue ? .fill : .none)
                    }
                    .tag(1)
            }
            .tint(.accent)
            .toolbarBackground(.ultraThinMaterial)

            FloatingAudioPlayer()
                .environment(viewModel)
                .offset(y: -50)
        }
    }
}

#Preview {
    MainTabView()
}
