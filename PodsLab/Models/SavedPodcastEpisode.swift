//
//  SavedPodcastEpisode.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/30/24.
//

import Foundation
import SwiftData

@Model class SavedPodcastEpisode {
    var id: String
    var name: String
    var episodeDescription: String
    var audioUrl: String
    var subtitle: String
    var datePublished: Int
    var duration: Int
    @Relationship(deleteRule: .noAction)
    var podcastSeries: SavedPodcastSeries?
    var playbackProgress: Double
    var playbackProgressRatio: CGFloat

    init(id: String, name: String, episodeDescription: String, audioUrl: String, subtitle: String, datePublished: Int, duration: Int, podcastSeries: SavedPodcastSeries, playbackProgress: Double, playbackProgressRatio: CGFloat) {
        self.id = id
        self.name = name
        self.episodeDescription = episodeDescription
        self.audioUrl = audioUrl
        self.subtitle = subtitle
        self.datePublished = datePublished
        self.duration = duration
        self.podcastSeries = podcastSeries
        self.playbackProgress = playbackProgress
        self.playbackProgressRatio = playbackProgressRatio
    }
}

