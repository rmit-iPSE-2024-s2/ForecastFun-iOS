//
//  Item.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 11/9/2024.
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
