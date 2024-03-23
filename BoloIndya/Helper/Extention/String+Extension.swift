//
//  String+Extension.swift
//  BoloIndya
//
//  Created by Rahul Garg on 06/01/21.
//  Copyright © 2021 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

extension String {
    func htmlToAttributedString(font: UIFont? = nil) -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let font = font ?? UIFont.systemFont(ofSize: 14)
            let fontAttribute = [NSAttributedString.Key.font: font,
                                 NSAttributedString.Key.foregroundColor: UIColor.white]
            attributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attributedString.length))
            
            let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
            var range = (attributedString.string as NSString).rangeOfCharacter(from: invertedSet)
            let loc = range.length > 0 ? range.location : 0
            
            range = (attributedString.string as NSString).rangeOfCharacter(from: invertedSet, options: .backwards)
            let len = (range.length > 0 ? NSMaxRange(range) : attributedString.string.count) - loc
            let r = attributedString.attributedSubstring(from: NSRange(location: loc, length: len))
            return r
        } catch {
            print(error)
        }
        
        return nil
    }
    
//    func htmlAttributedString() -> NSAttributedString? {
//        guard let data = self.data(using: .utf8) else {
//            return nil
//        }
//
//        return try? NSAttributedString(
//            data: data,
//            options: [.documentType: NSAttributedString.DocumentType.html],
//            documentAttributes: nil
//        )
//    }
}
