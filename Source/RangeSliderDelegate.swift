import UIKit

public protocol RangeSliderDelegate {

    func rangeSliderValueChanged(minValue: Int, maxValue: Int)

    func rangeSliderMinValueDisplayText(minValue: Int) -> String?

    func rangeSliderMaxValueDisplayText(maxValue: Int) -> String?
}