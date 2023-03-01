//
//  DragDropDelegate.swift
//  CircularArrangemant
//
//  Created by Ken Oonishi on 2022/12/30.
//

import Foundation
import SwiftUI


/// 個々のプレーヤー情報の構造体
///
/// ユーザーID、画像番号、名前をそれぞれ格納
///
///     var id = UUID().uuidString
///     var pictureNumber: Int
///     var Name: String
///
struct PlayerItem: Identifiable {
    var id = UUID().uuidString
    var pictureNumber: Int
    var Name: String
}



/// プレーヤー情報を作成するクラス。
/// プレーヤー情報はサーバーを介さないので羅列で作成
class PlayerItems: ObservableObject {

    /// 選択中のプレーヤー番号
    @Published var currentItem: PlayerItem?
    /// プレーヤー情報の配列
    @Published var items = [
        PlayerItem(pictureNumber: 1, Name: "player1"),
        PlayerItem(pictureNumber: 2, Name: "player2"),
        PlayerItem(pictureNumber: 3, Name: "player3"),
        PlayerItem(pictureNumber: 4, Name: "player4"),
        PlayerItem(pictureNumber: 5, Name: "player5"),
        PlayerItem(pictureNumber: 6, Name: "player6"),
        PlayerItem(pictureNumber: 7, Name: "player7"),
        PlayerItem(pictureNumber: 8, Name: "player8"),
        PlayerItem(pictureNumber: 9, Name: "player9"),
//        PlayerItem(pictureNumber: 10, Name: "player10"),
//        PlayerItem(pictureNumber: 11, Name: "player11"),
//        PlayerItem(pictureNumber: 12, Name: "player12"),
//        PlayerItem(pictureNumber: 13, Name: "player13"),
//        PlayerItem(pictureNumber: 14, Name: "player14"),
//        PlayerItem(pictureNumber: 15, Name: "player15"),
//        PlayerItem(pictureNumber: 16, Name: "player16")
        ]
}


struct DropViewDelegate: DropDelegate {
    
    var item: PlayerItem
    var players: PlayerItems
    
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    
    func dropEntered(info: DropInfo) {

        //　個人メモ：「firstIndex」検索値と一致した最初の配列番号を返す
        
        //from　移動元の配列番号
        let fromIndex = players.items.firstIndex { (item) -> Bool in
            return item.id == players.currentItem?.id
        } ?? 0
        
        //to　移動先の配列番号
        let toIndex = players.items.firstIndex { (item) -> Bool in
            return item.id == self.item.id
        } ?? 0
        
        //　移動元・移動先の番地が異なっていればデータを移動する
        if fromIndex != toIndex {
            withAnimation(.default) {
                //移動元のデータを一時的にバックアップ
                let fromPage = players.items[fromIndex]
                
                //　データ入れ替え時の注意
                //　配列内のデータを移動する際は、移動元から移動先の順に配列内をいれかえる(アニメーションの動きが一定にならない)
                
                //　移動元のほうが配列番号が大きい時
                if fromIndex > toIndex {
                    //　配列の最初と最後を移動する場合は直接入れ替える
                    if fromIndex == players.items.count - 1 && toIndex == 0 {
                        players.items[fromIndex] = players.items[toIndex]
                    }
                    else {
                        //移動先へデータを割り込む
                        for index in stride(from: fromIndex, to: toIndex, by: -1) {
                            players.items[index] = players.items[index - 1]
                        }
                    }
                }
                //移動元のほうが配列番号が小さい時
                else {
                    if fromIndex == 0 && toIndex == players.items.count - 1 {
                        players.items[fromIndex] = players.items[toIndex]
                    }
                    else {
                        for index in stride(from: fromIndex, to: toIndex, by: 1) {
                            players.items[index] = players.items[index + 1]
                        }
                    }
                }
                //　最後にバックアップしておいた移動元のデータを入れる
                players.items[toIndex] = fromPage
            }
        }
    }
    
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
}
