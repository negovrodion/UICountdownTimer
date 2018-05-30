//
//  CountdownTimerPickerViewDataSource.swift
//  UICountdownTimer
//
//  Created by Rodion Negov on 5/25/18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - CountdownTimerPickerViewDataSourceDelegate
public protocol CountdownTimerPickerViewDataSourceDelegate: class {
    var numberOfComponents: Int { get }
    var numberOfRowsInComponent: Int { get }
}

// MARK: - CountdownTimerPickerViewDataSource
public class CountdownTimerPickerViewDataSource: NSObject {

    fileprivate weak var delegate: CountdownTimerPickerViewDataSourceDelegate!

    // MARK: - Initialization
    public init(delegate: CountdownTimerPickerViewDataSourceDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UIPickerViewDataSource
extension CountdownTimerPickerViewDataSource: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return delegate.numberOfComponents
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate.numberOfRowsInComponent
    }
}
