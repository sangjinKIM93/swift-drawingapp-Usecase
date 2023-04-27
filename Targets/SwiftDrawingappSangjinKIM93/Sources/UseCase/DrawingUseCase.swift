//
//  DrawingUseCase.swift
//  swift-drawingapp
//
//  Created by 김상진 on 2023/04/08.
//

import Foundation

protocol DrawingUseCaseProtocol {
    func drawRectangle(rect: CGRect, completion: (Square)->())
    func selectRectangle(point: CGPoint, completion: (Square?)->())
    func startLineDraw(point: CGPoint, completion: (Line)->())
    func updateLineDraw(point: CGPoint)
    func endLineDraw()
}

class DrawingUseCase: DrawingUseCaseProtocol {
    private let drawingStore: DrawingStoreProtocol
    private let drawingFactory: DrawingFactoryProtocol
    
    init(drawingStore: DrawingStoreProtocol,
         drawingFactory: DrawingFactoryProtocol) {
        self.drawingStore = drawingStore
        self.drawingFactory = drawingFactory
    }
    
    func drawRectangle(rect: CGRect, completion: (Square)->()) {
        let square = drawingFactory.makeSquare(rect: rect)
        appendDrawing(shape: square)
        
        completion(square)
    }
    
    func selectRectangle(point: CGPoint, completion: (Square?)->()) {
        let squre = drawingStore.findSquare(point: point)
        completion(squre)
    }
    
    func startLineDraw(point: CGPoint, completion: (Line)->()) {
        let line = drawingFactory.startLinePoint(point: point)
        completion(line)
    }
    
    func updateLineDraw(point: CGPoint) {
        drawingFactory.updateLinePoints(point: point)
    }
    
    func endLineDraw() {
        let line = drawingFactory.endLinePoints()
        appendDrawing(shape: line)
    }
    
    private func appendDrawing(shape: Shape) {
        drawingStore.appendData(data: shape)
    }
}
