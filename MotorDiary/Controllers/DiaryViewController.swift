//
//  DiaryViewController.swift
//  MotorDiary
//
//  Created by lex on 10/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var hintHeader: UIView!
    @IBOutlet weak var hintViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hintView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    @IBOutlet weak var onDysLabel: UILabel!
    
    private var statusBarColor: UIColor?
    private var hintHeaderTap = UITapGestureRecognizer()
    var diary: Diary!
    
    private let hintMessae = "Please provide information regarding how you would rate your mobility for each 30-minutes period."
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        setupUI()
    }
    
    private func setupUI() {
        setupDysLabel()
        hintViewHeight.constant = 0.0
        addShadow(to: tableHeaderView)
        addShadow(to: hintView)
        
        doneButton.isEnabled = false
        
        hintHeaderTap = UITapGestureRecognizer(target: self, action: #selector(headerTap(_:)))
        hintHeader.addGestureRecognizer(hintHeaderTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let statusBarView = UIApplication.shared.statusBarView {
            statusBarColor = statusBarView.backgroundColor
            statusBarView.backgroundColor = UIColor.navBarColor
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let statusBarView = UIApplication.shared.statusBarView {
            let color = statusBarColor ?? .clear
            statusBarView.backgroundColor = color
        }
        super.viewWillDisappear(animated)
    }
    
    private func setupDysLabel() {
        let text = "Troublesome\ndyskinesias\ndoing this"
        let boldRange = NSString(string: text).range(of: "dyskinesias")
        let attrText = NSMutableAttributedString(string: text)
        let length = NSMakeRange(0, text.count)
        
        guard let font = UIFont.init(name: "Helvetica", size: 10), let boldFont = UIFont.init(name: "Helvetica-Bold", size: 10) else {
            onDysLabel.text = text
            return
        }
        
        attrText.addAttribute(.font, value: font, range: length)
        attrText.addAttribute(.font, value: boldFont, range: boldRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        attrText.addAttribute(.paragraphStyle, value:paragraphStyle, range:length)
        
        onDysLabel.attributedText = attrText
    }
    
    private func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 2
    }
    
    private func toggleHint(_ collapse: Bool) {
        if collapse {
            UIView.animate(withDuration: 0.3) {
                self.hintViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.hintViewHeight.constant = 70
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func headerTap(_ r: UITapGestureRecognizer) {
        toggleHint(hintViewHeight.constant > 0)
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        diary?.save()
        navigationController?.popViewController(animated: true)
    }
}

extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiaryEntryCell.reuseID, for: indexPath) as! DiaryEntryCell
        
        let viewModel = EntryViewModel(entry: diary[indexPath.row], delegate: self)
        cell.setup(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension DiaryViewController: DiaryEntryModelDelegate {
    func valueChanged(_ entry: DiaryEntry) {
        diary.update(entry: entry)
        doneButton.isEnabled = true
    }
}
