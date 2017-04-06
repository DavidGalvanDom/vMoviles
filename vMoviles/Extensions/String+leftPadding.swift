//
//  String+leftPadding.swift
//  vMoviles
//
//  Created by David Galvan on 4/3/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation


extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let newLength = self.characters.count
        if newLength < toLength {
            return String(repeatElement(character, count: toLength - newLength)) + self
        } else {
            return self.substring(from: index(self.startIndex, offsetBy: newLength - toLength))
        }
    }
}
