//
//  BubbleChartDelegate.swift
//  PackedBubbleChart
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import Foundation

protocol BubbleChartDelegate {
    var selectedTag: Tag? { get set }
    mutating func setSelectedTag(tag: Tag?)
}
