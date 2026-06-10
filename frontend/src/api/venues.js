import axiosClient from './axiosClient';

const venuesApi = {
  getVenues: async (params) => {
    try {
      const response = await axiosClient.get('/venues/', { params });
      return response;
    } catch (error) {
      console.error('取得場館列表失敗:', error);
      throw error;
    }
  },
  createVenue: async (data) => {
    try {
      const response = await axiosClient.post('/venues/', data);
      return response;
    } catch (error) {
      console.error('新增場館失敗:', error);
      throw error;
    }
  },
  updateVenue: async (venueId, data) => {
    try {
      const response = await axiosClient.patch(`/venues/${venueId}/`, data);
      return response;
    } catch (error) {
      console.error('更新場館失敗:', error);
      throw error;
    }
  },
  getCourts: async (params) => {
    try {
      const response = await axiosClient.get('/courts/', { params });
      return response;
    } catch (error) {
      console.error('取得球場列表失敗:', error);
      throw error;
    }
  },
  createCourt: async (data) => {
    try {
      const response = await axiosClient.post('/courts/', data);
      return response;
    } catch (error) {
      console.error('新增球場失敗:', error);
      throw error;
    }
  },
  updateCourt: async (courtId, data) => {
    try {
      const response = await axiosClient.patch(`/courts/${courtId}/`, data);
      return response;
    } catch (error) {
      console.error('更新球場失敗:', error);
      throw error;
    }
  },
  deleteCourt: async (courtId) => {
    try {
      const response = await axiosClient.delete(`/courts/${courtId}/`);
      return response;
    } catch (error) {
      console.error('刪除球場失敗:', error);
      throw error;
    }
  },
  getRegions: async () => {
    try {
      const response = await axiosClient.get('/taiwan_regions/');
      return response;
    } catch (error) {
      console.error('取得台灣縣市區域列表失敗:', error);
      throw error;
    }
  }
};

export default venuesApi;
