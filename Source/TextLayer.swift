import UIKit

class TextLayer: CATextLayer {

    weak var rangeSlider: RangeSlider?

    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }

        self.fontSize = slider.displayTextFontSize
        if #available(iOS 8.2, *) {
            self.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        } else {
            // Fallback on earlier versions
        }
        self.foregroundColor = slider.trackHighlightTintColor.cgColor
        self.alignmentMode = CATextLayerAlignmentMode.center
        super.draw(in: ctx)
    }
}
