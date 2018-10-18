unit gestionDeCombat_UNIT;

interface

	uses 
		fonctionsGlobales_UNIT, 
		moduleGestionEcran_UNIT, 
		System.SysUtils, 
		initialisationVariables_UNIT;

	// D�claration des variables de texte d�di�es � l'unit�
	var
	  texteTitre,
	  texteBarres,
	  texteListeSoldats,
	  texteSoldatsJoueur,
	  texteCanonsJoueur,
	  textePointsRecrutement
	  : String;

	const
	  PTSRECRU_RECRUTEMENT_SOLDAT : Integer = 1;
	  PTSRECRU_RECRUTEMENT_CANON  : Integer = 4;

	procedure gestionDeCombat(var game: TGame; var civ: TCivilisation; var combat: TCombat);
	{R�LE : Cette proc�dure a pour r�le d'afficher les diff�rentes possibilit�s qu'a le joueur (attaquer un grand camp ou un petit etc) grace aux 
    * differentes fonctions d'affichage}

implementation

  procedure afficherRecrutementTexte(var combat: TCombat);
  {R�LE ET PRINCIPE : cette procedure regule l'affichage selon la couleur passe en param�tre en appelant une autre procedure qui ecrit le texte a 
  * afficher stoch�s dans combat.Recrutement_texte au centre de l'�cran}
  begin
    if      combat.Recrutement_Texte_couleur = 'Green'  then couleurTexte(LightGreen)
    else if combat.Recrutement_Texte_couleur = 'Red'    then couleurTexte(LightRed)
    else couleurTexte(White);

    ecrireAuCentre(27,combat.Recrutement_Texte);

    couleurTexte(White);
  end;

  procedure setRecrutementTexte(couleur, texte: String; var combat: TCombat);
  {R�LE ET PRINCIPE : on recupere la couleur et le texte voulu par le joueur et on les affecte au record combat contenant 
  * les variables necessaires par simple affectation.}
  begin
    combat.Recrutement_Texte_couleur := couleur;
    combat.Recrutement_Texte := texte;
  end;

  procedure recruterSoldat(var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette procedure a pour role la gestion de recrutement de soldats avec la mise a jour des variables}
  {PRINCIPE : On ne peut recruter de soldats que si on a une caserne et assez de points de recrutements. On teste donc ces booleens et on incremente
  * en fonction}
  begin


    if (civ.PointsRecrutement >= PTSRECRU_RECRUTEMENT_SOLDAT) and (civ.lvlCaserne > 0) then
      begin
        combat.SoldatsDispo := combat.SoldatsDispo + 1;
        civ.PointsRecrutement := civ.PointsRecrutement - PTSRECRU_RECRUTEMENT_SOLDAT;
        setRecrutementTexte('Green','Soldat recrut� !', combat)
      end
    else if ((civ.PointsRecrutement <= 0) and (civ.lvlCaserne > 0)) then
      setRecrutementTexte('Red','Pas assez de points de recrutement.', combat)

    else if ((civ.lvlCaserne <= 0) and (civ.PointsRecrutement > 0)) then
      setRecrutementTexte('Red','Il faut construire une caserne !', combat)

    else if ((civ.lvlCaserne <= 0) and (civ.PointsRecrutement <= 0)) then
      setRecrutementTexte('Red','Pas assez de points, aucune caserne disponible', combat);

  end;

  procedure recruterCanon(var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette procedure a pour role la gestion de recrutement de canons avec la mise a jour des variables}
  {PRINCIPE : On ne peut recruter de canons que si on a une caserne et assez de points de recrutements. On teste donc ces booleens et on incremente
  * en fonction}
  begin

    if ((civ.PointsRecrutement >= PTSRECRU_RECRUTEMENT_CANON) and (civ.lvlCaserne > 0) and (civ.lvlMine > 0)) then
      begin
        combat.CanonsDispo := combat.CanonsDispo + 1;
        civ.PointsRecrutement := civ.PointsRecrutement - PTSRECRU_RECRUTEMENT_CANON;
        setRecrutementTexte('Green','Canon recrut� !', combat)
      end

    else if ((civ.PointsRecrutement <= PTSRECRU_RECRUTEMENT_CANON) and (civ.lvlCaserne > 0) and (civ.lvlMine > 0)) then
      setRecrutementTexte('Red','Pas assez de points de recrutement.', combat)

    else if ((civ.lvlCaserne <= 0) and (civ.PointsRecrutement > PTSRECRU_RECRUTEMENT_CANON) and (civ.lvlMine > 0)) then
      setRecrutementTexte('Red','Il faut construire une caserne!', combat)

    else if ((civ.lvlCaserne > 0) and (civ.PointsRecrutement > PTSRECRU_RECRUTEMENT_CANON) and (civ.lvlMine <= 0)) then
      setRecrutementTexte('Red','Il faut construire une mine !', combat)

    else if ((civ.lvlCaserne<=0) and (civ.PointsRecrutement > PTSRECRU_RECRUTEMENT_CANON) and (civ.lvlMine <= 0))  then
      setRecrutementTexte('Red','Il faut construire une mine et une caserne!', combat)

    else if ((civ.lvlCaserne <= 0) and (civ.PointsRecrutement <= PTSRECRU_RECRUTEMENT_CANON) and (civ.lvlMine <= 0)) then
      setRecrutementTexte('Red','Pas assez de points, ni caserne, ni mine disponible', combat);
  end;

  procedure attaquerCampBarbare(adversaire: String; var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette procedure a pour role la gestion d'attaque de camps barbares - elle lance les attaques}
  {PRINCIPE : On teste si le joueur a au moins un soldat. Si non, il ne peut pas attaquer. Si oui, on affecte la taille du camp en fonction du combat
  * passe en parametre}
  begin
    if combat.SoldatsDispo > 0 then
      begin
        if      adversaire = 'Petit' then combat.Adversaire := 'Petit camp barbare'
        else if adversaire = 'Grand' then combat.Adversaire := 'Grand camp barbare';

        game.Screen := 'ecranDeCombat';
      end
    else
      begin
        setRecrutementTexte('Red','Vous ne pouvez attaquer sans soldat.', combat);
      end;

  end;

  procedure attaquerPetitCampHumain(nbCamp: Integer; var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : cette proc�dure a pour role la gestion d'attaque des petits camps humains (3 au total)}
  {PRINCIPE : on dirige le joueur vers l'ecran de combat en lancant ainsi le combat}
  var
    lancerCombat: Boolean;
  begin
    lancerCombat := False;

    case nbCamp of
      1: lancerCombat := civ.Histoire_PetitCamp1;
      2: lancerCombat := civ.Histoire_PetitCamp2;
      3: lancerCombat := civ.Histoire_PetitCamp3;
    end;

    if lancerCombat then
    begin

      civ.nbCamp := nbCamp;
      combat.Adversaire := 'Camp humain';
      game.Screen := 'ecranDeCombat';

    end;
  end;

  procedure attaquerGrandCampHumain(var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : cette proc�dure a pour role la gestion d'attaque du grand camp humain (1 au total)}
  {PRINCIPE : on dirige le joueur vers l'ecran de combat en lancant ainsi le combat}
  begin
    effacerEcran;
    displayHeader(game, civ);

    sleep(100);
    ecrireAuCentre(14,'Le combat fatidique est lanc�.');
    sleep(1000);
    ecrireAuCentre(15,'Que le meilleur gagne ... !');
    sleep(1000);
    ecrireAuCentre(25,'0 - Lancer le combat d�cisif');
    sleep(1000);

    game.Input := -1;
    while game.Input <> 0 do
    begin
      demanderReponse(game);
    end;

    combat.Adversaire := 'Grand camp humain';

    game.Screen := 'ecranDeCombat';
  end;

  procedure attaquerCampHumain(var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE :  cette procedure gere les attaques des camps humains avec la mise a jour des variables concern�es}
  {PRINCIPE : si le joueur poss�de un dragon (gestion par booleen) alors on lance le combat contre le grand camp a travers 
  * la procedure attaquerGrandHumain() ; si la reponse du joueur correpond au petit camp, on lance une attaque a travers la procedure
  * attaquerPetitCampHumain() qui redirigeront le joueur vers la fenetre suivante.}
  begin
    afficherCarte(True, game, civ);

    if civ.Dragon then
      begin
        if game.Input = 1 then attaquerGrandCampHumain(game, civ, combat);
      end
    else
      begin
        case game.Input of
          1: attaquerPetitCampHumain(1, game, civ, combat);
          2: attaquerPetitCampHumain(2, game, civ, combat);
          3: attaquerPetitCampHumain(3, game, civ, combat);
        end;
      end;

  end;

  procedure gestionDeCombat(var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette proc�dure a pour r�le d'afficher les diff�rentes possibilit�s qu'a le joueur (attaquer un grand camp ou un petit etc) grace aux 
  * differentes fonctions d'affichage}
  {PRINCIPE : On appelle tout simplement les diff�rentes procedures d'affichage en lisant l'input du joueur pour le rediriger vers l'ecran 
  * correpondant ensuite }
  begin

    // Header
      displayHeader(game, civ);


    // Affichage
      texteTitre := 'Ecran de gestion militaire';
      texteBarres := '--------------------------------';
      ecrireAuCentre(6,texteTitre);
      ecrireAuCentre(7,texteBarres);

      texteListeSoldats := 'Liste de troupes disponibles : ';
      ecrireEnPositionXY(4,9,texteListeSoldats);
      ecrireEnPositionXY(4,10,texteBarres);

      texteSoldatsJoueur := '- Soldats disponibles : '+IntToStr(combat.SoldatsDispo);
      texteCanonsJoueur :='- Canons disponibles  : '+IntToStr(combat.CanonsDispo);
      ecrireEnPositionXY(5,12,texteSoldatsJoueur);
      ecrireEnPositionXY(5,13,texteCanonsJoueur);

      textePointsRecrutement := 'Nombre de points de recrutements : '+IntToStr(civ.PointsRecrutement);
      ecrireEnPositionXY(4,15,textePointsRecrutement);

    // Affichage des r�ponses du joueur
      ecrireEnPositionXY(4,17,'1 - Recruter un soldat');
      ecrireEnPositionXY(4,18,'2 - Construire un canon');

      ecrireEnPositionXY(4,21,'3 - Attaquer un petit camp barbare');
      ecrireEnPositionXY(4,22,'4 - Attaquer un grand camp barbare');
      ecrireEnPositionXY(4,23,'5 - Attaquer un camp humain');
      ecrireEnPositionXY(4,27,'0 - Retour au menu principal');
      afficherRecrutementTexte(combat);

    // Affichage du cadre de r�ponse
      dessinerCadreXY(95,26,105,28, simple, White, Black);
      deplacerCurseurXY(100,27);
      readln(game.Input);

    // Lecture des entr�es du joueur
      case game.Input of
        1: recruterSoldat(civ,combat);
        2: recruterCanon (civ,combat);
        3: attaquerCampBarbare('Petit',game, civ, combat);
        4: attaquerCampBarbare('Grand',game, civ, combat);
        5: attaquerCampHumain(game, civ, combat);
        0: game.Screen := 'ecranPrincipal';
      end;

    effacerEcran();
  end;


end.
