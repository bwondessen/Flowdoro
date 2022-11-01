//
//  HomeView.swift
//  Flowdoro
//
//  Created by Bruke on 10/24/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    @State private var showEditTimerPopupView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        VStack {
                            Text("Flow")
                            Text(vm.flowTime.asNumberString())
                        }
                        VStack {
                            Text("Focus")
                            Text(vm.focusTime.asNumberString())
                        }
                        .onTapGesture {
                            showEditTimerPopupView = true
                        }
                        VStack {
                            Text("Break")
                            Text(vm.breakTime.asNumberString())
                        }
                    }
                    Text("focus time: \(vm.focusTime)")
                    Text("focus time remaining: \(vm.focusTimeRemaining)")
                    Text("flow time: \(vm.flowTime)")
                    Text("flow time remaining: \(vm.flowTimeRemaining)")
                    Text("break time: \(vm.breakTime)")
                    Text("break time remaining: \(vm.breakTimeRemaining)")
                    Text("counter: \(vm.counter)")
                    timerView
                    
                    HStack {
                        focusButton
                            .onTapGesture {
                                //vm.startFlowdoroCycle = true
                            }
                            .disabled(vm.inFlow)
                            .opacity(vm.inFlow ? 0.70 : 1)
//                        if inBreak {
//                            breakButton
//                        }
                    }
                    .onChange(of: vm.breakTimeRemaining) { _ in
                        if vm.breakTimeRemaining == 0 {
                            vm.resetCycle()
                        }
                    }
                }
                .onChange(of: vm.flowTimeRemaining) { _ in
                            if vm.flowTimeRemaining == 0 {
                                vm.pauseTimer()
                                vm.inFlow = false
                                vm.inFocus = false
                                vm.inBreak = true
                                vm.counter = 0
                            }
                        }
                .navigationTitle("Flexodoro")
                .onAppear(perform: vm.pauseTimer)
                //            .overlay(
                //                EditTimeView(timeSelected: $timeSelected)
                //            )
                EditTimerPopupView(showEditTimerPopupView: $showEditTimerPopupView)
            }
            .onChange(of: vm.focusTimeRemaining) { _ in
                if vm.focusTimeRemaining == 0 {
                    vm.inFlow = true
                    vm.inFocus = false
                    vm.inBreak = false
                    vm.counter = 0
                    if vm.inFlow {
                        vm.startTimer()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension HomeView {
    private var timerView: some View {
        Circle()
            .stroke(Color.theme.buttonBackground, lineWidth: 15)
            .frame(width: UIScreen.main.bounds.width * 0.80, height: UIScreen.main.bounds.height * 0.45)
            .overlay(
                ZStack {
                    Circle()
                        .trim(from: 0, to: vm.timeRemainingInPercent())
                        .stroke(Color.theme.accent, lineWidth: 15)
                        .rotationEffect(.degrees(-90))
                    Text(vm.inFocus ? "\(vm.focusTimeRemaining.asNumberString())" : (vm.inFlow ? "\(vm.flowTimeRemaining.asNumberString())" : "\(vm.breakTimeRemaining.asNumberString())"))
                        .font(.title.bold())
                        .onReceive(vm.timer) { _ in
                            if vm.inFocus {
                                if vm.focusTimeRemaining > 0 {
                                    vm.focusTimeRemaining -= 1
                                    vm.counter += 1
                                }
                            }
                            if vm.inFlow {
                                if vm.flowTimeRemaining > 0 {
                                    vm.flowTimeRemaining -= 1
                                    vm.counter += 1
                                }
                            }
                            if vm.inBreak {
                                if vm.breakTimeRemaining > 0 {
                                    vm.breakTimeRemaining -= 1
                                    vm.counter += 1
                                }
                            }
                        }
                }
            )
    }
    
    private var focusButton: some View {
        HStack {
            if vm.inFocus {
                if vm.timerPaused && vm.focusTimeRemaining > 0 {
                    Button {
                        
                    } label: {
                        ButtonView(label: "Skip", selectSmallerSize: true)
                    }
                }
            }
            
            VStack {
                if vm.inFocus {
                    if vm.timerPaused && vm.focusTimeRemaining > 0 {
                        Button {
                            vm.startTimer()
                        } label: {
                            ButtonView(label: "Focus")
                        }
                    } else if !vm.timerPaused && vm.focusTimeRemaining > 0 {
                        Button {
                            vm.pauseTimer()
                        } label: {
                            ButtonView(label: "Pause")
                        }
                    } else if vm.focusTimeRemaining == 0 {
                        Button {
                            vm.endTimer()
                        } label: {
                            ButtonView(label: "End")
                        }
                    }
                } else if vm.inBreak {
                    if vm.timerPaused && vm.breakTimeRemaining > 0 {
                        Button {
                            vm.startTimer()
                        } label: {
                            ButtonView(label: "Break")
                        }
                    } else if !vm.timerPaused && vm.breakTimeRemaining > 0 {
                        Button {
                            vm.pauseTimer()
                        } label: {
                            ButtonView(label: "Pause")
                        }
                    } else if vm.breakTimeRemaining == 0 {
                        Button {
                            vm.endTimer()
                        } label: {
                            ButtonView(label: "End")
                        }
                    }
                } else {
                    Button {
                        
                    } label: {
                        ButtonView(label: "Focus")
                    }
                }
            }
            
            if vm.inFocus {
                if vm.timerPaused && vm.focusTimeRemaining > 0 {
                    Button {
                        vm.endTimer()
                    } label: {
                        ButtonView(label: "End", selectSmallerSize: true)
                    }
                }
            }
        }
    }
    
//    private var breakButton: some View  {
//        VStack {
//            if inBreak {
//                if vm.timerPaused && vm.breakTimeRemaining > 0 {
//                    Button {
//                        vm.startTimer()
//                    } label: {
//                        ButtonView(label: "Break")
//                    }
//                } else if !vm.timerPaused && vm.focusTimeRemaining > 0 {
//                    Button {
//                        vm.pauseTimer()
//                    } label: {
//                        ButtonView(label: "Pause")
//                    }
//                } else if vm.focusTimeRemaining == 0 {
//                    inFocus = true
//                }
//            } else {
//                Text("hi")
//            }
//        }
//    }
    
    //    func inverse() -> Int {
    //        if vm.focusTime == vm.focusTimeRemaining {
    //            vm.counter = 0
    //        } else if vm.counter <= Int(vm.focusTime) - 1 {
    //            vm.counter += 1
    //        }
    //        return vm.counter
    //    }
}