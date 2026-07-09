//  VIPER Template created by Vladyslav Vdovychenko
//
//  ManagePresetsViewOutput.swift
//  control.camera
//

import Foundation

protocol ManagePresetsViewOutput: AnyObject {
    func onViewDidLoad()

    func didRenamePreset(at index: Int, to name: String)
    func didDeletePreset(at index: Int)
}
