import QtQuick
import Quickshell.Services.Notifications

QtObject {
    id: notificationService

    property var notifications: []
    property int count: notifications.length

    property NotificationServer server: NotificationServer {
        keepOnReload: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        actionsSupported: true

        onNotification: notification => {
            notification.tracked = true;
            let entry = {
                id: notification.id,
                appName: notification.appName || "Unknown",
                summary: notification.summary || "",
                body: notification.body || "",
                urgency: notification.urgency,
                image: notification.image || "",
                time: new Date(),
                notification: notification
            };
            let updated = [entry].concat(notificationService.notifications);
            notificationService.notifications = updated;
        }
    }

    function dismiss(index) {
        if (index < 0 || index >= notifications.length) return;
        let entry = notifications[index];
        if (entry.notification) {
            entry.notification.dismiss();
        }
        let updated = notifications.slice();
        updated.splice(index, 1);
        notifications = updated;
    }

    function dismissAll() {
        for (let i = 0; i < notifications.length; i++) {
            let entry = notifications[i];
            if (entry.notification) {
                entry.notification.dismiss();
            }
        }
        notifications = [];
    }

    function timeAgo(date) {
        let now = new Date();
        let diff = Math.floor((now - date) / 1000);
        if (diff < 60) return "just now";
        if (diff < 3600) return Math.floor(diff / 60) + "m ago";
        if (diff < 86400) return Math.floor(diff / 3600) + "h ago";
        return Math.floor(diff / 86400) + "d ago";
    }
}
