import axiosClient from './axiosClient';

const usersApi = {
  /**
   * 取得個人資料與信譽積分
   * @returns {Promise}
   */
  getUserProfile: () => {
    return axiosClient.get('/users/profile');
  },

  /**
   * 更新個人資料 (建立個人檔案)
   * @param {Object} data - { name, phone, birthday, gender, bio, avatar, levels, line_id, instagram }
   * @returns {Promise}
   */
  updateUserProfile: (data) => {
    return axiosClient.put('/users/profile', data);
  },

  /**
   * 取得所有使用者列表 (限 Admin)
   * @returns {Promise}
   */
  getAllUsers: () => {
    return axiosClient.get('/users/');
  },

  /**
   * 取得特定使用者詳細資訊 (限 Admin)
   * @param {number|string} userId
   * @returns {Promise}
   */
  getUserDetail: (userId) => {
    return axiosClient.get(`/users/${userId}`);
  },

  /**
   * 搜尋使用者 (限 Admin)
   * @param {string} query
   * @returns {Promise}
   */
  searchUsers: (query) => {
    return axiosClient.get(`/users/?search=${encodeURIComponent(query)}`);
  }
};

export default usersApi;
