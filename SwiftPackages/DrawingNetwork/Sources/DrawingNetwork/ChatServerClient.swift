//
//  ChatServerClient.swift
//

import Foundation
import CoreGraphics
import DrawingModel

public protocol ChatServerClientProtocol {
    var delegate: ChatServerDelegate? { get set }
    func login(id: String)
    func sendData(shape: Shape)
}

public protocol ChatServerDelegate: AnyObject {
    func loginSucceed()
    func dataReceived(shape: Shape)
}

public class ChatServerClient: ChatServerClientProtocol {
    
    private var socket: SocketManagerProtocol
    weak public var delegate: ChatServerDelegate?
    var userId: String?
    
    let converter = ChatCommandConverter()
    
    public init(socket: SocketManagerProtocol) {
        self.socket = socket
        self.socket.delegate = self
    }

    public func sendData(shape: Shape) {
        guard let command = converter.convertToCommand(shape: shape, userId: userId!) else {
            return
        }
        guard let commandData = command.data else {
            return
        }
        
        socket.sendData(data: commandData)
    }
    
    public func login(id: String) {
        guard let jsonData = Command(header: ChatRequestTyoe.login.rawValue, id: id, length: nil, data: nil, shapeType: nil).toJsonData() else {
            return
        }
        self.userId = id
        socket.connect()
        socket.sendData(data: jsonData)
    }
}

extension ChatServerClient: SocketManagerDelegate {
    public func dataReceived(data: Data) {
        guard let command = converter.dataToCommand(data: data) else {
            print("Wrong Command Format")
            return
        }
        guard let reponseType = ChatResponseType(rawValue: command.header) else {
            print("Undefined response")
            return
        }
        
        switch reponseType {
        case .loginSucceed:
            if command.id == userId {
                delegate?.loginSucceed()
            }
        case .shapePushed:
            guard let shape = try? converter.convertToShape(command: command) else {
                print("Decoding Error")
                return
            }
            delegate?.dataReceived(shape: shape)
        }
    }
}
