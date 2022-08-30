//
//  ErrorFactory.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation

struct ErrorsFactory {

    struct General {
        static let connection: NSError = ErrorsFactory.error(with: "No internet connection", code: 99999)
        static let unknown: NSError = ErrorsFactory.error(with: "Unknown error", code: 99998)
        static let location: NSError = ErrorsFactory.error(with: "Location Services Off", code: 99997)
        static let serverUrlIsMissing: NSError = ErrorsFactory.error(with: "Server URL is missing", code: 99996)
        static let processIsBusy: NSError = ErrorsFactory.error(with: "The process is busy", code: 99995)
        static let parsingError: NSError = ErrorsFactory.error(with: "Parsing error")
    }

    private static func error(with message: String, code: Int = 0) -> NSError {
        return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
