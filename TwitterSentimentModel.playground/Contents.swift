import Cocoa
import CreateML

let data = try MLDataTable(contentsOf:URL(fileURLWithPath:"/Users/sumansigdel/Downloads/twitter-sanders-apple3.csv"))

let(trainingData, testingData) = data.randomSplit(by: 0.7, seed: 5)
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")
let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")
let accuracy = (1.0 - evaluationMetrics.classificationError) * 100
let metaData = MLModelMetadata(author: "Suman Sigdel", shortDescription: "Twitter Sentiment Analyser Model", version: "1.0")
try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/sumansigdel/Downloads/TwitterSentimentClassifier.mlmodel"))
///try sentimentClassifier.prediction(from: "Word to try the sentiment analysis on")
