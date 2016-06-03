import UIKit

public protocol RangeSliderDelegate {

    func rangeSliderValueChanged(minValue: Int, maxValue: Int)
}