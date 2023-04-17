//
//  ViewModel.swift
//  swift-drawingapp
//
//  Created by 김상진 on 2022/10/15.
//

import Foundation
import QuartzCore

// 무슨 기준으로 나눈거니?
// 기대되는 출력값.
// viewModel에서 로직 처리 후 출력값을 전달하기 때문에, 기대되는 출력값들을 delegate로 정의하고 ViewController와 연결
protocol ViewModelDelegate: AnyObject {
    func selectSquare(square: Square)
    func drawSquare(square: Square, color: ColorAssets)
    func drawLine(line: Line, color: ColorAssets)
    func startLineDraw(line: Line, color: ColorAssets)
    func updateLineDraw(point: CGPoint)
    func endLineDraw()
}

enum DrawingMode {
    case square
    case line
}

protocol DrawingViewModelProtocol {
    var delegate: ViewModelDelegate? { get set }
    func handleTouchesBegan(point: CGPoint)
    func handleTouchesMoved(point: CGPoint)
    func handleTouchesEnded()
    func handleSquareButtonSelected(rect: CGRect)
    func handleLineButtonSelected()
    func connectServer(id: String)
}

class DrawingViewModel: DrawingViewModelProtocol {
    private let drawingUseCase: DrawingUseCaseProtocol
    private var chatUseCase: ChatUseCaseProtocol
    
    weak var delegate: ViewModelDelegate?
    
    var drawingMode: DrawingMode?
    
    init(
        drawingUseCase: DrawingUseCaseProtocol,
        chatUseCase: ChatUseCaseProtocol
    ) {
        self.drawingUseCase = drawingUseCase
        self.chatUseCase = chatUseCase
        
        self.chatUseCase.delegate = self
    }
    
    func handleTouchesBegan(point: CGPoint) {
        switch drawingMode {
        case .square:
            drawingUseCase.selectRectangle(point: point) { square in
                guard let square = square else { return }
                delegate?.selectSquare(square: square)
            }
        case .line:
            drawingUseCase.startLineDraw(point: point) { line in
                delegate?.startLineDraw(line: line, color: ColorAssets.randomColor())
            }
        case .none:
            return
        }
    }
    
    func handleTouchesMoved(point: CGPoint) {
        if drawingMode == .line {
            drawingUseCase.updateLineDraw(point: point)
            delegate?.updateLineDraw(point: point)
        }
    }
    
    func handleTouchesEnded() {
        if drawingMode == .line {
            drawingUseCase.endLineDraw()
            delegate?.endLineDraw()
        }
    }
    
    func handleSquareButtonSelected(rect: CGRect) {
        self.drawingMode = .square
        
        drawingUseCase.drawRectangle(rect: rect) { square in
            delegate?.drawSquare(square: square, color: ColorAssets.randomColor())
        }
    }
    
    func handleLineButtonSelected() {
        self.drawingMode = .line
    }
    
    func connectServer(id: String) {
        chatUseCase.login(id: id)
    }
}

extension DrawingViewModel: ChatUseCaseDelegate {
    func drawSquare(square: Square) {
        self.delegate?.drawSquare(square: square, color: .systemGray)
    }
    
    func drawLine(line: Line) {
        self.delegate?.drawLine(line: line, color: .systemGray)
    }
}
