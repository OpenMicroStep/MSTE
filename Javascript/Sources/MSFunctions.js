
var $MSCurrentLang = 17 ;

var $MSTranslations = [
	{}, /* 00 RUSSIAN */
	{}, /* 01 empty */
	{}, /* 02 empty */
	{}, /* 03 PORTUGUESE */
	{}, /* 04 empty */
	{}, /* 05 ITALIAN */
	{}, /* 06 GREEK */
	{}, /* 07 DANISH */
	{}, /* 08 empty */
	{}, /* 09 empty */
	{}, /* 10 empty */
	{}, /* 11 TURKISH */
	{}, /* 12 empty */
	{}, /* 13 empty */
	{}, /* 14 DUTCH */
	{}, /* 15 NORWEGIAN */
	{}, /* 16 ROMAN */
	{   /* 17 FRENCH */
		htmlLang:"fr-FR",
		months:["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"],
		shortMonths:["Jan.", "Fév.", "Mars", "Avr.", "Mai", "Juin", "Juil.", "Août", "Sept.", "Oct.", "Nov.", "Déc."],
		days:["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"],
		shortDays:["Dim", "Lun", "Mar", "Mer", "Jen", "Ven", "Sam"],
		startingWeekDay:1,
		noFileSelected:"Pas de fichier",
		noSelectionTitle:"Choisissez SVP",
		noSelectionEntry:"Pas de sélection",
		deleteAction:"Supprimer",
		renameAction:"Renommer",
		geo:{latitude:48.5, longitude:2.2, reference:"Paris"},
		unnamed:"Sans nom",
        ordinals:["e","er"],
        week:['semaine', 'semaines', 'sem.', 'sem.'],
        year:["année", "années", "an", "ans"],
        isWeekEndDay: function(d) { return (d == 0 || d == 6) ? true : false ; }, 
		shortDateString: function(aDate) {
			var q = aDate.getDate() ;
			var m = aDate.getMonth() ;
			return (q < 10 ? "0":"")+q+"/"+(m < 9 ? "0":"")+m+"/"+aDate.getYear() ;
		},
		dateString: function(aDate) {
			var q = aDate.getDate() ;
			var m = aDate.getMonth() ;
			return (q < 10 ? "0":"")+q+"/"+(m < 9 ? "0":"")+m+"/"+aDate.getFullYear() ;			
		},
		fullDateString: function(aDate) {
			var day = aDate.getDay() ;
			var q = aDate.getDate() ;
			if (q == 1) { q = "1er" ; }
			return this.days[day]+' '+q+' '+this.months[aDate.getMonth()]+' '+aDate.getFullYear() ;
		}
	},
	{}, /* 18 empty */
	{}, /* 19 empty */
	{}, /* 20 SPANISH */
	{}, /* 21 ARMENIAN */
	{}, /* 22 empty */
	{}, /* 23 ARABIC */
	{}, /* 24 empty */
	{}, /* 25 empty */
	{	/* 26 GERMAN */
		htmlLang:"de-DE",
		months:["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"],
		shortMonths:["Jan", "Feb", "Mrz", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"],
		days:["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"],
		shortDays:["Son", "Mon", "Die", "Mit", "Don", "Fre", "Sam"],
		startingWeekDay:1,
		noFileSelected:"Pas de fichier",
		noSelectionTitle:"Choisissez SVP",
		noSelectionEntry:"Pas de sélection",
		deleteAction:"Löschen",
		renameAction:"Vierdernamen",
		geo:{latitude:52.3, longitude:13.25, reference:"Berlin"},
		unnamed:"Namenlos",
        dayOrdinals:["."],
        ordinals:["."],
        week:['Woche', 'Wochen', 'Wo.', 'Wo.'],
        year:["Jahr", "Jahren", "Jahr", "Jahr."],
        isWeekEndDay: function(d) { return (d == 0 || d == 6) ? true : false ; }, 
		shortDateString: function(aDate) {
			// TODO			
		},
		dateString: function(aDate) {
			// TODO
		},
		fullDateString: function(aDate) {
			// TODO
		}
	},
	{}, /* 27 BULGARIAN */
	{}, /* 28 empty */
	{   /* 29 ENGLISH */
		htmlLang:"en-US",
		months:["January", "February", "March", "April", "May", "June", "July", "August", "Septembre", "Octobre", "Novembre", "Decembre"],
		shortMonths:["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
		days:["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
		shortDays:["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
		startingWeekDay:0,
		noFileSelected:"No file selected",
		noSelectionTitle:"Select...",
		noSelectionEntry:"Nothing selected",
		deleteAction:"Delete",
		renameAction:"Rename",
		geo:{latitude:39.91, longitude:-77.02, reference:"Washington DC"},
		unnamed:"Unamed",
        dayOrdinals:["th","st","nd","rd"],
        ordinals:["th","st","nd","rd"],
        week:['week', 'weeks', 'wk', 'wks'],
        year:['year', 'years', 'yr', 'yrs'],
        isWeekEndDay: function(d) { return (d == 0 || d == 6) ? true : false ; }, 
		shortDateString: function(aDate) {
			// TODO
			
		},
		dateString: function(aDate) {
			// TODO
		},
		fullDateString: function(aDate) {
			// TODO
		}
	},
	{}, /* 30 SERBIAN */
	{}, /* 31 GAELIC */
	{}, /* 32 CZECH */
	{}, /* 33 POLISH */
	{}  /* 34 CROATIAN */
] ;

function $Ordinal(x, language) {
    var ordinals, i = $MSInt(x) ;

	if (i == 0) { return "" ; }
	if (!$MSOK(language)) { language = $MSCurrentLang ; }
    
	ordinals = $MSTranslations[language].ordinals ;
	$MSTranslations[language].fullDateString();
	if (i >= ordinals.length) { return ""+i+ordinals[0] ; }
	return ""+i+ordinals[i] ;
}

function $MSOK(self) { return ((self === null || (typeof self) === 'undefined') ? false : true) ; }
function $MSCount(self) { return ((self === null || (typeof self) === 'undefined' || (typeof self.length) === 'undefined') ? 0 : self.length) ; }
function $MSLength(self) { return ((self === null || (typeof self) === 'undefined' || (typeof self.length) === 'undefined') ? 0 : self.length) ; }

function $MSInt(x) {
    var t,r ;
    if (x === null) { return 0 ;}
    
    t = typeof x ;
    switch(t) {
        case 'undefined': return 0 ;
        case 'string': r = parseInt(x, 10) ; return (isNaN(r) ? 0 : r) ; 
        case 'number': return x ;
        case 'object':
            if (typeof (x.toNumber) === 'function') {
                r = x.toNumber() ;
                return (isNaN(r) ? 0 : r) ;
            }
            return 0 ;
        default: return 0 ;
    }
}

function $MSDesc(self, excludedKeys) {
	var s = '{' ;
	for (var aKey in self) {
		if (aKey != 'isa' && (!excludedKeys || excludedKeys.indexOf(aKey) == -1)) {
			var v = self[aKey], t = typeof v ;
			if (v !== null && t !== 'function' && t !== 'undefined') { s = s + aKey + ' = ' + v + '; ' ; }
		}
	}
	return s + '}';
}

function $MSMethods(self) {
	var s = '{' ;
	for (var aKey in self) {
		var v = self[aKey], t = typeof v ;
		if (t === 'function') { s = s + aKey + ' = ' + v + '; ' ; }
	}
	return s + '}';
}

function $MSTimeString(h,mn,sec) { 
	while (h < 0) { h += 24 ; }
	if ($MSOK(sec)) {
		return (h < 10 ? "0":"") + (h % 24) +"h "+ (mn < 10 ? "0" : "") + mn + "mn " + (sec > 0 ? (sec < 10 ? "0":"") + sec : "");		
	}
	return (h < 10 ? "0":"") + (h % 24) +"h"+ (mn < 10 ? "0" : "") + mn ;
}

function $MSTrim(self) { return self.replace(/^\s*(\S*(\s+\S+)*)\s*$/, "$1"); }

function $MSElem(elementID)
{
	if (document.layers) { return document.layers[elementID] ; }
	if (document.all) { return document.all[elementID] ; }
	return document.getElementById(elementID) ;
}

function $IsLeapYear(y) { return (y % 4 ? false : ( y % 100 ? (y > 7 ? true : false) : (y % 400 || y < 1600 ? false : true))) ; }

function $MSMouseX(e) { return e.pageX || e.clientX + document.documentElement.scrollLeft ; }
function $MSMouseY(e) { return e.pageY || e.clientY + document.documentElement.scrollTop ; }

function $MSDomSetOpacity(node, opacity) {
	if ($MSOK(node)) {
		if (!$MSOK(opacity)) { opacity = 0 ; }
		else if (opacity > 1) { opacity = 1 ; } 
		else if (opacity < 0) { opacity = 0 ; }
		if (Ext.isIE) {
			if (opacity == 1) { node.style.filter = '' ; }
			else { node.style.filter = "alpha(opacity=" + opacity*100 + ")"; } ; 
		}		
		else { node.style.opacity = opacity ; }
	}
}

function $MSIsWordSeparator(c) { return (c == 32 || c == 9 || (c >= 44 && c <= 48) || c == 58 || c == 59) ? true : false ; }