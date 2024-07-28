//
//  SavedPodcastSeries.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/30/24.
//

import SwiftData

@Model class SavedPodcastSeries {
    var id: String
    var name: String
    var seriesDescription: String
    var imageUrl: String
    @Relationship(deleteRule: .cascade)
    var episodes: [SavedPodcastEpisode]?
    
    init(id: String, name: String, seriesDescription: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.seriesDescription = seriesDescription
        self.imageUrl = imageUrl
        self.episodes = []
    }
}

