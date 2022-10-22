//
//  ViewController.swift
//  Questions App
//
//  Created by Sang Tran on 2022-10-16.
//

import UIKit

class ViewController: UIViewController, QuestionsProtocol, DialogDismissedProtocol,
                      UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var AnswersTableView: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var questions = [Question]()
    var currentQuestion : Question?
    var model = QuestionsModel()
    var currentQuestionIndex = 0
    var correctAnswers = 0
    
    var resultDialog: ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AnswersTableView.delegate = self
        AnswersTableView.dataSource = self
        
        model.delegate = self
        model.getQuestions()
        
        //iniate resultDialog
        resultDialog = storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext //completely covers
        resultDialog?.delegateDialog = self
    }
    
    //MARK: QuestionsProtocol methods
    func questionsReceived(_ questions: [Question]) {
        DispatchQueue.main.async {
            self.questions = questions
            //display question
            self.displayQuestion()
        }
    }
    
    func displayQuestion()
    {
        let question = questions[currentQuestionIndex]
        
        questionLabel.text = question.question
        
        //refresh table view
        AnswersTableView.reloadData()
    }
    
    //MARK: UITABLE methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard questions.count > 0 else {return 0}
        
        let currentQuestion = questions[currentQuestionIndex]
        return currentQuestion.answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AnswersTableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        //get label, display answers
        if let label = cell.viewWithTag(1) as? UILabel {
            let question = questions[currentQuestionIndex]
            if question.answers != nil {
                
                label.text = question.answers![indexPath.row]
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get question
        let question = questions[currentQuestionIndex]
        guard question.answers != nil && question.answers!.count > 0 else {return}
        
        guard resultDialog != nil else {return}
        
        //check correct
        
        if (indexPath.row == question.correctAnswerIndex)
        {
            correctAnswers += 1
            
            resultDialog!.resultText = "Correct"
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
        } else
        {
            resultDialog!.resultText = "Wrong"
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
        }
        
        DispatchQueue.main.async {
            self.present(self.resultDialog!, animated: true, completion: nil)
        }
    }
    
    //MARK: dialog dismissed protocol
    func DialogDismissed() {
        //popup dismissed
        
        //increment
        currentQuestionIndex += 1
        //display next question
        
        if (currentQuestionIndex == questions.count)
        {
            //show summary
            
            resultDialog!.resultText = "End"
            resultDialog!.feedbackText = "You got \(correctAnswers)/\(questions.count)"
            resultDialog!.buttonText = "Reset"
            
            DispatchQueue.main.async {
                self.present(self.resultDialog!, animated: true, completion: nil)
            }
        } else if (currentQuestionIndex > questions.count)
        {
            currentQuestionIndex = 0
            correctAnswers = 0
            displayQuestion()
        } else if (currentQuestionIndex < questions.count)
        {
            displayQuestion()
        }
    }
}

