import mapboxgl from "mapbox-gl/dist/mapbox-gl.js"
import { createGeoJSONCircle } from "plugins/geojsoncircle"

// Start up the small map
$(document).ready(function() {

  var map = document.getElementById('map')

  if (map) {

    mapboxgl.accessToken = 'pk.eyJ1IjoicmV4bW9ydHVzIiwiYSI6ImNrMnplc3VscjAzYXUzb3IwNHBnaTJlZjMifQ.-gKFpHfNC1yfmO7c-rDLhw';

    var map = new mapboxgl.Map({
      container: 'map',
      center: $('#user_location').data('geocode').slice().reverse(),
      zoom: 10,
      style: 'mapbox://styles/mapbox/outdoors-v9',
      pitch: 0,
      interactive: false
    });

    var coordinates = $('#user_location').data('geocode').slice().reverse()
    var location = $('#user_location').data('location');
    var searchRadius = parseInt($('#search_distance').val());

    map.on('load', function() {

      var polygon = createGeoJSONCircle(coordinates, searchRadius);
      map.addSource("polygon", polygon);

      map.addLayer({
          "id": "polygon",
          "type": "fill",
          "source": "polygon",
          "layout": {},
          "paint": {
              "fill-color": "#6e4d54",
              "fill-opacity": 0.15,
              'fill-outline-color': '#6e4d54'
          }
      });

      window.map = map
      window.markers = [];

      let el = document.createElement('span');
      el.innerHTML = '<i class="material-icons">gps_fixed</i>';

      const marker = new mapboxgl.Marker(el)
        .setLngLat(coordinates)
        .addTo(map);

      window.markers.push(marker);

      var center_x = coordinates[0];
      var center_y = coordinates[1];
      var earth_radius = 6378.1;
      var dY = 360 * searchRadius / earth_radius * 0.2;
      var dX = dY * Math.cos(center_y / (Math.PI / 180)) * 0.2;

      var x1 = center_x - dX;
      var y1 = center_y - dY;
      var x2 = center_x + dX;
      var y2 = center_y + dY;

      window.map.fitBounds(
        [
          [x1,y1],
          [x2,y2]
        ], {padding: {
          top: 0,
          right: 0,
          bottom: 50,
          left: 0
        }});

    })

  }

});

// Start up the big map
$(window).on('initialise-map-view', function() {

  // Hide the small map
  var smallMap = document.getElementById('map');
  smallMap.classList.add('hidden');

  // Adjust the slider style


  var map = document.getElementById('map-results-view')

  if (map) {

    mapboxgl.accessToken = 'pk.eyJ1IjoicmV4bW9ydHVzIiwiYSI6ImNrMnplc3VscjAzYXUzb3IwNHBnaTJlZjMifQ.-gKFpHfNC1yfmO7c-rDLhw';

    var map = new mapboxgl.Map({
      container: 'map-results-view',
      center: $('#user_location').data('geocode').slice().reverse(),
      zoom: 10,
      style: 'mapbox://styles/mapbox/outdoors-v9',
      pitch: 0,
      interactive: true
    });

    var coordinates = $('#user_location').data('geocode').slice().reverse()
    var searchRadius = parseInt($('#search_distance').val());

    // On initial load
    map.on('load', function() {

      // Save the map to the window global
      window.mapView = map
      window.markers = [];

      // Generate a new search radius polygon
      var polygon = createGeoJSONCircle(coordinates, searchRadius);
      map.addSource("polygon", polygon);

      map.addLayer({
          "id": "polygon",
          "type": "fill",
          "source": "polygon",
          "layout": {},
          "paint": {
              "fill-color": "#6e4d54",
              "fill-opacity": 0.15,
              'fill-outline-color': '#6e4d54'
          }
      });

      let el = document.createElement('span');
      el.innerHTML = '<i class="material-icons">gps_fixed</i>';

      const marker = new mapboxgl.Marker(el)
        .setLngLat(coordinates)
        .addTo(map);

      window.markers.push(marker);

      // Center the map on the new coordinates
      var center_x = coordinates[0];
      var center_y = coordinates[1];
      var earth_radius = 6378.1;
      var dY = 360 * searchRadius / earth_radius * 0.2;
      var dX = dY * Math.cos(center_y / (Math.PI / 180)) * 0.2;

      var x1 = center_x - dX;
      var y1 = center_y - dY;
      var x2 = center_x + dX;
      var y2 = center_y + dY;

      window.mapView.fitBounds(
        [
          [x1,y1],
          [x2,y2]
        ], 50);

    })

    window.addEventListener('remove-map-view', function() {
      window.mapView = null;
    });

  }
})

$(window).on('update-map-view', function() {

  const coordinates = $('#user_location').data('geocode').slice().reverse()
  const searchRadius = parseInt($('#search_distance').val());

  const polygon = createGeoJSONCircle(coordinates, searchRadius);
  window.mapView.removeLayer('polygon');
  window.mapView.removeSource('polygon');
  window.mapView.addSource("polygon", polygon);

  window.mapView.addLayer({
      "id": "polygon",
      "type": "fill",
      "source": "polygon",
      "layout": {},
      "paint": {
          "fill-color": "#6e4d54",
          "fill-opacity": 0.15,
          'fill-outline-color': '#6e4d54'
      }
  });

  const center_x = coordinates[0];
  const center_y = coordinates[1];
  const earth_radius = 6378.1;
  const dY = 360 * searchRadius / earth_radius * 0.2;
  const dX = dY * Math.cos(center_y / (Math.PI / 180)) * 0.2;

  const x1 = center_x - dX;
  const y1 = center_y - dY;
  const x2 = center_x + dX;
  const y2 = center_y + dY;

  window.mapView.fitBounds(
    [
      [x1,y1],
      [x2,y2]
    ], 50);

});
