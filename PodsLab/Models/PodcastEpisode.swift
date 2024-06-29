//
//  PodcastEpisode.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/18/24.
//

import Foundation

enum AudioPlaybackStatus {
    case stop, play, pause
    
    var icon: String {
        switch self {
        case .stop:
            "play.fill"
        case .play:
            "pause.fill"
        case .pause:
            "play.fill"
        }
    }
}

@Observable class PodcastEpisode: Identifiable, Hashable, Equatable {
    let id, name, description, audioUrl, subtitle: String
    let datePublished, duration: Int
    let podcastSeries: PodcastSeries
    var playbackStatus: AudioPlaybackStatus
    var playbackProgress: Double
    var playbackProgressRatio: CGFloat
    
    init(id: String, name: String, description: String, audioUrl: String, subtitle: String, datePublished: Int, duration: Int, podcastSeries: PodcastSeries) {
        self.id = id
        self.name = name
        self.description = description
        self.audioUrl = audioUrl
        self.subtitle = subtitle
        self.datePublished = datePublished
        self.duration = duration
        self.podcastSeries = podcastSeries
        self.playbackStatus = .stop
        self.playbackProgress = 0
        self.playbackProgressRatio = 0.0
    }

    static func == (lhs: PodcastEpisode, rhs: PodcastEpisode) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
