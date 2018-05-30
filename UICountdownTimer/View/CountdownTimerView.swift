//
//  CountdownTimerWireframe.swift
//  UICountdownTimer
//
//  Created by Rodion Negov on 5/25/18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - CountdownTimerView
public class CountdownTimerView: UIView {

    // MARK: - Constants
    public enum Constants {
        static let cornerRadius = CGFloat(5)
        static let borderWidth  = CGFloat(1)

        static let myBlue = fromRGBA(red: 0, green: 122, blue: 255)

        enum Strings {
            static let min       = "m:"
            static let sec       = "s:"
            static let timer     = "Timer"
            static let stopwatch = "Stopwatch"
            static let go        = "Go"
            static let stop      = "Stop"
            static let reset     = "Reset"

        }

        private static func fromRGBA(red: Int, green: Int, blue: Int, alpha: Float = 1) -> UIColor {
            return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0,
                           alpha: CGFloat(alpha))
        }
    }

    // MARK: - Properties
    public var presenter: CountdownTimerViewOutputProtocol! {
        didSet {
            pickerViewDataSource      = CountdownTimerPickerViewDataSource(delegate: presenter)
            minutesPickerViewDelegate = CountdownTimerPickerViewDelegate(delegate: presenter,
                                                                         didSelect: presenter.didSelectMinutes)
            secondsPickerViewDelegate = CountdownTimerPickerViewDelegate(delegate: presenter,
                                                                         didSelect: presenter.didSelectSeconds)

            minutesPickerView.dataSource = pickerViewDataSource
            secondPickerView.dataSource  = pickerViewDataSource
            minutesPickerView.delegate   = minutesPickerViewDelegate
            secondPickerView.delegate    = secondsPickerViewDelegate
        }
    }

    fileprivate var pickerViewDataSource: CountdownTimerPickerViewDataSource!
    fileprivate var minutesPickerViewDelegate: CountdownTimerPickerViewDelegate!
    fileprivate var secondsPickerViewDelegate: CountdownTimerPickerViewDelegate!

    fileprivate var isSetuped = false

    public let minutesPickerView = UIPickerView()
    public let secondPickerView  = UIPickerView()
    public let mLabel            = UILabel()
    public let sLabel            = UILabel()
    public let segmentControl    = UISegmentedControl()
    public let parentForPickers  = UIView()
    public let actionButton      = UIButton()

    // MARK: - Initialize
    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    // MARK: - Life cycle
    public override func layoutSubviews() {
        super.layoutSubviews()

        setupUI()
    }

    // MARK: - Private functions
    private func initialize() {

        tintColor = Constants.myBlue

        // Parent for pickers
        parentForPickers.layer.borderWidth  = Constants.borderWidth
        parentForPickers.layer.borderColor  = tintColor.cgColor
        parentForPickers.layer.cornerRadius = Constants.cornerRadius

        secondPickerView.showsSelectionIndicator  = false
        minutesPickerView.showsSelectionIndicator = false

        addSubview(parentForPickers)

        // PickerViews

        parentForPickers.addSubview(minutesPickerView)
        parentForPickers.addSubview(secondPickerView)

        // Labels

        mLabel.text = Constants.Strings.min
        sLabel.text = Constants.Strings.sec

        mLabel.textColor = tintColor
        sLabel.textColor = tintColor

        parentForPickers.addSubview(mLabel)
        parentForPickers.addSubview(sLabel)

        // Segment control

        segmentControl.addTarget(self, action: #selector(didChangeValueAtSegmentControl), for: .valueChanged)
        segmentControl.insertSegment(withTitle: Constants.Strings.timer, at: 0, animated: false)
        segmentControl.insertSegment(withTitle: Constants.Strings.stopwatch, at: 1, animated: false)

        addSubview(segmentControl)

        // Action button
        actionButton.setTitle(Constants.Strings.go, for: .normal)
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchDown)

        actionButton.backgroundColor    = Constants.myBlue
        actionButton.layer.borderWidth  = Constants.borderWidth
        actionButton.layer.borderColor  = Constants.myBlue.cgColor
        actionButton.layer.cornerRadius = Constants.cornerRadius

        addSubview(actionButton)

    }

    private func setupUI() {
        let sectionWidth       = frame.width / 8.0
        let halfOfSectionWidth = sectionWidth / 2.0
        let halfOfWidth        = (frame.width + halfOfSectionWidth) / 2.0
        let pickerHeight       = frame.height * 0.7
        let controlHeight      = (frame.height - pickerHeight) / 2.0


        minutesPickerViewDelegate.sectionWidth = sectionWidth
        secondsPickerViewDelegate.sectionWidth = sectionWidth
        minutesPickerViewDelegate.color        = tintColor
        secondsPickerViewDelegate.color        = tintColor

        // Parent for pickers

        parentForPickers.frame = CGRect(x: 0, y: 0, width: frame.width, height: pickerHeight)

        // PickerViews

        minutesPickerView.frame = CGRect(x: 0, y: 0, width: halfOfWidth, height: pickerHeight)
        secondPickerView.frame  = CGRect(x: halfOfWidth - halfOfSectionWidth, y: 0, width: halfOfWidth,
                                         height: pickerHeight)

        minutesPickerView.subviews.forEach { (subview) in
            guard subview.frame.height < 1 else { return }
            subview.isHidden = true
        }

        secondPickerView.subviews.forEach { (subview) in
            guard subview.frame.height < 1 else { return }
            subview.isHidden = true
        }

        // Labels

        mLabel.sizeToFit()
        sLabel.sizeToFit()

        let mLabelX  = mLabel.frame.width > sectionWidth ? 1 : sectionWidth / 2 - mLabel.frame.width / 2
        mLabel.frame = CGRect(x: mLabelX, y: pickerHeight / 2 - mLabel.frame.height / 2, width: mLabel.frame.width,
                              height: mLabel.frame.height)

        let sLabelX  = sLabel.frame.width > sectionWidth ? sectionWidth * 4 : sectionWidth / 2 -
            sLabel.frame.width / 2 + sectionWidth * 4
        sLabel.frame = CGRect(x: sLabelX, y: pickerHeight / 2 - sLabel.frame.height / 2, width: sLabel.frame.width,
                              height: sLabel.frame.height)


        // Segment control

        segmentControl.frame = CGRect(x: 0, y: pickerHeight + 1, width: frame.width, height: controlHeight)

        // Action Button

        actionButton.frame = CGRect(x: 0, y: pickerHeight + controlHeight + 2, width: frame.width,
                                    height: controlHeight - 2)


        guard !isSetuped else { return }
        isSetuped = true

        presenter.didSetuped()
    }

    // MARK: - Actions

    @objc private func didTapActionButton() {
        presenter.didTapGo()
    }

    @objc private func didChangeValueAtSegmentControl(segment: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 0 {
            presenter.didSelectTimer()
        } else {
            presenter.didSelectStopwatch()
        }
    }
}




extension CountdownTimerView: CountdownTimerViewInputProtocol {
    public func toReadyState() {
        actionButton.setTitle(Constants.Strings.go, for: .normal)

        secondPickerView.isUserInteractionEnabled  = true
        minutesPickerView.isUserInteractionEnabled = true
        segmentControl.isUserInteractionEnabled    = true
    }

    public func toInPrograssState() {
        actionButton.setTitle(Constants.Strings.stop, for: .normal)

        secondPickerView.isUserInteractionEnabled  = false
        minutesPickerView.isUserInteractionEnabled = false
        segmentControl.isUserInteractionEnabled    = false
    }

    public func toStopState() {
        actionButton.setTitle(Constants.Strings.reset, for: .normal)
    }

    public func setTimerStype(type: CountdownTimerType) {
        switch type {
        case .stopwatch:
            segmentControl.selectedSegmentIndex = 1
        case .timer:
            segmentControl.selectedSegmentIndex = 0
        }
    }

    public func selectMinutes(row: Int, component: Int, animated: Bool) {
        minutesPickerView.selectRow(row, inComponent: component, animated: animated)
    }

    public func selectSeconds(row: Int, component: Int, animated: Bool) {
        secondPickerView.selectRow(row, inComponent: component, animated: animated)
    }


}
