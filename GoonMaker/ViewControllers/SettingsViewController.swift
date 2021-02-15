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
    let defaults = UserDefaults.standard
    var name: String = "" {
        didSet {
            nameTextField.placeholder = name
            print("New name: \(name)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadName()
    }
    private func saveName(name: String) {
        defaults.setValue(name, forKey: "userName")
        loadName()
    }
    private func loadName() {
        if let userName = defaults.string(forKey: "userName") {
            name = userName
        }
    }
    @IBAction func submitNameButtonPressed(_ sender: UIButton) {
        let userName = nameTextField.text ?? "ERROR"
        saveName(name: userName)
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
