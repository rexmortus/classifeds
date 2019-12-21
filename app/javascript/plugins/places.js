import mapboxgl from "mapbox-gl/dist/mapbox-gl.js"
import { createGeoJSONCircle } from 'plugins/geojsoncircle'

// Places autocomplete
var placesAutocomplete = document.getElementById('algolia-places-input');

if (placesAutocomplete) {

  // Initialse the shit
  placesAutocomplete = places(
    {
    appId: 'plIXN9SZEJE6',
    apiKey: 'adcd356c5d066b32a4538fe81b280f9f',
    container: placesAutocomplete
    }
  );

  // On new page (when u create a new ad)
  // We'll let changing the autocomplete field
  // change the map location.
  // We don't need to do this on the search page, since
  // updating the map is part of ajax-submitting the form
  let newPage = document.querySelector('[data-new-page-map]');

  if (newPage) {
    placesAutocomplete.on('change', function(event) {

      // Unfocus the input
      // event.target.blur();
      // this

      // Get the suggested coordinates
      let coordinates = Object.values(event.suggestion.latlng);

      // Create the update map event
      var event = new CustomEvent('update-map-view', {
        detail: {
          coordinates: coordinates,
          radius: 5,
          data: '[]'
        }
      });

      // Dispatch the event
      window.dispatchEvent(event);
    });
  };
};
