//
//  ViewController.swift
//  Breakout
//
//  Created by Sai Girap on 6/22/17.
//  Copyright © 2017 Sai Girap. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func screenTapped(_ sender: Any) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let detailController = segue.destination as! GameViewController
    }


}
