//
//  MaterialDesignSpinner.swift
//  MaterialDesignSpinner
//
//  Created by Bas van Kuijck on 12/11/2019.
//  Copyright © 2019 E-sites. All rights reserved.
//

import UIKit
import Foundation

open class MaterialDesignSpinner: UIView {
    private enum Constants {
        static let ringRotationAnimationKey = "ringRotationAnimationKey"
        static let ringStrokeAnimationKey = "ringStrokeAnimationKey"
    }

    @IBInspectable
    public var hidesWhenStopped: Bool = true {
        didSet {
            isHidden = !isAnimating && hidesWhenStopped
        }
    }

    public var lineCap: CAShapeLayerLineCap = .round {
        didSet {
            progressLayer.lineCap = lineCap
            updatePath()
        }
    }

    public var percentageComplete: CGFloat = 0 {
        didSet {
            updatePercentageComplete()
        }
    }

    @IBInspectable
    public var duration: TimeInterval = 1.5

    @IBInspectable
    public var lineWidth: CGFloat = 1.5 {
        didSet {
            progressLayer.lineWidth = lineWidth
            updatePath()
        }
    }

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = tintColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = lineWidth
        layer.lineCap = lineCap
        return layer
    }()

    private var _isAnimating: Bool = false

    @IBInspectable
    public var isAnimating: Bool {
        get {
            return _isAnimating
        }
        set {
            if newValue {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }

    override open var tintColor: UIColor! {
        didSet {
            progressLayer.strokeColor = tintColor.cgColor
        }
    }

    // MARK: - Initialization
    // --------------------------------------------------------

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(resetAnimations), name: UIApplication.didBecomeActiveNotification, object: nil)
        invalidateIntrinsicContentSize()
        layer.addSublayer(progressLayer)
        updatePath()
    }

    // MARK: - Layout
    // --------------------------------------------------------

    override public var intrinsicContentSize: CGSize {
        return bounds.size
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.frame = bounds
        invalidateIntrinsicContentSize()
        updatePath()
    }

    private func updatePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.size.width / 2, bounds.size.height / 2) - (lineWidth / 2)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = percentageComplete
    }

    private func updatePercentageComplete() {
        if isAnimating {
            return
        }
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = percentageComplete
    }

    // MARK: - Animation
    // --------------------------------------------------------

    @objc
    private func resetAnimations() {
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }

    public func startAnimating() {
        if isAnimating {
            return
        }
        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = duration / 0.375
        animation.fromValue = 0.0
        animation.toValue = 2.0 * Double.pi
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: Constants.ringRotationAnimationKey)

        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.duration = duration / 1.5
        headAnimation.fromValue = 0.0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = timingFunction

        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.duration = duration / 1.5
        tailAnimation.fromValue = 0.0
        tailAnimation.toValue = 1.0
        tailAnimation.timingFunction = timingFunction

        let endHeadAnimation = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnimation.duration = duration / 3.0
        endHeadAnimation.beginTime = duration / 1.5
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = timingFunction

        let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnimation.duration = duration / 3.0
        endTailAnimation.beginTime = duration / 1.5
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = timingFunction

        let animations = CAAnimationGroup()
        animations.duration = duration
        animations.animations = [ headAnimation, tailAnimation, endHeadAnimation, endTailAnimation ]
        animations.repeatCount = .infinity
        animations.isRemovedOnCompletion = false
        progressLayer.add(animations, forKey: Constants.ringStrokeAnimationKey)

        _isAnimating = true
        if hidesWhenStopped {
            isHidden = false
        }
    }

    public func stopAnimating() {
        if !isAnimating {
            return
        }
        progressLayer.removeAnimation(forKey: Constants.ringStrokeAnimationKey)
        progressLayer.removeAnimation(forKey: Constants.ringRotationAnimationKey)

        _isAnimating = false

        if hidesWhenStopped {
            isHidden = true
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}
