﻿unit gestionCapitale_UNIT;
{Unite gerant la capitale avec ses ressources et ses différentes caractéristiques}

interface

	uses 
		fonctionsGlobales_UNIT, 
		moduleGestionEcran_UNIT, 
		System.SysUtils, 
		initialisationVariables_UNIT;

	procedure gestionCapitale(var game: TGame; var civ: TCivilisation; var combat: TCombat);
	{RÔLE : Cette procédure a pour rôle d'afficher les différents textes en rapport avec la gestion de la capitale
  * (caractéristiques, bâtiments...) }

implementation

const
  TRAVAIL_MAX_FERME         : Array[0..9] of Integer = (20,60,200,400,600,800,1000,1200,1400,1600);
  TRAVAIL_MAX_MINE          : Array[0..9] of Integer = (100,300,600,1000,1500,2000,2500,3000,3500,4000);
  TRAVAIL_MAX_CARRIERE      : Array[0..9] of Integer = (50,150,300,450,600,750,900,1050,1200,1350);
  TRAVAIL_MAX_CASERNE       : Array[0..9] of Integer = (50,150,300,450,600,750,900,1050,1200,1350);
  TRAVAIL_MAX_BIBLIOTHEQUE  : Array[0..9] of Integer = (150,300,450,600,750,900,1050,1200,1350,1500);
  TRAVAIL_MAX_MARCHE        : Array[0..9] of Integer = (100,200,400,800,1200,1600,2000,2400,2800,3200);
  TRAVAIL_MAX_PARC          : Array[0..19] of Integer = (50,150,300,450,500,500,500,500,500,500,500,500,500,500,500,500,500,500,500,500);

var
{$REGION}
  texteVueDetaillee,
  texteBarres,
  texteNom,
  texteNourriture,
  textePopulation,
  texteCroissance,
  texteTravailParTour,
  texteConstructionLancee,
  texteNourritureParTour,
  texteBatiments,
  texteConstruireFerme,
  texteConstruireMine,
  texteConstruireCarriere,
  texteConstruireCaserne,
  texteConstruireBibliotheque,
  texteConstruireMarche,
  texteConstruireParc,
  texteRetourMenu : String;
  {$ENDREGION}

  procedure construire(construction: String; var civ: TCivilisation);
  {RÔLE : Cette procédure a pour rôle de gérer le lancement d'une construction d'un bâtiment.}
  {PRINCIPE : D'abord, on vérifie s'il n'y a aucune construction en cours, auquel cas
  * on lance la construction demandée par le joueur, en mettant a jour les variables de travail.}
  begin
    if (civ.CurrentConstruction = 'Aucun') then
      if (civ.Population > civ.NbConstructions) then
        begin
          civ.Travail := 0; // On réinitialise la variable de travail.
          civ.CurrentConstruction := construction; // On définit la construction actuelle.
          texteConstructionLancee := 'Construction lancée !';

          if construction = 'Ferme' then
            begin
              civ.texteConstruction := 'Construction : Ferme niveau '+IntToStr(civ.lvlFerme + 1);
              civ.Travail_Max := TRAVAIL_MAX_FERME[civ.lvlFerme];
            end
          else if construction = 'Mine' then
            begin
              civ.texteConstruction := 'Construction : Mine niveau '+IntToStr(civ.lvlMine + 1);
              civ.Travail_Max := TRAVAIL_MAX_MINE[civ.lvlMine];
            end
          else if construction = 'Carriere' then
            begin
              civ.texteConstruction := 'Construction : Carrière niveau '+IntToStr(civ.lvlCarriere + 1);
              civ.Travail_Max := TRAVAIL_MAX_CARRIERE[civ.lvlCarriere];
            end
          else if construction = 'Caserne' then
            begin
              civ.texteConstruction := 'Construction : Caserne niveau '+IntToStr(civ.lvlCaserne + 1);
              civ.Travail_Max := TRAVAIL_MAX_CASERNE[civ.lvlCaserne];

            end
          else if construction = 'Bibliotheque' then
            begin
              civ.texteConstruction := 'Construction : Bibliothèque niveau '+IntToStr(civ.lvlBibliotheque + 1);
              civ.Travail_Max := TRAVAIL_MAX_BIBLIOTHEQUE[civ.lvlBibliotheque];

            end
          else if construction = 'Marché' then
            begin
              civ.texteConstruction := 'Construction : Marché niveau '+IntToStr(civ.lvlMarche + 1);
              civ.Travail_Max := TRAVAIL_MAX_MARCHE[civ.lvlMarche];

            end
          else if construction = 'Parc' then
            begin
              civ.texteConstruction := 'Construction : Zone protégée niveau '+IntToStr(civ.lvlParc + 1);
              civ.Travail_Max := TRAVAIL_MAX_PARC[civ.lvlParc];

            end;

          // Affichage du texte pour le travail.
          // Le fonctionnement est le même que pour civ.Construction_Texte ici.
          civ.texteTravail := 'Travail accumulé : '+IntToStr(civ.Travail)+'/'+IntToStr(civ.Travail_Max);

        end
      else texteConstructionLancee := 'Population insuffisante pour construire !'
    else texteConstructionLancee := 'Vous avez déja une construction en cours !';

  end;

  procedure gestionCapitale_initVariables(civ: TCivilisation);
  {RÔLE : Cette procédure gère l'initialisation des variables d'affichage des proprietés de la capitale}
  {PRINCIPE : On met à jour les différentes variables une par une.}
  begin
    texteNom                := 'Nom : '+civ.Ville;
    texteNourriture         := 'Nourriture : '+IntToStr(civ.Food)+' / '+IntToStr(civ.Food_Max);
    texteTravailParTour     := 'Travail par tour : '+IntToStr(civ.Travail_Par_Tour);
    textePopulation         := 'Population : '+IntToStr(civ.Population);
    texteNourritureParTour  := 'Nourriture par tour : '+IntToStr(civ.Food_Par_Tour);

    if (civ.Food_Par_Tour > 0) then texteCroissance := 'Nb tours avant croissance : '+IntToStr(civ.Nb_Tours_Levelup)
    else texteCroissance := 'Aucune croissance possible.';

  end;

  procedure gestionCapitale(var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {RÔLE : Cette procédure a pour rôle d'afficher les différents textes en rapport avec la gestion de la capitale (caractéristiques, bâtiments...}
  {PRINCIPE : On appelle les différentes procédures d'affichage puis on lit l'input du joueur pour le redirigrer vers un ecran suivant grace au case}
  begin

    // Affichage du cadre et des données du header
    displayHeader(game, civ);

    // Affichage des spécifités de l'écran
    texteVueDetaillee := 'Vue détaillée du campement';
    texteBarres       := '--------------------------';
    ecrireAuCentre(6,texteVueDetaillee);
    ecrireAuCentre(7,texteBarres);

    // Affichage des propriétés de la civilisation

    // Texte
    gestionCapitale_initVariables(civ);

    if civ.CurrentConstruction = 'Aucun' then
    begin
      civ.texteConstruction := 'Pas de construction en cours';
      civ.texteTravail := '';
    end;


    // Affichage
    ecrireEnPositionXY(4,9,texteNom);
    ecrireEnPositionXY(40,9,texteNourriture);
    ecrireEnPositionXY(80,9,texteTravailParTour);
    ecrireEnPositionXY(4,10,textePopulation);
    ecrireEnPositionXY(40,10,texteNourritureParTour);
    ecrireEnPositionXY(80,10,civ.texteConstruction);
    ecrireEnPositionXY(40,11,texteCroissance);
    ecrireEnPositionXY(80,11,civ.texteTravail);
    ecrireAuCentre(27,texteConstructionLancee);

    // Affichage des bâtiments
    texteBatiments := 'Batiments construits : ';
    ecrireEnPositionXY(80,15,texteBatiments);
    if civ.lvlFerme         <> 0 then ecrireEnPositionXY(82,16, '- Ferme (niveau '+IntToStr(civ.lvlFerme)+')'         );
    if civ.lvlMine          <> 0 then ecrireEnPositionXY(82,17, '- Mine (niveau '+IntToStr(civ.lvlMine)+')'          );
    if civ.lvlCarriere      <> 0 then ecrireEnPositionXY(82,18, '- Carriere (niveau '+IntToStr(civ.lvlCarriere)+')'      );
    if civ.lvlCaserne       <> 0 then ecrireEnPositionXY(82,19, '- Caserne (niveau '+IntToStr(civ.lvlCaserne)+')'       );
    if civ.lvlBibliotheque  <> 0 then ecrireEnPositionXY(82,20, '- Bibliotheque (niveau '+IntToStr(civ.lvlBibliotheque)+')'       );
    if civ.lvlMarche        <> 0 then ecrireEnPositionXY(82,21, '- Marché (niveau '+IntToStr(civ.lvlMarche)+')'       );
    if civ.lvlParc          <> 0 then ecrireEnPositionXY(82,22, '- Zone protégée (niveau '+IntToStr(civ.lvlParc)+')'       );

    // Affichage des options du joueur
    texteConstruireFerme        := '1 - Construire la ferme';
    texteConstruireMine         := '2 - Construire la mine';
    texteConstruireCarriere     := '3 - Construire la carrière';
    texteConstruireCaserne      := '4 - Construire la caserne';
    texteConstruireBibliotheque := '5 - Construire la bibliotheque';
    texteConstruireMarche       := '6 - Construire le marché';
    texteConstruireParc         := '7 - Construire une zone protégée';

    texteRetourMenu := '0 - Retour au menu';

    ecrireEnPositionXY(4,16,texteConstruireFerme);
    ecrireEnPositionXY(4,17,texteConstruireMine);
    ecrireEnPositionXY(4,18,texteConstruireCarriere);
    ecrireEnPositionXY(4,19,texteConstruireCaserne);
    ecrireEnPositionXY(4,20,texteConstruireBibliotheque);
    ecrireEnPositionXY(4,21,texteConstruireMarche);
    ecrireEnPositionXY(4,22,texteConstruireParc);
    ecrireEnPositionXY(4,27,texteRetourMenu);

    // Affichage du cadre de réponse
    dessinerCadreXY(95,26,105,28, simple, White, Black);
    deplacerCurseurXY(100,27);
    readln(game.Input);

    // Structure conditionnelle
    case game.Input of
      1: construire('Ferme',civ);
      2: construire('Mine',civ);
      3: construire('Carriere',civ);
      4: construire('Caserne',civ);
      5: construire('Bibliotheque',civ);
      6: construire('Marché',civ);
      7: construire('Parc', civ);
      0: begin
           texteConstructionLancee := '';
           game.Screen := 'ecranPrincipal';
         end;

    end;

    effacerEcran();
  end;


end.
