import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    token: null,
    email: null,
    streets: null,
    zones: null,
  },
  mutations: {
    setToken(state, token) {
      state.token = token;
    },
    setEmail(state, email) {
      state.email = email;
    },
    setStreets(state, streets) {
      state.streets = streets;
    },
    setZones(state, zones) {
      state.zones = zones;
    }
  },
  actions: {
  },
  getters: {
    token: state => state.token,
    email: state => state.email,
    streets: state => state.streets,
    zones: state => state.zones,
  },
});
