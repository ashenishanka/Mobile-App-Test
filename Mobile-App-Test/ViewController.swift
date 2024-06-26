//
//  ViewController.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-25.
//
//  For Elegant Media app development test
import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        
        // Add tap gesture recognizer to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
              view.addGestureRecognizer(tapGesture)
        
        userAuthenticated()
    }
    @objc func hideKeyboard() {
           view.endEditing(true)
            //above line will dissmiss the keyboard
       }
    @IBAction func googleSignInBtnClicked(_ sender: UIButton) {
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
               return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            print("email is \(user.profile?.email ?? "error")")
            Auth.auth().signIn(with: credential) { result, error in

                self.userAuthenticated()
              // At this point, our user is signed in
               // print(result)
            }
                
        }
    }
    func showAlertController(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default,handler: nil))
        self.present(alert, animated: true)
    }
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        if userNameTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true{
            showAlertController("Cannot Login!","No empty field allowed")
        }else{
            let email = userNameTextField.text!
            let password = passwordTextField.text!
            performLogin(email,password)
        }
    }
    private func performLogin(_ email: String, _ password: String){
        let alertLogin = UIAlertController(title: "Login In...", message: "We are checking your account! Please wait", preferredStyle: .alert)
       
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        alertLogin.view.addSubview(activityIndicator)
        activityIndicator.leadingAnchor.constraint(equalTo: alertLogin.view.leadingAnchor,  constant: 20).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: alertLogin.view.topAnchor, constant: 10).isActive = true
        self.present(alertLogin, animated: true)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
//          print(authResult)
            if(error != nil){
                strongSelf.showAlertController("Cannot login", "Please check your email or password")
            }else{
               
                strongSelf.userAuthenticated()
            }
        }
    }
}

extension ViewController{
    func userAuthenticated(){
        if Auth.auth().currentUser != nil{
            //user already authenticated
            openHomeViewController()
        }
    }
    func openHomeViewController(){
       let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
       // self.present(homeViewController, animated: true)
        if let navigationController = self.navigationController{
            navigationController.setViewControllers([homeViewController], animated: true)
        }else{
            showAlertController("Error", "Functional error! Please contact the developer")
        }
        
    }
}
