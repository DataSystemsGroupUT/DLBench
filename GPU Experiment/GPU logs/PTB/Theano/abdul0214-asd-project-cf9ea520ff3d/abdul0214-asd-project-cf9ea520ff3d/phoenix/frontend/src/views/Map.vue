<template lang="html">
  <div id="map" class="map" />
</template>

<script>
import mapboxgl from 'mapbox-gl/dist/mapbox-gl';
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.min';
import axios from 'axios';

export default {
  name: 'Map',
  data() {
    return {
      token: 'pk.eyJ1IjoiaHRhZ2VuIiwiYSI6ImNrMzFncnlhaDA4ODYzaHMzaTQwams2N3EifQ.jCUecw-999YQOAV25W1GIQ',
      map: null,
      markers: [],
      parkingHouses: [],
    };
  },
  methods: {
    vectorDistance(dx, dy) {
      return Math.sqrt(dx * dx + dy * dy);
    },
    locationDistance(location1, location2) {
      const dx = location1[0] - location2[0];
      const dy = location1[1] - location2[1];

      return this.vectorDistance(dx, dy);
    },
    closestLocation(targetLocation, locationData) {
      return locationData.reduce(
        (prev, curr) => {
          const prevDistance = this.locationDistance(targetLocation, prev);
          const currDistance = this.locationDistance(targetLocation, curr);
          return (prevDistance < currDistance) ? prev : curr;
        },
      );
    },
    addParkingInfoMarker(event) {
      this.markers.map(m => m.remove());
      const points = [];
      this.$store.getters.streets.map(street => street.coords.map(p => points.push(p)));

      const closestPoint = this.closestLocation([event.lngLat.lng, event.lngLat.lat], points);
      const closestStreet = this.$store.getters.streets.find(
        street => street.coords.includes(closestPoint),
      );
      const closestStreetZone = this.$store.getters.zones.find(
        zone => zone.id === closestStreet.zone_id,
      );

      const marker = new mapboxgl.Marker()
        .setLngLat([event.lngLat.lng, event.lngLat.lat])
        .setPopup(new mapboxgl.Popup({ offset: 25 })
          .setHTML(`<h3>Zone ${closestStreetZone.name}</h3><p>Each hour costs: ${closestStreetZone.fee_hourly} euros</p><p>Each 5 minutes costs: ${closestStreetZone.fee_real_time} euros</p>`))
        .addTo(this.map);
      marker.togglePopup();
      this.markers.push(marker);
    },
    createLineObject(props) {
      const {
        id,
        coords: coordinates,
        zone_id: zoneId,
      } = props;

      return {
        id: `street${id}`,
        type: 'line',
        source: {
          type: 'geojson',
          data: {
            type: 'Feature',
            properties: {},
            geometry: {
              type: 'LineString',
              coordinates,
            },
          },
        },
        layout: {
          'line-join': 'round',
          'line-cap': 'square',
        },
        paint: {
          'line-color': zoneId === 1 ? 'rgba(255,51,51, 0.6)' : 'rgba(51,119,255, 0.6)',
          'line-width': 4,
        },
      };
    },
    createPolygonObject(props) {
      const {
        id,
        poly_coords: coordinates,
        zone_id: zoneId,
      } = props;

      return {
        id: `phouse${id}`,
        type: 'fill',
        source: {
          type: 'geojson',
          data: {
            type: 'Feature',
            properties: {},
            geometry: {
              type: 'Polygon',
              coordinates: [coordinates],
            },
          },
        },
        layout: {},
        paint: {
          'fill-color': zoneId === 1 ? 'rgba(255,51,51, 0.6)' : 'rgba(51,119,255, 0.6)',
        },
      };
    },
    addStreetsToMap() {
      const { streets } = this.$store.getters;
      streets.map(street => this.map.addLayer(this.createLineObject(street), 'road-label'));
    },
    addParkingHousesToMap() {
      this.parkingHouses.map(house => this.map.addLayer(this.createPolygonObject(house), 'road-label'));
    },
    addZonesToMap() {
      this.addStreetsToMap();
      this.addParkingHousesToMap();
    },
  },
  mounted() {
    mapboxgl.accessToken = this.token;
    axios.get('http://localhost:4000/api/parking/streets').then((response) => {
      this.$store.commit('setStreets', response.data.data);
    });
    axios.get('http://localhost:4000/api/parking/zones').then((response) => {
      this.$store.commit('setZones', response.data.data);
    });
    axios.get('http://localhost:4000/api/parking/parking_houses').then((response) => {
      this.parkingHouses = response.data.data;
    });

    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [26.7228191, 58.3786063], // starting position
      zoom: 14, // starting zoom
    });
    this.map.on('load', this.addZonesToMap);

    // Add the geocoder to the map
    this.map.addControl(new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl,
    }));
    this.map.addControl(new mapboxgl.NavigationControl());
    this.map.on('click', this.addParkingInfoMarker);
  },
};
</script>

<style lang="scss">
.map {
  height: 100vh;
  width: 100vw;
  margin: 0
}
</style>
