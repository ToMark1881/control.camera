//
//  LivePreviewEffectsService.swift
//  control.camera
//

import Foundation
import AVFoundation
import CoreImage

protocol LivePreviewEffectsService: AnyObject {
    /// Re-reads the effects state from the settings storage and
    /// enables/disables the filtered preview pipeline. Main thread only
    func refresh()
}

class LivePreviewEffectsServiceImplementation: NSObject, LivePreviewEffectsService {

    // MARK: - Injected

    weak var view: CameraViewConfiguration!
    weak var camera: CameraConfiguration!
    var settingsStorage: CameraSettingsStorage!
    var colorCorrectionApplyingService: ColorCorrectionApplyingService!
    var filmGrainApplyingService: FilmGrainApplyingService!
    var frameApplyingService: FrameApplyingService!
    var croppingService: CroppingService!

    // MARK: - Private

    private struct EffectsState {
        static let inactive = EffectsState(colorCorrection: CurveColorCorrection(contrast: 0, red: 0, green: 0, blue: 0),
                                           isBlackWhiteActive: false,
                                           noiseIntensity: 0,
                                           noiseGrainSize: 1,
                                           frameRelativeWidth: 0,
                                           frameColor: BorderColorCameraControl.BorderColor.white.cgColor,
                                           formAspectRatio: FormCameraControl.PhotoAspectRatio.threeByFour.aspectRatio)

        let colorCorrection: CurveColorCorrection
        let isBlackWhiteActive: Bool
        let noiseIntensity: CGFloat
        let noiseGrainSize: CGFloat
        let frameRelativeWidth: CGFloat
        let frameColor: CGColor
        let formAspectRatio: CGFloat

        var isActive: Bool {
            return !colorCorrection.isNeutral
                || isBlackWhiteActive
                || noiseIntensity > 0
                || frameRelativeWidth > 0
        }
    }

    private let stateLock = NSLock()
    private var state = EffectsState.inactive
    private var needsReveal = false

    private weak var renderView: FilteredPreviewView?

    func refresh() {
        let newState = currentState()

        renderView = view?.cameraContainerView.filteredPreviewView

        let shouldReveal = newState.isActive && (renderView?.isHidden ?? true)

        stateLock.lock()
        state = newState
        needsReveal = shouldReveal
        stateLock.unlock()

        camera?.setLivePreviewEffects(active: newState.isActive)

        if !newState.isActive {
            view?.cameraContainerView.setFilteredPreview(visible: false)
        }
    }

}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension LivePreviewEffectsServiceImplementation: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        stateLock.lock()
        let currentState = state
        stateLock.unlock()

        guard currentState.isActive,
              let renderView = renderView,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        var image = CIImage(cvPixelBuffer: pixelBuffer)

        // The same services as in the saving pipeline, so the preview
        // matches the stored photo: correction -> black and white -> grain
        if !currentState.colorCorrection.isNeutral {
            image = colorCorrectionApplyingService.applyCorrection(currentState.colorCorrection, to: image)
        }

        if currentState.isBlackWhiteActive {
            image = colorCorrectionApplyingService.applyMonochrome(to: image)
        }

        if currentState.noiseIntensity > 0 {
            image = filmGrainApplyingService.applyGrain(to: image,
                                                        intensity: currentState.noiseIntensity,
                                                        grainSize: currentState.noiseGrainSize)
        }

        if currentState.frameRelativeWidth > 0 {
            // Emulate the aspect crop of the saving pipeline first, so the
            // border wraps the final composition, and fit the result over a
            // border-colored background to keep it fully visible
            let cropRect = croppingService.crop(size: image.extent.size,
                                                for: currentState.formAspectRatio)
            image = image.cropped(to: cropRect)
            image = frameApplyingService.applyFrame(to: image,
                                                    relativeWidth: currentState.frameRelativeWidth,
                                                    color: currentState.frameColor)

            renderView.render(image, fittedOver: CIColor(cgColor: currentState.frameColor))
        } else {
            renderView.render(image)
        }

        revealRenderViewIfNeeded()
    }

}

extension LivePreviewEffectsServiceImplementation {

    /// The render view is unhidden only after the first frame is drawn,
    /// so switching the effects on never flashes a black screen
    private func revealRenderViewIfNeeded() {
        stateLock.lock()
        let shouldReveal = needsReveal
        needsReveal = false
        stateLock.unlock()

        guard shouldReveal else { return }

        DispatchQueue.main.async { [weak self] in
            self?.view?.cameraContainerView.setFilteredPreview(visible: true)
        }
    }

    private func currentState() -> EffectsState {
        // RAW is saved untouched, so effects are not previewed
        // in this format either
        guard settingsStorage.formatControl?.photoFormat != .raw else {
            return .inactive
        }

        let correction = CurveColorCorrection(contrast: settingsStorage.contrastControl?.normalizedLevel ?? 0,
                                              red: settingsStorage.redControl?.normalizedLevel ?? 0,
                                              green: settingsStorage.greenControl?.normalizedLevel ?? 0,
                                              blue: settingsStorage.blueControl?.normalizedLevel ?? 0)

        let noiseControl = settingsStorage.noiseControl
        let frameControl = settingsStorage.frameControl
        let borderColor = settingsStorage.borderColorControl?.selectedColor ?? .white
        let aspectRatio = settingsStorage.formControl?.aspectRatio ?? .threeByFour

        return EffectsState(colorCorrection: correction,
                            isBlackWhiteActive: settingsStorage.blackWhiteControl?.isActive ?? false,
                            noiseIntensity: noiseControl?.isActive == true ? (noiseControl?.grainIntensity ?? 0) : 0,
                            noiseGrainSize: noiseControl?.grainSize ?? 1,
                            frameRelativeWidth: frameControl?.isActive == true ? (frameControl?.selectedWidth ?? 0) : 0,
                            frameColor: borderColor.cgColor,
                            formAspectRatio: aspectRatio.aspectRatio)
    }

}
