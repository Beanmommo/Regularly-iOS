//
//  LoginViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 10/5/2023.
//

import UIKit

//First ViewController of the app, User need to login in order to access their data
class LoginViewController: UIViewController {

    
    weak var authenticateController: AuthenticateProtocol?
    weak var firebaseController: FirebaseController?
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBAction func singInButtonTap(_ sender: Any) {
        Task { @MainActor in
            //1. Validate input
            guard let email = emailField.text,let pass = passField.text, pass.count >= 6, !pass.isEmpty, email.contains("@"), email.contains("."), !email.isEmpty else{
                print("Display errror message")
                return
            }
            
            //2. Attempt login
            do{
                let _ = try await authenticateController?.loginAccount(email: email, pass: pass)
            }catch{
                print(error)
            }
            
            //3. Check if user id is retrieved
            //Change to guard statment
            if authenticateController?.signInUserId != "" {
                
                //4. Set firebaseDatabase value
                guard let signInUserId = authenticateController?.signInUserId else{
                    print("SignIn user id is not initialised")
                    return
                }
                do{
                    try await firebaseController?.setupDatabaseValue(forUser: signInUserId)
                }catch{
                    print(error)
                }
                
                performSegue(withIdentifier: "signInSegue", sender: sender)
            }else{
                //4.Show sign in error message
                let title = "error"
                let message = "Failed to sign in, Invalid email and password combination, please consider create account."
                displayMessage(title: title, message: message )
            }
            
            
        }
    }
    
    //Run this func whenever create account button is tapped
    @IBAction func createAccButtonTap(_ sender: Any) {
        Task { @MainActor in
            //1. Validate input
            guard let email = emailField.text,let pass = passField.text, pass.count >= 6, !pass.isEmpty, email.contains("@"), email.contains("."), !email.isEmpty else{
                let title = "error"
                let message = "Failed to create an account, please check input"
                displayMessage(title: title, message: message )
                return
            }
            
            //2. attempt create account
            var createdUserUid = ""
            do{
                let userUid = try await authenticateController?.createAccount(email: email, pass: pass)
                createdUserUid = userUid ?? ""
                
            }catch{
                print(error)
                return
            }
            
            //3. Add user Documents in firestore
            do{
                let category = try await firebaseController?.addCategory(title: email)
                let user = try await firebaseController?.addUser(belongsTo: createdUserUid, category: category!)
            }catch{
                print(error)
            }
            
            do {
                try await authenticateController?.signOut()
            }catch{
                error
            }
            
            

            //Show Successfull account creation message
            let title = "Success"
            let message = "Account created sign in now!"
            displayMessage(title: title, message: message )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        authenticateController = appDelegate?.authenticateController
        firebaseController = appDelegate?.firebaseController
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

}
