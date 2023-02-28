//
//  PackedBubbleChartApp.swift
//  PackedBubbleChart
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import SwiftUI

@main
struct PackedBubbleChartApp: App {
    
    @StateObject var model = MockModel() as Model
    
    var body: some Scene {
        WindowGroup {
            PackedBubbleView()
                .environmentObject(model)
        }
    }
}
