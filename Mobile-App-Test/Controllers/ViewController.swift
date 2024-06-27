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

    // MARK: - Reference to UI elements
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    //end reference
    
    // MARK: - Life cycle functions
    override func viewWillAppear(_ animated: Bool) {
        //hiding the navigation bar when view is going to appear
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        //unhide the navigation bar when view is going to disappear (going to open another view controller)
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //below codes are from Google authentication documentation that we should use when we are going to access Google Login with Firebase
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        
        // Add tap gesture recognizer to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
              view.addGestureRecognizer(tapGesture)
        
        //we are going to call userAuthenticated function to check whether current user is already authenticated or not
        userAuthenticated()
    }
    @objc func hideKeyboard() {
           view.endEditing(true)
            //above line will dissmiss the keyboard
       }
    @IBAction func googleSignInBtnClicked(_ sender: UIButton) {
        // Start the Google sign in flow!
        //Codes are from Google authentication official page
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
            //Google authentication is success
            //Now wea are going to signin user with firebase using credentials received from the Google
            Auth.auth().signIn(with: credential) { result, error in

            
              // At this point, our user is signed in
               //going to call userAuthenticated function to check whether authenticated and will open Home page for authenticated users
                self.userAuthenticated()
               // print(result)
            }
                
        }
    }
    // MARK: - Reusable alert controller for show alert messages to users
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
            strongSelf.dismiss(animated: true)
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
            //calling to openHomeViewController
            openHomeViewController()
        }
    }
    func openHomeViewController(){
        //going to open Hotel Home View Controller
        
        performSegue(withIdentifier: "openHome", sender: nil)
        
    }
}
