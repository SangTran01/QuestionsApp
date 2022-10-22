//
//  Question.swift
//  Questions App
//
//  Created by Sang Tran on 2022-10-16.
//

import Foundation

public struct Question: Codable
{
    var question: String?
    var answers: [String]?
    var correctAnswerIndex: Int?
    var feedback: String?
}
