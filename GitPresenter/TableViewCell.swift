//
//  TableViewCell.swift
//  GitPresenter
//
//  Created by Максим on 05.08.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ownerLogin: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    
    static let id = Identifier.cell
    static func nib() -> UINib {
        return UINib(nibName: Identifier.cell, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(repository: Repository) {
        self.name.text = repository.name
        self.id.text = String(repository.id)
        self.ownerLogin.text = repository.owner.login
        self.repoDescription.text = repository.description
        self.textLabel?.text = ""
    }
    
    func loader() {
        self.name.text = ""
        self.id.text = ""
        self.ownerLogin.text = ""
        self.repoDescription.text = ""
        self.textLabel?.text = "Загрузка..."
        self.textLabel?.textColor = .systemBlue
    }
    
}
