//
//  VolumeButtonListeningService.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.04.2024.
//

import Foundation
import AVFoundation

protocol VolumeButtonListeningService {
    func start()
    func stop()
}

protocol VolumeButtonListeningServiceOutput: AnyObject {
    func didTapVolumeButton()
}

class VolumeButtonListeningServiceImplementation: VolumeButtonListeningService {
    
    weak var output: VolumeButtonListeningServiceOutput?
    
    private var outputVolumeObserve: NSKeyValueObservation?
    private let audioSession = AVAudioSession.sharedInstance()
    
    func start() {
        do {
            try audioSession.setActive(true)
        } catch {}

        outputVolumeObserve = audioSession.observe(\.outputVolume) { [weak self] (audioSession, changes) in
            self?.output?.didTapVolumeButton()
        }
    }
    
    func stop() {
        outputVolumeObserve?.invalidate()
    }
    
}
