//
//  SettingsViewController.swift
//  GoonMaker
//
//  Created by Gregory Keeley on 2/12/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    let dataPersistence = PersistenceHelper()
    var name: String = "" {
        didSet {
            nameTextField.placeholder = name
            print("New name: \(name)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    private func saveName(name: String) {
        try? dataPersistence.changeUserName(name: name)
    }
    private func loadName() {
        do {
            name = try PersistenceHelper.loadUserName()
            
        } catch {
            print("Error loading userName: \(error)")
        }
    }
    @IBAction func submitNameButtonPressed(_ sender: UIButton) {
        
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let name = textField.text else { return false }
        saveName(name: name)
        return true
    }
}
