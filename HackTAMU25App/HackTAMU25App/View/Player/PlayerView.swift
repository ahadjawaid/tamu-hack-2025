import SwiftUI
import SwiftData
import AVFoundation
import SplineRuntime

struct SplineViewModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background(color)
    }
}

struct PlayerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var playerManager = AudioPlayerManager()
    @State private var sliderValue: Double = 0
    @State private var isAnimating = false
    let topic: Topic
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                if playerManager.isLoading {
                    Text("Loadding...")
                } else {
                    let url = URL(string: "https://build.spline.design/uYSazCziM6sbgc5gcgRC/scene.splineswift")!
                    ZStack(alignment: .bottomTrailing) {
                        SplineView(sceneFileURL: url)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        RoundedRectangle(cornerRadius: 5).fill(Color(hex: "#f9f9fa"))
                            .frame(width: 180, height: 80)
                        RoundedRectangle(cornerRadius: 25).fill(.yellow.opacity(0.1))
                    }
                    
                    
                    VStack(spacing: 24) {
                        HStack {
                            Text(topic.title)
                        }
                        
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
            }
            .padding()
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
        .onAppear {
            playerManager.setupAudio(urlString: topic.audioURL!)
            withAnimation(.spring(duration: 1)) {
                isAnimating = true
            }
        }
        .background(Color.gray.opacity(0.05))
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}


func generateSong(prompt: String) async throws -> [String: Any] {
    guard let url = URL(string: "http://127.0.0.1:8000/generate") else {
        throw URLError(.badURL)
    }
    let parameters = ["prompt": prompt]
    let jsonData = try JSONEncoder().encode(parameters)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = 600
    request.httpBody = jsonData
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }
    
    if httpResponse.statusCode != 200 {
        if let responseString = String(data: data, encoding: .utf8) {
            throw NSError(domain: "SunoAPI", code: httpResponse.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: responseString])
        }
        throw URLError(.badServerResponse)
    }
    
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let response = json["response"] as? [String: Any] else {
        throw URLError(.cannotParseResponse)
    }
    
    return response
}

#Preview {
    PlayerView(topic: SampleData.shared.topics.filter({ $0.audioURL != nil })[0])
}
