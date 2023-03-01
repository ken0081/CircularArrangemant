//
//  YouserIcon.swift
//  CircularArrangemant
//
//  Created by Ken Oonishi on 2022/11/12.
//

import SwiftUI


/// プレーヤー情報を渡してアイコンを作成する。タップした時のジェスチャーはこっちで実装
///
/// プレーヤー情報・名前表示切り替えの情報を渡す
///
///     var pItem: PlayerItem
///     var isNameShow: Bool = true

struct YouserIcon: View {
    
    var pItem: PlayerItem               //　プレイヤー情報
    var isNameShow: Bool = true         //　プレイヤー名の表示切り替え

    //タップジェスチャーによる名前表示切替え
    @State var select: Bool = false
    
    var tapGesture: some Gesture {
        TapGesture().onEnded({ tapValue in
            select.toggle()
        })
    }
    
    
//　DragGesture()では順番並び替えには使えないのでコメント化
//    //ドラッグジェスチャー
//    @State var imagePos: CGPoint = CGPoint(x: 35, y: 35)
//    @State var homePos: CGPoint = CGPoint(x: 35, y: 35)
//    @State var isDrag: Bool = false
//
//    //ドラッグ時にイメージの座標を変更する
//    //ドラッグ終了時に元の座標へ戻す
//    var returnPosGesture: some Gesture {
//        DragGesture()
//            .onChanged({ value in
//                self.imagePos = value.location
//                isDrag = true
//            })
//            .onEnded { value in
//                self.imagePos = self.homePos
//                isDrag = false
//            }
//    }

    
    var body: some View {
        
        ZStack {

            //　丸型のアイコン本体
            Image("\(pItem.pictureNumber)")
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 70, height: 70)
                .overlay(Circle().stroke(lineWidth: 1).foregroundColor(.gray))
                

            //名前表示する時の位置変更
            if isNameShow {
                if select {
                    Text(pItem.Name)
                        .offset(y:-10)
                } else {
                    Text(pItem.Name)
                        .font(.system(size: 17))
                        .offset(y:40)
                        .foregroundColor(.secondary)
                }
            }
        }
        .scaleEffect(select ? 1.5 : 1)  //　タップした時は1.5倍表示
        .gesture(tapGesture)            //　タップジェスチャーを有効にする
        .animation(.spring(response: 0.2, dampingFraction: 0.5), value: select)

        //.opacity(isDrag ? 0.3 : 1)
        //.zIndex(isDrag ? 1 : 0)
        //.position(imagePos)
        //.gesture(returnPosGesture)
        //.animation(.spring(response: 0.3, dampingFraction: 0.6), value: imagePos)
        
    }
}



struct YouserIcon_Previews: PreviewProvider {
    //　アイコン1個でプレビュー
    static var pItem: PlayerItem = PlayerItem(pictureNumber: 1, Name: "Player1")
    
    static var previews: some View {
        YouserIcon(pItem: pItem)
    }
}
