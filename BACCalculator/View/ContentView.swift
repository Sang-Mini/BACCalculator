//
//  ContentView.swift
//  BACCalculator
//
//  Created by 유상민 on 2023/09/08.
//

import SwiftUI
import ACarousel

let roles = ["soju", "beer", "makgeolli", "wine", "vodka", "whiskey", "brandy", "rum"]
let alcohol = ["소주", "맥주", "막걸리", "와인", "보드카", "위스키", "브랜디", "럼"]

struct ContentView: View {
    
    @State var spacing: CGFloat = 10
    @State var headspace: CGFloat = 10
    @State var sidesScaling: CGFloat = 0.8
    @State var isWrap: Bool = false
    @State var autoScroll: Bool = false
    @State var time: TimeInterval = 1
    
    @ObservedObject var viewModel = BACCalculatorViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: HStack {
                    Text("주류를 선택해 주세요 ⬅️ ➡️").font(.system(size: 15, weight: .bold))
                    Text(" ( \(alcohol[viewModel.alcoholSelectedNumber]) )").foregroundColor(Color.blue)
                }) {
                    ACarousel(roles,
                              id: \.self,
                              index: $viewModel.alcoholSelectedNumber,
                              spacing: spacing,
                              headspace: headspace,
                              sidesScaling: sidesScaling,
                              isWrap: isWrap,
                              autoScroll: autoScroll ? .active(time) : .inactive) { name in
                        Image(name)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .shadow(color: .gray, radius: 4, y: 15)
                            .background(.thinMaterial)
                            .cornerRadius(30)
                    }.frame(height: 200)
                }
                
                Section(header: HStack {
                    Text("개인정보를 입력해 주세요 🫵").font(.system(size: 15, weight: .bold))
                }) {
                    TextField("체중 (kg)", text: $viewModel.weightText)
                        .keyboardType(.numberPad)
                    
                    Picker("성별", selection: $viewModel.genderSelection) {
                        ForEach(viewModel.genders.indices, id: \.self) { index in
                            Text(self.viewModel.genders[index])
                        }
                    }
                }
                
                Section(header: HStack {
                    Text("음주 정보를 입력해 주세요 ❗️").font(.system(size: 15, weight: .bold))
                }) {
                    TextField("음주량 (잔) ex) 1", text: $viewModel.alcoholConsumedText)
                        .keyboardType(.numberPad)
                    
                    TextField("음주 시간 (몇 시간 전) ex) 1", text: $viewModel.hoursSinceLastDrink)
                        .keyboardType(.numberPad)
                }
                .listStyle(GroupedListStyle())
                
                Section(header: Text("혈중 알코올 농도 (BAC)")) {
                    Text("\(String(format: "%.4f", viewModel.bacResult))%")
                        .font(.largeTitle)
                    
                    Text(viewModel.bacDescription)
                        .foregroundColor(viewModel.bacColor)
                        .font(.headline)
                }
                
                if viewModel.bacResult != 0.0 {
                    Section(header: Text("혈중 알코올 농도 (BAC)")) {
                        Text("음주를 한지 \(viewModel.hoursSinceLastDrink)시간 이내이며 \n 알코올 분해 시간은 음주를 한 시점으로부터 \n \(Text("\(viewModel.hoursToDecay)시간 \(viewModel.minutesToDecay)분").foregroundColor(.blue)) 소요될 것으로 예상돼요! \n\n 만약 운전을 하게 된다면\n\(Text("\(viewModel.bacLevel)").foregroundColor(viewModel.bacColor))\n에 해당돼요 \n\n 단 한 잔이라도 운전은 절대금지🚫 입니다! \n\n \(Text("위 내용은 참고사항으로 실제 혈중 알코올농도는 다를 수 있어요❗️").font(.system(size: 11.5, weight: .bold)).foregroundColor(.gray))")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 17, weight: .bold))
                    }
                }
                
                if viewModel.bacResult == 0.0 {
                    Section {
                        Button(action: {
                            viewModel.calculateBAC()
                            viewModel.calculateDecayTime()
                        }) {
                            Text("계산하기")
                        }
                    }
                } else {
                    Section {
                        Button(action: {
                            viewModel.bacResult = 0.0
                        }) {
                            Text("다시 계산하기")
                        }
                    }
                }
            }
            .navigationTitle("BAC 계산기")
        }
    }
    
}
// 주석 추가

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
