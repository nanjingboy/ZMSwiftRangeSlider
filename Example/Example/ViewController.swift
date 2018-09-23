import UIKit
import ZMSwiftRangeSlider

class ViewController: UIViewController {

    @IBOutlet weak var rangeSlider1: RangeSlider!

    @IBOutlet weak var rangeSlider2: RangeSlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        rangeSlider1.setValueChangedCallback { (minValue, maxValue) in
            print("rangeSlider1 min value:\(minValue)")
            print("rangeSlider1 max value:\(maxValue)")
        }
        rangeSlider1.setMinValueDisplayTextGetter { (minValue) -> String? in
            return "$\(minValue)"
        }
        rangeSlider1.setMaxValueDisplayTextGetter { (maxValue) -> String? in
            return "$\(maxValue)"
        }
        rangeSlider1.setMinAndMaxRange(10, maxRange: 90)

        rangeSlider2.setValueChangedCallback { (minValue, maxValue) in
            print("rangeSlider2 min value:\(minValue)")
            print("rangeSlider2 max value:\(maxValue)")
        }
        rangeSlider2.setMinValueDisplayTextGetter { (minValue) -> String? in
            return "¥\(minValue)"
        }
        rangeSlider2.setMaxValueDisplayTextGetter { (maxValue) -> String? in
            return "¥\(maxValue)"
        }
    }
}
