import axiosClient from './axiosClient';

const notificationsApi = {
  /**
   * 取得通知列表
   * @returns {Promise}
   */
  getNotifications: () => {
    return axiosClient.get('/notifications');
  },

  /**
   * 標記通知為已讀
   * @param {number|string} notificationId 
   * @returns {Promise}
   */
  markAsRead: (notificationId) => {
    return axiosClient.patch(`/notifications/${notificationId}/read`);
  },

  /**
   * 刪除通知
   * @param {number|string} notificationId 
   * @returns {Promise}
   */
  deleteNotification: (notificationId) => {
    return axiosClient.delete(`/notifications/${notificationId}`);
  },

  /**
   * 一鍵刪除所有通知
   * @returns {Promise}
   */
  deleteAllNotifications: () => {
    return axiosClient.delete('/notifications/delete-all');
  }
};

export default notificationsApi;
