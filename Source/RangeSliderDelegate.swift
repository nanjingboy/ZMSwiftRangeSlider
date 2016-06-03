import UIKit

public protocol RangeSliderDelegate {

    func onValueChanged(minValue: Int, maxValue: Int)
}