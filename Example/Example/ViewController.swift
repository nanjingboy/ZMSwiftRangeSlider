import UIKit
import SwiftRangeSlider

class ViewController: UIViewController, RangeSliderDelegate {

    @IBOutlet weak var rangeSlider: RangeSlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        rangeSlider.delegate = self
        rangeSlider.setRangeValues([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        rangeSlider.setMinAndMaxValue(2, maxValue: 8)
    }

    func onValueChanged(minValue: Int, maxValue: Int) {
        print("min value:\(minValue)")
        print("max value:\(maxValue)")
    }
}

