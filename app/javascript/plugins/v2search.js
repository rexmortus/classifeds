import $ from 'jquery';
import Packery from 'packery';
import imagesLoaded from "imagesloaded"
import { createGeoJSONCircle } from "plugins/geojsoncircle"

const form = document.getElementById('search_form');

if (form) {

  let resultsContainer = document.getElementById('js-results-grid');
  let appliedFiltersContainers = document.querySelectorAll('[data-applied-filters]');
  let typeFiltersContainer = document.getElementById('js-type-filters');
  let categoryFiltersContainer = document.getElementById('js-category-filters');

  let pckry = new Packery(resultsContainer, {
    itemSelector: '.js-packery-item',
    gutter: '.js-gutter-sizer',
    percentPosition: true,
    transitionDuration: 0,
  });

  imagesLoaded(resultsContainer, function( instance ) {
    pckry.layout();
  });

  // Applying type filters
  typeFiltersContainer.addEventListener('click', function(event) {
    event.preventDefault();
    let typeFilter = event.target.dataset.typeFilter;
    let filterInput = document.getElementById('search_types_' + typeFilter)
    filterInput.checked = !filterInput.checked
    Rails.fire(form, 'submit');
  })

  // Applying category filters
  categoryFiltersContainer.addEventListener('click', function(event) {
    event.preventDefault();
    let categoryFilter = event.target.dataset.categoryFilter;
    let filterInput = document.getElementById('search_category_subcategory_' + categoryFilter)
    filterInput.checked = !filterInput.checked
    Rails.fire(form, 'submit');
  })

  // Applying view-type selector
  let viewTypeSelectorContainer = document.querySelectorAll('[data-view-type-toggle]');
  viewTypeSelectorContainer.forEach(function(element) {
    element.addEventListener('click', function(event) {
      let viewTypeFilter = event.target.dataset.viewFilter;
      let filterInput = document.getElementById('search_view_type_' + viewTypeFilter)
      filterInput.checked = !filterInput.checked;
      Rails.fire(form, 'submit');
    })
  });

  // A function to clear filters
  window.clearFilters = function() {
    document.getElementsByName('search[types][]').forEach(function(element) {
    	element.checked = false;
    })
    document.getElementsByName('search[category_subcategory]').forEach(function(element) {
    	element.checked = false;
    })
    Rails.fire(form, 'submit');
  }

  // Applying distance filter
  $('#radius-slider').on('changed.zf.slider', function(event) {

    const searchRadius = parseInt($('#search_distance').val());

    let valueNow = event.target.children[0].attributes[7].value;
    let sliderElement = event.target.children[0];
    sliderElement.textContent = "+" + searchRadius + "km";

    if (window.map.removeLayer && sliderElement.dataset.sliderInitialLoad == 'false') {

      const coordinates = $('#user_location').data('geocode').slice().reverse();

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

      // this is so geocode
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
    }

    sliderElement.dataset.sliderInitialLoad = 'false';

  });

  // Event hooks
  $(form).on('ajax:before', function() {
    $('#search_query').blur();
    appliedFiltersContainers.forEach(function(element) {
      element.classList.add('submitting');
    })
    resultsContainer.classList.add('submitting');
  })

  $(form).on('ajax:success', function(event, xhr, status, error) {
    pckry.reloadItems();
    pckry.layout();
    appliedFiltersContainers.forEach(function(element) {
      element.classList.remove('submitting');
    })
    resultsContainer.classList.remove('submitting');
  });

  window.addEventListener('refresh-masonry-layout', function() {
    pckry.layout();
  });

}
