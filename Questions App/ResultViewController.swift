//
//  ResultViewController.swift
//  Questions App
//
//  Created by Sang Tran on 2022-10-19.
//

import UIKit

protocol DialogDismissedProtocol {
    func DialogDismissed()
}

class ResultViewController: UIViewController {

    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var DialogView: UIView!
    
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var FeedbackLabel: UILabel!
    @IBOutlet weak var NextButton: UIButton!
    
    
    var resultText: String = ""
    var feedbackText: String = ""
    var buttonText: String = ""
    
    var delegateDialog: DialogDismissedProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ResultLabel.text = resultText
        FeedbackLabel.text = feedbackText
        NextButton.setTitle(buttonText, for: .normal)
    }

    @IBAction func NextButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
        delegateDialog?.DialogDismissed()
    }
}
