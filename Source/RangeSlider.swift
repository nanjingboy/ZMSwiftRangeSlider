import UIKit

@IBDesignable
public class RangeSlider: UIControl {

    private let trackLayer = TrackLayer()
    private let minValueThumbLayer = ThumbLayer()
    private let maxValueThumbLayer = ThumbLayer()

    private var beginTrackLocation = CGPointZero

    public var minValue = 0
    public var maxValue = 100

    public var values = Array(0...100) {
        didSet {
            minValue = values[0]
            maxValue = values[values.count - 1]
            updateLayerFrames()
        }
    }

    public override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable public var trackHeight: CGFloat = 6.0 {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable public var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    @IBInspectable public var trackHighlightTintColor: UIColor = UIColor(red: 2.0 / 255, green: 192.0 / 255, blue: 92.0 / 255, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
            minValueThumbLayer.setNeedsLayout()
            maxValueThumbLayer.setNeedsLayout()
        }
    }

    @IBInspectable public var thumbSize: CGFloat = 30.0 {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable public var thumbOutlineSize: CGFloat = 2.0 {
        didSet {
            minValueThumbLayer.setNeedsLayout()
            maxValueThumbLayer.setNeedsLayout()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }

    public override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        updateLayerFrames()
    }

    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        beginTrackLocation = touch.locationInView(self)
        if minValueThumbLayer.frame.contains(beginTrackLocation) {
            minValueThumbLayer.isHighlight = true
        } else if maxValueThumbLayer.frame.contains(beginTrackLocation) {
            maxValueThumbLayer.isHighlight = true
        }

        return minValueThumbLayer.isHighlight || maxValueThumbLayer.isHighlight
    }

    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        let count = values.count
        var index = Int(location.x * CGFloat(count) / (bounds.width - thumbSize))

        if maxValue == minValue && location.x > beginTrackLocation.x && !maxValueThumbLayer.isHighlight {
            maxValueThumbLayer.isHighlight = true
            minValueThumbLayer.isHighlight = false
        }

        if index < 0 {
            index = 0
        } else if index > count - 1 {
            index = count - 1
        }

        if minValueThumbLayer.isHighlight {
            if index > values.indexOf(maxValue)! {
                minValue = maxValue
            } else {
                minValue = values[index]
            }
        } else if maxValueThumbLayer.isHighlight {
            if index < values.indexOf(minValue)! {
                maxValue = minValue
            } else {
                maxValue = values[index]
            }
        }
        updateLayerFrames()

        sendActionsForControlEvents(.ValueChanged)

        return true
    }

    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        minValueThumbLayer.isHighlight = false
        maxValueThumbLayer.isHighlight = false
    }

    func setupLayers() {
        layer.backgroundColor = UIColor.clearColor().CGColor

        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)

        minValueThumbLayer.rangeSlider = self
        minValueThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(minValueThumbLayer)

        maxValueThumbLayer.rangeSlider = self
        maxValueThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(maxValueThumbLayer)
    }

    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame = CGRect(x: 0,
                                  y: (bounds.height - trackHeight + 1) / 2,
                                  width: bounds.width,
                                  height: trackHeight)
        trackLayer.setNeedsDisplay()

        minValueThumbLayer.frame = CGRect(x: position(minValue) - thumbSize / 2.0,
                                          y: (bounds.height - thumbSize) / 2.0,
                                          width: thumbSize,
                                          height: thumbSize)
        minValueThumbLayer.setNeedsDisplay()

        maxValueThumbLayer.frame = CGRect(x: position(maxValue) - thumbSize / 2.0,
                                          y: (bounds.height - thumbSize) / 2.0,
                                          width: thumbSize,
                                          height: thumbSize)
        maxValueThumbLayer.setNeedsDisplay()
        CATransaction.commit()
    }

    func position(value: Int) -> CGFloat {
        let index = values.indexOf(value)!
        let count = values.count
        if index == 0 {
            return thumbSize / 2.0
        } else if index == count - 1 {
            return bounds.width - thumbSize / 2.0
        }

        return (bounds.width - thumbSize) * CGFloat(index) / CGFloat(count) + thumbSize / 2.0
    }
}