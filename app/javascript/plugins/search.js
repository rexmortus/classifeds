import mapboxgl from "mapbox-gl/dist/mapbox-gl.js"

$(document).ready(function() {

  var searchElement = document.getElementById('algoliasearch');

  if (searchElement) {

    // 1. Instantiate the search
    const search = instantsearch({
      indexName: 'Advertisement',
      searchClient: __algolia.algoliasearch('2GSQ5ZCOVT', '0950d041361731d13877c7ff4b0b54ba'),
      searchFunction: function(helper) {
        helper
        .setQueryParameter('aroundLatLng', $('#user_location').data('geocode').join(','))
        .setQueryParameter('minimumAroundRadius', 1)
        .setQueryParameter('aroundRadius', '' + parseInt($('#sliderOutput2').val()) * 1000 + '')
        .search();;
      },
    });

    window.search = search

    search.addWidget(
      instantsearch.widgets.searchBox({
        container: '#searchbox',
        placholder: 'Search...',
         searchAsYouType: false,
        autofocus: true,
      })
    );

    // 1. Create a render function
    const renderForRefinementList = (renderOptions, isFirstRender) => {
      const {
        items,
        isFromSearch,
        refine,
        createURL,
        isShowingMore,
        canToggleShowMore,
        searchForItems,
        toggleShowMore,
        widgetParams,
      } = renderOptions;

      if (isFirstRender) {
        const ul = document.createElement('ul');
        ul.classList.add('menu');
        ul.classList.add('vertical');

        widgetParams.container.appendChild(ul);
      }


      widgetParams.container.querySelector('ul').innerHTML = `
      ${items
        .map(
          item => `
            <li>
              <a href="${createURL(item.value)}"
              data-value="${item.value}"
              class="${item.isRefined ? 'is-refined' : ''}">
              ${item.label} (${item.count})
              </a>
            </li>
          `
        )
        .join('')}
        `;

      [...widgetParams.container.querySelectorAll('a')].forEach(element => {
        element.addEventListener('click', event => {
          event.preventDefault();
          refine(event.currentTarget.dataset.value);
        });
      });

    };

    // 2. Create the custom widget
    const customForRefinementList = instantsearch.connectors.connectRefinementList(
      renderForRefinementList
    );

    // 3. Instantiate
    search.addWidgets([
      customForRefinementList({
        container: document.querySelector('#for_filter'),
        attribute: 'for',
      })
    ]);

    // Create the render function
    const createDataAttribtues = refinement =>
      Object.keys(refinement)
        .map(key => `data-${key}="${refinement[key]}"`)
        .join(' ');

    const renderListItem = item => `
      ${item.refinements
        .map(
          refinement =>
            `<span class="label" ${createDataAttribtues(refinement)}>${refinement.label} <strong>(${refinement.count || 0})</strong></span>`
        )
        .join('')}
    `;

    const renderCurrentRefinements = (renderOptions, isFirstRender) => {
      const { items, refine, widgetParams } = renderOptions;

      widgetParams.container.innerHTML = `
          ${items.map(renderListItem).join('')}
      `;

      [...widgetParams.container.querySelectorAll('a')].forEach(element => {
        element.addEventListener('click', event => {
          const item = Object.keys(event.currentTarget.dataset).reduce(
            (acc, key) => ({
              ...acc,
              [key]: event.currentTarget.dataset[key],
            }),
            {}
          );

          refine(item);
        });
      });
    };

    // Create the custom widget
    const customCurrentRefinements = instantsearch.connectors.connectCurrentRefinements(
      renderCurrentRefinements
    );

    // Instantiate the custom widget
    search.addWidgets([
      customCurrentRefinements({
        container: document.querySelector('#current-refinements'),
      })
    ]);

    // Create the render function
    const renderClearRefinements = (renderOptions, isFirstRender) => {
      const { hasRefinements, refine, widgetParams } = renderOptions;

      if (isFirstRender) {
        const a = document.createElement('a');
        a.className = "label alert clear-filters"
        a.innerHTML = '<i class="fi-x-circle"></i>Clear filters';

        a.addEventListener('click', () => {
          refine();
        });

        widgetParams.container.appendChild(a);
      }

      const a = widgetParams.container.querySelector('a')

      if (!hasRefinements) {
        a.innerHTML = 'No filters';
        a.className = "label secondary"
      } else {
        a.innerHTML = '<i class="fi-x"></i> Clear filters';
        a.className = "label alert clear-filters"
      }


    };

    // Create the custom widget
    const customClearRefinements = instantsearch.connectors.connectClearRefinements(
      renderClearRefinements
    );

    // Instantiate the custom widget
    search.addWidgets([
      customClearRefinements({
        container: document.querySelector('#clear-refinements'),
      })
    ]);

    // Create the render function
    const renderList = ({ items, createURL, nested }) => `
      <ul class="vertical menu ${ nested ? 'nested' : '' }">
        ${items
          .map(
            item => `
              <li>
                <a
                  href="${createURL(item.value)}"
                  data-value="${item.value}"
                  class="${item.isRefined ? 'is-refined' : ''}">
                  ${item.label} (${item.count})
                </a>
                ${item.data ? renderList({ items: item.data, createURL, nested: true }) : ''}
              </li>
            `
          )
          .join('')}
      </ul>
    `;

    const renderHierarchicalMenu = (renderOptions, isFirstRender) => {
      const {
        items,
        isShowingMore,
        refine,
        toggleShowMore,
        createURL,
        widgetParams,
      } = renderOptions;

      if (isFirstRender) {
        const list = document.createElement('fieldset');
        list.classList.add('fieldset')
        widgetParams.container.appendChild(list);
      }

      const children = renderList({ items, createURL });

      widgetParams.container.querySelector('fieldset').innerHTML = `
        <legend><i class="fi-filter"></i> Categories</legend>
        ${children}
      `;


      [...widgetParams.container.querySelectorAll('a')].forEach(element => {
        element.addEventListener('click', event => {
          event.preventDefault();
          refine(event.target.dataset.value);
        });
      });
    };

    // Create the custom widget
    const customHierarchicalMenu = instantsearch.connectors.connectHierarchicalMenu(
      renderHierarchicalMenu
    );

    // Instantiate the custom widget
    search.addWidgets([
      customHierarchicalMenu({
        container: document.querySelector('#category-list'),
        attributes: [
          'category_name',
          'subcategory_name'
        ],
        limit: 5,
        showMoreLimit: 10,
      })
    ]);

    // Create the render function
    const renderHits = (renderOptions, isFirstRender) => {

      // Render new hits on the map
      if (window.map.addSource) {
        for (const marker in window.markers) {
          if (window.markers[marker]) {
              window.markers[marker].remove();
          }
        }

        window.markers = [];

        for (const hit of renderOptions.hits) {

          const marker = new mapboxgl.Marker()
            .setLngLat(hit['_geoloc'])
            .addTo(window.map);

          window.markers.push(marker);

        }

      }

      const { hits, widgetParams } = renderOptions;
        widgetParams.container.innerHTML = `
          <div class="grid grid-x grid-padding-x">
            ${hits
              .map(
                item =>
                  `<div class="cell small-12 medium-6 large-4 x-large-3">
                    <a href="/advertisements/${ item.objectID }">
                      <div class="card">
                        <img height="320" width="240" src="${ item.cover_image }" />
                        <div class="card-section">
                          <div class="grid grid-x">
                            <div class="cell small-12 medium-12 large-11">
                              <p><span class="label primary">${ item.for }</span><span class="label warning">${ item.subcategory_name }</span></p>
                              <h5>${ item.title }</h5>
                              <p class="card-location"><strong><small><i class="fi-marker"></i> ${ item.location }</small></strong></p>
                            </div>
                            <div class="cell small-12 medium-12 large-1">
                              <h4 class="emoji">${ item.emoji }</h4>
                            </div>
                          </div>
                        </div>
                      </div>
                    </a>
                  </div>`
              )
              .join('')}
          </div>
        `;
      };

    // Create the custom widget
    const customHits = instantsearch.connectors.connectHits(renderHits);

    // Instantiate the custom widget
    search.addWidgets([
      customHits({
        container: document.querySelector('#advert-hits'),
      })
    ]);

    search.addWidget(
      instantsearch.widgets.pagination({
        container: '#pagination',
         totalPages: 3,
      })
    );

    // 5. Start the search!
    search.start();

  }

});
