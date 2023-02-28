//
//  Tag.swift
//  PackedBubbleChart
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import Foundation
import SwiftUI

struct Tag {
    let id: UUID
    let name: String
    let color: Color
    let completionRate: Double
    
    init(id: UUID? = nil, name: String, color: Color, completionRate: Double) {
        self.id = id ?? UUID()
        self.name = name
        self.color = color
        self.completionRate = completionRate
    }
}
