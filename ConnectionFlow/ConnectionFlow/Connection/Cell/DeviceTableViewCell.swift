//
//  DeviceTableViewCell.swift
//  ConnectionFlow
//
//  Created by Anastasia Bilous on 2023-03-07.
//

import UIKit
import CoreBluetooth


class DeviceTableViewCell: UITableViewCell {
  
    @IBOutlet weak var deviceLabel: UILabel!
    
    func configure(with model: CBPeripheral) {
        deviceLabel.text = model.name
    }
}
