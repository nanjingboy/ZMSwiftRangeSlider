import UIKit

class TextLayer: CATextLayer {

    weak var rangeSlider: RangeSlider?

    override func drawInContext(ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }

        self.fontSize = slider.displayTextFontSize
        self.foregroundColor = slider.trackHighlightTintColor.CGColor
        self.alignmentMode = kCAAlignmentCenter
        super.drawInContext(ctx)
    }
}