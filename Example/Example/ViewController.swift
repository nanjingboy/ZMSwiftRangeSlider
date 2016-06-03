import UIKit
import SwiftRangeSlider

class ViewController: UIViewController, RangeSliderDelegate {

    @IBOutlet weak var rangeSlider: RangeSlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        rangeSlider.delegate = self
    }

    func onValueChanged(minValue: Int, maxValue: Int) {
        print("min value:\(minValue)")
        print("max value:\(maxValue)")
    }
}