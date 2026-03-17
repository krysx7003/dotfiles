import QtQuick
import Quickshell
import Quickshell.Services.Notifications

NotificationServer {
    id: notificationServer

    property var showPopup: () => console.log("Notification not handled")

    actionsSupported: true
    imageSupported: true
    persistenceSupported: true
    
    onNotification: (notification) => {
        notification.tracked = true
        console.log(`New notification from: ${notification.appName}`)
        showPopup(notification)
    }
}
