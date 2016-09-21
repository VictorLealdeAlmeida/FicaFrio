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
    
    var CurrentGoal : String = ""
    
    @IBOutlet weak var gifView: UIImageView!
    
    
    @IBOutlet weak var NewGoalView: UIView!
    @IBOutlet weak var TaskText: UITextField!
    @IBOutlet weak var insertGoalLabel: UILabel!
    @IBOutlet weak var newGoalButton: UIButton!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!

    @IBAction func DismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
    
    @IBAction func SetTask(sender: AnyObject) {
        self.resignFirstResponder()
        CurrentGoal = TaskText.text!

    }
    
    
    // Configura view
   /* func ShowNewGoalView() {
        UIView.animateWithDuration(0.6, animations: {
            self.NewGoalView.hidden = false
            self.NewGoalView.alpha = 0.98
        })
    }
    
 */
    
    override func viewDidLoad() {
    
        NewGoalView.hidden = true
        NewGoalView.alpha = 0
        
        TaskText.autocapitalizationType = UITextAutocapitalizationType.Sentences
        
        newGoalButton.setTitle(NSLocalizedString("New Goal", comment: ""), forState: UIControlState.Normal)
        
        super.viewDidLoad()
        TaskText.delegate = self;
        self.view.addGestureRecognizer(tapGesture)
        
        insertGoalLabel.text = NSLocalizedString("Insert your goal", comment:"")
        
        
      /*  let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "balao_InsirasuaMeta2.png")
        self.NewGoalView.insertSubview(backgroundImage, atIndex: 0)
     */
 
 
     // Configura a logo
        let logoGif = UIImage.gifImageWithName("GIF_INICIAL_CERTO")
        gifView.image
            = logoGif
        //let imageView = UIImageView(image: logoGif)
        //imageView.frame = CGRect(x: self.view.frame.size.width/2 - imageView.frame.size.width/6, y: self.view.frame.size.height - imageView.frame.size.height, width: imageView.frame.size.width/3.2, height: imageView.frame.size.height/3.2)
        //view.addSubview(imageView)
       // imageView.backgroundColor = UIColor.clearColor()
        
        //let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        //let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        //blurEffectView.frame = self.view.bounds
        //blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight,]
        
        //self.view.addSubview(blurEffectView)
        //blurEffectView.addSubview(imageView);
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
//        let goalName = TaskText.text
//        let defaults = NSUserDefaults.init()
//        defaults.setObject(goalName, forKey: "goalName")
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
        //print("While entering the characters this method gets called")
        let maxLength = 45
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        TaskText.resignFirstResponder();
        let goalName = TaskText.text
        let defaults = NSUserDefaults.init()
        defaults.setObject(goalName, forKey: "goalName")
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
