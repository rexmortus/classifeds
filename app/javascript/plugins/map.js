import mapboxgl from "mapbox-gl/dist/mapbox-gl.js"
import { createGeoJSONCircle } from "plugins/geojsoncircle"

function addMarkers(results, mapView) {

  // Add an emoji marker for each result
  results.forEach(result => {

    // Get the co-ordinates
    let coords = result.coordinates.reverse()

    // Compute a scatter
    var r = 900/111300 // = 900 meters *just to be safe for UI*
      , y0 = coords[0]
      , x0 = coords[1]
      , u = Math.random()
      , v = Math.random()
      , w = r * Math.sqrt(u)
      , t = 2 * Math.PI * v
      , x = w * Math.cos(t)
      , y1 = w * Math.sin(t)
      , x1 = x / Math.cos(y0)

    // Our scattered co-ordinates
    let newY = y0 + y1
    let newX = x0 + x1

    // Create the marker HTML element
    let element = document.createElement('a');
    element.href = '/advertisements/' + result.id;
    element.classList.add('emoji-marker');
    element.dataset.content = result.title;
    element.innerHTML = result.emoji + ' ';

    let marker = new mapboxgl.Marker(element)
      .setLngLat([
        newY,
        newX
      ])
      .addTo(mapView);

    window.markers.push(marker);

  })
}

function centerMap(map, coordinates = $('#user_location').data('geocode').slice().reverse(), searchRadius = parseInt($('#search_distance').val()), radar = false) {

  // Refresh the radar marker each time
  if (true) {

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
    ], 50);
}

// Start up the small map
$(document).ready(function() {

  var map = document.getElementById('js-small-map')

  if (map) {

    mapboxgl.accessToken = 'pk.eyJ1IjoicmV4bW9ydHVzIiwiYSI6ImNrMnplc3VscjAzYXUzb3IwNHBnaTJlZjMifQ.-gKFpHfNC1yfmO7c-rDLhw';

    var map = new mapboxgl.Map({
      container: 'js-small-map',
      center: $('#user_location').data('geocode').slice().reverse(),
      zoom: 10,
      style: 'mapbox://styles/mapbox/outdoors-v10',
      pitch: 0,
      interactive: false
    });

    var coordinates = $('#user_location').data('geocode').slice().reverse()
    var location = $('#user_location').data('location');
    var searchRadius = parseInt($('#search_distance').val());

    map.on('load', function() {

      window.map = map
      window.markers = [];

      let el = document.createElement('span');
      el.innerHTML = '<i class="material-icons rada">gps_fixed</i>';

      // const marker = new mapboxgl.Marker(el)
      //   .setLngLat(coordinates)
      //   .addTo(map);
      //
      // window.markers.push(marker);

      centerMap(window.map);
    })
  }
});

// Start up the big map
$(window).on('initialise-map-view', function(event) {

  // initialise the map element
  var map = document.getElementById('map-results-view')

  if (map) {

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
      window.markers = [];

      // Add markers
      let results = JSON.parse(event.detail.data)
      addMarkers(results, map);

      // Center the map
      let searchRadius = event.detail.radius;
      centerMap(window.mapView, coordinates, searchRadius);

    })

    window.addEventListener('remove-map-view', function() {
      window.mapView = null;
    });

  }
})

$(window).on('update-map-view', function(event) {

  // clear markers
  window.markers.forEach(marker => {
    marker.remove();
  });

  window.markers = [];

  // Add an emoji marker for each result
  let results = JSON.parse(event.detail["data"])
  addMarkers(results, window.mapView)

  // Center the map
  var coordinates = event.detail["coordinates"].slice().reverse();
  let searchRadius = event.detail.radius;
  centerMap(window.map, coordinates, searchRadius, false);
  centerMap(window.mapView, coordinates, searchRadius, true);

});
