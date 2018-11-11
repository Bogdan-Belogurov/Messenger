//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 28/09/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import CoreData
import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var userImage: UIImageView!

    @IBOutlet var editButton: UIButton!
    @IBOutlet var saveStackView: UIStackView!
    @IBOutlet var newImageButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var nameProfileLabel: UILabel!
    @IBOutlet var descriptonProfileLabel: UILabel!
    @IBOutlet var actitvityIndicator: UIActivityIndicatorView!

    private var isEditMode: Bool = false
    var dataSavePicker: SaveProfileProtocol = StorageManager()
    
    var profile: UserProfile? {
        let name = nameTextField.text
        let description = descriptionTextField.text
        
        if name == nil || description == nil {
            return nil
        }
        
        if name!.isEmpty || description!.isEmpty {
            return nil
        }
         let image = userImage.image
        
        return UserProfile(name: name!, description: description!, image: image)
    }

    @IBOutlet var coreDataSave: UIButton!

    @IBAction func textFieldAction(_ sender: UITextField) {
        checkProfileInput()
    }
    
    func checkProfileInput() {
        if profile != nil {
            coreDataSave.alpha = 1.0
            coreDataSave.isEnabled = true
        } else {
            coreDataSave.alpha = 0.3
            coreDataSave.isEnabled = false
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        actitvityIndicator.isHidden = false
        actitvityIndicator.startAnimating()
        profile?.name = nameTextField.text
        profile?.description = descriptionTextField.text
        profile?.image = userImage.image
        dataSavePicker = StorageManager()
        

        dataSavePicker.saveUserProfile(userProfile: profile!) { success in
            self.actitvityIndicator.stopAnimating()
            self.actitvityIndicator.isHidden = true

            if success {
                self.successAlert()
                self.loadData()
                self.viewEditor(self.isEditMode)
            } else {
                self.errorAlert(function: { self.saveButtonPressed(sender) })
            }
        }
        view.endEditing(true)
    }

    @IBAction func editPressed(_ sender: Any) {
        viewEditor(isEditMode)
        coreDataSave.isEnabled = false
        coreDataSave.alpha = 0.3
    }

    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    let imagePicker = UIImagePickerController()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBAction func selectNewImage(_ sender: Any) {
        print("Выбери изображение профиля")
        setAlertControllerForSelectNewImage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // testFrameEditButton()
        imagePicker.delegate = self
        loadData()
        viewEditor(isEditMode)
        addKeyboardObserver()
        coreDataSave.isEnabled = false
        coreDataSave.alpha = 0.3
        self.nameTextField.placeholder = "Write your name"
        self.descriptionTextField.placeholder = "Some things about you"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sizeAndLayoutSettings()
    }

    func sizeAndLayoutSettings() {
        userImage.layer.cornerRadius = 30
        userImage.clipsToBounds = true

        newImageButton.layer.cornerRadius = 30
        newImageButton.clipsToBounds = true

        editButton.layer.cornerRadius = 20
        editButton.layer.borderWidth = 1.0
        editButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editButton.clipsToBounds = true

        actitvityIndicator.isHidden = true
    }

    private func viewEditor(_ state: Bool) {
        nameProfileLabel.isHidden = state
        descriptonProfileLabel.isHidden = state
        saveStackView.isHidden = !state
        nameTextField.isHidden = !state
        descriptionTextField.isHidden = !state
        newImageButton.isHidden = !state
        editButton.isHidden = state
        isEditMode = !isEditMode
    }

    private func setAlertControllerForSelectNewImage() {
        let alertController = UIAlertController(title: NSLocalizedString("Истоник фотографий", comment: "Истоник фотографий"), message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("Камера", comment: "Камера"), style: .default, handler: { _ in

            if !(UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let warningAlert = UIAlertController(title: "Ошибка!", message: "Невозможно использовать камеру", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)

                warningAlert.addAction(closeAction)
                self.present(warningAlert, animated: true, completion: nil)
            } else {
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            self.checkProfileInput()
        })
        let photoLibAction = UIAlertAction(title: NSLocalizedString("Фото", comment: "Фото"), style: .default, handler: { _ in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary

            self.present(self.imagePicker, animated: true, completion: nil)
            self.checkProfileInput()
        })

        let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: "Отмена"), style: .cancel, handler: { _ in
            self.coreDataSave.isEnabled = false
            self.coreDataSave.alpha = 0.3
        })

        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }

    private func successAlert() {
        let alertController = UIAlertController(title: "Changes saved!", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func errorAlert(function: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        let repeatAction = UIAlertAction(title: "Save again", style: .default, handler: {
            (_: UIAlertAction!) in function()
        })

        alertController.addAction(repeatAction)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Delegates For Image Picker

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            userImage.contentMode = .scaleToFill
            userImage.image = chosenImage
        }
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Load Data Info Profile

    func loadData() {
        dataSavePicker.loadUserProfile { profile in
            if let name = profile?.name {
                self.nameProfileLabel.text = name
            }
            if let description = profile?.description {
                self.descriptonProfileLabel.text = description
            }
            
            self.nameTextField.text = profile?.name
            self.descriptionTextField.text = profile?.description
            self.userImage.image = profile?.image
        }
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y == 0,
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.size.height
            view.frame = CGRect(x: view.frame.origin.x,
                                y: -keyboardHeight + (25 + saveStackView.frame.height),
                                width: view.frame.width,
                                height: view.frame.height)
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame = CGRect(x: view.frame.origin.x,
                            y: 0,
                            width: view.frame.width,
                            height: view.frame.height)
        view.layoutIfNeeded()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
