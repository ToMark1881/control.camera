//
//  Logger.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation

enum LoggerTypes: Int {
    case all
    case requests
    case responses
    case lifecycle
    case gcd
    case parserFactory
    case parserEntity
    case localNotifications
}

class Logger {

    static let shared = Logger()
    
    var enabled: Bool {
        get {
            #if DEBUG
            return true
            #else
            return false
            #endif
        }
    }
    
    private init() {}

    func log(_ error: Error?, descriptions: String? = "", path: String = #file, line: Int = #line, function: String = #function) {
        print("\n")

        if let e = error {
            debugPrint(e)
            print(" ")
        }

        if !(descriptions ?? "").isEmpty {
            print(descriptions!)
            print(" ")
        }
    }

    func log(_ string: String? = "", type: LoggerTypes = .all, function: String = #function) {
        if let s = string, !s.isEmpty {
            self.prepare("\(s)", type: type)
        } else {
            self.prepare("\(function)", type: type)
        }
    }

    func log(_ data: Data?) {
        guard let data = data else { return }
        self.prepare(String(data: data, encoding: String.Encoding.utf8) ?? "", type: .all)
    }

    func log(_ url: URL?) {
        guard let url = url else { return }
        self.prepare(url.absoluteString, type: .all)
    }

    // MARK: - Fileprivate
    fileprivate func prepare(_ string: String, type: LoggerTypes) {
        // just comment unnecessary printing logs
        switch type {
        case .all:
            self.printStr(" - LOGGER \(time()) " + string)
            break
        case .responses:
            self.printStr(" - LOGGER \(time()) ⬅️ Response" + string)
            break
        case .requests:
            self.printStr(" - LOGGER \(time()) ➡️ Request " + string)
            break
        case .lifecycle:
            self.printStr(" - LOGGER \(time()) 💙 Lifecycle " + string)
            break
        case .gcd:
            self.printStr(" - LOGGER \(time()) ⬛ GCD " + string)
            break
        case .localNotifications:
            self.printStr(" - LOGGER \(time()) 📬 Local Notification " + string)
            break
        case .parserEntity:
            self.printStr(" - LOGGER \(time()) ✏️ Entity Parser " + string)
            break
        case .parserFactory:
            self.printStr(" - LOGGER \(time()) 🏭 Factory Parsers " + string)
            break
        }
    }
    
    private func printStr(_ str: String) {
        guard self.enabled else { return }
        print(str)
    }

    private func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter.string(from: Date())
    }
}
