//
//  SettingsViewController.swift
//  YearLongProject
//
//  Created by Derek Stengel on 7/1/24.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    weak var delegate: SettingsDelegate?
    
    @IBOutlet var nameChangeTextField: UITextField!
    @IBOutlet var bioChangeTextView: UITextView!
    @IBOutlet var interestsChangeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameChangeTextField.text = profile.name
        bioChangeTextView.text = profile.bio
        interestsChangeTextView.text = profile.interests
        
        nameChangeTextField.delegate = self
        bioChangeTextView.delegate = self
        interestsChangeTextView.delegate = self
        
        bioChangeTextView.tag = 1
        interestsChangeTextView.tag = 2
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // Dismiss keyboard if return key is pressed
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            
            // Determine the character limit based on the textView
            let characterLimit: Int
            if textView.tag == 1 {
                characterLimit = 130 // Set character limit for textView1
            } else if textView.tag == 2 {
                characterLimit = 75 // Set character limit for textView2
            } else {
                characterLimit = 0 // Default or fallback character limit
            }
            
            // Check if the new text exceeds the character limit
            let currentText = textView.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
            return newText.count <= characterLimit || characterLimit == 0
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Calculate the new text
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // Set your desired character limit here
        let characterLimit = 20

        return updatedText.count <= characterLimit
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        delegate?.didUpdateProfile(
            name: nameChangeTextField.text,
            bio: bioChangeTextView.text,
            interests: interestsChangeTextView.text
        )
        dismiss(animated: true, completion: nil)
    }
}
