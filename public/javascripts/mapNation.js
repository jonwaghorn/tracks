var map;
var regionPolys = [];

function initialize() {
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    map.setCenter(maplatlng, mapZoom);
    map.clearOverlays();
    map.setMapType(mapType);
    addRegions();
  } else {
    document.getElementById("map").innerHTML="This website uses Google Maps, which appear not to work with your browser. See the FAQ.";
  }
}

function addRegions() {
  for (var i = 0; i < regionPolys.length; i++) {
    addRegion(new GPolygon.fromEncoded(regionPolys[i][0]), regionPolys[i][1]);
  }
}

function addRegion(poly, ref) {
  map.addOverlay(poly);
  GEvent.addListener(poly,'click',function(para){window.open("/region/show/" + ref, "_top");});
  GEvent.addListener(poly, 'mouseover', function() {
    map.getDragObject().setDraggableCursor("pointer");
    this.setStrokeStyle({weight:4});
  });
  GEvent.addListener(poly, 'mouseout', function() {
    map.getDragObject().setDraggableCursor("url(http://maps.google.com/intl/en_us/mapfiles/openhand.cur),default");
    this.setStrokeStyle({weight:2});
  });
}

