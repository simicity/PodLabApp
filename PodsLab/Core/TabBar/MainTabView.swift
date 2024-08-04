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
                    .environment(viewModel)
                    .tabItem {
                        Label("Saved", systemImage: TabItems.list.imageName)
                            .fontWeight(.bold)
                            .environment(\.symbolVariants, selectedTab == TabItems.list.rawValue ? .fill : .none)
                    }
                    .tag(1)
            }
            .tint(.accent)
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                appearance.backgroundColor = UIColor(Color.background.opacity(0.1))
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
                UITabBar.appearance().clipsToBounds = true
            }

            FloatingAudioPlayer()
                .environment(viewModel)
                .offset(y: -50)
        }
    }
}

#Preview {
    MainTabView()
}
