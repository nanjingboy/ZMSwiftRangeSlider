import UIKit

@IBDesignable
open class RangeSlider: UIControl {

    public typealias ValueChangedCallback = (_ minValue: Int, _ maxValue: Int) -> Void
    public typealias MinValueDisplayTextGetter = (_ minValue: Int) -> String?
    public typealias MaxValueDisplayTextGetter = (_ maxValue: Int) -> String?

    fileprivate let trackLayer = TrackLayer()
    fileprivate let minValueThumbLayer = ThumbLayer()
    fileprivate let minValueDisplayLayer = TextLayer()
    fileprivate let maxValueThumbLayer = ThumbLayer()
    fileprivate let maxValueDisplayLayer = TextLayer()

    fileprivate var beginTrackLocation = CGPoint.zero
    fileprivate var rangeValues = Array(0...100)

    fileprivate var valueChangedCallback: ValueChangedCallback?
    fileprivate var minValueDisplayTextGetter: MinValueDisplayTextGetter?
    fileprivate var maxValueDisplayTextGetter: MaxValueDisplayTextGetter?
    
    fileprivate var maxSliderValue: Int

    var minValue: Int
    var maxValue: Int
    var minRange: Int
    var maxRange: Int
    var thumbRadius: CGFloat

    open override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable open var trackHeight: CGFloat = 6.0 {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable open var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable open var minValueThumbTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            minValueThumbLayer.thumbTint = minValueThumbTintColor.cgColor
            updateLayerFrames()
        }
    }

    @IBInspectable open var maxValueThumbTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            maxValueThumbLayer.thumbTint = maxValueThumbTintColor.cgColor
            updateLayerFrames()
        }
    }

    @IBInspectable open var trackHighlightTintColor: UIColor = UIColor(red:0.17, green:0.74, blue:0.39, alpha:1.00) {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable open var thumbSize: CGFloat = 32.0 {
        didSet {
            thumbRadius = thumbSize / 2.0
            updateLayerFrames()
        }
    }

    @IBInspectable open var thumbOutlineSize: CGFloat = 2.0 {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable open var displayTextFontSize: CGFloat = 14.0 {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable open var labelsAreBelow: Bool = true {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable open var labelsFont: UIFont {
        didSet {
            minValueDisplayLayer.font = labelsFont
            maxValueDisplayLayer.font = labelsFont
            updateLayerFrames()
        }
    }

    @IBInspectable open var labelsPreprendedString: String = "" {
        didSet {
            updateLayerFrames()
        }
    }

    @IBInspectable open var maxValueAppendedString: String = "" {
        didSet {
            updateLayerFrames()
        }
    }

    public override init(frame: CGRect) {
        minValue = rangeValues[0]
        maxValue = rangeValues[rangeValues.count - 1]
        minRange = minValue
        maxRange = maxValue
        maxSliderValue = maxValue
        thumbRadius = thumbSize / 2.0
        if #available(iOS 8.2, *) {
            labelsFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        } else {
            labelsFont = UIFont.systemFont(ofSize: 16)
        }
        super.init(frame: frame)
        setupLayers()
    }

    public required init?(coder aDecoder: NSCoder) {
        minValue = rangeValues[0]
        maxValue = rangeValues[rangeValues.count - 1]
        minRange = minValue
        maxRange = maxValue
        maxSliderValue = maxValue
        thumbRadius = thumbSize / 2.0
        if #available(iOS 8.2, *) {
            labelsFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        } else {
            labelsFont = UIFont.systemFont(ofSize: 16)
        }
        super.init(coder: aDecoder)
        setupLayers()
    }

    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.updateLayerFrames()
    }

    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        beginTrackLocation = touch.location(in: self)
        if minValueThumbLayer.frame.contains(beginTrackLocation) {
            minValueThumbLayer.isHighlight = true
        } else if maxValueThumbLayer.frame.contains(beginTrackLocation) {
            maxValueThumbLayer.isHighlight = true
        }

        return minValueThumbLayer.isHighlight || maxValueThumbLayer.isHighlight
    }

    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let count = rangeValues.count
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
            if index > rangeValues.index(of: maxValue)! {
                minValue = maxValue
            } else {
                minValue = rangeValues[index]
            }
        } else if maxValueThumbLayer.isHighlight {
            if index < rangeValues.index(of: minValue)! {
                maxValue = minValue
            } else {
                maxValue = rangeValues[index]
            }
        }
        setMinAndMaxValue(minValue, maxValue: maxValue)
        valueChangedCallback?(minValue, maxValue)
        return true
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        minValueThumbLayer.isHighlight = false
        maxValueThumbLayer.isHighlight = false
    }

    open func setRangeValues(_ rangeValues: [Int]) {
        self.rangeValues = rangeValues
        setMinAndMaxValue(rangeValues[0], maxValue: rangeValues[rangeValues.count - 1])
    }

    open func setMinAndMaxRange(_ minRange: Int, maxRange: Int) {
        self.minRange = minRange
        self.maxRange = maxRange
        self.setMinAndMaxValue(minValue, maxValue: maxValue)
    }

    open func setInitialMinAndMaxValue(_ minValue: Int, maxValue: Int) {
        self.minValue = max(minValue, minRange)
        self.maxValue = min(maxValue, maxRange)
        self.maxSliderValue = maxValue
        updateLayerFrames()
    }

    private func setMinAndMaxValue(_ minValue: Int, maxValue: Int) {
        self.minValue = max(minValue, minRange)
        self.maxValue = min(maxValue, maxRange)
        updateLayerFrames()
    }

    open func setValueChangedCallback(_ callback: ValueChangedCallback?) {
        self.valueChangedCallback = callback
    }

    open func setMinValueDisplayTextGetter(_ getter: MinValueDisplayTextGetter?) {
        self.minValueDisplayTextGetter = getter
    }

    open func setMaxValueDisplayTextGetter(_ getter: MaxValueDisplayTextGetter?) {
        self.maxValueDisplayTextGetter = getter
    }

    func setupLayers() {
        layer.backgroundColor = UIColor.clear.cgColor

        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)

        minValueThumbLayer.rangeSlider = self
        minValueThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(minValueThumbLayer)

        minValueDisplayLayer.rangeSlider = self
        minValueDisplayLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(minValueDisplayLayer)

        maxValueThumbLayer.rangeSlider = self
        maxValueThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(maxValueThumbLayer)

        maxValueDisplayLayer.rangeSlider = self
        maxValueDisplayLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(maxValueDisplayLayer)
    }

    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame = CGRect(x: 0,
                                  y: (bounds.height - trackHeight + 1) / 2,
                                  width: bounds.width,
                                  height: trackHeight)
        trackLayer.setNeedsDisplay()
        let offsetY = (bounds.height - thumbSize) / 2.0
        var minValueSize: CGSize!
        var maxValueSize: CGSize!
        
        let defaultMinValueString = "\(labelsPreprendedString)\(minValue)"
        let defaultMaxValueString = "\(labelsPreprendedString)\(maxValue)\(maxValueAppendedString)"
        
        if let minValueText = minValueDisplayLayer.string {
            minValueSize = (minValueText as! NSString).size(withAttributes: [NSAttributedString.Key.font: labelsFont])
        } else {
            minValueSize = (defaultMinValueString as NSString).size(withAttributes: [NSAttributedString.Key.font: labelsFont])
        }
        
        
        if let maxValueText = maxValueDisplayLayer.string {
            maxValueSize = (maxValueText as! NSString).size(withAttributes: [NSAttributedString.Key.font: labelsFont])
        } else {
            maxValueSize = (defaultMaxValueString as NSString).size(withAttributes: [NSAttributedString.Key.font: labelsFont])
        }
        
        var displayLayerOffsetY: CGFloat!
        
        if(labelsAreBelow) {
            displayLayerOffsetY = thumbSize + 25
        } else {
            displayLayerOffsetY = offsetY - thumbRadius - 8
        }
        
        let minValuePosition = position(minValue)
        minValueThumbLayer.frame = CGRect(x: minValuePosition - thumbRadius,
                                          y: offsetY,
                                          width: thumbSize,
                                          height: thumbSize)
        minValueThumbLayer.setNeedsDisplay()
        minValueDisplayLayer.frame = CGRect(x: minValuePosition - (minValueSize.width / 2),
                                            y: displayLayerOffsetY,
                                            width: minValueSize.width,
                                            height: displayTextFontSize)
        
        if let minValueDisplayText = minValueDisplayTextGetter?(minValue) {
            minValueDisplayLayer.string = "\(labelsPreprendedString)\(minValueDisplayText)"
        } else {
            minValueDisplayLayer.string = defaultMinValueString
        }
        
        minValueDisplayLayer.setNeedsDisplay()

        let maxValuePosition = position(maxValue)
        maxValueThumbLayer.frame = CGRect(x: maxValuePosition - thumbRadius,
                                          y: offsetY,
                                          width: thumbSize,
                                          height: thumbSize)
        maxValueThumbLayer.setNeedsDisplay()
        maxValueDisplayLayer.frame = CGRect(x: maxValuePosition - (maxValueSize.width / 2),
                                            y: displayLayerOffsetY,
                                            width: maxValueSize.width,
                                            height: displayTextFontSize)
        
        if maxValue < maxSliderValue {
            maxValueDisplayLayer.string = "\(labelsPreprendedString)\(maxValue)"
        } else {
            maxValueDisplayLayer.string = defaultMaxValueString
        }
        
        maxValueDisplayLayer.setNeedsDisplay()
        CATransaction.commit()
    }

    func position(_ value: Int) -> CGFloat {
        let index = rangeValues.index(of: value)!
        let count = rangeValues.count
        if index == 0 {
            return thumbRadius
        } else if index == count - 1 {
            return bounds.width - thumbRadius
        }
        return (bounds.width - thumbSize) * CGFloat(index) / CGFloat(count) + thumbRadius
    }
}
