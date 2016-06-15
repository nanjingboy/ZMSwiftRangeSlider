import UIKit
import ZMSwiftRangeSlider

class ViewController: UIViewController, RangeSliderDelegate {

    @IBOutlet weak var rangeSlider: RangeSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        rangeSlider.delegate = self
    }

    func rangeSliderValueChanged(minValue: Int, maxValue: Int) {
        print("min value:\(minValue)")
        print("max value:\(maxValue)")
    }

    func rangeSliderMinValueDisplayText(minValue: Int) -> String? {
        return "$\(minValue)"
    }

    func rangeSliderMaxValueDisplayText(maxValue: Int) -> String? {
        return "$\(maxValue)"
    }
}