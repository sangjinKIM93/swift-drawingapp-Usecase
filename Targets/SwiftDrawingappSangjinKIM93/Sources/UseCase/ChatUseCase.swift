//
//  ChatUseCase.swift
//  swift-drawingapp
//
//  Created by 김상진 on 2023/04/08.
//

import Foundation
import DrawingModel
import DrawingNetwork

protocol ChatUseCaseProtocol {
    var delegate: ChatUseCaseDelegate? { get set }
    func login(id: String)
}

protocol ChatUseCaseDelegate: AnyObject {
    func drawSquare(square: Square)
    func drawLine(line: Line)
}


class ChatUseCase: ChatUseCaseProtocol {
    private let drawingStore: DrawingStoreProtocol
    private var chatServerClient: ChatServerClientProtocol
    
    weak var delegate: ChatUseCaseDelegate?
    
    init(drawingStore: DrawingStoreProtocol,
         chatServerClient: ChatServerClientProtocol) {
        self.drawingStore = drawingStore
        self.chatServerClient = chatServerClient
        
        self.chatServerClient.delegate = self
    }
    
    func login(id: String) {
        chatServerClient.login(id: id)
    }
    
}

extension ChatUseCase: ChatServerDelegate {
    func loginSucceed() {
        drawingStore.getData().forEach { shape in
            chatServerClient.sendData(shape: shape)
        }
    }
    
    //
    func dataReceived(shape: Shape) {
        DispatchQueue.main.async {
            if let square = shape as? Square {
                self.delegate?.drawSquare(square: square)
                return
            }
            if let line = shape as? Line {
                self.delegate?.drawLine(line: line)
                return
            }
        }
    }
}
