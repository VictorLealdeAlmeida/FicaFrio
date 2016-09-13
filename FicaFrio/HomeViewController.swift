//
//  HomeViewController.swift
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

import Foundation

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var NewGoalView: UIView!
    
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
