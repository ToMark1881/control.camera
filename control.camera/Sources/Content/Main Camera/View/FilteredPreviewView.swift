//
//  FilteredPreviewView.swift
//  control.camera
//

import UIKit
import MetalKit
import CoreImage

/// Metal-backed render target for the live effects preview.
/// AVCaptureVideoPreviewLayer cannot display filtered frames,
/// so filtered frames are drawn into this view instead
class FilteredPreviewView: MTKView {

    private lazy var commandQueue: MTLCommandQueue? = device?.makeCommandQueue()
    private lazy var ciContext: CIContext? = device.map { CIContext(mtlDevice: $0) }
    private let colorSpace = CGColorSpaceCreateDeviceRGB()

    private let imageLock = NSLock()
    private var pendingImage: CIImage?
    private var pendingBackground: CIColor?

    convenience init(frame: CGRect) {
        self.init(frame: frame, device: MTLCreateSystemDefaultDevice())
    }

    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    /// Thread-safe, can be called from the video output queue
    func render(_ image: CIImage) {
        enqueue(image, background: nil)
    }

    /// Renders the image aspect-fitted over a solid background, so a
    /// composition with a different aspect (e.g. a bordered photo)
    /// stays fully visible. Thread-safe
    func render(_ image: CIImage, fittedOver background: CIColor) {
        enqueue(image, background: background)
    }

    override func draw(_ rect: CGRect) {
        imageLock.lock()
        let image = pendingImage
        let background = pendingBackground
        pendingImage = nil
        imageLock.unlock()

        guard let image = image,
              let ciContext = ciContext,
              let drawable = currentDrawable,
              let commandBuffer = commandQueue?.makeCommandBuffer() else {
            return
        }

        let drawableBounds = CGRect(x: 0,
                                    y: 0,
                                    width: drawable.texture.width,
                                    height: drawable.texture.height)

        let composed: CIImage

        if let background = background {
            let backgroundImage = CIImage(color: background).cropped(to: drawableBounds)
            composed = aspectFitted(image, in: drawableBounds).composited(over: backgroundImage)
        } else {
            composed = aspectFilled(image, in: drawableBounds)
        }

        ciContext.render(composed,
                         to: drawable.texture,
                         commandBuffer: commandBuffer,
                         bounds: drawableBounds,
                         colorSpace: colorSpace)

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

}

private extension FilteredPreviewView {

    func enqueue(_ image: CIImage, background: CIColor?) {
        imageLock.lock()
        pendingImage = image
        pendingBackground = background
        imageLock.unlock()

        draw()
    }

    func commonInit() {
        if device == nil {
            device = MTLCreateSystemDefaultDevice()
        }

        framebufferOnly = false
        isPaused = true
        enableSetNeedsDisplay = false
        isUserInteractionEnabled = false
        backgroundColor = .black
    }

    /// Mirrors the resizeAspectFill behavior of the camera preview layer
    func aspectFilled(_ image: CIImage, in bounds: CGRect) -> CIImage {
        let extent = image.extent

        guard extent.width > 0, extent.height > 0 else {
            return image
        }

        let scale = max(bounds.width / extent.width, bounds.height / extent.height)
        let scaled = image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        let dx = bounds.midX - scaled.extent.midX
        let dy = bounds.midY - scaled.extent.midY

        return scaled
            .transformed(by: CGAffineTransform(translationX: dx, y: dy))
            .cropped(to: bounds)
    }

    func aspectFitted(_ image: CIImage, in bounds: CGRect) -> CIImage {
        let extent = image.extent

        guard extent.width > 0, extent.height > 0 else {
            return image
        }

        let scale = min(bounds.width / extent.width, bounds.height / extent.height)
        let scaled = image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        let dx = bounds.midX - scaled.extent.midX
        let dy = bounds.midY - scaled.extent.midY

        return scaled
            .transformed(by: CGAffineTransform(translationX: dx, y: dy))
            .cropped(to: bounds)
    }

}
