//
//  AudioManager.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/8/24.
//

import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var session = AVAudioSession.sharedInstance()
    private(set) var currentTime: Double = 0.0

    private init() {}
    
    private func activateSession() {
        do {
            try session.setCategory(.playback, mode: .default)
        } catch {
            print("Failed to set the audio session configuration")
        }
        
        do {
            try session.setActive(true)
        } catch let error {
            print("Failed to activate the audio session: \(error.localizedDescription)")
        }
    }

    private func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    func play(url: String, seekTo seconds: Double) throws {
        activateSession()

        guard let url = URL(string: url) else {
            throw AudioPlayerError.invalidUrl
        }

        let playerItem: AVPlayerItem = AVPlayerItem(url: url)

        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }

        if let player = player {
            seek(to: seconds)
            player.play()
        } else {
            throw AudioPlayerError.audioPlayerNotAvailable
        }
    }

    func pause() {
        if let player = player {
            player.pause()
        }

        deactivateSession()
    }
    
    func addPeriodicTimeObserver(callback: @escaping (Double) -> Void) {
        // Create a 1.0 second interval time
        let interval = CMTime(value: 1, timescale: 2)
        if let player = player {
            timeObserver = player.addPeriodicTimeObserver(forInterval: interval,
                                                          queue: .main) { time in
                callback(time.seconds)
            }
        }
    }
    
    func removePeriodicTimeObserver() {
        guard let timeObserver else { return }
        if let player = player {
            player.removeTimeObserver(timeObserver)
        }
        self.timeObserver = nil
    }
    
    func fastForward(by seconds: Double) {
        guard let player = player else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeGetSeconds(currentTime) + seconds
        seek(to: newTime)
    }

    func rewind(by seconds: Double) {
        guard let player = player else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeGetSeconds(currentTime) - seconds
        seek(to: newTime)
    }

    private func seek(to seconds: Double) {
        guard let player = player else { return }
        let time = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(USEC_PER_SEC))
        player.seek(to: time)
    }
    
    deinit {
        removePeriodicTimeObserver()
    }
}

enum AudioPlayerError: Error {
    case invalidUrl
    case audioPlayerNotAvailable
}
