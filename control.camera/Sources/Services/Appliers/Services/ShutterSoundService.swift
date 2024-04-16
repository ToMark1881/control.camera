//
//  ShutterSoundService.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 14.04.2024.
//

import AudioToolbox

protocol ShutterSoundService {
    func play()
    func prepare()
}

class ShutterSoundServiceImplementation: ShutterSoundService {
    
    private var shutterSound: SystemSoundID = {
        var aSound: SystemSoundID = 1000
        if let soundURL = Bundle.main.url(forResource: Sounds.shutterSound01, withExtension: "wav") {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &aSound)
            print("Initialised aSound:\(aSound)")
        } else {
            print("You have forgotten to add your sound file to the app.")
        }
        return aSound
    }()
    
    func play() {
        AudioServicesPlaySystemSound(shutterSound)
    }
    
    func prepare() {
        let _ = shutterSound
    }
    
}
