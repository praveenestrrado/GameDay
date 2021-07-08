//
//  ViewController.swift
//  GameDay
//
//  Created by MAC on 14/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ViewBase: UIView!
    @IBOutlet weak var laounchImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {

            self.animation()
        })
        
        
     
        
        
        laounchImage.alpha = 9;
    }

    func animation()
    {
        
        
        UIView.animate(withDuration: 3, delay: 0.1, options: .beginFromCurrentState, animations: {
            self.ViewBase.alpha = 3
            self.ViewBase.alpha = 2
            self.ViewBase.alpha = 1
            self.ViewBase.alpha = 0.9
            self.ViewBase.alpha = 0.8
            self.ViewBase.alpha = 0.7
            self.ViewBase.alpha = 0.6
            self.ViewBase.alpha = 0.5
            self.ViewBase.alpha = 0.4
            self.ViewBase.alpha = 0.3
            self.ViewBase.alpha = 0.2
            self.ViewBase.alpha = 0.1
            
        }, completion: { done in
            
            if done
            {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(next, animated: false)
            }
        })
        

    }

}

