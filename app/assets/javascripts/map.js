$(document).ready(function() {
  var geocodeAddress, geocoder, initialize, map;
  var input = document.getElementById('address');
  var gmap_picth = document.getElementById('gmap-canvas');

  if (typeof(input) != 'undefined' && input != null &&
      typeof(gmap_picth) != 'undefined' && gmap_picth != null) {
  initialize = function() {
    var autocomplete;
    return autocomplete = new google.maps.places.Autocomplete(input);
  };
  google.maps.event.addDomListener(window, 'load', initialize);
  map = new google.maps.Map(gmap_picth, {
    zoom: 8,
    center: {
      lat: 16.0544068,
      lng: 108.2021667
    }
  });
  geocoder = new google.maps.Geocoder;
  $('#address').change(function() {
    return geocodeAddress(geocoder, map);
  });
  geocodeAddress = function(geocoder, resultsMap) {
    var address;
    address = document.getElementById('address').value;
    return geocoder.geocode({
      'address': address
    }, function(results, status) {
      var marker;
      if (status === 'OK') {
        resultsMap.setCenter(results[0].geometry.location);
        return marker = new google.maps.Marker({
          map: resultsMap,
          position: results[0].geometry.location
        });
      }
    });
  };
  return geocodeAddress(geocoder, map);
  }
});
