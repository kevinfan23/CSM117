//
//  SubmitOpitonViewController.swift
//  Clicker
//
//  Created by Likai Wei on 5/24/16.
//  Copyright © 2016 CS M117. All rights reserved.
//

import UIKit
import CoreBluetooth

import UIKit
import CoreBluetooth

class SubmitOpitonViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate {
    @IBOutlet private var submitButton: UIButton!
    @IBOutlet private var A_Button:UIButton!
    @IBOutlet private var B_Button:UIButton!
    @IBOutlet private var C_Button:UIButton!
    @IBOutlet private var D_Button:UIButton!
    @IBAction func change_dataToSend(sender: UIButton){
        switch sender {
        case A_Button:
            dataToSend = "A".dataUsingEncoding(NSUTF8StringEncoding)
            print(dataToSend!)
        case B_Button:
            dataToSend = "B".dataUsingEncoding(NSUTF8StringEncoding)
            print(dataToSend!)
        case C_Button:
            dataToSend = "C".dataUsingEncoding(NSUTF8StringEncoding)
            print(dataToSend!)
        case D_Button:
            dataToSend = "D".dataUsingEncoding(NSUTF8StringEncoding)
            print(dataToSend!)
        default:
            break
        }
    
    }
    
    
    private var peripheralManager: CBPeripheralManager?
    private var transferCharacteristic: CBMutableCharacteristic?
    
    private var dataToSend: NSData?
    private var sendDataIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Start up the CBPeripheralManager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Don't keep it going while we're not showing.
        peripheralManager?.stopAdvertising()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** Required protocol method.  A full app should take care of all the possible states,
     *  but we're just waiting for  to know when the CBPeripheralManager is ready
     */
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        // Opt out from any other state
        if (peripheral.state != CBPeripheralManagerState.PoweredOn) {
            return
        }
        
        // We're in CBPeripheralManagerStatePoweredOn state...
        print("self.peripheralManager powered on.")
        
        // ... so build our service.
        
        // Start with the CBMutableCharacteristic
        transferCharacteristic = CBMutableCharacteristic(
            type: transferCharacteristicUUID,
            properties: CBCharacteristicProperties.Notify,
            value: nil,
            permissions: CBAttributePermissions.Readable
        )
        
        // Then the service
        let transferService = CBMutableService(
            type: transferServiceUUID,
            primary: true
        )
        
        // Add the characteristic to the service
        transferService.characteristics = [transferCharacteristic!]
        
        // And add it to the peripheral manager
        peripheralManager!.addService(transferService)
    }
    
    /** Catch when someone subscribes to our characteristic, then start sending them data
     */
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
        print("Central subscribed to characteristic")
        
        // Get the data
//        dataToSend = textView.text.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Reset the index
        sendDataIndex = 0;
        
        // Start sending
        sendData()
    }
    
    /** Recognise when the central unsubscribes
     */
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic) {
        print("Central unsubscribed from characteristic")
    }
    
    // First up, check if we're meant to be sending an EOM
    private var sendingEOM = false;
    
    /** Sends the next amount of data to the connected central
     */
    private func sendData() {
        if sendingEOM {
            // send it
            let didSend = peripheralManager?.updateValue(
                "EOM".dataUsingEncoding(NSUTF8StringEncoding)!,
                forCharacteristic: transferCharacteristic!,
                onSubscribedCentrals: nil
            )
            
            // Did it send?
            if (didSend == true) {
                
                // It did, so mark it as sent
                sendingEOM = false
                
                print("Sent: EOM")
            }
            
            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
            return
        }
        
        // We're not sending an EOM, so we're sending data
        
        // Is there any left to send?
        guard sendDataIndex < dataToSend?.length else {
            // No data left.  Do nothing
            return
        }
        
        // There's data left, so send until the callback fails, or we're done.
        var didSend = true
        
        while didSend {
            // Make the next chunk
            
            // Work out how big it should be
            var amountToSend = dataToSend!.length - sendDataIndex!;
            
            // Can't be longer than 20 bytes
            if (amountToSend > NOTIFY_MTU) {
                amountToSend = NOTIFY_MTU;
            }
            
            // Copy out the data we want
            let chunk = NSData(
                bytes: dataToSend!.bytes + sendDataIndex!,
                length: amountToSend
            )
            
            // Send it
            didSend = peripheralManager!.updateValue(
                chunk,
                forCharacteristic: transferCharacteristic!,
                onSubscribedCentrals: nil
            )
            
            // If it didn't work, drop out and wait for the callback
            if (!didSend) {
                return
            }
            
            let stringFromData = NSString(
                data: chunk,
                encoding: NSUTF8StringEncoding
            )
            
            print("Sent: \(stringFromData)")
            
            // It did send, so update our index
            sendDataIndex! += amountToSend;
            
            // Was it the last one?
            if (sendDataIndex! >= dataToSend!.length) {
                
                // It was - send an EOM
                
                // Set this so if the send fails, we'll send it next time
                sendingEOM = true
                
                // Send it
                let eomSent = peripheralManager!.updateValue(
                    "EOM".dataUsingEncoding(NSUTF8StringEncoding)!,
                    forCharacteristic: transferCharacteristic!,
                    onSubscribedCentrals: nil
                )
                
                if (eomSent) {
                    // It sent, we're all done
                    sendingEOM = false
                    print("Sent: EOM")
                }
                
                return
            }
        }
    }
    
    /** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
     *  This is to ensure that packets will arrive in the order they are sent
     */
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        // Start sending again
        sendData()
    }
    
    /** This is called when a change happens, so we know to stop advertising
     */
//    func textViewDidChange(textView: UITextView) {
//        // If we're already advertising, stop
//        if (advertisingSwitch.on) {
//            advertisingSwitch.setOn(false, animated: true)
//            peripheralManager?.stopAdvertising()
//        }
//    }
    
    /** Start advertising
     */
    @IBAction func optionSubmitted(sender: UIButton) {
        
            // All we advertise is our service's UUID
            peripheralManager!.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey : [transferServiceUUID]
                ])
        print("Submit")
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        print(error)
    }
}
