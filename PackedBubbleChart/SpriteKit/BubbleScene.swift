//
//  BubbleScene.swift
//  PackedBubbleChart
//
//  Created by Jakob Paul Körber on 28.02.23.
//  Inspired by: https://github.com/efremidze/Magnetic
//

import SpriteKit

class BubbleScene: SKScene {

    var bubbleChartDelegate: BubbleChartDelegate?
    var previousCameraPoint = CGPoint.zero
    var cameraDifference: (Double, Double) = (.zero, .zero)

    open lazy var magneticField: SKFieldNode = { [unowned self] in
        let field = SKFieldNode.radialGravityField()
        self.addGravityChild(field)
        return field
    }()

    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .aspectFill
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(cameraNode)
        self.camera = cameraNode
        configureGravity()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGravity()
    }

    func configureGravity() {
        let strength = Float(max(size.width, size.height))
        let radius = strength.squareRoot() * 100

        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: { () -> CGRect in
            var frame = self.frame
            frame.size.width = CGFloat(radius)
            frame.size.height = CGFloat(radius)
            frame.origin.x -= frame.size.width / 2
            return frame
        }())

        magneticField.region = SKRegion(radius: radius)
        magneticField.minimumRadius = radius
        magneticField.strength = strength
        magneticField.position = CGPoint(x: frame.midX, y: frame.midY)
        self.view?.showsFields = true
    }


    func addGravityChild(_ node: SKFieldNode) {
        node.position = CGPoint(x: 0.0, y: 0.0)
        super.addChild(node)
    }

    override open func addChild(_ node: SKNode) {
        if super.children.count == 2 || super.children.isEmpty {
            node.physicsBody?.isDynamic = false
            node.position = CGPoint(x: frame.midX, y: frame.midY)
        } else {
            if children.count % 2 == 0 {
                let xValue = -node.frame.width
                let yValue = CGFloat.random(0, self.frame.height)
                node.position = CGPoint(x: xValue, y: yValue)
            } else {
                let xValue = self.frame.width + node.frame.width
                let yValue = CGFloat.random(0, self.frame.height)
                node.position = CGPoint(x: xValue, y: yValue)
            }
        }
        super.addChild(node)
    }

    open func node(at point: CGPoint) -> Node? {
        nodes(at: point)
            .compactMap {
                $0 as? Node
            }
            .first(where: {
                $0.path!.contains(convert(point, to: $0))
            })
    }
}

// MARK: - Gestures (panGesture found on https://stackoverflow.com/questions/38865788/moving-camera-in-spritekit-swift)
extension BubbleScene {
    override func didMove(to view: SKView) {
        let panGesture = UIPanGestureRecognizer()
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        panGesture.addTarget(self, action: #selector(panGestureAction(_:)))
        tapGesture.addTarget(self, action: #selector(tapGestureAction(_:)))
        doubleTapGesture.addTarget(self, action: #selector(doubleTapGestureAction(_:)))
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(doubleTapGesture)
    }

    @objc func tapGestureAction(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            var location = sender.location(ofTouch: 0, in: self.view)
            let xLocation = (location.x + cameraDifference.0)
            let yLocation = (self.size.height - location.y + cameraDifference.1)
            location = CGPoint(x: xLocation, y: yLocation)

            guard let node = node(at: location) else {
                return
            }
            addSelectedTag(tag: node.tag)
        }
    }

    @objc func doubleTapGestureAction(_ sender: UITapGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        if sender.state == .ended {
            camera.position = CGPoint(x: frame.midX, y: frame.midY)
            cameraDifference = (0, 0)
        }
    }

    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }

        if sender.state == .began {
            previousCameraPoint = camera.position
        }

        let translation = sender.translation(in: self.view)

        guard previousCameraPoint.x + translation.x * -1 > -100 && previousCameraPoint.x + translation.x * -1 < self.size.width + 100 else {
            return
        }

        guard previousCameraPoint.y + translation.y > -100 && previousCameraPoint.y + translation.y < self.size.height + 100 else {
            return
        }

        let newPosition = CGPoint(
            x: previousCameraPoint.x + translation.x * -1,
            y: previousCameraPoint.y + translation.y
        )
        camera.position = newPosition
        cameraDifference = (newPosition.x - frame.midX, newPosition.y - frame.midY)
    }
}

extension BubbleScene {
    private func addSelectedTag(tag: Tag?) {
        if var bubbleChartDelegate = self.bubbleChartDelegate {
            bubbleChartDelegate.setSelectedTag(tag: tag)
        }
    }
}

extension CGFloat {
    static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        lower <= upper ? CGFloat.random(in: lower...upper) : CGFloat.random(in: upper...lower)
    }
}
