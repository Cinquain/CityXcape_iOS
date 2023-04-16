//
//  PublicStampView.swift
//  CityXcape
//
//  Created by James Allan on 7/1/22.
//

import SwiftUI
import Shimmer
import SDWebImageSwiftUI

struct PublicStampView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId) var userId: String?


    let verification: Verification
    let width: CGFloat = UIScreen.screenWidth
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var showSpot: Bool = false
    @State private var secretSpot: SecretSpot?
    @State private var comments: [Comment] = []
    @State private var showComments: Bool = false
    @State private var showUser: Bool = false
    @State private var didLike: Bool = false
    @State private var didProps: Bool = false
    
    var body: some View {
        VStack {
            imageFrame
            header
            stamp
            downArrow
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: .black, location: 0.40),
            Gradient.Stop(color: .cx_orange, location: 3.0),
        ]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .onAppear {
            checkUserLike()
            checkUserProp()
        }
    }
    
    
    fileprivate func loadComments() {
        DataService.instance.downloadStampComments(forId: verification.verifierId, verificationId: verification.id) {  result in
            switch result {
            case .success(let comments):
                if comments.isEmpty {
                    self.alertMessage = "No comments on this stamp"
                    self.showAlert.toggle()
                    return
                }
                self.comments = comments
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showComments.toggle()
                }
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.showAlert.toggle()
            }
        }
    }
    
    func getSecretSpot(spotId: String) {
        DataService.instance.getSpecificSpot(postId: spotId) {  result in
                switch result {
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        showAlert = true
                    case .success(let spot):
                        secretSpot = spot
                }
        }
    }
    
    func likeUnlikePost() {
        didLike.toggle()
        DataService.instance
            .likeOrUnlike(stamp: verification, didLike: didLike) { result in
                switch result {
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        showAlert = true
                    case .success(let message):
                        didLike.toggle()
                        alertMessage = message
                        showAlert = true
                    }
        }
    }
    
    func giveProps() {
        DataService.instance.givePropsToUser(stamp: verification) { result in
            switch result {
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                case .success(let message):
                    didProps.toggle()
                    alertMessage = message
                    showAlert = true
                }
        }
    }
    

    func checkUserLike() {
        guard let uid = userId else {return}
        guard !verification.likedIds.isEmpty else {return}
        didLike = verification.likedIds.contains(where: {$0 == uid})
    }
    
    func checkUserProp() {
        guard let uid = userId else {return}
        guard !verification.propIds.isEmpty else {return}
        didProps = verification.propIds.contains(where: {$0 == uid})
    }
    
    
    
    }




extension PublicStampView {
    
    private var header: some View {
        HStack {
            
            Button {
                loadComments()
            } label: {
                Image(systemName: "bubble.left")
                    .foregroundColor(.white)
                    .opacity(0.8)
                    .font(.title)
            }
            .sheet(isPresented: $showComments) {
                StampCommentView(stamp: verification, comments: comments)
            }
            
            Button {
                likeUnlikePost()
            } label: {
                Image(systemName: didLike ? "heart.fill" : "heart")
                    .opacity(0.8)
                    .font(.title)
                    .foregroundColor(didLike ? .red : .white)
                    .animation(.easeInOut(duration: 0.5), value: didLike)
            }

            Button {
                giveProps()
            } label: {
                Image("props")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .foregroundColor(didProps ? .cx_orange : .white)
                    .animation(.easeIn(duration: 0.5))

            }
            .disabled(didProps)

            
            Spacer()
            
            
            Button {
                getSecretSpot(spotId: verification.postId)
            } label: {
                HStack(alignment: .center) {
                 
                    Image("pin_blue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        
                    Text(verification.name)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                        .font(Font.custom("Savoye LET", size: 22))
                }
            }
            .sheet(item: $secretSpot) { spot in
                SpotDetailsView(spot: spot)
            }
      
        }
        .padding(.horizontal, 20)
    }
    
    private var imageFrame: some View {
        ZStack {
           Rectangle()
                .fill(Color.white)
                .frame(width: width - 20, height: width - 20)
                .alert(isPresented: $showAlert) {
                    return Alert(title: Text(alertMessage))
                }
            
            WebImage(url: URL(string: verification.imageUrl))
                .resizable()
                .frame(width: width - 40, height: width - 40)
        }
    }
    
    private var titleView: some View {
        
        Button {
            getSecretSpot(spotId: verification.id)
        } label: {
            HStack {
                Image("pin_blue")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding(.bottom, 12)
                
                Text(verification.name)
                    .font(Font.custom("Savoye LET", size: 42))
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var socialButtons: some View {
        HStack {
            Button {
                loadComments()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showComments.toggle()
                }
            } label: {
                Image(systemName: "bubble.left.fill")
                    .foregroundColor(.white)
                    .opacity(0.8)
                    .font(.title)
            }
            .sheet(isPresented: $showComments) {
                let user = User(verification: verification)
                StampCommentView(stamp: verification, comments: comments)
            }
            
            Button {
                //
            } label: {
                Image(systemName: "hand.thumbsup.fill")
                    .foregroundColor(.white)
                    .opacity(0.8)
                    .font(.title)
            }

            
            Spacer()
            
            Button {
                showUser.toggle()
            } label: {
                VStack(spacing: 0) {
                    UserDotView(imageUrl: verification.verifierImage, width: 40)
                    Text(verification.verifierName)
                        .font(.caption)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showUser) {
                let user = User(verification: verification)
                PublicStreetPass(user: user)
            }
         
            
        }
        .padding(.horizontal, 20)
    }
    
    private var downArrow: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("arrow")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .opacity(0.5)
        }
    }
    
    private var stamp: some View {
        HStack(alignment: .bottom) {
            Spacer()
            Image("Stamp")
                .resizable()
                .scaledToFit()
                .frame(height: width - 100 )
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        
                        Text(verification.time.formattedDate())
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)
                        
                        Text("\(verification.name), \(verification.time.timeFormatter())")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.stamp_red)

                        
                    
                    }
                    .rotationEffect(Angle(degrees: -30))
                    )
            
      
            
        }
        .padding()
    }
}

struct PublicStampView_Previews: PreviewProvider {
    static var previews: some View {
        PublicStampView(verification: Verification.demo)
    }
}
