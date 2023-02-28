//
//  Model.swift
//  PackedBubbleChart
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import Foundation

class Model: ObservableObject {
    
    @Published var tags: [Tag]
    
    init(tags: [Tag]) {
        self.tags = tags
    }
}
