//
//  HomeViewController.swift
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

import Foundation

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    var CurrentGoal : String = ""
    
    @IBOutlet weak var NewGoalView: UIView!
    @IBOutlet weak var TaskText: UITextField!
    @IBOutlet weak var insertGoalLabel: UILabel!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!

    @IBAction func DismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func NewGoalButton(sender: UIButton) {
        UIView.animateWithDuration(0.4, animations: {
            self.NewGoalView.alpha = 1
        })
    }
    
    @IBAction func SetTask(sender: AnyObject) {
        self.resignFirstResponder()
        CurrentGoal = TaskText.text!

    }
    
    
    // Configura view
    func ShowNewGoalView() {
        UIView.animateWithDuration(0.4, animations: {
            self.NewGoalView.hidden = false
            self.NewGoalView.alpha = 0.98
        })
    }
    
    
    
    override func viewDidLoad() {
    
        NewGoalView.hidden = false
        NewGoalView.alpha = 0
        
        super.viewDidLoad()
        TaskText.delegate = self;
        self.view.addGestureRecognizer(tapGesture)
        
        insertGoalLabel.text = NSLocalizedString("Insira sua meta", comment:"")
        
        
      /*  let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "balao_InsirasuaMeta2.png")
        self.NewGoalView.insertSubview(backgroundImage, atIndex: 0)
     */
 
 
     // Configura a logo
        let logoGif = UIImage.gifImageWithName("GifInicial")
        let imageView = UIImageView(image: logoGif)
        imageView.frame = CGRect(x: self.view.frame.size.width/2 - imageView.frame.size.width/6, y: self.view.frame.size.height - imageView.frame.size.height, width: imageView.frame.size.width/3, height: imageView.frame.size.height/3)
        view.addSubview(imageView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        ViewUpanimateMoving(true, upValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
        
        let goalName = TaskText.text
        let defaults = NSUserDefaults.init()
        defaults.setObject(goalName, forKey: "goalName")
        TaskText.resignFirstResponder();
        ViewUpanimateMoving(false, upValue: 100)

    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        TaskText.resignFirstResponder()
        return true;
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        TaskText.resignFirstResponder();
        self.performSegueWithIdentifier("homeToSet", sender: self)
        return true;
    }
    
    func ViewUpanimateMoving (up:Bool, upValue :CGFloat){
        let durationMovement:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -upValue : upValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(durationMovement)
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }

    
    
    
}
