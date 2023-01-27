//
//  LocalFeed.swift
//  CityXcape
//
//  Created by James Allan on 1/10/23.
//

import SwiftUI

struct LocalFeedView: View {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    
    @State var spot: SecretSpot
    @State var users: [User] = []
    @State var feed: [Feed] = []
    @State var errorMessage: String = ""
    @State var currentUser: User?
    @State var submissionText: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    
    var body: some View {
        VStack {
            HStack {
                SecretSpotView(width: 60, height: 60, imageUrl: spot.imageUrls.first ?? "")
                Text("\(spot.spotName) Real Time")
                    .font(.title3)
                    .fontWeight(.thin)
                Spacer()
            }
            .padding(.horizontal, 20)
            .foregroundColor(.white)
            
            Divider()
                .frame(height: 0.5)
                .background(Color.white)
            
            ScrollView {
                
                ForEach(feed.unique()) { feed in
                        FeedBubbleView(feed: feed)
                    }
                    .sheet(item: $currentUser) { user in
                        PublicStreetPass(user: user)
                    }
                  
                    
                }
            
            Spacer()
            
            commentField
           
            }
            .background(
                ZStack {
                    Color.black
                    Image(Icon.heatmap.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIScreen.screenHeight)
                        .shimmering(active: true, duration: 3, bounce: true)
                }
                .edgesIgnoringSafeArea(.all)
                .zIndex(-100)
            
            )
            .onAppear {
                fetchVerifierFeed()
            }
            .onDisappear {
                removeListener()
            }
          
        }
      
    
    
    
    
    fileprivate func removeListener() {
        DataService.instance.removeStampListener()
        DataService.instance.removeChatListener()
    }
    
    func fetchLocalMessages() {
        DataService.instance.fetchLocalMessages(postId: spot.id) { result in
            switch result {
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            case .success(let messages):
                messages.forEach { feed in
                    self.feed.append(feed)
                }
            }
        }
    }

    
    func fetchVerifierFeed() {
        DataService.instance.getVerifiersForFeed(postId: spot.id) { result in
            switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .success(let feed):
                    self.feed = feed
                    self.fetchLocalMessages()
            }
        }
    }
    
    func postMessage() {
        
        guard var wallet = wallet else {return}
        
        if wallet >= 1 {
            //Decremement wallet locally
            if submissionText.count < 2 {
                alertMessage = "Cannot broadcast empty message to \(spot.spotName)"
                showAlert = true
                return
            }
            
            wallet -= 1
            UserDefaults.standard.set(wallet, forKey: CurrentUserDefaults.wallet)
            
            DataService.instance.postFeedMessage(content: submissionText, type: .spot, spotId: spot.id) {  result in

                switch result {
                    case .failure(let error):
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                    case .success(_):
                        self.alertMessage = "Message Sent. -1 StreetCred"
                        self.submissionText = ""
                        self.showAlert = true
                }
                
            }
            
        } else {
            self.alertMessage = "Insufficient streetCred to send a messgae. Buy STC at the CX store under settings."
            self.showAlert = true
        }
        //End of function
    }
}


extension LocalFeedView {
    
    
    
    private var stamp: some View {
        
        Image("Stamp")
            .resizable()
            .scaledToFit()
            .frame(height: 40)
            .padding(.leading, 20)
    
    }
    
    private var commentField: some View {
        HStack {
            UserDotView(imageUrl: profileUrl ?? "", width: 30)
               
            TextField("Broadcast a message", text: $submissionText)
                .placeholder(when: submissionText.isEmpty) {
                    Text("Broadcast a message").foregroundColor(.gray)
            }
            .padding()
            
            
            Button {
                postMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .renderingMode(.template)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .alert(isPresented: $showAlert) {
                return Alert(title: Text(alertMessage))
            }

        }
        .padding(.horizontal, 20)
    }
    
    
    
    
}

struct LocalFeed_Previews: PreviewProvider {
    static var previews: some View {
        LocalFeedView(spot: SecretSpot.spot)
    }
}
