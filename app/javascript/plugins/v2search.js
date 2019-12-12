import $ from 'jquery';
import Packery from 'packery';
import imagesLoaded from "imagesloaded"
import { createGeoJSONCircle } from "plugins/geojsoncircle"

const form = document.getElementById('search_form');

if (form) {

  let container = document.getElementById('js-results-grid');
  let appliedFiltersContainer = document.getElementById('js-applied-filters');

  let pckry = new Packery(container, {
    itemSelector: '.js-packery-item',
    gutter: '.js-gutter-sizer',
    percentPosition: true,
    transitionDuration: 0,
  });

  pckry.layout();

  imagesLoaded(container, function( instance ) {
    pckry.layout();
  });

  // Applying type filters
  $('#js-type-filters').on('click', function(event) {
    let typeFilter = event.target.dataset.typeFilter;
    let filterInput = document.getElementById('search_types_' + typeFilter)
    filterInput.checked = !filterInput.checked
    Rails.fire(form, 'submit');
  });

  // Applying distance filter
  $('#radius-slider').on('changed.zf.slider', function() {

    if (window.map.removeLayer) {

      Rails.fire(form, 'submit');

      const coordinates = $('#user_location').data('geocode').slice().reverse()
      const searchRadius = parseInt($('#search_distance').val());

      const polygon = createGeoJSONCircle(coordinates, searchRadius);
      window.map.removeLayer('polygon');
      window.map.removeSource('polygon');
      window.map.addSource("polygon", polygon);

      window.map.addLayer({
          "id": "polygon",
          "type": "fill",
          "source": "polygon",
          "layout": {},
          "paint": {
              "fill-color": "#6e4d54",
              "fill-opacity": 0.15
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

      window.map.fitBounds(
        [
          [x1,y1],
          [x2,y2]
        ]);
    }

  });

  $(form).on('ajax:before', function() {
    $('#search_query').blur();
  })

  $(form).on('ajax:success', function(event, xhr, status, error) {
    pckry.reloadItems();
    pckry.layout();
  });

}
