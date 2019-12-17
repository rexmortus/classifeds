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
          bottom: 55,
          left: 0
        }});

    })

  }

});

// Start up the big map
$(window).on('initialise-map-view', function(event) {

  let results = JSON.parse(event.detail["data"])

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
      style: 'mapbox://styles/mapbox/outdoors-v10',
      pitch: 0,
      interactive: false,
    });

    var coordinates = $('#user_location').data('geocode').slice().reverse()
    var searchRadius = parseInt($('#search_distance').val());

    // On initial load
    map.on('load', function() {

      // Save the map to the window global
      window.mapView = map
      window.markers = [];

      // Create the center, spinning radar thing
      let radar = document.createElement('span');
      radar.innerHTML = '<i class="material-icons rada">gps_fixed</i>';

      let marker = new mapboxgl.Marker(radar)
        .setLngLat(coordinates)
        .addTo(map);

      // Add an emoji marker for each result
      results.forEach(result => {

        let coords = result.coordinates.reverse()

        var r = 900/111300 // = 100 meters
          , y0 = coords[0]
          , x0 = coords[1]
          , u = Math.random()
          , v = Math.random()
          , w = r * Math.sqrt(u)
          , t = 2 * Math.PI * v
          , x = w * Math.cos(t)
          , y1 = w * Math.sin(t)
          , x1 = x / Math.cos(y0)

        let newY = y0 + y1
        let newX = x0 + x1

        // Create the marker element
        let element = document.createElement('a');
        element.href = '/advertisements/' + result.id;
        element.classList.add('emoji-marker');
        element.dataset.content = result.title;
        element.innerHTML = result.emoji + ' ';

        let marker = new mapboxgl.Marker(element)
          .setLngLat([newY, newX])
          .addTo(map);

        window.markers.push(marker);

      })

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

$(window).on('update-map-view', function(event) {

  // Get the results
  let results = JSON.parse(event.detail["data"])

  // clear markers
  window.markers.forEach(marker => {
    marker.remove();
  });

  window.markers = [];

  // Add an emoji marker for each result
  results.forEach(result => {

    // Get the co-ordinates
    let coords = result.coordinates.reverse()

    // Calculate a scatter within 900ms (just to be safe!)
    var r = 900/111300
      , y0 = coords[0]
      , x0 = coords[1]
      , u = Math.random()
      , v = Math.random()
      , w = r * Math.sqrt(u)
      , t = 2 * Math.PI * v
      , x = w * Math.cos(t)
      , y1 = w * Math.sin(t)
      , x1 = x / Math.cos(y0)

    // Here's our co-ordinates, scattered over 900m
    let newY = y0 + y1
    let newX = x0 + x1

    // Create the marker element
    let element = document.createElement('a');
    element.href = '/advertisements/' + result.id;
    element.classList.add('emoji-marker');
    element.dataset.content =  result.title;
    element.innerHTML = result.emoji + ' ';

    // Add the marker to the map, and store it in the window.markers array
    let marker = new mapboxgl.Marker(element)
      .setLngLat([newY, newX])
      .addTo(window.mapView);

    window.markers.push(marker);

    // Add an event listener
    element.addEventListener('click', function(event) {
      console.log(event.target.dataset.id)
    })

  })

  const coordinates = $('#user_location').data('geocode').slice().reverse()
  const searchRadius = parseInt($('#search_distance').val());

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
