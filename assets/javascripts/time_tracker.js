/*
 * This script updates the element 'id' with 'newContent' if the two contents differ
 */
function updateElementIfChanged(id, newContent, link) {
    el = $(id);
    if (el.html() != newContent) { el.html(newContent); }
    $(link).bind("ajax:success", function(et, data){
      updateElementIfChanged(id, data, link);
    });
}
