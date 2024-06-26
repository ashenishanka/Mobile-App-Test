//
//  NewAccountViewController.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-25.
//

import UIKit
import FirebaseAuth

class NewAccountViewController: UIViewController {

    func showAlertController(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default,handler: nil))
        self.present(alert, animated: true)
    }
    @IBOutlet weak var emailNewAccountTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func btnCreateAccount(_ sender: UIButton) {
        if emailNewAccountTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true{
            showAlertController("Cannot create the account","No empty fields allowed")
        }else{
            if(passwordTextField.text!.count >= 6){
                let email = emailNewAccountTextField.text!
                let password = passwordTextField.text!
                let alertNewAccount = UIAlertController(title: "Creating Account...", message: "We are working to create your Account! Please wait", preferredStyle: .alert)
               
                let activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                activityIndicator.startAnimating()
                
                alertNewAccount.view.addSubview(activityIndicator)
                activityIndicator.leadingAnchor.constraint(equalTo: alertNewAccount.view.leadingAnchor,  constant: 20).isActive = true
                activityIndicator.topAnchor.constraint(equalTo: alertNewAccount.view.topAnchor, constant: 10).isActive = true
                self.present(alertNewAccount, animated: true)
                
                Auth.auth().createUser(withEmail: email, password: password){[weak self]authResult, error in
                    if authResult?.user != nil{
                        
                        guard let strongSelf = self else{
                            return
                        }
                        strongSelf.dismiss(animated: true)
                        let alert = UIAlertController(title:"Successful",message: "Now you can SignIn to your account", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default,handler: {[weak self]_ in
                            strongSelf.navigationController?.popViewController(animated: true)
                        }))
                        
                        strongSelf.present(alert, animated: true)
                        
                        
                    }
                }
            }else{
                showAlertController("Cannot create the account","Password should consist  atleast 6 character")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
