//
//  MainViewController.swift
//  MotorDiary
//
//  Created by lex on 10/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    
    private let fileName = "activities.json"
    private var storage: Storage!
    private var diary: Diary!

    override func viewDidLoad() {
        super.viewDidLoad()

        storage = Storage(fileName: fileName)
        diary = Diary(storage: storage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let caption = storage.exists() ? "fill diary" : "start diary"
        startButton.setTitle(caption, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DiaryViewController {
            vc.diary = diary
        }
    }
}
