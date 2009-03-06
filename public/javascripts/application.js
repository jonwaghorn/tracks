// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function clearSearchText(term) {
  if (term.defaultValue == term.value) {
    term.value = "";
    term.style.color = 'black';
  }
}

function reshowSearchText(term) {
  if (term.value == '') {
    term.value = term.defaultValue;
    term.style.color = '#f48a00';
  }
}
