//
//  SoundController.swift
//  CanBreak
//
//  Created by Can Babaoğlu on 1.11.2022.
//

import AVFoundation

class SoundController {
    static let shared = SoundController()
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var popEffect: AVAudioPlayer?
    
    private init() {
        popEffect = preloadSoundEffect("pop.wav")
    }
    
    func playBackgroundMusic(_ filename: String) {
        backgroundMusicPlayer = preloadSoundEffect(filename)
        backgroundMusicPlayer?.numberOfLoops = -1
        backgroundMusicPlayer?.play()
        backgroundMusicPlayer?.setVolume(0.5, fadeDuration: 0.1)
    }
    
    func playPopEffect() {
        popEffect?.play()
    }
    
    func preloadSoundEffect(_ filename: String) -> AVAudioPlayer? {
        if let url = Bundle.main.url(forResource: filename,
                                     withExtension: nil) {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                return player
            } catch {
                print("file \(filename) not found")
            }
        }
        return nil
    }
    
    
}
