//
//  ViewController.swift
//  Netweek
//
//  Created by Saul Garza on 5/2/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: UIButton) {
        //checking to make sure that there crendentials aren't nil
        if let userName = userName.text{
            if let password = password.text{
                Auth.auth().signIn(withEmail: userName, password: password, completion: { (user, error) in
                    if error != nil{//there was an error login in
                        print(error!);
                    }
                    else{
                        self.performSegue(withIdentifier: "goToBuilding", sender: self)
                    }
                })
            }
        }
        
    }
    
}

