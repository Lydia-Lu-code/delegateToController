//
//  addLiftJournalViewController.swift
//  delegateToController
//
//  Created by 維衣 on 2020/8/31.
//

import UIKit

class EditJournalViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var setTime: UIButton!
    @IBOutlet weak var subjectText: UITextField!
    @IBOutlet var emojiButtons: [UIButton]!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var lockLabel: UILabel!
    @IBOutlet weak var lockSwitch: UISwitch!
    @IBOutlet weak var imageButton: UIButton!
    
    var journal: Journal?
    var i:Int = 0
    var dayString:String = ""

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTimer()
        lockLabel.text = "Lock On"
        imageButton.imageView?.contentMode = .scaleAspectFill
        subjectText.delegate = self

        if let journal = journal{
            emojiLabel.text = journal.emoji
            subjectText.text = journal.subject
            journalTextView.text = journal.journalText
            
            if let imageName = journal.imageName {
                let imageUrl = Journal.documentsDirectory.appendingPathComponent(imageName).appendingPathExtension("jpg")
                let image = UIImage(contentsOfFile: imageUrl.path)
                imageButton.setImage(image, for: .normal)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard segue.destination is JournalTableViewController else {return}

        let emoji = emojiLabel.text ?? ""
        let time = dayString
        let subject = subjectText.text ?? ""
        let journalText = journalTextView.text ?? ""
        var imageName: String?
        
        imageName = UUID().uuidString
            let imageData = imageButton.image(for: .normal)?.jpegData(compressionQuality: 0.9)
            let  imageUrl = Journal.documentsDirectory.appendingPathComponent(imageName!).appendingPathExtension("jpg")
            try? imageData?.write(to: imageUrl)
        
        journal = Journal(emoji: emoji, time: time, subject: subject, journalText: journalText, imageName: imageName)
    }
    
    func imagePickerController(_ Picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]) {
        let image = info[ .originalImage] as? UIImage
            imageButton.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func setTimer(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dayString = dateFormatter.string(from: Date())
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy/MM/dd HH:mm"
        timeLabel.text = dateFormatter1.string(from: Date())
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        subjectText.resignFirstResponder()
          return true
    }
    
    @IBAction func resetTime(_ sender: UIButton) {
        setTimer()
    }
    
    @IBAction func addEmoji(_ sender: UIButton) {
        emojiLabel.text = emojiButtons[Int(sender.tag)].currentTitle
    }
    
    @IBAction func onSwitch(_ sender: UISwitch) {
        if sender.isOn{
            for index in 0...4{
                emojiButtons[index].isEnabled = true
            }
            subjectText.endEditing(false)
            journalTextView.isEditable = true
            lockLabel.text = "Lock On"
            imageButton.isEnabled = true

        }else{
            for index in 0...4{
                emojiButtons[index].isEnabled = false
            }
            subjectText.endEditing(true)
            journalTextView.isEditable = false
            lockLabel.text = "Lock Off"
            imageButton.isEnabled = false
        }
    }
    
    @IBAction func selectPhotoBtn(_ sender: UIButton) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
        
    }
}

