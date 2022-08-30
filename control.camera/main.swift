//
//  main.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation
import UIKit

let start = Date().timeIntervalSince1970

// very first statement after load.. the current time
let WaysStartTime = CFAbsoluteTimeGetCurrent()

// build the parameters for the call to UIApplicationMain()
let argc = CommandLine.argc
//let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))

// start the main loop
//UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.self))
 UIApplicationMain(
    argc, CommandLine.unsafeArgv,
    nil, NSStringFromClass(AppDelegate.self)
)
