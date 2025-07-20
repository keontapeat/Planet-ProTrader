import AVFoundation

class BackgroundAudioPlayer: ObservableObject {
    static let shared = BackgroundAudioPlayer()
    private var player: AVAudioPlayer?

    func play(sound: String, volume: Float = 0.84, loop: Bool = true) {
        if let url = Bundle.main.url(forResource: sound, withExtension: nil) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.volume = volume
                player?.numberOfLoops = loop ? -1 : 0
                player?.play()
            } catch {
                print("Error playing \(sound): \(error)")
            }
        } else {
            print("Audio file \(sound) not found")
        }
    }

    func stop() {
        player?.stop()
    }
}