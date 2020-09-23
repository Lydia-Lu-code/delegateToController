//
//  JournalTableViewCell.swift
//  delegateToController
//
//  Created by 維衣 on 2020/9/21.
//

import UIKit

class JournalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emojiLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var subjectLab: UILabel!
    @IBOutlet weak var smallImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
