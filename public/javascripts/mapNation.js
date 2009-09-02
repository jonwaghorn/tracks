var map;
var regionPolys = [];

function initialize() {
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    var uiOptions = map.getDefaultUI();
    uiOptions.zoom.scrollwheel = false; // Disable scroll wheel zoom
    map.setUI(uiOptions);
    map.setCenter(maplatlng, mapZoom);
    map.addMapType(G_SATELLITE_3D_MAP);
    map.setMapType(mapType);
    map.clearOverlays();
    map.setMapType(mapType);
    addRegions();
  } else {
    document.getElementById("map").innerHTML="This website uses Google Maps, which appear not to work with your browser. See the FAQ.";
  }
}

function addRegions() {
  for (var i = 0; i < regionPolys.length; i++) {
    addRegion(new GPolygon.fromEncoded(regionPolys[i][0], {mouseOutTolerance:1}), regionPolys[i][1], regionPolys[i][2]);
  }
}

function addRegion(poly, ref, tooltip) {
  map.addOverlay(poly);
  GEvent.addListener(poly,'click',function(para){window.open("/region/show/" + ref, "_top");});
  GEvent.addListener(poly, 'mouseover', function() {
    map.getDragObject().setDraggableCursor("pointer");
    this.setStrokeStyle({weight:3});
  });
  GEvent.addListener(poly, 'mouseout', function() {
    map.getDragObject().setDraggableCursor("url(http://maps.google.com/intl/en_us/mapfiles/openhand.cur),default");
    this.setStrokeStyle({weight:2});
  });
}
