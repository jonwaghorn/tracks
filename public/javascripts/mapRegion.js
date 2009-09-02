var map;
var polygon = 0;
var markers = new Array();             // Non-track map markers
var icon = getIcon();                  // Google icon to use for non-track views
var regionPolys = [];                  // Raw region polygon data
var regionPoly;                        // Region GPolygon
var regionShowHide = false;            // Toggle for showing/hiding region

// document.getElementById("area").innerHTML = (Math.round(polygon.getArea() / 10000) / 100) + "km<sup>2</sup>";

function initialize(action) {
  if (GBrowserIsCompatible()) {
    setupMap();
    switch(action) {
      case 'show':
        setupMapForShow();
        break;    
      default:
        setupMapForEdit();
    }
  } else {
    document.getElementById("map").innerHTML="This website uses Google Maps, which appear not to work with your browser. See the FAQ.";
  }
}

function setupMap() {
  map = new GMap2(document.getElementById("map"));
  var uiOptions = map.getDefaultUI(); // Get default options
  uiOptions.zoom.scrollwheel = false; // Disable scroll wheel zoom
  map.setUI(uiOptions); // Set the map's interface
  map.setCenter(maplatlng, mapZoom);
  map.addMapType(G_SATELLITE_3D_MAP);
  G_SATELLITE_3D_MAP.getName = function() {return "Earth 3D"}  // Rename Google Earth map type button
  map.setMapType(mapType);
  // *** GOverviewMapControl currently broken for minimized ***
  // ovMap = new GOverviewMapControl(new GSize(100,80));
  // map.addControl(ovMap);
  // ovMap.hide(true);
}

function setupMapForShow() {
  addMarkers('area');  // markers for a Region are Area markers
  addRegionForShow();
}

function setupMapForEdit() {
  addAreas();
  addRegions();
  GEvent.addListener(map, "moveend", function() {
    var center = map.getCenter();
    document.getElementById("region_latitude").value = center.lat();
    document.getElementById("region_longitude").value = center.lng();
    document.getElementById("region_zoom").value = map.getZoom();
  });
  if (polygon) {
    map.addOverlay(polygon);
    updatePolyPoints(polygon);
    document.getElementById("edit_region").style.display = 'inline';
    document.getElementById("add_region").style.display = 'none';
    document.getElementById("fit_region").disabled = false;
    enableColourOptions();
  } else {
    document.getElementById("edit_region").style.display = 'none';
    document.getElementById("add_region").style.display = 'inline';
    document.getElementById("fit_region").disabled = true;
  }
}

function editShape() {
  document.getElementById("edit_region_info").innerHTML = "Edit shape on the map. Click handles to add/move/delete.";
  document.getElementById("edit_region").disabled = true;
  polygon.enableEditing({onEvent: "mouseover"});
  polygon.disableEditing({onEvent: "mouseout"});
  GEvent.bind(polygon, "lineupdated", "fred", function() {
    updatePolyPoints(polygon);
  });
  GEvent.addListener(polygon, "click", function(latlng, index) {
    if (typeof index == "number") {
      polygon.deleteVertex(index);
    } else {
      cells.color.style.backgroundColor = regionColour;
      polygon.setStrokeStyle({color: regionColour, weight: 4});
    }
  });
}

function startShape() {
  document.getElementById("edit_region_info").innerHTML = "Create shape on the map. Click handles to add/move/delete. Complete the shape before saving page.";
  document.getElementById("add_region").disabled = true;
  polygon = new GPolygon([], regionColour, 2, 0.7, regionColour, 0.2);
  map.addOverlay(polygon);
  polygon.enableDrawing();
  polygon.enableEditing({onEvent: "mouseover"});
  polygon.disableEditing({onEvent: "mouseout"});
  GEvent.addListener(polygon, "endline", function() {
    GEvent.bind(polygon, "lineupdated", "fred", function() {
      updatePolyPoints(polygon);
    });
    GEvent.addListener(polygon, "click", function(latlng, index) {
      if (typeof index == "number") {
        polygon.deleteVertex(index);
      } else {
        cells.color.style.backgroundColor = regionColour;
        polygon.setStrokeStyle({color: regionColour, weight: 4});
      }
    });
    document.getElementById("fit_region").disabled = false;
    enableColourOptions();
  });
}

function updatePolyPoints(poly) {
  var rows = [];
  document.getElementById("points").innerHTML = "";
  if (poly) {
    var len = poly.getVertexCount() || 0;
    for (var i = 0; i < len; i++) {
      var point = poly.getVertex(i);
      rows.push(point.lat().toFixed(6) + "," + point.lng().toFixed(6));
    }
    document.getElementById("points").value = rows.join(';');
  }
}

function fit() {
  var bounds = new GLatLngBounds();
  if (polygon) {
    for (var i = 0; i < polygon.getVertexCount() || 0; i++) {
      bounds.extend(polygon.getVertex(i))
    };
    var lngCenter = (bounds.getNorthEast().lng() + bounds.getSouthWest().lng()) / 2;
    var latCenter = (bounds.getNorthEast().lat() + bounds.getSouthWest().lat()) / 2;
    var center = new GLatLng(latCenter,lngCenter);
    map.setCenter(center, map.getBoundsZoomLevel(bounds));
  }
}

function enableColourOptions() {
  for (var i = 0; i < regionColourCount; i++) {
    document.getElementById("region_colour_" + i).disabled = false;
  }
}

function getIcon() {
  var i = new GIcon();
  i.image = "http://tracks.org.nz/images/mm_20_orange.png";
  i.shadow = "http://tracks.org.nz/images/mm_20_shadow.png";
  i.iconSize = new GSize(12, 20);
  i.shadowSize = new GSize(22, 20);
  i.iconAnchor = new GPoint(6, 20);
  i.infoWindowAnchor = new GPoint(5, 1);
  return i;
}

function addRegions() {
  for (var i = 0; i < regionPolys.length; i++) {
    map.addOverlay(new GPolygon.fromEncoded(regionPolys[i]));
  }
}

function addRegionForShow() {
  if (regionPolys.length == 1) { // expects 0 or 1 regions
    regionPoly = new GPolygon.fromEncoded(regionPolys[0]);
    map.addOverlay(regionPoly);
    showHideRegion();
  }
}

function showHideRegion() {
  if (regionShowHide) {
    regionPoly.show();
  }
  else {
    regionPoly.hide()
  }
  regionShowHide = !regionShowHide;
}

function addMarkers(pageType)
{  // all the markers for a page using pre-setup markers var
  for (var i = 0; i <= markers.length - 1; i++)
  {
    map.addOverlay(createMarker(new GLatLng(markers[i].lat, markers[i].lng), {title:markers[i].name, icon:icon}, "/" + pageType + "/show/" + markers[i].id))
  }
}

function createMarker(point,opts,url)
{  // a single icon marker
  var marker = new GMarker(point,opts);
  GEvent.addListener(marker,"click",function(){window.open(url, "_top");});
  return marker;
}
