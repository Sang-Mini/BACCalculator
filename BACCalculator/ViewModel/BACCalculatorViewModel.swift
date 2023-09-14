//
//  BACCalculatorViewModel.swift
//  BACCalculator
//
//  Created by 유상민 on 2023/09/08.
//

import SwiftUI

class BACCalculatorViewModel: ObservableObject {
    @Published var weightText = ""
    @Published var genderSelection = 0
    @Published var alcoholConsumedText = ""
    @Published var hoursSinceLastDrink = ""
    @Published var alcoholSelectedNumber = 0
    @Published var bacResult = 0.0
    @Published var hoursToDecay = 0
    @Published var minutesToDecay = 0
    @Published var calculateButtonTapped = false
    
    
    // 각 술 종류별 알코올 함량 (g)
    // [소주, 맥주, 막걸리, 와인, 보드카, 위스키, 브랜디, 럼]
    let alcoholContents: [Double] = [19.5, 4.5, 6.0, 12.5, 40.0, 40.0, 40.0, 40.0]
    let genders = ["남성 🚹", "여성 🚺"]
    
    // BAC를 계산하고 결과를 저장하는 함수
    func calculateBAC() {
        guard let weight = Double(weightText),
              let alcoholConsumed = Double(alcoholConsumedText),
              let hoursSinceLastDrink = Double(hoursSinceLastDrink)
        else {
            return
        }
        
        let genderConstant = genderSelection == 0 ? 0.68 : 0.55
        let alcoholContent = alcoholContents[alcoholSelectedNumber] // 선택한 술의 알코올 농도
        
        let bac = (alcoholConsumed * alcoholContent / 100 * 5.14) / (weight * genderConstant) - (0.015 * hoursSinceLastDrink)
        
        bacResult = max(bac, 0.0)
    }
    
    // BAC가 0%로 감소하는데 필요한 시간을 계산하는 함수
    func calculateDecayTime() {
        let bac = bacResult
        let bacDecayRate = 0.015 // BAC 감소 속도 (일반적으로 0.015% per hour)
        
        // BAC가 0%로 감소하는데 필요한 시간 계산
        let totalMinutes = Int((bac / bacDecayRate) * 60)
        hoursToDecay = totalMinutes / 60
        minutesToDecay = totalMinutes % 60
    }
    
    // BAC에 따른 설명
    var bacDescription: String {
        let bacValue = bacResult
        switch bacValue {
        case ..<0.02:
            return "음주 영향 없음"
        case 0.02..<0.05:
            return "약간의 영향 가능"
        case 0.05..<0.08:
            return "주의가 필요함"
        case 0.08..<0.1:
            return "취하기 쉬움"
        default:
            return "매우 취함"
        }
    }
    
    // BAC에 따른 레벨
    var bacLevel: String {
        let bacValue = bacResult
        switch bacValue {
        case ..<0.03:
            return "안전한 수치"
        case 0.03..<0.05:
            return "벌금 및 경고"
        case 0.05..<0.1:
            return "벌금, 면허정지, 의무교통안전교육"
        default:
            return "벌금, 면허정지, 교통안전교육, 범죄 기록"
        }
    }
    
    // BAC에 따른 색상
    var bacColor: Color {
        let bacValue = bacResult
        switch bacValue {
        case ..<0.02:
            return .green
        case 0.02..<0.05:
            return .yellow
        case 0.05..<0.08:
            return .orange
        case 0.08..<0.1:
            return .red
        default:
            return .red
        }
    }

}
