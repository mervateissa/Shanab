//
//  OrderReceiptCell.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class OrderReceiptCell: UITableViewCell {
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var OptionsTableView: UITableView!
    private let cellIdentifier = "DriverDetaisTableViewCell"
    @IBOutlet weak var price: UILabel!
    var options = [Option]() {
        didSet {
            DispatchQueue.main.async {
                self.OptionsTableView.reloadData()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionsTableView.delegate = self
        OptionsTableView.dataSource = self
        OptionsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func config(name: String, number: Int, price: Int, options: [Option]) {
        self.name.text = name
        self.number.text = "\(number)"
        self.price.text = "\(price)"
        self.options = options
    }
    
}
extension OrderReceiptCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as?
            DriverDetailsTableViewCell else {return UITableViewCell()}
        let detailedOption = options[indexPath.row].options ?? Options()
        cell.config(name:  detailedOption.nameEn ?? ""  , number: 1 ,price: 0)
               return cell
    }
    
    
}
