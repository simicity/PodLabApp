//
//  PodsLabApp.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/18/24.
//

import SwiftUI

@main
struct PodsLabApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [SavedPodcastEpisode.self])
    }
}
