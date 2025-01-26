//
//  AudioPlayerManager.swift
//  HackTAMU25App
//
//  Created by tk on 1/26/25.
//

import AVFoundation

@MainActor
final class AudioPlayerManager: ObservableObject {
    private var player: AVPlayer?
    private var timeObserver: Any?
    @Published var isPlaying = false
    @Published var duration: Double = 0
    @Published var currentTime: Double = 0
    @Published var isLoading = false
    @Published var error: String?
    
    nonisolated func setupAudio(urlString: String) {
        Task { @MainActor in
            guard let url = URL(string: urlString) else {
                self.error = "Invalid URL"
                return
            }
            
            self.isLoading = true
            let asset = AVURLAsset(url: url)
            
            do {
                let duration = try await asset.load(.duration)
                self.duration = duration.seconds
                self.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
                self.setupTimeObserver()
                self.isLoading = false
            } catch {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func setupTimeObserver() {
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            Task { @MainActor in
                self?.currentTime = time.seconds
            }
        }
    }
    
    func play() {
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func seek(to time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 600))
    }
    
    func forward() {
        let newTime = min((currentTime) + 10, duration)
        seek(to: newTime)
    }
    
    func backward() {
        let newTime = max((currentTime) - 10, 0)
        seek(to: newTime)
    }
    
    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}
