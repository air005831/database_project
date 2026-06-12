import axiosClient from './axiosClient';

const weatherApi = {
  /**
   * 取得大廳即時天氣與 AQI
   * @param {Object} params - 包含 city 和 district
   * @returns {Promise}
   */
  getWeatherAqi: (params) => {
    return axiosClient.get('/weather/aqi', { params });
  }
};

export default weatherApi;
