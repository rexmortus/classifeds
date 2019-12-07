import mapboxgl from "mapbox-gl/dist/mapbox-gl.js"
import { createGeoJSONCircle } from "plugins/geojsoncircle"

$(document).ready(function() {

  var map = document.getElementById('map')

  if (map) {

    mapboxgl.accessToken = 'pk.eyJ1IjoicmV4bW9ydHVzIiwiYSI6ImNrMnplc3VscjAzYXUzb3IwNHBnaTJlZjMifQ.-gKFpHfNC1yfmO7c-rDLhw';

    var map = new mapboxgl.Map({
      container: 'map',
      center: $('#user_location').data('geocode').slice().reverse(),
      zoom: 8,
      style: 'mapbox://styles/mapbox/outdoors-v9',
      pitch: 50,
      interactive: false
    });

    var coordinates = $('#user_location').data('geocode').slice().reverse()
    var searchRadius = 3;

    map.on('load', function() {

      var polygon = createGeoJSONCircle(coordinates, searchRadius);
      map.addSource("polygon", polygon);

      map.addLayer({
          "id": "polygon",
          "type": "fill",
          "source": "polygon",
          "layout": {},
          "paint": {
              "fill-color": "#ef633f",
              "fill-opacity": 0.25
          }
      });

      var geocode = $('#user_location').data('geocode').slice().reverse()

      window.map = map
      window.markers = [];

      const marker = new mapboxgl.Marker()
        .setLngLat(geocode)
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
        ]);

    })

  }

});
