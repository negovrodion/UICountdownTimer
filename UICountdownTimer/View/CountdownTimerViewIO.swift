//
//  CountdownTimerViewIO.swift
//  UICountdownTimer
//
//  Created by Rodion Negov on 5/25/18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CountdownTimerViewOutputProtocol
public protocol CountdownTimerViewOutputProtocol: CountdownTimerPickerViewDataSourceDelegate,
    CountdownTimerPickerViewDelegateDelegate {

    func didSetuped()
    func didSelectMinutes(row: Int, component: Int)
    func didSelectSeconds(row: Int, component: Int)
    func didSelectTimer()
    func didSelectStopwatch()
    func didTapGo()
}

// MARK: - CountdownTimerViewInputProtocol
public protocol CountdownTimerViewInputProtocol: class {
    func selectMinutes(row: Int, component: Int, animated: Bool)
    func selectSeconds(row: Int, component: Int, animated: Bool)
    func toReadyState()
    func toInPrograssState()
    func toStopState()
    func setTimerStype(type: CountdownTimerType)
}
