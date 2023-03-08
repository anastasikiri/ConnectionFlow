//
//  ViewController.swift
//  ConnectionFlow
//
//  Created by Anastasia Bilous on 2023-03-06.
//

import UIKit
import CoreBluetooth

class ConnectionViewController: UIViewController, ConnectionViewModelDelegate {
    
    private var peripheralScannerViewModel = ConnectionViewModel()
    private var peripherals = Array<CBPeripheral>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBOutlet weak var searchLabelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralScannerViewModel.delegate = self
        searchLabelOutlet.isHidden = true
        registerCell(reuseId: String(describing: DeviceTableViewCell.self))
    }
    
    private func registerCell(reuseId: String) {
        tableView.register(UINib(nibName: reuseId, bundle: nil),
                           forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func peripheralScanner(_ peripheralScanner: ConnectionViewModel, didUpdatePeripherals peripherals: [CBPeripheral]) {
        self.peripherals = peripherals
        tableView.reloadData()
    }
    
    func peripheralScanner(_ peripheralScanner: ConnectionViewModel, didEncounterError error: String) {
        self.showBasicAlert(title: error, vc: self)
        searchLabelOutlet.isHidden = true
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        tableView.reloadData()
        searchLabelOutlet.isHidden = false
        peripheralScannerViewModel.scanForPeripherals()
    }
    
    @IBAction func stopPressed(_ sender: Any) {
        searchLabelOutlet.isHidden = true
        peripheralScannerViewModel.stopScan()
    }
}

extension ConnectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = String(describing: DeviceTableViewCell.self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for:  indexPath) as? DeviceTableViewCell else
        {fatalError()}
        
        cell.configure(with: peripherals[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
}

extension ConnectionViewController: UITableViewDelegate {
   
}
