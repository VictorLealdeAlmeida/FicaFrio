//
//  HomeViewController.swift
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

import Foundation;
import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var NewGoalView: UIView!
    @IBOutlet weak var TaskText: UITextField!
    @IBOutlet weak var insertGoalLabel: UILabel!
    @IBOutlet weak var newGoalButton: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    let number = 1;
    let direction = 1;
    let shakes = 55;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NewGoalView.hidden = true
        NewGoalView.alpha = 0
        
        TaskText.autocapitalizationType = UITextAutocapitalizationType.Sentences
        TaskText.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        insertGoalLabel.text = NSLocalizedString("Insert your goal", comment:"")
    }
    
    override func viewDidAppear(animated: Bool) {
        // Configura a logo
        //let logoGif = UIImage.gifImageWithName("INICIAL")
        //let logoGif = UIImage.animatedImageNamed("inicial", duration: 2.25)
        //gifView.image = logoGif
        
        var gifFrames: [UIImage] = []
        
        for i in 1...20 {
            gifFrames.append(UIImage.init(named: "inicial\(i).png")!)
        }
        
        gifView.animationImages = gifFrames
        gifView.image = gifFrames.last
        gifView.animationDuration = 2.25
        gifView.animationRepeatCount = 1
        gifView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NewGoalButton(sender: UIButton) {
        UIView.animateWithDuration(0.6, animations: {
            if self.NewGoalView.hidden {
                // balloon appears
                self.newGoalButton.setImage(UIImage.init(named: "botao_menos_novo"), forState: UIControlState.Normal)
                self.NewGoalView.alpha = 1
                self.NewGoalView.hidden = false
            }
            else {
                // balloon disappears
                self.NewGoalView.alpha = 0
                self.newGoalButton.setImage(UIImage.init(named: "botao_azul_novaMeta"), forState: UIControlState.Normal)
            }
            
            }, completion: {(finished:Bool) in
                if self.NewGoalView.alpha == 0{
                    self.NewGoalView.hidden = true
                } })
    }
    
    @IBAction func DismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        //print("TextField did begin editing method called")
        ViewUpanimateMoving(true, upValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        //print("TextField did end editing method called")
        TaskText.resignFirstResponder();
        ViewUpanimateMoving(false, upValue: 100)

    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //print("While entering the characters this method gets called")
        let maxLength = 45
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //print("TextField should return method called")
        
        if TaskText.text!.characters.count < 1 {
            self.shakeview(NewGoalView, numberOfShakes: 1, direction: 1, maxShakes: 55);
        }
        else {
            let goalName = TaskText.text
            let defaults = NSUserDefaults.init()
            defaults.setObject(goalName, forKey: "goalName")
            self.performSegueWithIdentifier("homeToSet", sender: self)
        }

        return true;
    }
    
    // Animations
    func ViewUpanimateMoving (up:Bool, upValue :CGFloat){
        let durationMovement:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -upValue : upValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(durationMovement)
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    func shakeview (NewGoalView: UIView, numberOfShakes : Int, direction: CGFloat, maxShakes : Int) {
        
        let interval : NSTimeInterval = 0.03
        
        UIView.animateWithDuration(interval, animations: { () -> Void in
            NewGoalView.transform = CGAffineTransformMakeTranslation(5 * direction, 0)
            
            }, completion: { (aBool :Bool) -> Void in
                
                if (numberOfShakes >= maxShakes) {
                    NewGoalView.transform = CGAffineTransformIdentity
                    NewGoalView.becomeFirstResponder()
                    return
                }
        })
        
    }
    
}
