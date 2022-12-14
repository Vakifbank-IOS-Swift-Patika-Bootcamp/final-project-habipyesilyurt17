//
//  NoteFormVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 15.12.2022.
//

import UIKit

final class NoteFormVC: BaseVC {
    @IBOutlet weak var formLabel: UILabel!
    @IBOutlet weak var gameTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    private var noteFormViewModel: NoteFormViewModelProtocol = NoteFormViewModel()
    
    var choosenFormLabel: String?
    var choosenNote: Notes?
    var games: [Game]?
    var gameNames: [String]? {
        didSet {
            listOfGameName = gameNames ?? []
        }
    }
    var listOfGameName: [String] = []
    var notes: [Notes] = []
    
    var gameNamePickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NoteFormVC.removeFormVC))
        view.addGestureRecognizer(gestureRecognizer)
        formLabel?.text = choosenFormLabel ?? ""
        setDataTextFieldsForUpdating()
        gameTextField.delegate = self
        noteTextField.delegate = self
        setUpGameNamePickerView()
    }
    
    @objc func removeFormVC() {
        self.dismiss(animated: true, completion: nil)
    }
                                         
    private func setDataTextFieldsForUpdating() {
        if let note = choosenNote {
            if let name = note.gameName {
                self.gameTextField.text = name
            }
            if let note = note.note {
                self.noteTextField.text = note
            }
        }
    }
    
    private func setUpGameNamePickerView() {
        gameTextField.inputView = gameNamePickerView
        gameNamePickerView.delegate = self
        gameNamePickerView.dataSource = self
        gameNamePickerView.tag = 1
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let formType = formLabel.text else { return }
        
        guard let name = gameTextField.text else {return }

        guard let note = noteTextField.text else { return }
        
        if name.isEmpty || note.isEmpty {
            showErrorAlert(message: ConstantValue.INPUT_CANNOT_BE_EMPTY.rawValue) {
            }
        } else {
            noteFormViewModel.newOrEditForm(formType: formType, name: name, note: note, games: games, selectedNote: choosenNote) { isSuccess, error in
                if isSuccess {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    guard let error = error else { return }
                    self.showErrorAlert(message: error) {
                    }
                }
            }
        }
    }
}


extension NoteFormVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return listOfGameName.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return listOfGameName[row]
        default:
            return ConstantValue.DATA_NOT_FOUND.rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            gameTextField.text = listOfGameName[row]
            gameTextField.resignFirstResponder()
        default:
            return
        }
    }
}

extension NoteFormVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
