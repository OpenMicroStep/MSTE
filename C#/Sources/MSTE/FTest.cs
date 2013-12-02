﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Reflection;

namespace MSTEClasses {
    public partial class FTest : Form {
        public FTest() {
            InitializeComponent();
        }

        private void btnDecode_Click(object sender, EventArgs e) {

           try {
                txtErrors.Text = "";
                // Decodage
                string res = "[\"MSTE0101\",59,\"CRC74FD101E\",1,\"Person\",6,\"firstname\",\"maried-to\",\"name\",\"birthday\",\"mother\",\"father\",20,3,50,4,0,5,\"Yves\",1,50,4,0,5,\"Claire\",1,9,1,2,5,\"Durand\",3,6,-207360000,2,9,5,3,6,-243820800,9,3,50,5,0,5,\"Lou\",4,9,3,2,9,5,3,6,552096000,5,9,1]";
                // string res = "[\"MSTE0101\",57,\"CRCFAFCE14D\",0,12,\"PACT\",\"MID\",\"CARD\",\"RSRC\",\"path\",\"modificationDate\",\"isFolder\",\"basePath\",\"STAT\",\"INAM\",\"OPTS\",\"CTXCLASS\",8,7,0,5,\"home\",1,3,8,2,9,1,3,20,1,8,4,4,5,\"z\",5,6,1349681026,6,3,0,7,5,\"_main_/interfaces/main@home\",8,3,2,9,5,\"main\",10,8,1,11,5,\"XNetInitialContext\"]";
                // string res = "[\"MSTE0101\",2579,\"CRC9311A237\",1,\"XVar\",62,\"VARS\",\"homeForm\",\"ApplicationVersion\",\"flags\",\"value\",\"options\",\"index\",\"objectKey\",\"CARD\",\"RSRC\",\"path\",\"basePath\",\"modificationDate\",\"isFolder\",\"PACT\",\"OPTS\",\"PREF-LIST\",\"items\",\"informations\",\"type\",\"name\",\"title\",\"local\",\"list\",\"time\",\"entity\",\"values\",\"maximum\",\"minimum\",\"MENU-TEMPL\",\"menuID\",\"parentMenuID\",\"contextOptions\",\"key\",\"class\",\"targetClassNumber\",\"iconName\",\"contextClassName\",\"category\",\"printModelFolders\",\"initialMessage\",\"french\",\"english\",\"interface\",\"card\",\"GLOBAL-INFOS\",\"server\",\"system\",\"application\",\"shortName\",\"complement\",\"identifier\",\"user\",\"firstName\",\"login\",\"connection\",\"defaultGroup\",\"mode\",\"CTXCLASS\",\"INAM\",\"MID\",\"STAT\",8,8,0,8,1,1,8,1,2,50,5,3,3,392,4,5,\"Planitech v3.9.2_beta2 - XNet v4.1.16 (Licence Ville)\",5,22,0,0,6,3,-1,7,3,-1,8,5,\"home\",9,20,3,8,4,10,5,\"Z:\\PlanitecMS\\Library\\XNet\\PlanitecServer.xna\\Resources\\Microstep\\MASH\\interfaces\\fr\\main@home.json\",11,5,\"_main_\/interfaces\/fr\/main@home\",12,6,1358238331,13,3,0,8,4,10,5,\"Z:\\PlanitecMS\\Library\\XNet\\PlanitecServer.xna\\Resources\\Microstep\\MASH\\images\\stadium.png\",11,5,\"_main_\/images\/stadium\",12,6,1353321299,13,3,0,8,4,10,5,\"Z:\\PlanitecMS\\Library\\XNet\\PlanitecServer.xna\\Resources\\Microstep\\MASH\\images\\camescope.png\",11,5,\"_main_\/images\/camescope\",12,6,1353321299,13,3,0,14,5,\"getApplicationParameters\",15,8,4,16,20,6,8,2,17,20,8,8,5,18,8,1,19,3,8,20,5,\"fieldEditionColor\",21,5,\"Couleur d'\u00E9dition des champs\",22,5,\"fieldEditionColor\",4,7,16776960,8,5,18,8,1,19,3,8,20,5,\"mainMenuContrastColor\",21,5,\"Couleur de contraste du menu\",22,5,\"menuContrastColor\",4,7,16776960,8,5,18,8,1,19,3,8,20,5,\"interdictionColor\",21,5,\"Couleur des entr\u00E9es interdites dans les listes\",22,5,\"interdictionColor\",4,7,16711680,8,5,18,8,1,19,3,8,20,5,\"boldColor\",21,5,\"Couleur de mise en exergue dans les listes\",22,5,\"boldColor\",4,7,255,8,5,18,8,1,19,3,8,20,5,\"mainMenuTextSelectionColor\",21,5,\"Texte du module s\u00E9lectionn\u00E9 dans le menu\",22,5,\"menuTextSelectionColor\",4,7,255,8,4,20,5,\"centerAllWindows\",21,5,\"Garder les fenetres hors planning centrees\",22,5,\"centerAllWindows\",18,8,1,19,3,5,8,5,18,8,1,19,3,5,20,5,\"verifyBeforeQuit\",21,5,\"Toujours demander avant de quitter\",22,5,\"verifyBeforeQuit\",4,3,0,8,4,20,5,\"outputPath\",21,5,\"Chemin par d\u00E9faut des impressions\",22,5,\"outputPath\",18,8,2,19,3,7,10,5,\"YES\",21,5,\"G\u00E9n\u00E9rales\",8,2,17,20,2,8,3,18,8,2,23,20,4,5,\"Personne\",5,\"Soci\u00E9t\u00E9\",5,\"Association\",5,\"Organisme\",19,3,1,21,5,\"Utilisateur par d\u00E9faut pour les recherche\",20,5,\"defaultUSerForSearch\",8,3,18,8,2,23,20,4,5,\"Aucun\",5,\"Un\",5,\"Deux\",5,\"Trois\",19,3,1,21,5,\"Nb mini de caract\u00E8res pour chercher des lieux\",20,5,\"restrictPlaceNameForSearch\",21,5,\"Edition des fiches\",8,2,17,20,31,8,4,20,5,\"defaultReservationStart\",21,5,\"Heure de d\u00E9but par d\u00E9faut des r\u00E9servations\",4,3,28800,18,8,2,24,3,1,19,3,1,8,4,20,5,\"defaultReservationEnd\",21,5,\"Heure de fin par d\u00E9faut des r\u00E9servations\",4,3,36000,18,8,2,24,3,1,19,3,1,8,4,20,5,\"defaultReservationQuality\",21,5,\"Etat par d\u00E9faut de la r\u00E9servation\",4,3,0,18,8,2,23,20,3,5,\"Normal\",5,\"Pr\u00E9-r\u00E9sa\",5,\"Confirm\u00E9\",19,3,1,8,3,18,8,2,23,20,4,5,\"D\u00E9sactiv\u00E9\",5,\"Partiel\",5,\"Maximal\",5,\"Minimum\",19,3,1,21,5,\"D\u00E9pliage automatique du planning\",20,5,\"expandsOnRefreshPlanning\",8,3,18,8,1,19,3,5,21,5,\"Afficher le nom des ressources avec ou sans r\u00E9servation\",20,5,\"showsAllConfigItems\",8,3,18,8,1,19,3,5,21,5,\"Expansion auto. des listes de s\u00E9lections multiples\",20,5,\"expandAllSelections\",8,3,18,8,1,19,3,5,21,5,\"Afficher la structure des r\u00E9servants\",20,5,\"completeUserParh\",8,3,18,8,1,19,3,5,21,5,\"Ne pas afficher les jours sans r\u00E9servation\",20,5,\"deactivateEmptyPeriods\",8,3,18,8,1,19,3,5,21,5,\"Ne pas afficher l'objet des r\u00E9servations\",20,5,\"dontDrawsLabels\",8,3,18,8,1,19,3,5,21,5,\"Confirmer avant de d\u00E9truire une r\u00E9servation\",20,5,\"confirmsReservationDeletion\",8,3,18,8,1,19,3,5,21,5,\"Confirmer avant d'invalider un cr\u00E9neau\",20,5,\"confirmsGapInvalidation\",8,3,18,8,1,19,3,5,21,5,\"Confirmer avant de re-dimensionner ou d\u00E9placer une r\u00E9sa\",20,5,\"confirmsReservationMoveOrResize\",8,3,18,8,2,23,20,5,5,\"Objet de la r\u00E9servation\",5,\"R\u00E9servant\",5,\"Activit\u00E9\",5,\"Type de la r\u00E9servation\",5,\"Dates de d\u00E9but\/fin de r\u00E9servation\",19,3,1,21,5,\"Libell\u00E9 d'affichage des cr\u00E9neaux\",20,5,\"gapsTextContent\",8,3,18,8,2,23,20,9,5,\"Sans d\u00E9grad\u00E9\",5,\"Vertical\",5,\"Horizontal\",5,\"Vertical invers\u00E9\",5,\"Horizontal invers\u00E9\",5,\"Centr\u00E9 vertical\",5,\"Centr\u00E9 horizontal\",5,\"Centr\u00E9 vertical invers\u00E9\",5,\"Centr\u00E9 horizontal invers\u00E9\",19,3,1,21,5,\"Affichage de la couleur de fond des cr\u00E9neaux\",20,5,\"gapsGradientStyle\",8,3,18,8,2,23,20,5,5,\"D\u00E9grad\u00E9\",5,\"Fl\u00E8ches\",5,\"Zig-zag\",5,\"Bo\u00EEte avec Croix\",5,\"Bo\u00EEte vide\",19,3,1,21,5,\"Style d'affichage des outlines\",20,5,\"outlineStyle\",8,3,18,8,2,23,20,4,5,\"Normale\",5,\"Petite\",5,\"Grande\",5,\"Tr\u00E8s Grande\",19,3,1,21,5,\"Hauteur des lignes\",20,5,\"gapsHeightStyle\",8,3,18,8,2,23,20,5,5,\"Rectangle simple\",5,\"En creux\",5,\"Bouton\",5,\"Orni\u00E8re\",5,\"Arrondi\",19,3,1,21,5,\"Affichage du contour des cr\u00E9neaux\",20,5,\"gapsStrokeStyle\",8,4,20,5,\"backgroundColorInPlanning\",21,5,\"Couleur de fond du planning\",4,7,13421772,18,8,1,19,3,8,8,4,20,5,\"periodBackgroundColorInPlanning\",21,5,\"Couleur de fond des p\u00E9riodes\",4,7,13421772,18,8,1,19,3,8,8,4,20,5,\"periodTitlesColorInPlanning\",21,5,\"Couleur des titre des p\u00E9riodes\",4,7,0,18,8,1,19,3,8,8,4,20,5,\"gapsBackgroundColorInPlanning\",21,5,\"Couleur sous les cr\u00E9neaux\",4,7,16777215,18,8,1,19,3,8,8,4,20,5,\"gapsHeaderBackgroundColorInPlanning\",21,5,\"Couleur de fond des titres\",4,7,16777215,18,8,1,19,3,8,8,4,20,5,\"titlesColorInPlanning\",21,5,\"Couleur des titres\",4,7,240,18,8,1,19,3,8,8,4,20,5,\"outlinesColorInPlanning\",21,5,\"Couleur des outlines\",4,7,0,18,8,1,19,3,8,8,4,20,5,\"closuresColorInPlanning\",21,5,\"Couleur des fermetures\",4,7,11250603,18,8,1,19,3,8,8,4,20,5,\"conflictsColorInPlanning\",21,5,\"Couleur des conflits\",4,7,16711680,18,8,1,19,3,8,8,4,20,5,\"hoursSeparationLineColorInPlanning\",21,5,\"Couleur des lignes horaires\",4,7,10526880,18,8,1,19,3,8,8,4,20,5,\"rulerHoursColorInPlanning\",21,5,\"Couleur de fond heures\/r\u00E8gles\",4,7,16776960,18,8,1,19,3,8,8,4,20,5,\"rulerMinutesColorInPlanning\",21,5,\"Couleur de fond minutes\/r\u00E8gles\",4,7,10526880,18,8,1,19,3,8,8,4,20,5,\"rulerHoursFontColorInPlanning\",21,5,\"Couleur des chiffres des heures\",4,7,0,18,8,1,19,3,8,8,4,20,5,\"rulerMinutesFontColorInPlanning\",21,5,\"Couleur des chiffres des minutes\",4,7,0,18,8,1,19,3,8,21,5,\"Planning\",8,2,17,20,3,8,4,20,5,\"usedSubsidy\",21,5,\"Activation des Subventions\",4,3,1,18,8,1,19,3,5,8,4,20,5,\"typeSubsidy\",21,5,\"Nature par d\u00E9faut\",4,3,0,18,8,4,19,3,1,23,20,0,25,5,\"SubsidyType\",26,20,0,8,3,18,8,3,27,3,2030,28,3,2000,19,3,1,21,5,\"Ann\u00E9e par d\u00E9faut\",20,5,\"yearSubsidy\",21,5,\"Subventions\",8,2,17,20,5,8,3,18,8,1,19,3,5,21,5,\"Calcul automatique des alarmes \u00E0 l'ouverture\",20,5,\"automaticCalculationOfAlarm\",8,3,18,8,3,27,3,60,28,3,0,19,3,1,21,5,\"D\u00E9lai de pr\u00E9vision pour contr\u00F4le mat\u00E9riel (jours)\",20,5,\"anticipationDelayForMaterialCheck\",8,3,18,8,3,27,3,60,28,3,0,19,3,1,21,5,\"D\u00E9lai de pr\u00E9vision pour inventaire mat\u00E9riel (jours)\",20,5,\"anticipationDelayForMaterialInventory\",8,3,18,8,3,27,3,60,28,3,0,19,3,1,21,5,\"D\u00E9lai de confirmation de pr\u00E9-r\u00E9servation (jours)\",20,5,\"confirmationDelayForMeadowReservation\",8,3,18,8,3,27,3,60,28,3,0,19,3,1,21,5,\"D\u00E9lai de pr\u00E9vision pour \u00E9v\u00E9nement r\u00E9servation (jours)\",20,5,\"anticipationDelayForReservationEvent\",21,5,\"Alarmes\",8,2,17,20,1,8,3,18,8,2,23,20,2,5,\"Google Maps\",5,\"Bing Maps\",19,3,1,21,5,\"Type de carte par d\u00E9faut\",20,5,\"defaultMapVisualizationType\",21,5,\"Cartographie\",29,20,46,8,4,20,5,\"CAT_places_and_users\",21,5,\"Lieux et usagers\",30,3,100,31,3,0,8,4,20,5,\"CAT_planning\",21,5,\"Planning\",30,3,200,31,3,0,8,4,20,5,\"CAT_statistics\",21,5,\"Statistiques\",30,3,300,31,3,0,8,4,20,5,\"CAT_materials_products_presta\",21,5,\"Mat\u00E9riels, produits et prestations\",30,3,400,31,3,0,8,4,20,5,\"CAT_importation\",21,5,\"Importation\",30,3,500,31,3,0,8,4,20,5,\"CAT_rights\",21,5,\"Droits\",30,3,600,31,3,0,8,4,20,5,\"CAT_Legal_infos\",21,5,\"Informations l\u00E9gales\",30,3,700,31,3,0,8,4,20,5,\"CAT_params\",21,5,\"Param\u00E9trage\",30,3,3000,31,3,0,8,7,32,8,4,33,5,\"placeTypeID\",25,5,\"PlaceType\",34,5,\"PPlaceType\",35,3,2,36,5,\"place_type\",37,5,\"PGenericTypeContext\",20,5,\"placetype\",21,5,\"Types de Lieux\",30,3,30110,31,3,3000,8,7,32,8,4,33,5,\"reservationTypeID\",25,5,\"ReservationType\",34,5,\"PReservationType\",35,3,4,36,5,\"reservation_type\",37,5,\"PGenericTypeContext\",20,5,\"resatype\",21,5,\"Types de R\u00E9servations\",30,3,30120,31,3,3000,8,7,32,8,5,38,3,2,25,5,\"PeopleType\",34,5,\"PPeopleType\",35,3,3,33,5,\"peopleTypeID\",36,5,\"company_type\",37,5,\"PGenericTypeContext\",20,5,\"comptype\",21,5,\"Types de Soci\u00E9t\u00E9s\",30,3,30140,31,3,3000,8,7,32,8,5,33,5,\"peopleTypeID\",25,5,\"PeopleType\",34,5,\"PPeopleType\",35,3,3,38,3,3,36,5,\"association_type\",37,5,\"PGenericTypeContext\",20,5,\"assotype\",21,5,\"Types d'Associations\",30,3,30150,31,3,3000,8,7,32,8,5,33,5,\"peopleTypeID\",25,5,\"PeopleType\",34,5,\"PPeopleType\",35,3,3,38,3,4,36,5,\"organism_type\",37,5,\"PGenericTypeContext\",20,5,\"orgatype\",21,5,\"Types d'Organismes\",30,3,30160,31,3,3000,8,7,32,8,4,35,3,6,33,5,\"activityTypeID\",25,5,\"ActivityType\",34,5,\"PActivityType\",36,5,\"activity_type\",37,5,\"PGenericTypeContext\",20,5,\"actitype\",21,5,\"Types d'Activit\u00E9s\",30,3,30170,31,3,3000,8,7,32,8,5,35,3,1,33,5,\"resourceTypeID\",25,5,\"ResourceType\",34,5,\"PResourceType\",38,3,1,36,5,\"resource_type\",37,5,\"PGenericTypeContext\",20,5,\"mattype\",21,5,\"Types de mat\u00E9riels\",30,3,30180,31,3,3000,8,7,32,8,5,38,3,101,25,5,\"PeopleType\",34,5,\"PPeopleType\",35,3,3,33,5,\"peopleTypeID\",36,5,\"people_category\",37,5,\"PGenericTypeContext\",20,5,\"civility\",21,5,\"Civilit\u00E9s\",30,3,30220,31,3,3000,8,7,32,8,5,38,3,102,25,5,\"PeopleType\",34,5,\"PPeopleType\",35,3,3,33,5,\"peopleTypeID\",36,5,\"company_category\",37,5,\"PGenericTypeContext\",20,5,\"companyForm\",21,5,\"Formes Juridiques\",30,3,30230,31,3,3000,8,7,32,8,5,33,5,\"peopleTypeID\",25,5,\"PeopleType\",34,5,\"PPeopleType\",35,3,3,38,3,104,36,5,\"organism_category\",37,5,\"PGenericTypeContext\",20,5,\"orgaForm\",21,5,\"Cat\u00E9gories d'Organismes\",30,3,30240,31,3,3000,8,7,32,8,3,34,5,\"PPricingCategory\",25,5,\"PricingCategory\",33,5,\"pricingCategoryID\",36,5,\"price_category\",37,5,\"PGenericTypeContext\",20,5,\"pricingCategory\",21,5,\"Cat\u00E9gories de Tarifs\",30,3,30250,31,3,3000,8,7,32,8,3,34,5,\"PControlState\",25,5,\"ControlState\",33,5,\"controlStateID\",36,5,\"interrogation_3d\",37,5,\"PGenericTypeContext\",20,5,\"controlState\",21,5,\"Etats de contr\u00F4le\",30,3,30260,31,3,400,8,6,36,5,\"periods\",37,5,\"PPeriodsContext\",20,5,\"periods\",21,5,\"D\u00E9finition des P\u00E9riodes\",30,3,30270,31,3,200,8,6,36,5,\"planning\",37,5,\"PCalendarContext\",20,5,\"calendars\",21,5,\"D\u00E9finition des Calendriers\",30,3,30280,31,3,200,8,7,32,8,4,35,3,11,33,5,\"subsidyTypeID\",25,5,\"SubsidyType\",34,5,\"PSubsidyType\",36,5,\"subsidy_type\",37,5,\"PGenericTypeContext\",20,5,\"subsidytype\",21,5,\"Natures de subventions\",30,3,30290,31,3,3000,8,7,32,8,4,35,3,12,33,5,\"subsidyTypeID\",25,5,\"SubsidyType\",34,5,\"PSubsidyType\",36,9,611,37,5,\"PGenericTypeContext\",20,5,\"subsidycategory\",21,5,\"Cat\u00E9gories de subventions\",30,3,30292,31,3,3000,8,7,32,8,5,33,5,\"functionID\",25,5,\"Function\",34,5,\"PFunction\",35,3,8,38,3,5,36,5,\"worker_type\",37,5,\"PGenericTypeContext\",20,5,\"staffFunction\",21,5,\"Fonctions des Personnels\",30,3,30300,31,3,3000,8,7,32,8,5,33,5,\"functionID\",25,5,\"Function\",34,5,\"PFunction\",35,3,8,38,3,1,36,5,\"worker_type\",37,5,\"PGenericTypeContext\",20,5,\"organismFunction\",21,5,\"Fonctions des Organismes\",30,3,30310,31,3,3000,8,7,32,8,5,33,5,\"functionID\",25,5,\"Function\",34,5,\"PFunction\",35,3,8,38,3,2,36,9,648,37,5,\"PGenericTypeContext\",20,5,\"companyFunction\",21,5,\"Fonctions des Soci\u00E9t\u00E9s\",30,3,30320,31,3,3000,8,7,32,8,5,33,5,\"functionID\",25,5,\"Function\",34,5,\"PFunction\",35,3,8,38,3,4,36,9,648,37,5,\"PGenericTypeContext\",20,5,\"associationFunction\",21,5,\"Fonctions des Associations\",30,3,30330,31,3,3000,8,7,32,8,2,39,20,1,5,\"EquipementListe\",40,8,2,41,5,\"Choisissez un nouveau Lieu \u00E0 \u00E9diter ou cr\u00E9ez-en un\",42,5,\"Choose a Place or create a new one\",36,5,\"stadium\",37,5,\"PPlaceSelectionContext\",20,5,\"place\",21,5,\"Lieux\",30,3,2020,31,3,100,8,7,32,8,2,39,20,1,5,\"AssociationListe\",40,8,2,41,5,\"Choisissez une nouvelle association \u00E0 \u00E9diter ou cr\u00E9ez-en une\",42,5,\"Choose an Association or create a new one\",36,5,\"sportteam\",37,5,\"PAssociationSelectionContext\",20,5,\"asso\",21,5,\"Associations\",30,3,2040,31,3,100,8,7,32,8,2,39,20,1,5,\"SocieteListe\",40,8,2,41,5,\"Choisissez une nouvelle soci\u00E9t\u00E9 \u00E0 \u00E9diter ou cr\u00E9ez-en une\",42,5,\"Choose a Company or create a new one\",36,5,\"company\",37,5,\"PCompanySelectionContext\",20,5,\"company\",21,5,\"Soci\u00E9t\u00E9s\",30,3,2050,31,3,100,8,7,32,8,2,39,20,1,5,\"OrganismeListe\",40,8,2,41,5,\"Choisissez un nouvel organisme \u00E0 \u00E9diter ou cr\u00E9ez-en un\",42,5,\"Choose an Organism or create a new one\",36,5,\"statebuilding\",37,5,\"POrganismSelectionContext\",20,5,\"orga\",21,5,\"Organismes\",30,3,2060,31,3,100,8,7,32,8,2,39,20,1,5,\"PersonneListe\",40,8,2,41,5,\"Choisissez une nouvelle personne \u00E0 \u00E9diter ou cr\u00E9ez-en une\",42,5,\"Choose a People or create a new one\",36,5,\"group\",37,5,\"PPeopleSelectionContext\",20,5,\"people\",21,5,\"Personnes\",30,3,2065,31,3,100,8,7,32,8,2,39,20,1,5,\"Acti\",40,8,2,41,5,\"Choisissez une nouvelle Activit\u00E9 \u00E0 \u00E9diter ou cr\u00E9ez-en une\",42,5,\"Choose an Activity or create a new one\",36,5,\"activity\",37,5,\"PActivitySelectionContext\",20,5,\"acti\",21,5,\"Activit\u00E9s\",30,3,2068,31,3,3000,8,6,36,5,\"horizontalplanning\",37,5,\"PPlanningContext\",20,5,\"planning\",21,5,\"Planning\",30,3,2079,31,3,200,8,7,32,8,2,39,20,1,5,\"MaterielListe\",40,8,2,41,5,\"Choisissez un mat\u00E9riel indiff\u00E9renci\u00E9 \u00E0 \u00E9diter ou cr\u00E9ez-en un\",42,5,\"Choose a material or create a new one\",36,5,\"monitorgear\",37,5,\"PMaterialSelectionContext\",20,5,\"stock\",21,5,\"Mat\u00E9riels indiff\u00E9renci\u00E9s\",30,3,20810,31,3,400,8,7,32,8,2,39,20,1,5,\"MaterielListe\",40,8,2,41,5,\"Choisissez un mat\u00E9riel r\u00E9f\u00E9renc\u00E9 \u00E0 \u00E9diter ou cr\u00E9ez-en un\",42,5,\"Choose a material or create a new one\",36,5,\"taggedgear\",37,5,\"PMaterialUniqueSelectionContext\",20,5,\"mat\",21,5,\"Mat\u00E9riels r\u00E9f\u00E9renc\u00E9s\",30,3,20820,31,3,400,8,7,32,8,1,40,8,2,41,5,\"Choisissez une Cl\u00E9 \u00E0 \u00E9diter ou cr\u00E9ez-en une\",42,5,\"Choose a Key or create a new one\",36,5,\"keybadge\",37,5,\"PKeySelectionContext\",20,5,\"keys\",21,5,\"Gestion des cl\u00E9s\",30,3,2090,31,3,100,8,6,36,5,\"closedlocker\",37,5,\"PDefaultRightsContext\",20,5,\"defaultsRights\",21,5,\"Droits par d\u00E9faut\",30,3,9910,31,3,600,8,6,36,5,\"accessrights\",37,5,\"PObjectsRightsContext\",20,5,\"rights\",21,5,\"Gestion des droits\",30,3,9900,31,3,600,8,7,32,8,1,39,20,1,5,\"TableauDeBord\",36,5,\"stats\",37,5,\"PStatisticsContext\",20,5,\"statistics\",21,5,\"Tableau de bord\",30,3,9920,31,3,300,8,6,36,5,\"dbimport\",37,5,\"ImportContext\",20,5,\"priceload\",21,5,\"Importation\",30,3,9950,31,3,500,8,6,36,5,\"event\",37,5,\"PAlarmManagementContext\",20,5,\"alarmManagement\",21,5,\"Gestion des alarmes\",30,3,9960,31,3,200,8,6,36,5,\"printedlist\",37,5,\"PDocumentsProductionContext\",20,5,\"docprod\",21,5,\"Production de documents\",30,3,9970,31,3,300,8,7,32,8,2,43,5,\"main\",44,5,\"Legal\",36,5,\"informations_3d\",37,5,\"PInformationsContext\",20,5,\"_legal_\",21,5,\"Informations L\u00E9gales\",30,3,991230,31,3,700,8,7,32,8,2,43,5,\"main\",44,5,\"versions\",36,9,849,37,5,\"PInformationsContext\",20,5,\"_releaseNotes_\",21,5,\"Versions\",30,3,991231,31,3,700,45,8,4,46,8,2,47,5,\"NSWindowsNTOperatingSystem\",20,5,\"VM-Win7-32bits\",48,8,4,49,5,\"Planitech\",20,5,\"Planitech\",50,5,\"MYSQL 4 PLMS39VIERGE\",51,3,1,52,8,4,20,5,\"TEST\",53,5,\"?\",54,5,\"test\",51,3,1,55,8,3,56,3,1,51,3,1,57,5,\"manager\",58,5,\"XNetInitialContext\",59,5,\"main\",60,3,1,61,3,2]";
                if (txtDecode.Text == "") {
                    txtDecode.Text = res;
                } else {
                    res = txtDecode.Text;
                }

                object theObj = MSTE.decode(res, new Dictionary<string, object>() {
                   {MSTEDecoder.OPT_VALID_CRC, false},
                   {MSTEDecoder.OPT_UNKNOWN_USER_CLASS, true},
				   //{MSTEDecoder.OPT_USER_CLASS, new Dictionary<string, string>() { 
				   //     {"Person", "MSTEClasses.Person"},
				   //     {"XVar", "MSTEClasses.XVar"},

				   //}}
                });

                txtDecoded.Text = "";
                txtErrors.Text += "---------------------------------------------------------------------------------------------------------" + Environment.NewLine + MSTE.log;

				try {
					List<object> lstRes = (List<object>)theObj;
					lstRes.ForEach(delegate(object o) {
						try {
							txtDecoded.Text += Environment.NewLine + ((Person)o).ToString();
						}
						catch (Exception ex1) {
							txtDecoded.Text += Environment.NewLine + o.ToString();
						}
					});
					txtDecoded.Text += "Nb Object in list = " + lstRes.Count;
				}
				catch (Exception ex) {
					if (theObj != null) {
						txtDecoded.Text += "Object décodé ";
					}
					else {
						txtDecoded.Text += "Object non décodé ";
					}
				}

				if (theObj != null) {
					// encodage
					res = MSTE.encode(theObj);
					txtEncoded.Text = res;
					txtErrors.Text += "---------------------------------------------------------------------------------------------------------" + Environment.NewLine + MSTE.log;
				}
                
                Dictionary<string, object> dict = new Dictionary<string, object>();
                dict["to\to"] = "titi";
                dict["tutu"] = "tata";
                
                res = MSTE.encode(dict);
				Console.WriteLine(res);
            }
            catch (Exception ex) {
                MSTE.logEvent("Erreur : " + ex.ToString());
            }
        }

        private void button1_Click(object sender, EventArgs e) {

        }
    }
}
