//
//  JourneyBubbleView.swift
//  PackedBubbleChart
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import SwiftUI
import SpriteKit

struct PackedBubbleView: View, BubbleChartDelegate {

    @EnvironmentObject var model: Model
    @Environment(\.colorScheme) var cholorScheme

    @State var selectedTag: Tag?

    mutating func setSelectedTag(tag: Tag?) {
        self.selectedTag = tag
    }

    let maxSize = 70
    let minSize = 40

    func scene(width: CGFloat, height: CGFloat) -> BubbleScene {
        let scene = BubbleScene(size: CGSize(width: width, height: height))
        scene.backgroundColor = cholorScheme == .dark ? .black : .white
        for tag in model.tags.sorted(by: { $0.completionRate > $1.completionRate }) {
            let radius = CGFloat(Int.random(in: minSize...maxSize))
            let node = Node(tag: tag, radius: radius)
            node.name = tag.name
            scene.addChild(node)
        }
        scene.bubbleChartDelegate = self
        return scene
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                SpriteView(
                    scene: scene(width: geometry.size.width, height: geometry.size.height),
                    preferredFramesPerSecond: 30
                )
                .background(cholorScheme == .dark ? .black : .white)
                .navBar(selectedTag: $selectedTag)
            }
        }
    }
}

struct JourneyNavBar: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selectedTag: Tag?
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("PackedBubbleChart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color(colorScheme == .dark ? .black : .white)
                    .blendMode(.normal)
                    .opacity(0.1),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

extension View {
    func navBar(selectedTag: Binding<Tag?>) -> some View {
        modifier(JourneyNavBar(selectedTag: selectedTag))
    }
}

struct JourneyBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        PackedBubbleView()
            .environmentObject(MockModel())
    }
}
