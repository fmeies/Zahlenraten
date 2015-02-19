//
//  ViewController.swift
//  Zahlenraten
//
//  Created by Frank Meies on 24.01.15.
//  Copyright (c) 2015 Frank Meies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var lowerBoundaryField: UITextField!
    @IBOutlet weak var upperBoundaryField: UITextField!
    @IBOutlet weak var inputButton: UIButton!
	@IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!

	var game:Game
	
	required init(coder aDecoder: NSCoder)
	{
		self.game = Game()
		super.init(coder: aDecoder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func newGamePressed() {
		newGame()
  	}
    
	@IBAction func buttonPressed() {
        if(inputField.hidden){
            startGame()
        } else {
            nextGuess()
        }
    }
	
	@IBAction func infoPressed() {
		let alert = UIAlertView(title: "Zahlenraten", message: "(c) Frank & Emma Meies", delegate:nil, cancelButtonTitle:"Ok")
		alert.show()
		// not compatible with ios 7:
		//let alertController = UIAlertController(title: "Zahlenraten", message: "(c) Frank & Emma Meies", preferredStyle: UIAlertControllerStyle.Alert)
		//alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
		//self.presentViewController(alertController, animated: true, completion: nil)
	}
	
    func nextGuess(){
		var inputInt : UInt = 0
		if let input = inputField.text?.toInt() {
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
		
		if let lowerInput = lowerBoundaryField.text?.toInt() {
			lowerInt = UInt(lowerInput)
		} else {
			lowerBoundaryField.text = "1"
			return
		}
		
		if let upperInput = upperBoundaryField.text?.toInt() {
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
	
	func switchMode(startGame : Bool){
		lowerBoundaryField.hidden = startGame
		upperBoundaryField.hidden = startGame
		inputField.hidden = !startGame
		inputField.enabled = startGame
		inputButton.enabled = true
	}
	
	func updateStatus() {
		inputField.text = ""

		var moves = "Jetzt kommt dein " + String(game.moves + 1) + ". Zug"
		var message = "Bitte die Grenzen beachten!"

		var status : UInt = game.status;
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
			inputField.enabled = false
			inputButton.enabled = false
		}
		
		messageLabel.text = message
		movesLabel.text = moves

	}
}

