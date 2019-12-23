import mapboxgl from "mapbox-gl/dist/mapbox-gl.js"
import MapboxLanguage from '@mapbox/mapbox-gl-language'
import { createGeoJSONCircle } from "plugins/geojsoncircle"

function addRadarMarker(map, coordinates) {
  if (window.centerMarker) {
    window.centerMarker.remove();
    window.centerMarker = null;
  }

  let radarElement = document.createElement('span');
  radarElement.innerHTML = '<i class="material-icons rada">gps_fixed</i>';

  let marker = new mapboxgl.Marker(radarElement)
    .setLngLat(coordinates)
    .addTo(map);

  window.centerMarker = marker;
}

function addMarkers(results, mapView) {

  // Add an emoji marker for each result
  results.forEach(result => {

    // Get the co-ordinates
    let coords = result.coordinates.reverse()

    // Create the marker HTML element
    let element = document.createElement('a');
    element.href = '/advertisements/' + result.id;
    element.classList.add('emoji-marker');
    element.dataset.content = result.title;
    element.innerHTML = result.emoji + ' ';

    let marker = new mapboxgl.Marker(element)
      .setLngLat([
        coords[0],
        coords[1]
      ])
      .addTo(mapView);

    window.markers.push(marker);

  })
}

function centerMap(map, coordinates = $('#user_location').data('geocode').slice().reverse(), searchRadius = parseInt($('#search_distance').val()), radar = false) {

  const center_x = coordinates[0];
  const center_y = coordinates[1];
  const earth_radius = 6378.1;
  const dY = 360 * searchRadius / earth_radius * 0.2;
  const dX = dY * Math.cos(center_y / (Math.PI / 180)) * 0.2;

  const x1 = center_x - dX;
  const y1 = center_y - dY;
  const x2 = center_x + dX;
  const y2 = center_y + dY;

  map.fitBounds(
    [
      [x1,y1],
      [x2,y2]
    ], {padding: {
      top: 0,
      right: 0,
      // bottom: 40,
      bottom: 0,
      left: 0
    }});
}

// Start up the small map
$(document).ready(function() {

  var map = document.getElementById('js-small-map');

  if (map) {

    mapboxgl.accessToken = 'pk.eyJ1IjoicmV4bW9ydHVzIiwiYSI6ImNrMnplc3VscjAzYXUzb3IwNHBnaTJlZjMifQ.-gKFpHfNC1yfmO7c-rDLhw';

    var coordinates = $('#user_location').data('geocode').slice().reverse()
    var searchRadius = parseInt($('#search_distance').val());

    var map = new mapboxgl.Map({
      container: 'js-small-map',
      center: coordinates,
      zoom: 8,
      style: 'mapbox://styles/mapbox/outdoors-v10',
      pitch: 0,
      interactive: false
    });

    // Save map to window object
    window.map = map

    map.on('load', function() {

      // Create an array to hold markers
      window.markers = [];

      // addRadarMarker(map, coordinates);
      centerMap(window.map, coordinates, searchRadius);

      var language = new MapboxLanguage();
      map.addControl(language);
    })
  }
});

// Start up the big map
$(window).on('initialise-map-view', function(event) {

  // initialise the map element
  var map = document.getElementById('map-results-view')

  if (map) {

    // clear markers
    if (window.markers) {
      window.markers.forEach(marker => {
        marker.remove();
      });
    }

    window.markers = [];

    // Get coordinates
    var coordinates = event.detail["coordinates"].slice().reverse();

    // Setup mapbox
    mapboxgl.accessToken = 'pk.eyJ1IjoicmV4bW9ydHVzIiwiYSI6ImNrMnplc3VscjAzYXUzb3IwNHBnaTJlZjMifQ.-gKFpHfNC1yfmO7c-rDLhw';

    var map = new mapboxgl.Map({
      container: 'map-results-view',
      center: coordinates,
      zoom: 10,
      style: 'mapbox://styles/mapbox/outdoors-v10',
      pitch: 0,
      interactive: false,
    });

    // On initial load
    map.on('load', function() {

      // Save the map to the window global
      window.mapView = map

      // clear markers
      window.markers.forEach(marker => {
        marker.remove();
      });

      // Add the radar marker
      addRadarMarker(map, coordinates);

      // Add markers
      let results = JSON.parse(event.detail.data);
      addMarkers(results, map);

      // Center the map
      let searchRadius = event.detail.radius;
      centerMap(window.mapView, coordinates, searchRadius);

      var language = new MapboxLanguage();
      map.addControl(language);

    })

    window.addEventListener('remove-map-view', function(event) {

      // clear markers
      window.markers.forEach(marker => {
        marker.remove();
      });

      window.markers = [];

      // Clear the mapView global
      window.mapView = null;

      // Add the radar marker
      var coordinates = event.detail["coordinates"].slice().reverse();
      addRadarMarker(window.map, coordinates);

      // Add markers
      let results = JSON.parse(event.detail.data);
      addMarkers(results, window.map);
    });

  }
})

$(window).on('update-map-view', function(event) {

  // clear markers
  if (window.markers) {
    window.markers.forEach(marker => {
      marker.remove();
    });
  }

  window.markers = [];

  // Add an emoji marker for each result
  let results = JSON.parse(event.detail["data"])

  // Get the coords and search radius
  var coordinates = event.detail["coordinates"].slice().reverse();
  let searchRadius = event.detail.radius;

  // Always center the small map
  centerMap(window.map, coordinates, searchRadius, false);

  // If the mapView is onscreen
  if (window.mapView) {
    // update the mapView
    addRadarMarker(window.mapView, coordinates);
    // addMarkers(results, window.map);
    addMarkers(results, window.mapView)
    centerMap(window.mapView, coordinates, searchRadius, true);
  } else {
    // update the small map
    addRadarMarker(map, coordinates);
    addMarkers(results, window.map)
  }

});
