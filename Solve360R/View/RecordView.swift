

import SwiftUI
import SwiftData

struct RecordView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RecordData.score,order: .reverse) var records: [RecordData]
    @Binding var isRecordSheet: Bool
    var body: some View {

        NavigationStack{
            GeometryReader{ geometry in
                ZStack{
                    Colors.background

                    VStack{
                        ScrollView(showsIndicators: false){


                            ForEach(0..<10, id: \.self) { i in
                                if i < records.count {
                                           // 実際のデータがある場合
                                           let record = records[i]
                                           RecordRow(
                                               recordRank: "\(i + 1)",
                                               recordScore: "\(record.score)",
                                               recordDate: record.date
                                           )
                                             .scaleModifier(geometry: geometry, frameWidth: 1.0, frameheight: 0.1, scalex: 0.45, scaley: 0.45)
                                           .padding(.vertical)
                                       } else {
                                           // データがない場合（空の順位）
                                           RecordRow(
                                               recordRank: "\(i + 1)",
                                               recordScore: "---",
                                               recordDate: nil
                                           )
                                           .scaleModifier(geometry: geometry, frameWidth: 1.0, frameheight: 0.1, scalex: 0.45, scaley: 0.45)
                                           .padding(.vertical)
                                       }
                                   }
                                    .padding(.vertical)
                            }
                        }
                    .padding(.horizontal,10)
                    BackButton()
                    }
            }
//                .toolbar{
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button {
//                            dismiss()
//                        } label: {
//                            ZStack {
//                                // 背景円
//                                Circle()
//                                    .fill(Color.white.opacity(0.9))
//                                    .frame(width: 44, height: 44)
//
//                                // アイコン
//                                Image(systemName: "arrowshape.turn.up.backward.fill")
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.black)
//                            }
//                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
//                        }
//                        .buttonStyle(.plain)
//                    }
//                }

            }
        }
    }

extension RecordView{
    var closeButton:some View{
        HStack{
            Button {
                dismiss()
            } label: {
                ZStack {
                    // 背景円
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 44, height: 44)

                    // アイコン
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            .padding()
            Spacer()
        }
    }
}


#Preview {
    RecordView(isRecordSheet: .constant(false))
}
