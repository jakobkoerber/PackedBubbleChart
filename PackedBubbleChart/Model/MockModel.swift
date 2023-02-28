//
//  MockModel.swift
//  PackedBubbleChart
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import Foundation

class MockModel: Model {
    public convenience init() {
        let tags: [Tag] = [
            Tag(name: "MockTag1", color: .blue, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag2", color: .red, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag3", color: .green, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag4", color: .yellow, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag5", color: .orange, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag6", color: .purple, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag7", color: .teal, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag8", color: .cyan, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag9", color: .mint, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag10", color: .indigo, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag11", color: .pink, completionRate: Double.random(in: 0.0...1.0)),
            Tag(name: "MockTag12", color: .white, completionRate: Double.random(in: 0.0...1.0))
        ]
        self.init(tags: tags)
    }
}
