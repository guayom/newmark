/* ---------------------------- =Popup Window -------------------------------*/

function popupWindow (url, name, width, height, properties) {
	if (!name) name = "popWin";
	if (!width) width = "700";
	if (!height) height = "480";

	var features = "width=" + width + ",height=" + height;

	//	-- properties --
	//	not set or false    : standard clean window with no address bar, etc.
	//	some string         : use the string

	if (!properties || properties == false) {
		features += ",left=100,top=100,toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,scrollbars=1";
	} else {
		features += properties;
	}

	var popWin = window.open(url, name, features);
	checkPopped(popWin);
	return popWin;
}

function checkPopped (winName) {
	if (winName)
		winName.focus();
	else {
	    var popupWarning = 'Pop-up blocking software in your browser has prevented us from opening a new window. In order for this site to function properly please disable your Pop-up blocking software for this site.';
		alert(popupWarning);
		return;
	}
}


/* ---------------------------- =Toggle Display -------------------------------*/

// elmID          : ID of element to toggle
// defaultDisplay : Overides the default display for an element (block, inline, none)
// force          : If set to true, forces the element to use the defaultDisplay (overides toggling)

function toggleDisplay (elmID, defaultDisplay, force) {
	// Get the style property of our element
	if (document.getElementById) {
		// standards way
		var elmStyle = document.getElementById(elmID).style;
	} else if (document.all) {
		// old msie version way
		var elmStyle = document.all[elmID].style;
	} else if (document.layers) {
		// nn4 way
		var elmStyle = document.layers[elmID].style;
	}

	// Force display to defaultDisplay if force is set
	if (force)
	{
		elmStyle.display = defaultDisplay; return;
	}
	// If there is no defaultDisplay set check the default state for the element
	else if (!defaultDisplay)
	{
		var elmType = document.getElementById(elmID).tagName.toLowerCase();
		if (elmType == 'a' || elmType == 'span' || elmType == 'strong' || elmType == 'em')
			var defaultDisplay = 'inline';
		else
			var defaultDisplay = 'block';
	}

	// If not forced toggle it's display
	if (elmStyle.display == 'none') {
		// if set to 'none' toggle to whatever the default for this element is
		elmStyle.display = defaultDisplay;
	} else {
		// if set to 'block' or default (which can't be read but is 'block')
		// toggle to 'none'
		elmStyle.display = 'none';
	}
}

//-----------------------------------------------------------------------------
// Mail To

function mailTo(username, domain)
{
	document.location = 'mailto: ' + username + '@' + domain + '?subject=Web Site Contact';
}



/* ---------------------------- Suckerfish Dropdowns -------------------------*/

sfHover = function() {
    if(document.getElementById("navlist")!=null)
    {
	    var sfEls = document.getElementById("navlist").getElementsByTagName("li");
	    for (var i=0; i<sfEls.length; i++) {
		    sfEls[i].onmouseover=function() {
			    this.className+=" sfhover";
			    hideSelects('hidden');
		    }
		    sfEls[i].onmouseout=function() {
			    this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
			    hideSelects('visible');
		    }
	    }
	}
}
if (window.attachEvent) window.attachEvent("onload", sfHover);



function hideSelects(action) {
	//documentation for this script at http://www.shawnolson.net/a/1198/hide-select-menus-javascript.html
	//possible values for action are 'hidden' and 'visible'
	if (action!='visible') { action='hidden'; }

	if(!HideDropDownNav) return;

	if (navigator.userAgent.indexOf("MSIE 6.") >= 0)
	{
		for (var S = 0; S < document.forms.length; S++)
		{
			for (var R = 0; R < document.forms[S].length; R++)
			{
				if (document.forms[S].elements[R].options)
				{
					document.forms[S].elements[R].style.visibility = action;
				}
			}
		}
	}
}
