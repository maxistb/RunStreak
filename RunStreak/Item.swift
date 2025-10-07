//
//  Item.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
