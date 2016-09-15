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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let RelaxGif = UIImage.gifImageWithName("respiracao")
        let imageView = UIImageView(image: RelaxGif)
        imageView.frame = CGRect(x: 110, y: 120, width: self.view.frame.size.width - 221, height: 223)
        view.addSubview(imageView)
        
        // Initialize database and user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        let database = BD.init()
        
        let startReadingHeartRate = GetHeartRate.init()
        
        // Get current step and save its average heart rate on the database
        let currentGoalID = defaults.stringForKey("currentGoalID")
        let stepNumber = defaults.integerForKey("currentStepNumber")
        let currentStep = database.fetchStep(stepNumber, forGoalID: currentGoalID)
        let avgHeartRate = defaults.floatForKey("avgHeartRate")
        database.setAvgHeartRate(avgHeartRate, toStep: currentStep)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
