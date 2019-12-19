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

  // Changing search location
  const saveLocationButton = document.getElementById('js-save-location');
  const saveLocationModal = document.getElementById('js-change-location-modal');

  saveLocationButton.addEventListener('click', function(event) {
    $(saveLocationModal).foundation('close');
    Rails.fire(form, 'submit');
  })

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
    sliderElement.blur();

    Rails.fire(form, 'submit');

  });

  // Event hooks
  $(form).on('ajax:before', function() {
    $('#search_query').blur();
  })

  $(form).on('ajax:success', function(event, xhr, status, error) {
    pckry.reloadItems();
    pckry.layout();
  });

  window.addEventListener('refresh-masonry-layout', function() {
    pckry.reloadItems();
    pckry.layout();
  });

  // Location modal events
  const locationModal = document.getElementById('js-change-location-modal');

  // Focus the input on reveal
  $(document).on(
    'open.zf.reveal', '[data-reveal]', function () {
      $('#address-input').focus().select();
    }
  );

  // Some stuff to use the location value
  const addressInput = document.getElementById('address-input');
  const locationValue = document.getElementById('js-location-value');

  addressInput.addEventListener('change', function(event) {
    locationValue.value = event.target.value;
  })

  $(document).on(
    'closed.zf.reveal', '[data-reveal]', function () {
      Rails.fire(form, 'submit');
    }
  );

}
