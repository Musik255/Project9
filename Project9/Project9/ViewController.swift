//
//  ViewController.swift
//  Project9
//
//  Created by Павел Чвыров on 05.12.2023.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel : UILabel!
    var answersLabel : UILabel!
    var scoreLabel : UILabel!
    
    var currentAnswer : UITextField!
    
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0
    var level = 1
    
    
    override func loadView() {
        
        let submitButton = UIButton(type: .system)
        let clearButton = UIButton(type: .system)
        let buttonsView = UIView()
        
        
        view = UIView()
        view.backgroundColor = .white
        
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 24)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Нажми на буквы"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("ОТПРАВИТЬ ОТВЕТ", for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("ОЧИСТИТЬ", for: .normal)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        
//        cluesLabel.backgroundColor = .red
//        answersLabel.backgroundColor = .blue
//        scoreLabel.backgroundColor = .gray
//        currentAnswer.backgroundColor = .cyan
//        submitButton.backgroundColor = .lightGray
//        clearButton.backgroundColor = .magenta
//        buttonsView.backgroundColor = .systemIndigo
//        
        
        view.addSubview(scoreLabel)
        view.addSubview(cluesLabel)
        view.addSubview(answersLabel)
        view.addSubview(currentAnswer)
        view.addSubview(submitButton)
        view.addSubview(clearButton)
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -70),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),

            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
                
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 300),
            clearButton.centerYAnchor.constraint(equalTo: currentAnswer.centerYAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4{
            for col in 0..<5{
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                letterButton.setTitle(String(row) + String(col), for: .normal)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
        loadLevel()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    @objc func submitTapped(_ sender: UIButton){
        guard let answerText = currentAnswer.text else { return }
        if let solutionPosition = solutions.firstIndex(of: answerText){
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            if score % 7 == 0{
                let alertController = UIAlertController(title: "Супер! Все слова отгаданы!", message: "Готовы приступить к следующему уровню?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Поехали!", style: .default, handler: levelUp))
                present(alertController, animated: true)
            }
        }
        
    }
    @objc func clearTapped(_ sender: UIButton){
        currentAnswer.text = ""
        
        for button in activatedButtons{
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")
                print(lines)
                lines.remove(at: lines.count - 1)
                print(lines)
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    print(parts)
                    let answer = parts[0]
                    print(parts[0])
                    let clue = parts[1]
                    print(parts[1])
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "Состоит из \(solutionWord.count) букв\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count{
            for index in 0..<letterButtons.count{
                letterButtons[index].setTitle(letterBits[index], for: .normal)
            }
        }
    }
    func levelUp(action : UIAlertAction){
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
}

