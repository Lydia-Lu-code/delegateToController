//
//  fiveMinutesJournalTableViewController.swift
//  delegateToController
//
//  Created by 維衣 on 2020/8/31.
//

import UIKit

class JournalTableViewController: UITableViewController {

    var journals = [Journal]()
    var text: String?

    @IBAction func unwindToEditJournalViewController(_ unwindSegue: UIStoryboardSegue) {

        if let sourceViewController = unwindSegue.source as? EditJournalViewController,
           let journal = sourceViewController.journal {
            if let indexPath = tableView.indexPathForSelectedRow {
                journals[indexPath.row] = journal
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }else{
                journals.insert(journal,at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            Journal.saveToFile(journals: journals)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        journals.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        Journal.saveToFile(journals: journals)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docDir.appendingPathComponent("journals").appendingPathExtension("plist")
        print(url)
        
        if let journals = Journal.readLoversFromFile(){
            self.journals = journals
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        journals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as! JournalTableViewCell
        let journal = journals[indexPath.row]
        cell.emojiLab?.text = journal.emoji
        cell.timeLab?.text = journal.time
        cell.subjectLab?.text = journal.subject
        self.text = journal.journalText
        cell.smallImage?.image = UIImage(named: "\(String(describing: journal.imageName))")
        
        if let imageName = journal.imageName {
            let imageUrl = Journal.documentsDirectory.appendingPathComponent(imageName).appendingPathExtension("jpg")
            let image = UIImage(contentsOfFile: imageUrl.path)
            cell.smallImage?.image = image
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditJournalViewController,
           let row = tableView.indexPathForSelectedRow?.row{
            controller.journal = journals[row]
        }
    }
}

