import SwiftUI
import SwiftData
import AVFoundation
import SplineRuntime


private let apiDomain = "localhost:8000"

struct PlayerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var playerManager = AudioPlayerManager()
    @State private var sliderValue: Double = 0
    @State private var isAnimating = false
    let topic: Topic
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                if topic.audioURL == nil {
                    LoadingView()
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
        .task {
            if topic.audioURL == nil {
                do {
                    let response = try await makeAPICall(prompt: topic.prompt)
                    topic.audioURL = response.first
                    playerManager.setupAudio(urlString: topic.audioURL!)
                } catch {
                    print("Error generating song: \(error.localizedDescription)")
                }
            } else {
                print("has url")
                playerManager.setupAudio(urlString: topic.audioURL ?? "")
            }
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    private var spinnerAnimation: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                LinearGradient(
                    gradient: .init(colors: [.orange.opacity(0.8), .yellow.opacity(0.6)]),
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: .init(lineWidth: 4, lineCap: .round)
            )
            .frame(width: 60, height: 60)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 1)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
    }
    
    private var loadingText: some View {
        VStack(spacing: 4) {
            Text("Generating Your Song")
                .font(.system(.title2, weight: .medium))
                .foregroundStyle(.primary)
            
            Text("This may take a moment...")
                .font(.system(.subheadline))
                .foregroundStyle(.secondary.opacity(0.8))
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            spinnerAnimation
            loadingText
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .background(Color(.systemBackground).opacity(0.95))
        .onAppear { isAnimating = true }
    }
}

struct RequestBody: Encodable {
    let prompt: String
}

struct Response: Codable {
    struct Inner: Codable {
        struct Data: Codable {
            let id: String
            let clips: [Clip]
            let metadata: Metadata
            let majorModelVersion: String
            let status: String
            let createdAt: String
            let batchSize: Int
            
            enum CodingKeys: String, CodingKey {
                case id
                case clips
                case metadata
                case majorModelVersion = "major_model_version"
                case status
                case createdAt = "created_at"
                case batchSize = "batch_size"
            }
        }
        
        let response: Data
        let audioUrls: [String]
        let downloadedFiles: [String]
        
        enum CodingKeys: String, CodingKey {
            case response
            case audioUrls = "audio_urls"
            case downloadedFiles = "downloaded_files"
        }
    }
    
    let response: Inner
}

struct Clip: Codable {
    let id: String
    let videoUrl: String
    let audioUrl: String
    let majorModelVersion: String
    let modelName: String
    let metadata: Metadata
    let isLiked: Bool
    let userId: String
    let displayName: String
    let handle: String
    let isHandleUpdated: Bool
    let avatarImageUrl: String
    let isTrashed: Bool
    let createdAt: String
    let status: String
    let title: String
    let playCount: Int
    let upvoteCount: Int
    let isPublic: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case videoUrl = "video_url"
        case audioUrl = "audio_url"
        case majorModelVersion = "major_model_version"
        case modelName = "model_name"
        case metadata
        case isLiked = "is_liked"
        case userId = "user_id"
        case displayName = "display_name"
        case handle
        case isHandleUpdated = "is_handle_updated"
        case avatarImageUrl = "avatar_image_url"
        case isTrashed = "is_trashed"
        case createdAt = "created_at"
        case status
        case title
        case playCount = "play_count"
        case upvoteCount = "upvote_count"
        case isPublic = "is_public"
    }
}

struct Metadata: Codable {
    let prompt: String
    let type: String
    let stream: Bool
}

func makeAPICall(prompt: String) async throws -> [String] {
    let url = URL(string: "http://127.0.0.1:8000/generate")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = RequestBody(prompt: prompt)
    let encodedData = try JSONEncoder().encode(body)
    request.httpBody = encodedData
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let response = try JSONDecoder().decode(Response.self, from: data)
    return response.response.downloadedFiles
}

func generateSong(prompt: String) async throws -> [String: Any] {
    print("\(apiDomain)/generate")
    guard let url = URL(string: "\(apiDomain)/generate") else {
        throw URLError(.badURL)
    }
    print("parameters", prompt)
    
    let parameters = ["prompt": prompt]
    let jsonData = try JSONEncoder().encode(parameters)

    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = 600
    request.httpBody = jsonData
    
    let (data, response) = try await URLSession.shared.data(for: request)
    print("data", data)
    print("response", response)
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
    PlayerView(topic: SampleData.shared.topics.filter({$0.audioURL != nil})[0])
}
