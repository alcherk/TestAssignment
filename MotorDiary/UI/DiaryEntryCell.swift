//
//  DiaryEntryCellTableViewCell.swift
//  MotorDiary
//
//  Created by lex on 10/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import UIKit

class DiaryEntryCell: UITableViewCell {
    
    static let reuseID = "DiaryEntryCell"
    
    @IBOutlet var buttons: [CheckButton]!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dotImage: UIImageView!
    
    private var time = Date()
    private var viewModel: EntryViewModel!
    
    private var status: EntryStatus = .future {
        didSet {
            contentView.isUserInteractionEnabled = true
            contentView.alpha = 1
            dotImage.isHidden = true
            switch status {
            case .filled:
                contentView.backgroundColor = UIColor.diaryChecked
            case .future:
                contentView.isUserInteractionEnabled = false
                contentView.alpha = 0.5
                contentView.backgroundColor = .white
            case .unknown:
                contentView.backgroundColor = UIColor.diaryEmpty
                dotImage.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        buttons.forEach {
            $0.valueChanged = self.buttonSelected
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttons.forEach {
            $0.isChecked = false
        }
        status = .future
    }
    
    func buttonSelected(_ sender: CheckButton) {
        buttons.forEach {
            $0.isChecked = $0 == sender
        }
        
        status = .filled
        
        if let index = buttons.index(where: { $0 == sender }) {
            self.viewModel.updateType(index: index)
        }
    }
    
    func setup(with viewModel: EntryViewModel) {
        self.viewModel = viewModel
        timeLabel.text = viewModel.time
        if let index = viewModel.selectionIndex, index < buttons.count {
            buttons[index].isChecked = true
        }
        
        self.status = viewModel.status
    }
}
