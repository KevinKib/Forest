unit gestionCapitale_UNIT;

interface

	uses 
		fonctionsGlobales_UNIT, 
		moduleGestionEcran_UNIT, 
		System.SysUtils, 
		initialisationVariables_UNIT;

	procedure gestionCapitale(var game: TGame; var civ: TCivilisation; var combat: TCombat);
	{RÔLE : Cette procédure a pour rôle d'afficher les différents textes en rapport avec la gestion de la capitale
  * (caractéristiques, bâtiments...}

implementation

	const
	  TRAVAIL_MAX_FERME       : Array[0..2] of Integer = (20,60,200);
	  TRAVAIL_MAX_MINE        : Array[0..2] of Integer = (100,300,600);
	  TRAVAIL_MAX_CARRIERE    : Array[0..2] of Integer = (50,150,300);
	  TRAVAIL_MAX_CASERNE     : Array[0..2] of Integer = (50,150,300);

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
      displayHeader(civ.texteCivilisation, civ.texteTour, civ.Nom, game.NbTour);

    // Affichage des spécifités de l'écran
      texteVueDetaillee := 'Vue détaillée de : '+civ.Ville;
      texteBarres := '--------------------------';
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
      ecrireEnPositionXY(4,13,texteBatiments);
      if civ.lvlFerme <> 0    then ecrireEnPositionXY(6,14, '- Ferme (niveau '   +IntToStr(civ.lvlFerme)   +')'  );
      if civ.lvlMine <> 0     then ecrireEnPositionXY(6,15, '- Mine (niveau '    +IntToStr(civ.lvlMine)    +')'  );
      if civ.lvlCarriere <> 0 then ecrireEnPositionXY(6,16, '- Carriere (niveau '+IntToStr(civ.lvlCarriere)+')'  );
      if civ.lvlCaserne <> 0  then ecrireEnPositionXY(6,17, '- Caserne (niveau ' +IntToStr(civ.lvlCaserne) +')'  );

    // Affichage des options du joueur
      texteConstruireFerme      := '1 - Construire la ferme';
      texteConstruireMine       := '2 - Construire la mine';
      texteConstruireCarriere   := '3 - Construire la carrière';
      texteConstruireCaserne    := '4 - Construire la caserne';
      texteRetourMenu           := '0 - Retour au menu';

      ecrireEnPositionXY(4,22,texteConstruireFerme);
      ecrireEnPositionXY(4,23,texteConstruireMine);
      ecrireEnPositionXY(4,24,texteConstruireCarriere);
      ecrireEnPositionXY(4,25,texteConstruireCaserne);
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
        0: begin
              texteConstructionLancee := '';
              game.Screen := 'ecranPrincipal';
           end;

      end;

    effacerEcran();
  end;


end.
