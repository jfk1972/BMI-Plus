import UIKit
import SafariServices

final class IntroductionViewController: UIViewController {

    private let bmiURL = URL(string: "https://www.cdc.gov/bmi/adult-calculator/bmi-categories.html")!
    private let waistURL = URL(string: "https://www.nice.org.uk/guidance/NG246/chapter/Identifying-and-assessing-overweight-obesity-and-central-adiposity")!

    @IBAction func bmiInfoTapped(_ sender: UIButton) {
        present(SFSafariViewController(url: bmiURL), animated: true)
    }

    @IBAction func waistInfoTapped(_ sender: UIButton) {
        present(SFSafariViewController(url: waistURL), animated: true)
    }

    @IBAction func comparisonTapped(_ sender: UIButton) {
        present(ComparisonViewController(), animated: true)
    }
}
