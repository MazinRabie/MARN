import { apiClient } from './apiClient'
import { HubConnectionBuilder, HubConnection, LogLevel } from '@microsoft/signalr'

export interface AppNotification {
  id: string | number
  type: string
  typeDisplayName: string
  title: string
  body: string
  data: any
  actionType: string | null
  actionTypeDisplayName: string
  actionId: string | null
  isRead: boolean
  createdAt: string
}

let notificationConnection: HubConnection | null = null

export const startNotificationConnection = async () => {
  if (notificationConnection && notificationConnection.state !== 'Disconnected') return notificationConnection

  const BASE_URL = (import.meta.env.VITE_API_BASE_URL as string | undefined) || (import.meta.env.PROD ? 'https://marn.runasp.net' : '')
  const hubUrl = BASE_URL ? `${BASE_URL}/hubs/notification` : '/hubs/notification'
  
  const token = localStorage.getItem('token') ?? sessionStorage.getItem('token') ?? ''

  notificationConnection = new HubConnectionBuilder()
    .withUrl(hubUrl, { accessTokenFactory: () => token })
    .withAutomaticReconnect()
    .configureLogging(LogLevel.Information)
    .build()

  notificationConnection.on("ReceiveNotification", (notification: AppNotification) => {
    window.dispatchEvent(new CustomEvent('notification-received', { detail: notification }))
  })

  notificationConnection.on("AllNotificationsMarkedAsRead", () => {
    window.dispatchEvent(new CustomEvent('notifications-all-read'))
  })

  notificationConnection.on("NotificationMarkedAsRead", (notificationId: string) => {
    window.dispatchEvent(new CustomEvent('notification-marked-read', { detail: notificationId }))
  })

  try {
    await notificationConnection.start()
    console.log("Connection to NotificationHub successful")
  } catch (err) {
    console.error("SignalR notification connection error: ", err)
  }
  return notificationConnection
}

export const stopNotificationConnection = async () => {
  await notificationConnection?.stop()
  notificationConnection = null
}

export const notificationService = {
  getNotifications: async (): Promise<AppNotification[]> => {
    // The endpoint doesn't wrap it in an ApiResponse based on api.generated.ts, but let's see.
    // If it does, we may need to adjust this. For now we assume it returns an array.
    const response = await apiClient.get<any>('/api/Notification/notifications-get')
    // Handle both cases: if it returns an array directly, or if it returns an object with a data property
    if (Array.isArray(response)) {
      return response;
    } else if (response && Array.isArray(response.data)) {
      return response.data;
    }
    return [];
  },

  markAllAsRead: async () => {
    const connection = await startNotificationConnection()
    await connection.send("MarkAllNotificationsAsRead")
  },

  markAsRead: async (notificationId: string) => {
    const connection = await startNotificationConnection()
    const parsedId = Number(notificationId)
    await connection.send("MarkNotificationAsRead", isNaN(parsedId) ? notificationId : parsedId)
  }
}
