//
//  BreathingViewController.swift
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

import Foundation
import UIKit

class RelaxViewController: UIViewController {
    
   
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    var startReadingHeartRate : GetHeartRate?
    var selectHeartHate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let RelaxGif = UIImage.gifImageWithName("Espiral3")
        let imageView = UIImageView(image: RelaxGif)
        imageView.frame = CGRect(x: self.view.frame.size.width/2 - imageView.frame.size.width/4, y: self.view.frame.size.height/4, width: imageView.frame.size.width/2, height: imageView.frame.size.height/2)
        view.addSubview(imageView)
        
        if selectHeartHate {
            print("you chose to measure your heart rate");
            startReadingHeartRate = GetHeartRate.init()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("viewWillDisappear")
        if selectHeartHate {
            startReadingHeartRate?.pause()
            startReadingHeartRate = nil
        
            // Initialize database and user defaults
            let defaults = NSUserDefaults.standardUserDefaults()
            let database = BD.init()
        
            // Get current step and save its average heart rate on the database
            let currentGoalID = defaults.stringForKey("currentGoalID")
            let stepNumber = defaults.integerForKey("currentStepNumber")
            let currentStep = database.fetchStep(stepNumber, forGoalID: currentGoalID)
            let avgHeartRate = defaults.floatForKey("avgHeartRate")
            database.setAvgHeartRate(avgHeartRate, toStep: currentStep)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
