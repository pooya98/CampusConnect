//
//  MyPageView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/24.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack{
            titlebar
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Divider()
                    profile
                    Divider()
                    myActivity
                    Divider()
                    mySchool
                }
            }
        }
    }
    
    var titlebar : some View {
        HStack {
            Text("My Profile")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                print("Configuration Button")
            }) {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
            }
        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
    }
    
    var profile : some View {
        VStack{
            HStack{
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                VStack(alignment: .leading){
                    Text("name")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("usercode")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                }
                .padding([.leading, .trailing], 10)
                Spacer()
                Image(systemName: "chevron.right")
            }
            
            .padding([.bottom], 15)
            HStack{
                Spacer()
                VStack{
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("Hosting")
                        .font(.footnote)
                }
                Spacer()
                VStack{
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("Attendance")
                        .font(.footnote)
                }
                Spacer()
                VStack{
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("관심목록")
                        .font(.footnote)
                }
                Spacer()
            }
        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 15)
    }
    
    var myActivity : some View {
        VStack(alignment: .leading){
            Text("나의 활동")
                .font(.title3)
                .fontWeight(.bold)
                .padding([.top, .bottom], 5)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("학과 설정하기")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("학과 인증하기")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("키워드 알림")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("친구 초대하기")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("가까운 문 인증하기")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
    }
    
    var mySchool : some View {
        VStack(alignment: .leading){
            Text("우리 학교")
                .font(.title3)
                .fontWeight(.bold)
                .padding([.top, .bottom], 5)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("학교 생활 글/댓글")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("우리학교 탭 1")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("우리학교 탭 2")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("우리학교 탭 3")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
