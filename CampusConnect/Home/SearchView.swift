import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var searchText = ""
    @State private var showKeyboard = false
    @State private var recentSearches = ["맛집", "술집", "종강파티"]

    var popularKeywords = ["조기축구", "댕댕이", "교환학생", "고양이", "외국인", "북문맛집", "감성카페", "스터디", "헬스", "여행"]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 246/255, green: 201/255, blue: 246/255))
                }

                Spacer()

                TextField("Search", text: $searchText)
                    .padding(.horizontal, 24)
                    .frame(height: 40)
                    .foregroundColor(.black)
                    .font(.headline)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .cornerRadius(8)
                    .onTapGesture {
                        showKeyboard = true
                    }
            }
            .padding(.top, 16)
            .padding(.bottom, 8)
            .padding(.horizontal, 16)
            .background(Color.white)
            .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 16) {
                Text("친구들이 많이 찾고 있어요!")
                    .font(.headline)
                    .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(popularKeywords, id: \.self) { keyword in
                            Text(keyword)
                                .foregroundColor(.black)
                                .font(.subheadline)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(RoundedRectangle(cornerRadius: 12)
                                  .stroke(Color.gray, lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 16)

            VStack(alignment: .leading, spacing: 16) {
                Text("최근 검색어")
                    .font(.headline)
                    .padding(.horizontal, 16)

                ForEach(recentSearches, id: \.self) { keyword in
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text(keyword)
                            .foregroundColor(.black)
                            .font(.subheadline)
                        Spacer()
                        Button(action: {
                            removeRecentSearch(keyword)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 16)
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .animation(.easeInOut)
    }

    private func removeRecentSearch(_ keyword: String) {
        if let index = recentSearches.firstIndex(of: keyword) {
            recentSearches.remove(at: index)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

