//
//  CountdownTimerPickerViewDelegate.swift
//  UICountdownTimer
//
//  Created by Rodion Negov on 5/25/18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - CountdownTimerPickerViewDelegateDelegate
public protocol CountdownTimerPickerViewDelegateDelegate: class {
    func titleFor(row: Int) -> String
}

// MARK: - CountdownTimerPickerViewDelegate
public class CountdownTimerPickerViewDelegate: NSObject {
    public typealias DidSelectRowCallback = ((Int, Int) -> ())

    // MARK: - Properties
    public var sectionWidth = CGFloat(0)
    public var color        = UIColor.black

    fileprivate var didSelect: DidSelectRowCallback

    fileprivate weak var delegate: CountdownTimerPickerViewDelegateDelegate!

    public init(delegate: CountdownTimerPickerViewDelegateDelegate, didSelect: @escaping DidSelectRowCallback) {
        self.delegate  = delegate
        self.didSelect = didSelect
    }
}

extension CountdownTimerPickerViewDelegate: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = delegate.titleFor(row: row)

        return NSAttributedString(string: string, attributes:  [
            NSAttributedStringKey.foregroundColor: color
        ])
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        didSelect(row, component)
    }

    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return sectionWidth
    }


}
