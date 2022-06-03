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
    
    
    func playStamp() {
        
        guard let url = Bundle.main.url(forResource: "Stamp", withExtension: ".mp3") else {return}
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing stamp sound", error.localizedDescription)
        }
    }
    
    func playBeep() {
        
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: ".mp3") else {return}
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing radio sound", error.localizedDescription)
        }
    }
    
}
