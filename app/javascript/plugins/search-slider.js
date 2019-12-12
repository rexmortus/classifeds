import { createGeoJSONCircle } from 'plugins/geojsoncircle'

var slider = document.getElementById('radius-slider');

if (slider) {

  $('#radius-slider').on('changed.zf.slider', function() {


  //   const coordinates = $('#user_location').data('geocode').slice().reverse()
  //   const searchRadius = parseInt($('#sliderOutput2').val());
  //
  //   $('#distance-label').text(searchRadius);
  //
  //   if (window.map.removeLayer) {
  //
  //     const polygon = createGeoJSONCircle(coordinates, searchRadius);
  //     window.map.removeLayer('polygon');
  //     window.map.removeSource('polygon');
  //     window.map.addSource("polygon", polygon);
  //
  //     window.map.addLayer({
  //         "id": "polygon",
  //         "type": "fill",
  //         "source": "polygon",
  //         "layout": {},
  //         "paint": {
  //             "fill-color": "#6e4d54",
  //             "fill-opacity": 0.15
  //         }
  //     });
  //
  //     const center_x = coordinates[0];
  //     const center_y = coordinates[1];
  //     const earth_radius = 6378.1;
  //     const dY = 360 * searchRadius / earth_radius * 0.2;
  //     const dX = dY * Math.cos(center_y / (Math.PI / 180)) * 0.2;
  //
  //     const x1 = center_x - dX;
  //     const y1 = center_y - dY;
  //     const x2 = center_x + dX;
  //     const y2 = center_y + dY;
  //
  //     window.map.fitBounds(
  //       [
  //         [x1,y1],
  //         [x2,y2]
  //       ]);
  //   }
  //
  //    window.search.refresh();
  });

}
