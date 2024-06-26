//
//  HomeViewController.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-26.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnLogoutClicked(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
        }catch{
            print("error")
        }
    }
    func openMainViewController(){
       let vc = ViewController()
       present(vc, animated: true)
        
    }
}
