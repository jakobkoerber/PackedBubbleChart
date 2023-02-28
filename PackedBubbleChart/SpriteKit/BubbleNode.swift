//
//  BubbleNode.swift
//  PackedBubbleChart
//
//  Created by Jakob Paul Körber on 28.02.23.
//  Inspired by: https://github.com/efremidze/Magnetic
//

import SpriteKit
import SwiftUI

class Node: SKShapeNode {

    var tag: Tag?

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(tag: Tag, radius: CGFloat) {
        let path = SKShapeNode(circleOfRadius: radius).path!
        self.init(tag: tag, path: path)
    }

    init(tag: Tag, path: CGPath) {
        super.init()
        self.path = path
        regeneratePhysicsBody(withPath: path)
        configure(tag: tag)
    }

    open func configure(tag: Tag) {
        // label
        let name = tag.name.replacingOccurrences(of: " ", with: "\n")
        let labelNode = SKLabelNode(text: name)
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        let nodeFrame = calculateAccumulatedFrame()
        let scalingFactor = min((nodeFrame.width - 32) / labelNode.frame.width, (nodeFrame.height - 32) / labelNode.frame.height)
        labelNode.fontSize *= scalingFactor
        labelNode.fontName = "SFPro-Regular"
        let multiLined = Self.multipleLineText(labelInPut: labelNode)
        self.addChild(multiLined)

        // node itself
        self.fillTexture = SKTexture(size: self.frame.size, amountDone: tag.completionRate, tagColor: tag.color)
        self.fillColor = .white
        self.lineWidth = CGFloat(10)
        self.strokeColor = UIColor.systemBackground
        self.tag = tag
    }

    func regeneratePhysicsBody(withPath path: CGPath) {
        self.physicsBody = {
            let body = SKPhysicsBody(polygonFrom: path.copy()!)
            body.allowsRotation = false
            body.friction = 0
            body.linearDamping = 3
            return body
        }()
    }

    /// source: https://stackoverflow.com/a/33067471 slightly modified
    static func multipleLineText(labelInPut: SKLabelNode) -> SKLabelNode {
        let subStrings: [String] = labelInPut.text!.components(separatedBy: "\n")
        var labelOutPut = SKLabelNode()
        var subStringNumber: Int = 0
        for subString in subStrings {
            let labelTemp = SKLabelNode(fontNamed: labelInPut.fontName)
            labelTemp.text = subString
            labelTemp.fontColor = labelInPut.fontColor
            labelTemp.fontSize = labelInPut.fontSize
            labelTemp.position = labelInPut.position
            labelTemp.horizontalAlignmentMode = labelInPut.horizontalAlignmentMode
            labelTemp.verticalAlignmentMode = labelInPut.verticalAlignmentMode
            let yPos = CGFloat(subStringNumber) * labelInPut.fontSize
            if subStringNumber == 0 && subStrings.count > 1 {
                labelTemp.position = CGPoint(x: 0, y: labelInPut.fontSize * CGFloat(subStrings.count) / 2.0)
                labelOutPut = labelTemp
                subStringNumber += 1
            } else {
                labelTemp.position = CGPoint(x: 0, y: -yPos)
                labelOutPut.addChild(labelTemp)
                subStringNumber += 1
            }
        }
        labelOutPut.position = CGPoint(x: 0, y: labelOutPut.frame.height * 0.5 * CGFloat(subStrings.count - 1))
        return labelOutPut
    }
}

extension SKTexture {
    convenience init(size: CGSize, amountDone: Double, tagColor: Color) {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let locations = Self.getLocation(amountDone: amountDone)
            let colorSpace = context.cgContext.colorSpace ?? CGColorSpaceCreateDeviceRGB()
            let colors = [UIColor.systemGray3, UIColor(tagColor)].map({ $0.cgColor }) as CFArray
            guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: UnsafePointer<CGFloat>(locations)) else {
                return
            }
            let startPoint = CGPoint(x: size.width / 2, y: 0)
            let endPoint = CGPoint(x: size.width / 2, y: size.height)
            context.cgContext.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        }
        self.init(image: image)
    }

    private static func getLocation(amountDone: Double) -> [CGFloat] {
        if amountDone <= 0.5 {
            var gradientValue = 0.0
            if (1 - 2 * amountDone) >= 0 && (1 - 2 * amountDone) <= 1 {
                gradientValue = 1 - 2 * amountDone
            } else if (1 - 2 * amountDone) > 1 {
                gradientValue = 1.0
            }
            return [CGFloat(gradientValue), CGFloat(1)]
        } else {
            var gradientValue = 1.0
            if (-2 * amountDone + 2) <= 1 && (-2 * amountDone + 2) >= 0 {
                gradientValue = -2 * amountDone + 2
            } else if (-2 * amountDone + 2) < 0 {
                gradientValue = 0.0
            }
            return [CGFloat(0), CGFloat(gradientValue)]
        }
    }
}
