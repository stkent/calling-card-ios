//
//  NearbyViewController.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/26/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

final class NearbyViewController: UIViewController {
    
    static let storyboardId = "NearbyViewController"
    
    private let savedUsersManager = SavedUsersManager()

    private var currentUser: User?
    
    private var nearbyUsers: [User] = [] {
        didSet {
            print("Current nearby users: \(nearbyUsers.map({ $0.id }))")
            recomputeNearbyUsersToDisplay()
            tableView.reloadData()
        }
    }
    
    private var savedUsers: [User] = [] {
        didSet {
            print("Current saved users: \(savedUsers.map({ $0.id }))")
            recomputeNearbyUsersToDisplay()
            tableView.reloadData()
        }
    }
    
    private var nearbyUsersToDisplay: [User] = [] {
        didSet {
            print("Nearby users to display: \(nearbyUsersToDisplay.map({ $0.id }))")
        }
    }
    
    private var gnsPermissionProxy: GNSPermission?
    
    private var currentPublicationReference: GNSPublication? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var currentSubscriptionReference: GNSSubscription? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var messageManager: GNSMessageManager = {
        GNSMessageManager(APIKey: "AIzaSyClHL5KdqrIeyHjfWxRtb8C0nYmwffLGtI") { params in
            params.microphonePermissionErrorHandler = { hasError in
                if hasError {
                    // todo: do we get callback each time this status changes; or only initially?
                }
            }
            
            params.bluetoothPermissionErrorHandler = { hasError in
                if hasError {
                    
                }
            }
            
            params.bluetoothPowerErrorHandler = { hasError in
                if hasError {
                    
                }
            }
        }
    }()
    
    private var messageToPublish: GNSMessage? {
        if let currentUser = currentUser,
            currentUserJSON = currentUser.toNSData() {
            
                return GNSMessage(content: currentUserJSON)
        }
        
        return nil
    }
    
    private var activelyPublishing: Bool {
        return GNSPermission.isGranted() && currentPublicationReference != nil
    }
    
    private var activelySubscribing: Bool {
        return GNSPermission.isGranted() && currentSubscriptionReference != nil
    }

    @IBOutlet private weak var tableView: UITableView!

    @IBAction func signOutButtonTapped(sender: UIBarButtonItem) {
        cancelAllNearbyActivity()
        clearGoogleUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        savedUsers = savedUsersManager.getSavedUsers()
        
        gnsPermissionProxy = GNSPermission { [weak self] granted in
            if !granted {
                self?.cancelAllNearbyActivity()
            }
            
            self?.tableView.reloadData()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(tearDownNearby),
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        tearDownNearby()
        super.viewWillDisappear(animated)
    }
    
    func tearDownNearby() {
        cancelAllNearbyActivity()
        gnsPermissionProxy = nil
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 48
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func attemptToPublish() {
        if let messageToPublish = messageToPublish {
            currentPublicationReference = messageManager.publicationWithMessage(messageToPublish)
        }
    }
    
    private func attemptToSubscribe() {
        currentSubscriptionReference = messageManager.subscriptionWithMessageFoundHandler(
            { [weak self] foundMessage in
                print("Message found")
                
                if let _self = self, nearbyUser = User(nsData: foundMessage.content) {
                    print("\(nearbyUser.id) found")

                    if !_self.nearbyUsers.contains(nearbyUser) {
                        print("Adding \(nearbyUser.id) to nearby users list")

                        _self.nearbyUsers = [nearbyUser] + _self.nearbyUsers
                    }
                }
            },
            messageLostHandler: { [weak self] lostMessage in
                print("Message lost")
                
                if let _self = self, lostUser = User(nsData: lostMessage.content) {
                    print("\(lostUser.id) lost")
                    print("Removing \(lostUser.id) from nearby users list")
                    _self.nearbyUsers = _self.nearbyUsers.filter { $0 != lostUser }
                }
            })
    }
    
    private func stopPublishing() {
        currentPublicationReference = nil
    }
    
    private func stopSubscribing() {
        nearbyUsers = []
        currentSubscriptionReference = nil
    }
    
    private func cancelAllNearbyActivity() {
        stopPublishing()
        stopSubscribing()
    }
    
    private func clearGoogleUser() {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
    }
    
    private func recomputeNearbyUsersToDisplay() {
        nearbyUsersToDisplay = nearbyUsers.filter { !savedUsers.contains($0) }
    }
    
}

extension NearbyViewController: CurrentUserRecipient {
    
    func setCurrentUser(currentUser: User) {
        self.currentUser = currentUser
    }
    
}

extension NearbyViewController: UITableViewDataSource {
    
    /**
     * Count includes:
     * - Publish control
     * - Published user card
     * - Subscribe control
     * - "Saved Cards" header
     */
    private static let STATIC_CELL_COUNT = 4
    
     // Either display all eligible nearby users, or a single status row
    var numberOfCellsInNearbyUsersSection: Int {
        return max(nearbyUsersToDisplay.count, 1)
    }
    
    // Either display all saved users, or a single status row
    var numberOfCellsInSavedUsersSection: Int {
        return max(savedUsers.count, 1)
    }
    
    var savedCardsHeaderIndex: Int {
        return (NearbyViewController.STATIC_CELL_COUNT - 1) + numberOfCellsInNearbyUsersSection
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NearbyViewController.STATIC_CELL_COUNT
            + numberOfCellsInNearbyUsersSection
            + numberOfCellsInSavedUsersSection
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        // Publish control
        case 0:
            let result = tableView.dequeueReusableCellWithIdentifier(
                OperationControlTableViewCell.reuseIdentifier) as? OperationControlTableViewCell
            
            result?.operation = .Publish
            result?.controlOn = activelyPublishing
            result?.controlDelegate = self
            
            return result ?? UITableViewCell()
        
        // Published user card
        case 1:
            let result = tableView.dequeueReusableCellWithIdentifier(
                UserTableViewCell.reuseIdentifier) as? UserTableViewCell
            
            result?.bindUser(currentUser!)
            result?.setBorderColor(activelyPublishing ? .Blue : .Red)
            
            return result ?? UITableViewCell()
        
        // Subscribe control
        case 2:
            let result = tableView.dequeueReusableCellWithIdentifier(
                OperationControlTableViewCell.reuseIdentifier) as? OperationControlTableViewCell
        
            result?.operation = .Subscribe
            result?.controlOn = activelySubscribing
            result?.controlDelegate = self
            
            return result ?? UITableViewCell()
        
        // "Saved Cards" header
        case savedCardsHeaderIndex:
            return tableView.dequeueReusableCellWithIdentifier("SavedCardsHeaderTableViewCell")
                ?? UITableViewCell()
            
        default:
            if indexPath.row < savedCardsHeaderIndex {
                // Nearby users section
                if nearbyUsersToDisplay.isEmpty {
                    return statusTableViewCellWithString("No new nearby users detected!")
                } else {
                    return standardTableViewCellForUser(
                        nearbyUsersToDisplay[indexPath.row - (NearbyViewController.STATIC_CELL_COUNT - 1)])
                }
            } else if indexPath.row > savedCardsHeaderIndex {
                // Saved cards section
                if savedUsers.isEmpty {
                    return statusTableViewCellWithString("No saved cards found!")
                } else {
                    return standardTableViewCellForUser(
                        savedUsers[indexPath.row - NearbyViewController.STATIC_CELL_COUNT - numberOfCellsInNearbyUsersSection])
                }
            }
            
            fatalError("This code path should never be exercised")
        }
    }
    
    private func standardTableViewCellForUser(user: User) -> UITableViewCell {
        let result = tableView.dequeueReusableCellWithIdentifier(
            UserTableViewCell.reuseIdentifier) as? UserTableViewCell
        
        result?.bindUser(user)
        result?.setBorderColor(.Grey)
        
        return result ?? UITableViewCell()
    }
    
    private func statusTableViewCellWithString(string: String) -> UITableViewCell {
        let result = tableView.dequeueReusableCellWithIdentifier(
            StatusTableViewCell.reuseIdentifier) as? StatusTableViewCell
        
        result?.statusText = string
        
        return result ?? UITableViewCell()
    }
}

extension NearbyViewController: UITableViewDelegate {
    
    func rowRepresentsNearbyUser(indexPath: NSIndexPath) -> Bool {
        return !nearbyUsersToDisplay.isEmpty
            && indexPath.row >= (NearbyViewController.STATIC_CELL_COUNT - 1)
            && indexPath.row < savedCardsHeaderIndex
    }
    
    func rowRepresentsSavedUser(indexPath: NSIndexPath) -> Bool {
        return !savedUsers.isEmpty
            && indexPath.row > savedCardsHeaderIndex
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if rowRepresentsNearbyUser(indexPath) || rowRepresentsSavedUser(indexPath) {
            return indexPath
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if rowRepresentsNearbyUser(indexPath) {
            let tappedUser = nearbyUsersToDisplay[indexPath.row - (NearbyViewController.STATIC_CELL_COUNT - 1)]
            showSaveUserAlert(tappedUser)
        } else if rowRepresentsSavedUser(indexPath) {
            let tappedUser = savedUsers[indexPath.row - NearbyViewController.STATIC_CELL_COUNT - numberOfCellsInNearbyUsersSection]
            showDeleteUserAlert(tappedUser)
        }
    }
    
    private func showSaveUserAlert(user: User) {
        let savePrompt = getDefaultAlertController()
        savePrompt.message = "Save \(user.name)'s info?"
        savePrompt.addAction(UIAlertAction(title: "Save", style: .Default) { _ in
            self.savedUsersManager.saveUser(user)
            self.savedUsers = [user] + self.savedUsers
        })
        
        self.presentViewController(savePrompt, animated: true, completion: nil)
    }
    
    private func showDeleteUserAlert(user: User) {
        let deletePrompt = getDefaultAlertController()
        deletePrompt.message = "Delete \(user.name)'s info?"
        deletePrompt.addAction(UIAlertAction(title: "Delete", style: .Destructive) { _ in
            self.savedUsersManager.deleteUser(user)
            self.savedUsers = self.savedUsers.filter { $0 != user }
        })
        
        self.presentViewController(deletePrompt, animated: true, completion: nil)
    }
    
    private func getDefaultAlertController() -> UIAlertController {
        let result = UIAlertController()
        result.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        return result
    }
    
}

extension NearbyViewController: OperationControlTableViewCellDelegate {
    
    func controlToggled(operation: NearbyAPIOperation) {
        switch operation {
        case .Publish:
            if activelyPublishing {
                stopPublishing()
            } else {
                attemptToPublish()
            }
        case .Subscribe:
            if activelySubscribing {
                stopSubscribing()
            } else {
                attemptToSubscribe()
            }
        }
    }
    
}
