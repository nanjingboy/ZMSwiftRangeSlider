import UIKit

class TrackLayer: CALayer {

    weak var rangeSlider: RangeSlider?

    override func drawInContext(ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }

        let path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height * 0.5)
        CGContextAddPath(ctx, path.CGPath)

        CGContextSetFillColorWithColor(ctx, slider.trackTintColor.CGColor)
        CGContextAddPath(ctx, path.CGPath)
        CGContextFillPath(ctx)

        CGContextSetFillColorWithColor(ctx, slider.trackHighlightTintColor.CGColor)
        let minValueOffsetX = slider.position(slider.minValue)
        let maxValueOffsetX = slider.position(slider.maxValue)
        let rect = CGRect(x: minValueOffsetX, y: 0.0, width: maxValueOffsetX - minValueOffsetX, height: bounds.height)
        CGContextFillRect(ctx, rect)
    }
}