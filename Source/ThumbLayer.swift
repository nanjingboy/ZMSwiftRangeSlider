import UIKit

class ThumbLayer: CALayer {

    var isHighlight = false {
        didSet {
            setNeedsDisplay()
        }
    }

    weak var rangeSlider: RangeSlider?

    override func drawInContext(ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }

        let thumbFrame = bounds.insetBy(dx: slider.thumbOutlineSize / 2.0, dy: slider.thumbOutlineSize / 2.0)
        let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: thumbFrame.height * 0.5)
        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
        CGContextAddPath(ctx, thumbPath.CGPath)
        CGContextFillPath(ctx)

        CGContextSetStrokeColorWithColor(ctx, slider.trackHighlightTintColor.CGColor)
        CGContextSetLineWidth(ctx, slider.thumbOutlineSize)
        CGContextAddPath(ctx, thumbPath.CGPath)
        CGContextStrokePath(ctx)

        if isHighlight {
            CGContextSetFillColorWithColor(ctx, UIColor(white: 0.0, alpha: 0.1).CGColor)
            CGContextAddPath(ctx, thumbPath.CGPath)
            CGContextFillPath(ctx)
        }
    }
}