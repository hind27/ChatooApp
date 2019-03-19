//
//  ViewController.swift
//  ChatooApp
//
//  Created by hind on 3/13/19.
//  Copyright © 2019 hind. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController ,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
 

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
       
    }

  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CellForm", for: indexPath) as! Formcell
        if(indexPath.row == 0 )
        {
            //sign in Cell
            cell.userNameContainer.isHidden = true
            cell.actionButton.setTitle("Log in", for: .normal)
            cell.slideButton.setTitle("Sign Up 👉🏻", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToSignInCell(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(didPressSignIn(_:)), for: .touchUpInside)
            
        }else if(indexPath.row == 1)
        {
            //Sign up Cell
            cell.userNameContainer.isHidden = false
            cell.actionButton.setTitle("Sign Up", for: .normal)
            cell.slideButton.setTitle("Sign in 👈🏻", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToSignUpCell(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(didPressSignUp(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    @objc func didPressSignIn(_ sender: UIButton){
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! Formcell
        guard let emailAddress = cell.emailTextField.text, let password = cell.passwordTextField.text else {
            return
        }
        
        if(emailAddress.isEmpty == true || password.isEmpty == true){
            self.displayError(errorText: "Please fill empty fields")
        } else {
            
            Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
                if(error == nil){
                    self.dismiss(animated: true, completion: nil)
                    print(result?.user)
                } else {
                    self.displayError(errorText: "Wrong username or password")
                }
            }
        }
    }
    @objc func didPressSignUp(_ sender: UIButton){
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! Formcell
        guard let emailAddress = cell.emailTextField.text, let password = cell.passwordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if(error == nil){
                guard let userId = result?.user.uid, let userName = cell.userNameTextField.text else {
                    return
                }
                self.dismiss(animated: true, completion: nil)
                let reference = Database.database().reference()
                let user = reference.child("users").child(userId)
                let dataArray:[String: Any] = ["username": userName]
                user.setValue(dataArray)
            }
        }
        
    }
    @objc func slideToSignInCell(_ sender: UIButton){
        let indexPath = IndexPath(row: 1, section: 0)
        
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    @objc func slideToSignUpCell(_ sender: UIButton){
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    func displayError(errorText: String){
        let alert = UIAlertController.init(title: "Error", message: errorText, preferredStyle: .alert)
        let dismissButton = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

