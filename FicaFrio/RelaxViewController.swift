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
    
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var heartBeating: UIImageView!
    
   
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    var startReadingHeartRate : GetHeartRate?// = GetHeartRate.init()
    var selectHeartRate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        startReadingHeartRate?.pause()
        
        let relaxGif = UIImage.gifImageWithName("Espiral_Novo")
//        gifView.image = RelaxGif
        
//        let relaxGif = UIImage.animatedImageNamed("respirar", duration: 5)
        gifView.image = relaxGif
        
        //let imageView = UIImageView(image: RelaxGif)
        //imageView.frame = CGRect(x: self.view.frame.size.width/2 - imageView.frame.size.width/4, y: self.view.frame.size.height/4, width: imageView.frame.size.width/2, height: imageView.frame.size.height/2)
        //view.addSubview(imageView)
        
        if selectHeartRate {
            print("selectHeartRate")
            startReadingHeartRate = GetHeartRate.init()
            startReadingHeartRate?.heartBeating = heartBeating;
            startReadingHeartRate?.startCameraCapture()
            //startReadingHeartRate?.resume()
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("viewWillDisappear")
        if selectHeartRate {
            startReadingHeartRate?.pause()
            startReadingHeartRate?.stopCameraCapture()
            //startReadingHeartRate = nil
        
            // Initialize database and user defaults
            //let defaults = NSUserDefaults.standardUserDefaults()
            //let database = BD.init()
        
            // Get current step and save its average heart rate on the database
            //let currentGoalID = defaults.stringForKey("currentGoalID")
            //let stepNumber = defaults.integerForKey("currentStepNumber")
            //let currentStep = database.fetchStep(stepNumber-1, forGoalID: currentGoalID)
            //let previousHeartRate = defaults.integerForKey("avgHeartRate")
            //defaults.setInteger(<#T##value: Int##Int#>, forKey: <#T##String#>)
            //database.setAvgHeartRate(avgHeartRate, toStep: currentStep)
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
