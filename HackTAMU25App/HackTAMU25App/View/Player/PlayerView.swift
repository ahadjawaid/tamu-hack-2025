import SwiftUI
import AVFoundation
import SplineRuntime

struct PlayerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var playerManager = AudioPlayerManager()
    @State private var sliderValue: Double = 0
    @State private var isAnimating = false
    let audioURL: String
        
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    if playerManager.isLoading {
                        loadingView
                    } else if let error = playerManager.error {
                        errorView(error)
                    } else {
                        let url = URL(string: "https://build.spline.design/uYSazCziM6sbgc5gcgRC/scene.splineswift")!
                        SplineView(sceneFileURL: url)
                        
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
        .background(Color.gray.opacity(0.05))
    }
    
    private var loadingView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .trim(from: 0, to: 0.7)
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
                .symbolEffect(.bounce, options: .repeating)
            Text(error)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var playerControls: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Slider(value: $sliderValue,
                       in: 0...max(playerManager.duration, 0.01)) { editing in
                    if !editing {
                        playerManager.seek(to: sliderValue)
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
                }
                
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
                }
                
                Button(action: { playerManager.forward() }) {
                    Image(systemName: "goforward.10")
                        .font(.title)
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
