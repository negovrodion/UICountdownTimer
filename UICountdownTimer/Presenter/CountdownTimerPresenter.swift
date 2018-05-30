//
//  CountdownTimerPresenter.swift
//  UICountdownTimer
//
//  Created by Rodion Negov on 5/25/18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CountdownTimerDelegate
public protocol CountdownTimerDelegate: class {
    func handleError(error: CountdownTimerError)
    func reachedEnd(type: CountdownTimerType)
}

// MARK: - CountdownTimerPresenter
public class CountdownTimerPresenter {

    // MARK: - Constants
    fileprivate enum Constants {
        static let numberOfComponents      = 2
        static let numberOfRowsInComponent = 10

        static let loopMargin = 100

        static var rowsMiddle: Int {
            return (Constants.loopMargin / 2) * Constants.numberOfRowsInComponent
        }

        static let timerInterval = 1000

        static let timeMax = 99 * 60 + 59
    }

    // MARK: - State
    fileprivate enum State: Int {
        case readyToStart = 0
        case inProgress
        case stopped

        func next() -> State {
            let current = self.rawValue
            if let nextState = State(rawValue: current + 1) {
                return nextState
            } else {
                return .readyToStart
            }
        }
    }

    // MARK: - Properties
    public weak var view: CountdownTimerViewInputProtocol!
    public weak var delegate: CountdownTimerDelegate?

    fileprivate var state: State = .readyToStart
    fileprivate var currentTimerType: CountdownTimerType = .stopwatch
    fileprivate var isCancelled = false
    fileprivate var currentTime = 0
    fileprivate var isTimerWorks = false
    fileprivate var timeElements = [0, 0, 0, 0]

    // MARK: - Initialization
    public init() {

    }

    // MARK: - Functions

    fileprivate func startTimer() {
        isTimerWorks = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Constants.timerInterval)) { [weak self] in
            guard self?.isCancelled == false else { return }

            self?.timerTick()
        }
    }

    @objc private func timerTick() {
        var finished = false
        defer {
            if finished {
                isTimerWorks = false
                view.toStopState()
                delegate?.reachedEnd(type: currentTimerType)
                didTapGo()
            }
        }

        switch currentTimerType {
        case .stopwatch:
            guard currentTime < Constants.timeMax else {
                finished = true

                return
            }

            currentTime += 1
        case .timer:
            guard currentTime > 0 else {
                finished = true

                return
            }

            currentTime -= 1
        }

        let min = currentTime / 60
        let sec = currentTime - min * 60

        let middle = Constants.rowsMiddle

        view.selectMinutes(row: middle + (min / 10), component: 0, animated: true)
        view.selectMinutes(row: middle + (min % 10), component: 1, animated: true)
        view.selectSeconds(row: middle + (sec / 10), component: 0, animated: true)
        view.selectSeconds(row: middle + (sec % 10), component: 1, animated: true)

        if isTimerWorks {
            startTimer()
        }
    }

    fileprivate func toZeros() {
        let row = Constants.rowsMiddle

        for i in 0...Constants.numberOfComponents - 1 {
            view.selectMinutes(row: row, component: i, animated: false)
            view.selectSeconds(row: row, component: i, animated: false)
        }
    }
}

// MARK: - CountdownTimerViewOutputProtocol
extension CountdownTimerPresenter: CountdownTimerViewOutputProtocol {

    public var numberOfComponents: Int {
        return Constants.numberOfComponents
    }

    public var numberOfRowsInComponent: Int {
        return Constants.loopMargin * Constants.numberOfRowsInComponent
    }

    public func didSetuped() {
        toZeros()

        view.setTimerStype(type: .stopwatch)
    }

    public func titleFor(row: Int) -> String {
        return String(row % Constants.numberOfRowsInComponent)
    }

    public func didSelectMinutes(row: Int, component: Int) {
        let realRow = CountdownTimerPresenter.getRealRow(row: row)

        view.selectMinutes(row: realRow, component: component, animated: false)

        guard component < Constants.numberOfComponents else { return }

        timeElements[component] = getIndexFromRealRow(row: realRow)

        fromElementsToTime()
    }

    public func didSelectSeconds(row: Int, component: Int) {
        let realRow = CountdownTimerPresenter.getRealRow(row: row)
        let index   = getIndexFromRealRow(row: realRow)

        guard (index >= 0 && index <= 5 && component == 0) || component == 1 else {
            let maxAvailableMinutesRow = CountdownTimerPresenter.getRealRow(row: 5)
            view.selectSeconds(row: maxAvailableMinutesRow, component: 0, animated: false)

            return
        }

        view.selectSeconds(row: realRow, component: component, animated: false)

        guard component < Constants.numberOfComponents else { return }

        timeElements[component + Constants.numberOfComponents] = index

        fromElementsToTime()
    }


    public func didSelectTimer() {
        guard state == .readyToStart else {
            delegate?.handleError(error: .canNotChangeTimerTypeWhileCountingInProgress)

            return
        }

        currentTimerType = .timer
    }

    public func didSelectStopwatch() {
        guard state == .readyToStart else {
            delegate?.handleError(error: .canNotChangeTimerTypeWhileCountingInProgress)

            return
        }

        currentTimerType = .stopwatch
    }

    public func didTapGo() {
        switch state {
        case .readyToStart:
            isCancelled = false
            view.toInPrograssState()
            startTimer()
        case .inProgress:
            isCancelled = true
            view.toStopState()
            isTimerWorks = false
        case .stopped:
            view.toReadyState()
            toZeros()
            currentTime = 0
            timeElements = [0, 0, 0, 0]
        }

        state = state.next()
    }

    // MARK: - Private functions
    private static func getRealRow(row: Int) -> Int {
        var realRow = row % Constants.numberOfRowsInComponent
        realRow    += Constants.rowsMiddle

        return realRow
    }

    private func fromElementsToTime() {
        let time = timeElements[0] * 600 + timeElements[1] * 60 + timeElements[2] * 10 + timeElements[3]

        currentTime = time
    }

    private func getIndexFromRealRow(row: Int) -> Int {
        var index = row - Constants.rowsMiddle
        if index < 0 {
            index = Constants.numberOfRowsInComponent + index
        }

        return index
    }

}
