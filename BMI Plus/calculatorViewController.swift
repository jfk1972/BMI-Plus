//
//  CalculatorViewController.swift
//  BMI Plus
//
//  Created by Joseph Knight on 10/1/26.
//

import UIKit

/// Calculator scene. Matches the storyboard layout: height and waist have a
/// primary and a secondary text field; weight uses the primary field only.
///
///  Imperial:  height = ft + in,  weight = lb (decimals allowed, e.g. 124.25),  waist = in + 1/8 in
///  Metric:    primary field only (cm / kg / cm); the secondary fields are hidden.
///
/// In imperial, a secondary field can be left blank and counts as 0.
final class CalculatorViewController: UIViewController {

    private enum UnitSystem: Int {
        case imperial = 0
        case metric = 1
    }

    // MARK: - Outlets (connect in storyboard)
    @IBOutlet private weak var unitControl: UISegmentedControl!      // "Imperial", "Metric"

    @IBOutlet private weak var heightTitleLabel: UILabel!
    @IBOutlet private weak var heightPrimaryField: UITextField!      // ft (imperial) or cm (metric)
    @IBOutlet private weak var heightSecondaryField: UITextField!    // in (imperial), hidden in metric

    @IBOutlet private weak var weightTitleLabel: UILabel!
    @IBOutlet private weak var weightPrimaryField: UITextField!      // lb (imperial) or kg (metric)
    @IBOutlet private weak var weightSecondaryField: UITextField!    // always hidden (kept so the storyboard connection stays valid)

    @IBOutlet private weak var waistTitleLabel: UILabel!
    @IBOutlet private weak var waistPrimaryField: UITextField!       // in (imperial) or cm (metric)
    @IBOutlet private weak var waistSecondaryField: UITextField!     // 1/8 in (imperial), hidden in metric

    @IBOutlet private weak var bmiResultLabel: UILabel!              // white label under "BMI"
    @IBOutlet private weak var bmiWithWaistResultLabel: UILabel!     // white label under "BMI With Waist"

    // MARK: - State and constants
    private var activeSystem: UnitSystem = .imperial

    private let cmPerInch = 2.54
    private let kgPerPound = 0.45359237
    private let eighthsPerInch = 8.0

    private var allFields: [UITextField] {
        [heightPrimaryField, heightSecondaryField,
         weightPrimaryField, weightSecondaryField,
         waistPrimaryField, waistSecondaryField]
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        allFields.forEach { $0.keyboardType = .decimalPad }

        let resultLabels: [UILabel] = [bmiResultLabel, bmiWithWaistResultLabel]
        resultLabels.forEach {
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }

        unitControl.selectedSegmentIndex = activeSystem.rawValue
        // Wired in code so the storyboard doesn't need a Value Changed connection.
        // If you also connect it in the storyboard, it's harmless (the guard below ignores repeats).
        unitControl.addTarget(self, action: #selector(unitChanged(_:)), for: .valueChanged)

        applyUnitLabels()
        clearResults()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    // MARK: - Actions
    @IBAction private func unitChanged(_ sender: UISegmentedControl) {
        let newSystem = UnitSystem(rawValue: sender.selectedSegmentIndex) ?? .imperial
        guard newSystem != activeSystem else { return }

        // Read what's entered in the old units, convert, and refill in the new units.
        let height = heightCm(in: activeSystem)
        let weight = weightKg(in: activeSystem)
        let waist = waistCm(in: activeSystem)

        activeSystem = newSystem
        applyUnitLabels()
        fill(height: height, weight: weight, waist: waist)
        clearResults()
    }

    @IBAction private func calculateTapped(_ sender: UIButton) {
        view.endEditing(true)

        guard let cm = heightCm(in: activeSystem),
              let kg = weightKg(in: activeSystem),
              let waist = waistCm(in: activeSystem),
              (100...250).contains(cm),
              (30...300).contains(kg),
              (40...200).contains(waist) else {
            bmiResultLabel.text = "Check entries"
            bmiWithWaistResultLabel.text = "--"
            return
        }

        let meters = cm / 100.0
        let bmi = kg / (meters * meters)
        let ratio = waist / cm

        bmiResultLabel.text = String(format: "%.1f", bmi)
        bmiWithWaistResultLabel.text = String(format: "Waist-to-height %.2f", ratio)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Labels and results
    private func applyUnitLabels() {
        switch activeSystem {
        case .imperial:
            heightTitleLabel.text = "Height (ft / in)"
            heightPrimaryField.placeholder = "ft"
            heightSecondaryField.placeholder = "in"
            heightSecondaryField.isHidden = false

            weightTitleLabel.text = "Weight (lb) (e.g., 120.25)"
            weightPrimaryField.placeholder = "lb"
            weightSecondaryField.isHidden = true

            waistTitleLabel.text = "Waist at Navel (in / 1/8th of an inch)"
            waistPrimaryField.placeholder = "in"
            waistSecondaryField.placeholder = "1/8 in"
            waistSecondaryField.isHidden = false
        case .metric:
            heightTitleLabel.text = "Height (cm)"
            heightPrimaryField.placeholder = "cm"
            heightSecondaryField.isHidden = true

            weightTitleLabel.text = "Weight (kg)"
            weightPrimaryField.placeholder = "kg"
            weightSecondaryField.isHidden = true

            waistTitleLabel.text = "Waist at Navel (cm)"
            waistPrimaryField.placeholder = "cm"
            waistSecondaryField.isHidden = true
        }
    }

    private func clearResults() {
        bmiResultLabel.text = "--"
        bmiWithWaistResultLabel.text = "--"
    }

    // MARK: - Parsing (returns metric values, nil if empty or invalid)
    private func number(_ field: UITextField) -> Double? {
        guard let text = field.text?.replacingOccurrences(of: ",", with: "."),
              let value = Double(text), value > 0 else { return nil }
        return value
    }

    private func heightCm(in system: UnitSystem) -> Double? {
        switch system {
        case .imperial:
            let feet = number(heightPrimaryField) ?? 0
            let inches = number(heightSecondaryField) ?? 0
            let totalInches = feet * 12 + inches
            return totalInches > 0 ? totalInches * cmPerInch : nil
        case .metric:
            return number(heightPrimaryField)
        }
    }

    private func weightKg(in system: UnitSystem) -> Double? {
        guard let value = number(weightPrimaryField) else { return nil }
        return system == .imperial ? value * kgPerPound : value
    }

    private func waistCm(in system: UnitSystem) -> Double? {
        switch system {
        case .imperial:
            let inches = number(waistPrimaryField) ?? 0
            let eighths = number(waistSecondaryField) ?? 0
            let totalInches = inches + eighths / eighthsPerInch
            return totalInches > 0 ? totalInches * cmPerInch : nil
        case .metric:
            return number(waistPrimaryField)
        }
    }

    // MARK: - Refill after a unit change
    private func fill(height: Double?, weight: Double?, waist: Double?) {
        switch activeSystem {
        case .imperial:
            if let cm = height {
                let totalInches = Int((cm / cmPerInch).rounded())
                heightPrimaryField.text = "\(totalInches / 12)"
                heightSecondaryField.text = "\(totalInches % 12)"
            } else {
                heightPrimaryField.text = nil
                heightSecondaryField.text = nil
            }

            weightPrimaryField.text = weight.map { String(format: "%.1f", $0 / kgPerPound) }
            weightSecondaryField.text = nil

            if let cm = waist {
                let totalEighths = Int((cm / cmPerInch * eighthsPerInch).rounded())
                waistPrimaryField.text = "\(totalEighths / 8)"
                waistSecondaryField.text = "\(totalEighths % 8)"
            } else {
                waistPrimaryField.text = nil
                waistSecondaryField.text = nil
            }
        case .metric:
            heightPrimaryField.text = height.map { String(format: "%.0f", $0) }
            heightSecondaryField.text = nil
            weightPrimaryField.text = weight.map { String(format: "%.1f", $0) }
            weightSecondaryField.text = nil
            waistPrimaryField.text = waist.map { String(format: "%.1f", $0) }
            waistSecondaryField.text = nil
        }
    }
}
