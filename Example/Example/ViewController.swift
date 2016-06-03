import UIKit
import SwiftRangeSlider

class ViewController: UIViewController {

    @IBOutlet weak var rangeSlider: RangeSlider!

    @IBAction func onRangeSliderValueChanged(sender: AnyObject) {
        print("min value:\(rangeSlider.minValue)")
        print("max value:\(rangeSlider.maxValue)")
    }
}

