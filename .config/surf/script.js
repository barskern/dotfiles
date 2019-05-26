
// #### UNTARGET ####
//
// This script looks for links with "target" attribute set to "_blank" and
// strips this attribute. This prevents surf from unexpectedy opening new
// windows. (Opening new windows by middle click or via context menu still
// works.)
function untarget() {
	var links = document.getElementsByTagName('a');
	Array.prototype.slice.call(links).forEach(function(anchor, index, arr) {
		if (anchor["target"] == "_blank")
			anchor.removeAttribute("target");
	});
}

window.onload = untarget;
// #### UNTARGET END ####
