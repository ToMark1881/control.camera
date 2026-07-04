//
//  CaptureEventListeningService.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.04.2024.
//

import UIKit
import AVKit

protocol CaptureEventListeningService {
    func start()
    func stop()
}

protocol CaptureEventListeningServiceOutput: AnyObject {
    func didReceiveCaptureEvent()
}

class CaptureEventListeningServiceImplementation: CaptureEventListeningService {

    weak var output: CaptureEventListeningServiceOutput?
    weak var viewController: UIViewController?

    private var interaction: UIInteraction?

    func start() {
        guard #available(iOS 17.2, *) else { return }

        if interaction == nil {
            attachInteraction()
        }

        (interaction as? AVCaptureEventInteraction)?.isEnabled = true
    }

    func stop() {
        guard #available(iOS 17.2, *) else { return }

        (interaction as? AVCaptureEventInteraction)?.isEnabled = false
    }

    // Handles hardware capture events: volume buttons and the Camera Control
    // button on supported devices. Requires an active capture session,
    // otherwise the system keeps the default hardware button behavior.
    @available(iOS 17.2, *)
    private func attachInteraction() {
        guard let view = viewController?.viewIfLoaded else { return }

        let interaction = AVCaptureEventInteraction { [weak self] event in
            // .began matches the on-screen shutter, which fires on touch down
            guard event.phase == .began else { return }
            self?.output?.didReceiveCaptureEvent()
        }

        view.addInteraction(interaction)
        self.interaction = interaction
    }

}
