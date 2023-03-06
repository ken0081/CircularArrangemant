//
//  CircleArrangeView.swift
//  CircularArrangemant
//
//  Created by Ken Oonishi on 2022/12/30.
//

import SwiftUI

/**
 アイコンの円形配列のメインビュー
 
 配列に保持させたユーザー情報からそれぞれのアイコンを作成して 円形状に配置する。
 また、選択したユーザーを手前に表示できるように、ユーザー選択を追加。
 配列したアイコンにはドラッグ・ドロップによる並び替え機能を実装。
*/
struct CircleArrangeView: View {

    @ObservedObject var players = PlayerItems()     //プレーヤー情報のインスタンス
    @State var myPlayerNum : Int = 0                //自分のプレーヤー番号
    @State var playerNameShow: Bool = true          //プレーヤー名の表示切り替え

    
    var body: some View {

        VStack {
            //トップのメニューバー
            HStack {
                Spacer().frame(width: 10)

                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .foregroundColor(.secondary)
                
                Text(players.items[myPlayerNum].Name)
                
                Spacer()
                
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundColor(.secondary)
                
                Spacer().frame(width: 15)
            }
            .padding(.vertical, 7.0)
            .background(.gray.opacity(0.15))
            
            
            //レイアウト設定は円形状に配置する物を別途作成して利用する
            let layout = AnyLayout(MyRadialLayout())

            //ユーザーアイコンの円形状配置
            ZStack {
                //中心にある残り時間の表示
                CircleTimerView().offset(y: 12)
         
                //円形状配置のレイアウトを適用してアイコンを配置する
                Group {
                    layout {
                        ForEach(players.items) { player in
                            //ユーザーアイコンの作成
                            YouserIcon(pItem: player, isNameShow: playerNameShow)
                                //作成したレイアウト側へ値を渡す
                                //ここでは自分が何番目に並んでいるか渡して手前に表示されるようにする
                                .myPlayerNum(myPlayerNum)
                                .onDrag {
                                    players.currentItem = player
                                    return NSItemProvider(contentsOf: URL(string: "\(player.id)")!)!
                                }
                                .onDrop(of: [.url], delegate:
                                            DropViewDelegate(item: player, players: players))
                        }
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: myPlayerNum)
                .shadow(color: .gray, radius: 8, x: 10, y: 15)
            }
            .rotation3DEffect(Angle(degrees: 20), axis: (x: 1.0, y: 0.0, z: 0.0))
            .offset(y: -35)


//            Text("タイマースタート")
//                .padding()
//                .background(.cyan)
//                .cornerRadius(20)
                

            List {
                Picker(selection: $myPlayerNum, label: Text("プレーヤー名")){
                    ForEach(0..<players.items.count) { index in
                        Text(players.items[index].Name)
                    }
                }
                Toggle(isOn: $playerNameShow, label: {
                    Text("名前表示")}
                )
            }
            .frame(height: 200)
            
        }
    }
}


//中心に配置してる残り時間
struct CircleTimerView: View {
    
    private var defaultTimer: Float = 30
    @State private var timerCount: Float = 0
    @State private var timer: Timer? = nil
    
    //バイブレーション起動
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        Circle().stroke(lineWidth: 2)
            .frame(width: UIScreen.main.bounds.width / 3.5)
            .foregroundColor(.gray).opacity(0.3)
        
        Circle()
            .trim(from: 0, to: CGFloat(timerCount / defaultTimer))
            .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
            .frame(width: UIScreen.main.bounds.width / 3.5)
            .foregroundColor(.cyan)
            .rotationEffect(Angle(degrees: -90))
            .shadow(color: .gray, radius:1, x: 2, y: 3)
            .animation(.spring(response: 0.8), value: timerCount)
        
        VStack {
            Text("残り時間")
            Text("\(Int(timerCount + 1))秒")
        }
        .onAppear() {
            timerCount = defaultTimer
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                runEveryInterval()
            }
        }
    }

    //タイマカウント用の関数
    func runEveryInterval() {
        if 0 < timerCount {
            timerCount -= 0.1
        } else {
            //タイマアップでバイブを動かす
            generator.notificationOccurred(.success)
            timer?.invalidate() // タイマ削除
        }
    }
}


struct CircleArrangeView_Previews: PreviewProvider {
    static var previews: some View {
        CircleArrangeView()
    }
}
