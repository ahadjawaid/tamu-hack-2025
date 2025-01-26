import SwiftUI
import AVFoundation

@MainActor
class AudioPlayerManager: ObservableObject {
    private var player: AVPlayer?
    private var timeObserver: Any?
    @Published var isPlaying = false
    @Published var duration: Double = 0
    @Published var currentTime: Double = 0
    @Published var isLoading = false
    @Published var error: String?
    
    func setupAudio(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.error = "Invalid URL"
            return
        }
        
        isLoading = true
        let asset = AVURLAsset(url: url)
        
        Task {
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
            self?.currentTime = time.seconds
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

struct PlayerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var playerManager = AudioPlayerManager()
    @State private var sliderValue: Double = 0
    let audioURL: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if playerManager.isLoading {
                    ProgressView()
                } else if let error = playerManager.error {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    playerContent
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.down")
                    }
                }
            }
        }
        .onAppear {
            playerManager.setupAudio(urlString: audioURL)
        }
    }
    
    private var playerContent: some View {
        VStack(spacing: 20) {
            HStack {
                Text(formatTime(playerManager.currentTime))
                    .font(.caption)
                    .monospacedDigit()
                
                Slider(value: $sliderValue, in: 0...max(playerManager.duration, 0.01)) { editing in
                    if !editing {
                        playerManager.seek(to: sliderValue)
                    }
                }
                .accentColor(.blue)
                
                Text(formatTime(playerManager.duration))
                    .font(.caption)
                    .monospacedDigit()
            }
            .padding(.horizontal)
            
            HStack(spacing: 30) {
                Button(action: { playerManager.backward() }) {
                    Image(systemName: "backward.end")
                        .font(.system(size: 30))
                }
                
                Button(action: {
                    if playerManager.isPlaying {
                        playerManager.pause()
                    } else {
                        playerManager.play()
                    }
                }) {
                    Image(systemName: playerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 80))
                }
                
                Button(action: { playerManager.forward() }) {
                    Image(systemName: "forward.end")
                        .font(.system(size: 30))
                }
            }
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    PlayerView(audioURL: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8")
}
