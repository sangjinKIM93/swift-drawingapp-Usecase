//
//  SocketManager.swift
//  swift-drawingapp
//
//  Created by 김상진 on 2022/10/28.
//

import Network
import Foundation

public protocol SocketManagerDelegate: AnyObject {
    func dataReceived(data: Data)
}

public protocol SocketManagerProtocol {
    var delegate: SocketManagerDelegate? { get set }
    func connect()
    func disconnect()
    func sendData(data: Data)
}

@available(iOS 12.0, *)
@available(macOS 10.14, *)
public class SocketManager: SocketManagerProtocol {
    
    private let chatQueue = DispatchQueue(label: "ray.chat")
    weak public var delegate: SocketManagerDelegate?
    
    let connection: NWConnection
    
    public init(host: String, port: Int) {
        let host = NWEndpoint.Host(host)
        let port = NWEndpoint.Port("\(port)")!
        self.connection = NWConnection(host: host, port: port, using: .tcp)
    }
    
    public func connect() {
        connection.start(queue: chatQueue)
        setReceiver()
    }
    
    public func disconnect() {
        connection.cancel()
    }
    
    public func sendData(data: Data) {
        connection.send(content: data, completion: .contentProcessed({ error in
            if let error = error {
                print("Error: \(error)")
            }
            
        }))
    }
    
    private func setReceiver() {
        connection.receive(minimumIncompleteLength: 4, maximumLength: 25000) { [weak self] content, contentContext, isComplete, error in
//            let response = try! JSONDecoder().decode(CommandResponse.self, from: content!)
            if let error = error {
                print("Error: \(error)")
            }
            
            if let content = content {
                print("Response \(content)")
                self?.delegate?.dataReceived(data: content)
            }
            
            self?.setReceiver()
        }
    }
}
