//
//  String+Extensions.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation
import Security
import UIKit

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

extension String {
    
    func isNumbers(minLength: Int = 1, maxLength: Int = 16) -> Bool { // is numbers and . + -
        let phoneRegex = "^[0-9.+-]{\(minLength),\(maxLength)}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    func getCleanedURL() -> URL? {
        guard self.isEmpty == false else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let escapedURL = URL(string: urlEscapedString) {
                return escapedURL
            }
        }
        return nil
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        
        return from ..< to
    }
    
    subscript(r: CountableClosedRange<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[startIndex...endIndex])
    }
    
    var toDouble: Double? {
        
        if let iosVersion = Double(self) {
            return iosVersion
        }
        
        let arr = components(separatedBy: ".")
        if arr.count >= 1 {
            var integerPart = 0
            var floatPart = 0
            
            if let _integerPart = Int(arr[0]), !arr[0].isEmpty {
                integerPart = _integerPart
            }
            
            if let _floatPart = Int(arr[1]), !arr[1].isEmpty {
                floatPart = _floatPart
            }
            
            return Double("\(integerPart).\(floatPart)")
        }
        return nil
    }
    
    func clear(start: String, end: String) -> String {
        var string = self as NSString
        
        while true {
            var result = ""
            //            var string = str
            let startRange = string.range(of: start)
            
            if startRange.location == NSNotFound {
                break
            }
            let rangeStart = NSRange(location: 0, length: startRange.location)
            result += string.substring(with: rangeStart)
            
            let endrange = string.range(of: end)
            if endrange.location == NSNotFound {
                break
            }
            
            let endIndex = endrange.location + end.count
            let rangeEnd = NSRange(location: endIndex, length: string.length - endIndex)
            
            result += string.substring(with: rangeEnd)
            
            string = result as NSString
        }
        
        return string as String
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func insert(_ string: String, ind: Int) -> String {
        return String(self.prefix(ind)) + string + String(self.suffix(self.count - ind))
    }
    
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    
    func normalizeString() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    mutating func preparedToHtmlString() -> String {
        self = self.replacingOccurrences(of: "<li>", with: "")
        self = self.replacingOccurrences(of: "</li>", with: "<br>")
        self = self.replacingOccurrences(of: "\r\n\t", with: "")
        
        return self
    }
    
    func removeHtmlAmpersandSymbols() -> String {
        var fixed = self
        fixed = fixed.replacingOccurrences(of: "&laquo;", with: "")
        fixed = fixed.replacingOccurrences(of: "&raquo;", with: "")
        fixed = fixed.replacingOccurrences(of: "&nbsp;", with: "")
        fixed = fixed.replacingOccurrences(of: "&quot;", with: "")
        fixed = fixed.replacingOccurrences(of: "&ndash;", with: "")
        fixed = fixed.replacingOccurrences(of: "&bull;", with: "")
        fixed = fixed.replacingOccurrences(of: "&mdash;", with: "")
        
        return fixed
    }
    
    var html2AttributedString: NSAttributedString? {
        guard let d = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        let attributes: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.paragraphSpacing = 8
        
        do {
            let attrStr = try NSAttributedString(data: d, options: attributes, documentAttributes: nil)
            
            let attrStrModified = NSMutableAttributedString(attributedString: attrStr)
            var textAttributes = [NSAttributedString.Key: Any]()
            if #available(iOS 13.0, *) {
                textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.label]
            } else {
                textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]
            }
            let paragraphStyle = NSMutableParagraphStyle()
            let nonOptions = [NSTextTab.OptionKey: Any]()
            
            paragraphStyle.headIndent = 12
            paragraphStyle.defaultTabInterval = 12
            paragraphStyle.paragraphSpacing = 8
            paragraphStyle.tabStops = [
                NSTextTab(textAlignment: .left, location: 12, options: nonOptions)]
            paragraphStyle.firstLineHeadIndent = 0
            
            let array = attrStrModified.string.components(separatedBy: " ")
            
            let result = NSMutableAttributedString()
            
            for item in array where !item.isEmpty {
                let range = NSRange(location: 0, length: item.count)
                let stringToAdd = item + " "
                let attrString = NSMutableAttributedString(string: stringToAdd)
                if item.contains("•") {
                    attrString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
                } else {
                    attrString.addAttributes([NSAttributedString.Key.paragraphStyle: titleStyle], range: range)
                }
                attrString.addAttributes(textAttributes, range: range)
                result.append(attrString)
            }
            
            attrStrModified.enumerateAttribute(NSAttributedString.Key.link, in: NSRange(location: 0, length: attrStrModified.length), options: [.longestEffectiveRangeNotRequired]) { value, range, _ in
                if let value = value {
                    result.addAttribute(.link, value: value, range: range)
                }
            }
            
            return result
        } catch let error as NSError {
            Logger.shared.log(error)
            return nil
        }
    }
    
    var html2String: String {
        let html = self.html2AttributedString
        let res = html?.string.replacingOccurrences(of: "\t•", with: "")
        
        return res ?? ""
    }
    
    func index(of string: String, options: String.CompareOptions = .literal) -> String.Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func indexes(of string: String, options: String.CompareOptions = .literal) -> [String.Index] {
        var result: [String.Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    func ranges(of string: String, options: String.CompareOptions = .literal) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    
    func clearFromTags() -> String {
        return self.replacingOccurrences(of: "\r\n\r\n", with: "")
    }
    
    func clearHtml() -> String {
        var res: String = self.removeHtmlAmpersandSymbols().replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        while true {
            let str = res.first
            
            if (str == "\n" || str == "\t" || str == "\r" || str == "\r\n") {
                res.remove(at: res.startIndex)
            } else {
                break
            }
        }
        
        return res.replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\n\n\n", with: "\n").replacingOccurrences(of: "\n\n", with: "\n")
    }
    
    func safelyLimitedTo(length: Int) -> String {
        if (self.count <= length) {
            return self
        }
        return String(Array(self).prefix(upTo: length))
    }
    
    /// Returns `Date` converted from String with server format
    func convertToDate(withFormat format: String = kServerDateTimeFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
}
