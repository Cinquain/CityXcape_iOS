//
//  SoundManager.swift
//  CityXcape
//
//  Created by James Allan on 3/13/22.
//

import Foundation
import AVKit


class SoundManager {
    
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "Stamp", withExtension: ".mp3") else {return}
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing stamp sound", error.localizedDescription)
        }
    }
    
}
