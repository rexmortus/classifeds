import mapboxgl from "mapbox-gl/dist/mapbox-gl.js"
import { createGeoJSONCircle } from 'plugins/geojsoncircle'

$('form').on('keypress', e => {
    if (e.keyCode == 13) {
        return false;
    }
});

// Places autocomplete
var placesAutocomplete = document.getElementById('address-input');

if (placesAutocomplete) {
  placesAutocomplete = places(
    {
    appId: 'plIXN9SZEJE6',
    apiKey: 'adcd356c5d066b32a4538fe81b280f9f',
    container: placesAutocomplete
    }
  );

};

var updateMap = document.getElementById('user_location');

if (placesAutocomplete && updateMap) {

  placesAutocomplete.on('change', function(event) {

    if (window.map.removeLayer) {

      var coordinates = Object.values(event.suggestion.latlng).slice().reverse();
      var searchRadius = 3;

      var polygon = createGeoJSONCircle(coordinates, searchRadius);
      window.map.removeLayer('polygon');
      window.map.removeSource('polygon');
      window.map.addSource("polygon", polygon);

      window.map.addLayer({
          "id": "polygon",
          "type": "fill",
          "source": "polygon",
          "layout": {},
          "paint": {
              "fill-color": "green",
              "fill-opacity": 0.1
          }
      });

      for (const marker in window.markers) {
        if (window.markers[marker]) {
            window.markers[marker].remove();
        }
      }

      window.markers = [];

      const marker = new mapboxgl.Marker()
        .setLngLat(coordinates)
        .addTo(window.map);

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
    }

     window.search.refresh();
  });
}
