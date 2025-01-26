import SwiftUI
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

struct PlayerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var playerManager = AudioPlayerManager()
    @State private var sliderValue: Double = 0
    @State private var isAnimating = false
    @State private var animationAmount = 1.0
    let audioURL: String
    
    private let primaryColor = Color.orange
    private let secondaryColor = Color.red
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        primaryColor.opacity(0.1),
                        secondaryColor.opacity(0.1),
                        Color.orange.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ZStack {
                    ForEach(0..<15) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.1))
                            .frame(width: CGFloat.random(in: 4...12),
                                   height: CGFloat.random(in: 20...40))
                            .offset(x: CGFloat.random(in: -200...200),
                                    y: CGFloat.random(in: -400...400))
                            .animation(
                                Animation.linear(duration: Double.random(in: 20...40))
                                    .repeatForever(autoreverses: false)
                                    .delay(Double.random(in: 0...40)),
                                value: isAnimating
                            )
                    }
                }
                .opacity(playerManager.isPlaying ? 1 : 0)
                
                VStack(spacing: 30) {
                    if playerManager.isLoading {
                        loadingView
                    } else if let error = playerManager.error {
                        errorView(error)
                    } else {
                        mainPlayerView
                        playerControls
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.primary)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .preferredColorScheme(colorScheme)
        .onAppear {
            playerManager.setupAudio(urlString: audioURL)
            withAnimation(.spring(duration: 1)) {
                isAnimating = true
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(primaryColor.opacity(0.3), lineWidth: 4)
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .trim(from: 0, to: 0.7)
                        .stroke(primaryColor, lineWidth: 4)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1).repeatForever(autoreverses: false),
                                 value: isAnimating)
                )
            Text("Loading audio...")
                .foregroundStyle(.secondary)
                .padding(.top)
        }
    }
    
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(primaryColor)
                .symbolEffect(.bounce, options: .repeating)
            Text(error)
                .foregroundStyle(primaryColor)
                .multilineTextAlignment(.center)
        }
    }
    
    private var mainPlayerView: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .shadow(color: primaryColor.opacity(0.2), radius: 20, x: 0, y: 10)
                .overlay(
                    VStack(spacing: 16) {
                        HStack(spacing: 4) {
                            ForEach(0..<20) { index in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(
                                        LinearGradient(
                                            colors: [primaryColor, secondaryColor],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 4,
                                           height: playerManager.isPlaying ?
                                           CGFloat.random(in: 20...60) : 30)
                                    .animation(
                                        .easeInOut(duration: 0.3)
                                        .repeatForever()
                                        .delay(Double(index) * 0.1),
                                        value: playerManager.isPlaying
                                    )
                            }
                        }
                        .padding(.top)
                        
                        Text("Now Playing")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                )
        }
        .padding(.vertical, 20)
    }
    
    private var playerControls: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.secondary.opacity(0.2))
                        .frame(height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: UIScreen.main.bounds.width *
                            CGFloat(sliderValue / max(playerManager.duration, 1)),
                            height: 4
                        )
                    
                    Slider(value: $sliderValue,
                           in: 0...max(playerManager.duration, 0.01)) { editing in
                        if !editing {
                            playerManager.seek(to: sliderValue)
                        }
                    }
                }
                
                HStack {
                    Text(formatTime(playerManager.currentTime))
                    Spacer()
                    Text(formatTime(playerManager.duration))
                }
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            HStack(spacing: 40) {
                Button(action: { playerManager.backward() }) {
                    Image(systemName: "gobackward.10")
                        .font(.title)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [primaryColor.opacity(0.8),
                                        secondaryColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .buttonStyle(WarmButton())
                
                Button(action: {
                    if playerManager.isPlaying {
                        playerManager.pause()
                    } else {
                        playerManager.play()
                    }
                }) {
                    Image(systemName: playerManager.isPlaying ?
                          "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 70))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: primaryColor.opacity(0.3),
                               radius: 10, x: 0, y: 5)
                }
                .buttonStyle(WarmButton())
                
                Button(action: { playerManager.forward() }) {
                    Image(systemName: "goforward.10")
                        .font(.title)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [primaryColor.opacity(0.8),
                                        secondaryColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .buttonStyle(WarmButton())
            }
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct WarmButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6),
                      value: configuration.isPressed)
    }
}

#Preview {
    PlayerView(audioURL: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8")
}
