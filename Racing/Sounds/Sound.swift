//
//  Sound.swift
//  Racing
//
//  Created by Artem Listopadov on 4/25/21.
//  Copyright © 2021 Artem Listopadov. All rights reserved.
//

import Foundation
import AVFoundation

enum gameSounds: String {
    case coin = "Coin"
    case crash = "Crash"
    case menu = "Menu"
    case gameOver = "GameOver"
    case score =  "Score"
    case settings = "Settings"
}

class Player {
    
    var audioPlayer: AVAudioPlayer!
    
    func playSoundMp3(soundName: String) {
        if let path = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do{
                audioPlayer?.prepareToPlay()
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer?.play()
            } catch let error {
                print("Player:",error)
            }
        }
    }
    
    func playSoundWav(soundName: String) {
        if let path = Bundle.main.url(forResource: soundName, withExtension: "wav")  {
            do{
                audioPlayer?.prepareToPlay()
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer?.play()
            } catch let error {
                print("Player:",error)
            }
        }
    }
    
    func volumeMusic(volume: Float)  {
        audioPlayer?.volume = volume
    }
}
