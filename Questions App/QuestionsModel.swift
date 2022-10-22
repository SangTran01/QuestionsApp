//
//  QuestionsModel.swift
//  Questions App
//
//  Created by Sang Tran on 2022-10-16.
//

import Foundation

protocol QuestionsProtocol
{
    func questionsReceived(_ questions: [Question])
}

public class QuestionsModel
{
    
    var delegate: QuestionsProtocol?
    
    func getQuestions()
    {
        getQuestionsFromRemote()
    }
    
    func getQuestionsFromLocal()
    {
        //first get filePath
        guard let filePath = Bundle.main.path(forResource: "questionsTest", ofType: "json") else {
            print("no json file...")
            return
        }
        
        //get url object from path
        let url = URL(filePath: filePath)
        
        do
        {
            //get data from url object
            let data = try Data(contentsOf: url)
            
            //use decoder to get questions
            let decorder = JSONDecoder()
            
            let questions = try decorder.decode([Question].self, from: data)
            
            delegate?.questionsReceived(questions)
        } catch
        {
            print("failed to convert json to data")
        }
    }
    
    func getQuestionsFromRemote()
    {
        //get url
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        //get URL Object
        guard let url = URL(string: urlString) else {
            print("failed to convert url string to URL")
            return
        }
        
        //get session
        let session = URLSession.shared
        
        //use session to create task
        let task = session.dataTask(with: url) { data, response, error in
            if (data != nil && error == nil)
            {
                do
                {
                    //decode data into questions??
                    
                    //use decoder to get questions
                    let decorder = JSONDecoder()
                    
                    let questions = try decorder.decode([Question].self, from: data!)
                    
                    self.delegate?.questionsReceived(questions)
                } catch {
                    print("error parsing json into data")
                }
                
            } else
            {
                print("\(error.debugDescription)")
            }
        }
        
        //resume task
        task.resume()
    }
}
