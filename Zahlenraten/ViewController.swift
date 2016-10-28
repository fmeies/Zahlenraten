//
//  ViewController.swift
//  Zahlenraten
//
//  Created by Frank Meies on 24.01.15.
//  Copyright (c) 2015 Frank Meies. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var lowerBoundaryField: UITextField!
    @IBOutlet weak var upperBoundaryField: UITextField!
    @IBOutlet weak var inputButton: UIButton!
	@IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!

	var game:Game
	
	required init?(coder aDecoder: NSCoder)	{
		self.game = Game()
		super.init(coder: aDecoder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		let recognizer = UITapGestureRecognizer(target: self, action:#selector(ViewController.handleTap(_:)))
		recognizer.delegate = self
		view.addGestureRecognizer(recognizer)
	}

	func handleTap(_ recognizer: UITapGestureRecognizer) {
		// remove keyboard
		inputField.resignFirstResponder()
		lowerBoundaryField.resignFirstResponder()
		upperBoundaryField.resignFirstResponder()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func newGamePressed() {
		newGame()
  	}
    
	@IBAction func buttonPressed() {
        if(inputField.isHidden){
			startGame()
			inputField.becomeFirstResponder()
        } else {
            nextGuess()
        }
    }
	
	@IBAction func infoPressed() {
		let alertController = UIAlertController(title: "Zahlenraten " + ViewController.getVersion(), message: "(c) Frank & Emma Meies", preferredStyle: UIAlertControllerStyle.alert)
		alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
		self.present(alertController, animated: true, completion: nil)
	}
	
    func nextGuess(){
		var inputInt : UInt = 0
		if let input = Int(inputField.text!) {
			inputInt = UInt(input)
		}
		
        game.guess(inputInt)
        updateStatus()
    }
    
    func newGame(){
		switchMode(false)
		movesLabel.text = "Wähle die Grenzen: "
		messageLabel.text = "Warten auf Eingabe!"
    }
	
    func startGame(){
		var lowerInt : UInt = 0
		var upperInt : UInt = 0
		
		if let lowerInput = Int(lowerBoundaryField.text!) {
			lowerInt = UInt(lowerInput)
		} else {
			lowerBoundaryField.text = "1"
			return
		}
		
		if let upperInput = Int(upperBoundaryField.text!) {
			upperInt = UInt(upperInput)
		} else {
			upperBoundaryField.text = "100"
			return
		}
		
		if(upperInt < lowerInt) {
			lowerBoundaryField.text = "1"
			upperBoundaryField.text = "100"
			messageLabel.text = "Grenzen falsch angegeben!"
			return
		}

		switchMode(true)
		game.reset(lowerInt, upperBoundary: upperInt)
		updateStatus()
    }
	
	func switchMode(_ startGame : Bool){
		lowerBoundaryField.isHidden = startGame
		upperBoundaryField.isHidden = startGame
		inputField.isHidden = !startGame
		inputField.isEnabled = startGame
		inputButton.isEnabled = true
	}
	
	func updateStatus() {
		inputField.text = ""

		var moves = "Jetzt kommt dein " + String(game.moves + 1) + ". Zug"
		var message = "Bitte die Grenzen beachten!"

		let status : UInt = game.status;
		if(status == 0){
			message = "Gib eine Zahl ein!"
		}
		if(status == 1){
			message = "Die Zahl ist zu klein!"
		} else if (status == 2){
			message = "Die Zahl ist zu gross!"
		} else if (status == 3){
			moves = "Juhu, du hast gewonnen!!!"
			message =  "Du hast " + String(game.moves) + " Züge gebraucht."
			inputField.isEnabled = false
			inputButton.isEnabled = false
		}
		
		messageLabel.text = message
		movesLabel.text = moves

	}
	
	class func getVersion() -> String {
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			return version
		}
		return ""
	}
}

