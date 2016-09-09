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
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}