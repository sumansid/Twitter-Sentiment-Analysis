//
//  ViewController.swift
//  Twitter Sentiment Analyser
//
//  Created by Suman Sigdel on 1/26/20.
//  Copyright © 2020 Suman Sigdel. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML


class ViewController: UIViewController {
    
    
    @IBOutlet weak var sentimentLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    let tSentimentClassifier = TwitterSentimentClassifier()
    // Instantiation using Twitter's OAuth Consumer Key and secret
    let swifter = Swifter(consumerKey: "LTReJyreyyuz4SWjVABuA1WKI", consumerSecret: "ajf107xfd6869heCG8Ptn8iztfFHBWPIxLkFGvsmoEwI7MKZcz")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let prediction = try! tSentimentClassifier.prediction(text: "I hate @apple")
//        print(prediction.label)
        
        // Do any additional setup after loading the view.
       
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        if let searchText = textField.text {
                   swifter.searchTweet(using: searchText, lang:"en", count: 100, tweetMode: .extended, success: { (results, metadata) in
                       
                       var tweets = [TwitterSentimentClassifierInput]()
                       
                       for i in 0..<100 {
                           if let tweet = results[i]["full_text"].string {
                               let tweetForModel = TwitterSentimentClassifierInput(text: tweet)
                               tweets.append(tweetForModel)
                               }
                           
                       }
                       do {
                        
                           let predictions = try self.tSentimentClassifier.predictions(inputs: tweets)
                           var sentimentScore = 0
                           for prediction in predictions {
                               let sentiment = prediction.label
                               if sentiment == "Pos" {
                                   sentimentScore += 1
                               } else if sentiment == "Neg" {
                                   sentimentScore -= 1
                               }
                               
                           }
                        print(sentimentScore)
                        if sentimentScore > 15 {
                            self.sentimentLabel.text = "😍"
                        } else if sentimentScore > 5 {
                            self.sentimentLabel.text = "😊"
                        } else if sentimentScore > 0 {
                            self.sentimentLabel.text = "🙂"
                        } else if sentimentScore > -5 {
                            self.sentimentLabel.text = "😕"
                        } else if sentimentScore > -10 {
                            self.sentimentLabel.text = "😈"
                        }else if sentimentScore > -15 {
                            self.sentimentLabel.text = "☹️"
                        }else if sentimentScore > -25 {
                            self.sentimentLabel.text = "😡"
                        }else {
                            self.sentimentLabel.text = "😡💩🤮"
                            
                        }
                           
                       } catch {
                           print("An error making the prediction\(error)")
                           
                       }
                        
                       
                   }) { (error) in
                       print("Error with the twitter api request \(error)")
                   }
                   
               }
               
    }
    


}

