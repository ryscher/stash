// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var map;
$(document).ready(function() {

  // create a map in the "map" div, set the view to a given place and zoom
  map = L.map('map').setView([-41.2858, 174.78682], 14);
      mapLink = '<a href="https://openstreetmap.org">OpenStreetMap</a>';

    // add an OpenStreetMap tile layer
      L.tileLayer(
          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
          attribution: '&copy; ' + mapLink + ' Contributors',
          maxZoom: 18,
          }).addTo(map);

    // Initialize the FeatureGroup to store editable layers
        var drawnItems = new L.FeatureGroup();
        map.addLayer(drawnItems);

    // Initialize the draw control and pass it the FeatureGroup of editable layers
        var drawControl = new L.Control.Draw({
            position: 'topright',
            draw: {
              polyline : false,
              polygon : false,
              circle : false,
            },
            edit: {
                featureGroup: drawnItems
            }
        });
        map.addControl(drawControl);

    // listen to the draw created event
        map.on('draw:created', function (e) {
          var type = e.layerType,
              layer = e.layer;

          drawnItems.addLayer(layer);

          var shapes = getShapes(drawnItems);
          var geoJsonData = {
                              "type": "Feature",
                              "properties": {},
                              "geometry": {
                                "type": "Polygon",
                                "coordinates": [ shapes ]
                              }
                            };

          var geoJsonLayer = L.geoJson(geoJsonData);
          alert("Bounding Box: " + geoJsonLayer.getBounds().toBBoxString());

        });

        var getShapes = function(drawnItems) {

          // var lng, lat, coordinates = [];

          drawnItems.eachLayer(function(layer) {
              // Note: Rectangle extends Polygon. Polygon extends Polyline.
              // Therefore, all of them are instances of Polyline
              if (layer instanceof L.Polyline) {
                coordinates = [];
                latlngs = layer.getLatLngs();
                for (var i = 0; i < latlngs.length; i++) {
                    coordinates.push([latlngs[i].lng, latlngs[i].lat])
                }
              }
          });
          return coordinates;
        };

// var geoJsonLayer = L.geoJson(geoJsonData);

// console.log("Bounding Box: " + geoJsonLayer.getBounds().toBBoxString());
    // listen to the draw edited event
        map.on('draw:edited', function () {
            // Update db to save latest changes.
        });

    // listen to the draw deleted event
        map.on('draw:deleted', function () {
            // Update db to save latest changes.
        });
});



  // map = L.map('map').setView([51.505, -0.09], 13);
  // var layer = L.tileLayer("http://otile{s}.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png", {
  //     subdomains: "1234",
  //     attribution: "&copy; <a href='http://www.openstreetmap.org/'>OpenStreetMap</a> and contributors, under an <a href='http://www.openstreetmap.org/copyright' title='ODbL'>open license</a>. Tiles Courtesy of <a href='http://www.mapquest.com/'>MapQuest</a> <img src='http://developer.mapquest.com/content/osm/mq_logo.png'>"
  // })

  // layer.addTo(map);
  // map.attributionControl.setPrefix(''); // Don't show the 'Powered by Leaflet' text. Attribution overload

  // var marker = L.marker([51.5, -0.09]).addTo(map);

$(document).ready(function() {
  $("#geolocation_box").hide();
  $("#geo_box").on('click', function(e){
    $("#geolocation_box").show();
    $("#geolocation_point").hide();
  });
});

$(document).ready(function() {
  $("#geolocation_point").show();
  $("#geo_point").on('click', function(e){
    $("#geolocation_box").hide();
    $("#geolocation_point").show();
  });
});

$(document).ready(function(){
    $("#location_section").click(function() {
        setTimeout(function() {
            map.invalidateSize();
        }, 300);
    });
});

$(document).ready(function(){
  $("#geo_lat_point").on('blur', function(e){
  var lat = parseFloat($(this).val());
  var latReg = /^(\+|-)?(?:90(?:(?:\.0{1,6})?)|(?:[0-9]|[1-8][0-9])(?:(?:\.[0-9]{1,6})?))$/;
  if(!latReg.test(lat)) {
    alert("Please enter valid latitude value")
    }
    else {
      // do nothing
    }
  });
});

$(document).ready(function(){
  $("#geo_lng_point").on('blur', function(e){
  var lng = parseFloat($(this).val());
  var lngReg = /^(\+|-)?(?:180(?:(?:\.0{1,6})?)|(?:[0-9]|[1-9][0-9]|1[0-7][0-9])(?:(?:\.[0-9]{1,6})?))$/;
  if (lng == '') {}
  if(!lngReg.test(lng)) {
    alert("Please enter valid longitude value")
    }
    else {
      // do nothing
    }
  });
});



