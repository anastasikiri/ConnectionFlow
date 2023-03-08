//
//  ConnectionViewModel.swift
//  ConnectionFlow
//
//  Created by Anastasia Bilous on 2023-03-06.
//

import CoreBluetooth

enum PeripheralScannerError: Error {
    case bluetoothOff
    case noDevicesFound
    
    var errorMessage: String {
        switch self {
        case .bluetoothOff:
            return "Please, check if Bluetooth is on"
        case .noDevicesFound:
            return "No device has been found"
        }
    }
}

protocol ConnectionViewModelDelegate: AnyObject {
    func peripheralScanner(_ peripheralScanner: ConnectionViewModel, didUpdatePeripherals peripherals: [CBPeripheral])
    func peripheralScanner(_ peripheralScanner: ConnectionViewModel, didEncounterError error: String)
}

class ConnectionViewModel: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager?
    private var peripherals = Array<CBPeripheral>()
    private var searchDevices = false
    
    weak var delegate: ConnectionViewModelDelegate?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            searchDevices = true
        }
        else {
            searchDevices = false
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        if peripheral.name?.isEmpty == false && !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
            self.delegate?.peripheralScanner(self, didUpdatePeripherals: peripherals)
        }
    }
    
    func scanForPeripherals() {
        if searchDevices {
            peripherals = Array<CBPeripheral>()
            self.centralManager?.scanForPeripherals(withServices: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if self.peripherals.isEmpty {
                    self.delegate?.peripheralScanner(self,
                                                     didEncounterError: PeripheralScannerError.noDevicesFound.errorMessage)
                    self.centralManager?.stopScan()
                }
            }
        }
        else {
            self.delegate?.peripheralScanner(self,
                                             didEncounterError: PeripheralScannerError.bluetoothOff.errorMessage)
        }
    }
    
    func stopScan() {
        centralManager?.stopScan()
    }
}
