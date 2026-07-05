//
//  CameraSettingsStorage.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 12.02.2024.
//

import Foundation

protocol CameraSettingsStorage {
    var flashControl: FlashCameraControl! { get }
    var formControl: FormCameraControl! { get }
    var deviceControl: VideoDeviceCameraControl! { get }
    var zoomControl: ZoomCameraControl! { get }
    var focusControl: FocusCameraControl! { get }
    var exposureControl: ExposureCameraControl! { get }
    var isoControl: ISOCameraControl! { get }
    var whiteBalanceControl: WhiteBalanceCameraControl! { get }
    var arrangeControl: ArrangeCameraControl! { get }
    var formatControl: FormatCameraControl! { get }
    var frameControl: FrameCameraControl! { get }
    var borderColorControl: BorderColorCameraControl! { get }
    var noiseControl: NoiseCameraControl! { get }
    var contrastControl: ColorCorrectionCameraControl! { get }
    var redControl: ColorCorrectionCameraControl! { get }
    var greenControl: ColorCorrectionCameraControl! { get }
    var blueControl: ColorCorrectionCameraControl! { get }
    var blackWhiteControl: BlackWhiteCameraControl! { get }

    var maxControlCount: Int { get }
    
    func store(_ control: CameraControl)
}

final class CameraSettingsStorageImplementation: CameraSettingsStorage {
    
    static let `default` = CameraSettingsStorageImplementation()
    
    var flashControl: FlashCameraControl!
    var formControl: FormCameraControl!
    var deviceControl: VideoDeviceCameraControl!
    var zoomControl: ZoomCameraControl!
    var focusControl: FocusCameraControl!
    var exposureControl: ExposureCameraControl!
    var isoControl: ISOCameraControl!
    var whiteBalanceControl: WhiteBalanceCameraControl!
    var arrangeControl: ArrangeCameraControl!
    var formatControl: FormatCameraControl!
    var frameControl: FrameCameraControl!
    var borderColorControl: BorderColorCameraControl!
    var noiseControl: NoiseCameraControl!
    var contrastControl: ColorCorrectionCameraControl!
    var redControl: ColorCorrectionCameraControl!
    var greenControl: ColorCorrectionCameraControl!
    var blueControl: ColorCorrectionCameraControl!
    var blackWhiteControl: BlackWhiteCameraControl!

    var maxControlCount: Int {
        return 3 * 6 * 3
    }
    
    func store(_ control: CameraControl) {
        switch control {
        case is FlashCameraControl:
            flashControl = control as? FlashCameraControl
        case is FormCameraControl:
            formControl = control as? FormCameraControl
        case is VideoDeviceCameraControl:
            deviceControl = control as? VideoDeviceCameraControl
        case is ZoomCameraControl:
            zoomControl = control as? ZoomCameraControl
        case is FocusCameraControl:
            focusControl = control as? FocusCameraControl
        case is ExposureCameraControl:
            exposureControl = control as? ExposureCameraControl
        case is ISOCameraControl:
            isoControl = control as? ISOCameraControl
        case is WhiteBalanceCameraControl:
            whiteBalanceControl = control as? WhiteBalanceCameraControl
        case is ArrangeCameraControl:
            arrangeControl = control as? ArrangeCameraControl
        case is FormatCameraControl:
            formatControl = control as? FormatCameraControl
        case is FrameCameraControl:
            frameControl = control as? FrameCameraControl
        case is BorderColorCameraControl:
            borderColorControl = control as? BorderColorCameraControl
        case is NoiseCameraControl:
            noiseControl = control as? NoiseCameraControl
        case is BlackWhiteCameraControl:
            blackWhiteControl = control as? BlackWhiteCameraControl
        case let colorCorrectionControl as ColorCorrectionCameraControl:
            switch colorCorrectionControl.channel {
            case .contrast:
                contrastControl = colorCorrectionControl
            case .red:
                redControl = colorCorrectionControl
            case .green:
                greenControl = colorCorrectionControl
            case .blue:
                blueControl = colorCorrectionControl
            }
        default:
            break
        }
    }
    
}
