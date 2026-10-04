//
//  ViewController.swift
//  BMI Plus
//
//  Created by Joseph Knight on 10/1/26.
//

import UIKit

final class ComparisonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
    }

    @IBAction func doneTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}






// import UIKit

/// Presented as a page sheet from the disclaimer scene (segue id: "showComparison").
/// Content is built in code so the storyboard scene only needs the class assigned.
// final class ComparisonViewController: UIViewController {
//
//    private struct Person {
//        let name: String
//        let heightInches: Double
//        let weightPounds: Double
//        let waistInches: Double
//        let bodyFat: String   // illustrative estimate
//
//        var bmi: Double { 703.0 * weightPounds / (heightInches * heightInches) }
//        var waistToHeight: Double { waistInches / heightInches }
//        var heightText: String { "\(Int(heightInches) / 12)'\(Int(heightInches) % 12)\"" }
//    }
//
//    private let sam = Person(name: "Sam", heightInches: 74, weightPounds: 210, waistInches: 33, bodyFat: "~14%")
//    private let bill = Person(name: "Bill", heightInches: 66, weightPounds: 167, waistInches: 43, bodyFat: "~33%")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//
//        if let sheet = sheetPresentationController {
//            sheet.detents = [.medium(), .large()]
//            sheet.prefersGrabberVisible = true
//        }
//
//        buildContent()
//    }
//
//    private func buildContent() {
//        let title = UILabel()
//        title.text = "Same BMI. Very different people."
//        title.font = .preferredFont(forTextStyle: .title2)
//        title.numberOfLines = 0
//        title.textAlignment = .center
//
//        let rows = UIStackView(arrangedSubviews: [
//            row("", sam.name, bill.name, bold: true),
//            row("Height", sam.heightText, bill.heightText),
//            row("Weight", "\(Int(sam.weightPounds)) lb", "\(Int(bill.weightPounds)) lb"),
//            row("BMI", String(format: "%.1f", sam.bmi), String(format: "%.1f", bill.bmi), bold: true),
//            row("Waist", "\(Int(sam.waistInches)) in", "\(Int(bill.waistInches)) in"),
//            row("Waist ÷ height", String(format: "%.2f", sam.waistToHeight), String(format: "%.2f", bill.waistToHeight), bold: true),
//            row("Body fat*", sam.bodyFat, bill.bodyFat)
//        ])
//        rows.axis = .vertical
//        rows.spacing = 12
//
//        let footnote = UILabel()
//        footnote.text = "*Illustrative estimates. For entertainment only; not medical advice."
//        footnote.font = .preferredFont(forTextStyle: .footnote)
//        footnote.textColor = .secondaryLabel
//        footnote.numberOfLines = 0
//
//        let done = UIButton(type: .system)
//        done.setTitle("Done", for: .normal)
//        done.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
//
//        let stack = UIStackView(arrangedSubviews: [title, rows, footnote, done])
//        stack.axis = .vertical
//        stack.spacing = 20
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        let scroll = UIScrollView()
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//        scroll.addSubview(stack)
//        view.addSubview(scroll)
//
//        NSLayoutConstraint.activate([
//            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
//            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
//            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20),
//            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20)
//        ])
//    }
//
//    private func row(_ label: String, _ a: String, _ b: String, bold: Bool = false) -> UIStackView {
//        func make(_ text: String, align: NSTextAlignment) -> UILabel {
//            let l = UILabel()
//            l.text = text
//            l.textAlignment = align
//            l.font = bold ? .preferredFont(forTextStyle: .headline) : .preferredFont(forTextStyle: .body)
//            return l
//        }
//        let s = UIStackView(arrangedSubviews: [make(label, align: .left), make(a, align: .center), make(b, align: .center)])
//        s.distribution = .fillEqually
//        return s
//    }
//
//    @objc private func doneTapped() {
//        dismiss(animated: true)
//    }
//}
//
