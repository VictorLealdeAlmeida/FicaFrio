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
    
    
    @IBOutlet weak var NewGoalView: UIView!
    
    
    @IBOutlet weak var TaskText: UITextField!
    
    @IBAction func NewGoalButton(sender: UIButton) {
        UIView.animateWithDuration(0.4, animations: {
            self.NewGoalView.alpha = 1
        })
    }
    
    @IBAction func SetTask(sender: AnyObject) {
        self.resignFirstResponder()

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
        TaskText.clearsOnBeginEditing = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
        TaskText.resignFirstResponder();

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
        return true;
    }

    
    
    
}
