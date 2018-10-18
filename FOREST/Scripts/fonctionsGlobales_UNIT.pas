unit fonctionsGlobales_UNIT;
{RÔLE : Cette unité comprend toutes les fonctions qui peuvent être utilisées dans toutes les autres unités.
Elle comprend également la déclaration des différents types de variables.}

interface

  // Déclaration des différents types de variables, et définition des variables à l'intérieur

	uses
	  moduleGestionEcran_UNIT, 
	  System.SysUtils, 
	  initialisationVariables_UNIT, 
	  math;

  procedure sautLigne (nb : Integer);
  procedure displayHeader(var game: TGame; var civ: TCivilisation);
  procedure afficherInformationsCapitale(var civ: TCivilisation);
  procedure fadeToWhite(transition: Integer);
  procedure fadeToBlack(transition: Integer);
  procedure ecrireEnPositionXY(posX, posY: Integer; texte: string);
  procedure ecrireAuCentre(posY: Integer; texte: string);
  procedure demanderReponse(var game: TGame);
  procedure afficherCarte(ecranCombat: Boolean; var game: TGame; var civ: TCivilisation);
  procedure ecran_FinDuJeu(var game: TGame; var civ : TCivilisation; var combat: TCombat);

implementation

	procedure sautLigne (nb : Integer);
	{RÔLE : Cette procédure permet d'effectuer des sauts de ligne}
	var I : integer;
	{PRINCIPE : on fait nb iterations en affichant des sauts de ligne}
	begin
		for I := 1 to nb do writeln('');
	end;
	
	procedure displayHeader(var game: TGame; var civ: TCivilisation);
	{RÔLE : Cette procédure affiche le cadre, ainsi que la civilsation et le numéro du tour actuels en en-tête.}
	{PRINCIPE : Le role est permis grace aux procedures d'affichage}
  var
    texteCivilisation,
    texteTour,
    texteMonnaie,
    texteBonheur: String;
	begin
		// Affichage du cadre
    dessinerCadreXY(0,0,119,4,simple, White, Black);
    dessinerCadreXY(0,4,119,30,simple, White, Black);

    // Affichage des données du header
    texteCivilisation := 'Civilisation: '+civ.Nom;
    texteTour         := 'Tour: '+IntToStr(game.NbTour);
    texteMonnaie      := 'Monnaie: '+IntToStr(civ.gold)+' radis';
    texteBonheur      := 'Bonheur: '+IntToStr(civ.bonheur)+' / 10';

    ecrireEnPositionXY(5,2,texteCivilisation);
    ecrireEnPositionXY(40,2,texteMonnaie);
    ecrireEnPositionXY(75,2,texteBonheur);
    ecrireEnPositionXY(105,2,texteTour);
	end;

  procedure afficherInformationsCapitale(var civ: TCivilisation);
  {RÔLE ET PRINCIPE : Cette procédure affiche toutes les informations a montrer sur l'écran principal et l'écran de capitale
  * grace aux differentes procedures d'affichage de texte et de variables.}
  var
    texteNom, texteNourriture, textePopulation, texteCroissance, texteTravail, texteTravailParTour, texteConstruction: String;
  begin

    texteNom := 'Nom : '+civ.Ville;
    texteNourriture := 'Nourriture : '+IntToStr(civ.Food)+' / '+IntToStr(civ.Food_Max);
    textePopulation := 'Population : '+IntToStr(civ.Population);
    texteCroissance := civ.Croissance_Texte;
    texteTravail := civ.Travail_Texte;
    texteTravailParTour := 'Travail par tour : '+IntToStr(civ.Travail_Par_Tour);
    texteConstruction := civ.Construction_Texte;

    ecrireEnPositionXY(4,9,texteNom);
    ecrireEnPositionXY(40,9,texteNourriture);
    ecrireEnPositionXY(80,9,texteTravailParTour);
    ecrireEnPositionXY(4,10,textePopulation);
    ecrireEnPositionXY(40,10,texteCroissance);
    ecrireEnPositionXY(80,10,texteConstruction);
    ecrireEnPositionXY(40,11,texteTravail);

  end;

  procedure fadeToWhite(transition: Integer);
  {RÔLE ET PRINCIPE : procedure esthétique de transition du blanc vers le noir de l'ecran de jeu à travers le coloriage de l'ecran en differentes
  * teintes du gris}
  begin
    effacerEtColorierEcran(Black);
    sleep(transition);
    effacerEtColorierEcran(DarkGray);
    sleep(transition);
    effacerEtColorierEcran(LightGray);
    sleep(transition);
    effacerEtColorierEcran(White);
    sleep(transition);
    couleurTexte(Black);
  end;

  procedure fadeToBlack(transition: Integer);
  {RÔLE ET PRINCIPE : procedure esthétique de transition du noir vers le blanc de l'ecran de jeu à travers le coloriage de l'ecran en differentes
  * teintes du gris}
  begin
    effacerEtColorierEcran(White);
    sleep(transition);
    effacerEtColorierEcran(LightGray);
    sleep(transition);
    effacerEtColorierEcran(DarkGray);
    sleep(transition);
    effacerEtColorierEcran(Black);
    sleep(transition);
    couleurTexte(White);
  end;

  procedure ecrireEnPositionXY(posX, posY: Integer; texte: string);
  {RÔLE : Cette procedure permet d'ecrire en position XY de l'ecran d'affichage avec un texte a afficher a cette position}
  {PRINCIPE : On recupere les coordonnées puis on appelle la procedure ecrireEnPosition()}
  var
    position: coordonnees;
  begin
    position.x := posX;
    position.y := posY;
    ecrireEnPosition(position, texte);
  end;

  procedure ecrireAuCentre(posY: Integer; texte: string);
  {RÔLE : Cette procedure permet d'ecrire en au centre de la ligne Y de l'ecran d'affichage avec un texte a afficher a cette position}
  {PRINCIPE : On recupere les coordonnées puis on appelle la procedure ecrireEnPosition()}
  var
    position: coordonnees;
  const
    screenSize: Integer = 120;
  begin
    position.x := floor((screenSize-length(texte))/2);
    position.y := posY;
    ecrireEnPosition(position, texte);
  end;

  procedure demanderReponse(var game: TGame);
  {RÔLE ET PRINCIPE : procedure servant a demander la reponse au joueur en creant le cadre ou la reponse s'affiche et en la lisant}
  begin
    // Affichage du cadre de réponse
    dessinerCadreXY(95,26,105,28, simple, White, Black);
    deplacerCurseurXY(100,27);
    readln(game.Input);
  end;

  procedure afficherCarte(ecranCombat: Boolean; var game: TGame; var civ: TCivilisation);
  {RÔLE : procedure permettant d'afficher la carte du jeu!}
  {PRINCIPE : on affiche une carte de début puis lorsque les campements sont détruits un par un on met a jour les lignes concernés qui
  * formaient les campements en question qui n'existent donc plus. On met également à jour les campements détruits dans la liste récapitulative
  * de droite.}
  const
    pos_x: Integer = 10;
    pos_y: Integer = 5;
  begin
    effacerEcran;
    displayHeader(game, civ);

    if not(civ.Dragon) then
      begin
        ecrireEnPositionXY(pos_x,pos_y+0 ,'+----------------------------------------------------------------------+');
        ecrireEnPositionXY(pos_x,pos_y+1 ,'|                                                                      |');
        ecrireEnPositionXY(pos_x,pos_y+2 ,'|         +                                           -              - |');
        ecrireEnPositionXY(pos_x,pos_y+3 ,'|   *    / \    *                                             -        |');
        ecrireEnPositionXY(pos_x,pos_y+4 ,'|  OnO  :xxx:  OnO                           PETIT                     |');
        ecrireEnPositionXY(pos_x,pos_y+5 ,'|  I I   I I   I I           PETIT           CAMP 2      PETIT    -    |');
        ecrireEnPositionXY(pos_x,pos_y+6 ,'|  I I   I I   I I           CAMP 1            *         CAMP 3        |');
        ecrireEnPositionXY(pos_x,pos_y+7 ,'|  O_O_O_O_O_O_O_O             *              /_\          *           |');
        ecrireEnPositionXY(pos_x,pos_y+8 ,'|   +-----------+             /_\                         /_\    -    z|');
        ecrireEnPositionXY(pos_x,pos_y+9 ,'|    GRAND  CAMP                        zzzzzzzzzz                zzzzz|');
        ecrireEnPositionXY(pos_x,pos_y+10,'|      HUMAIN                zzzzzzzzzzzz.........zzzzzzzzzzzzzzzzz....|');
        ecrireEnPositionXY(pos_x,pos_y+11,'|                          zz..........................................|');
        ecrireEnPositionXY(pos_x,pos_y+12,'|                      zzz............................... * * .........|');
        ecrireEnPositionXY(pos_x,pos_y+13,'|                     zz................x.......x......../VVV\ ..LE ...|');
        ecrireEnPositionXY(pos_x,pos_y+14,'|                    zz ...............X  VOTRE  X...... I_o_I MARCHE  |');
        ecrireEnPositionXY(pos_x,pos_y+15,'|       _+_         zz.................X   CAMP  X...... I_O_I ........|');
        ecrireEnPositionXY(pos_x,pos_y+16,'|    /~~   ~~\     zz...................x.......x......................|');
        ecrireEnPositionXY(pos_x,pos_y+17,'| /~~         ~~\zz....................................................|');
        ecrireEnPositionXY(pos_x,pos_y+18,'|{               }........................................XXXXXXXXX....|');
        ecrireEnPositionXY(pos_x,pos_y+19,'| \  _-     -_  /......................................XX         XXX..|');
        ecrireEnPositionXY(pos_x,pos_y+20,'|   ~  \\ //  ~z.....................................XX   LA CITE   X..|');
        ecrireEnPositionXY(pos_x,pos_y+21,'|_- -   | | _-zz... LA FORET SACREE .................X DES SYLVAINS  X.|');
        ecrireEnPositionXY(pos_x,pos_y+22,'|  _ -  | |    z.....................................X              XX.|');
        ecrireEnPositionXY(pos_x,pos_y+23,'+----+-//-\\-----------------------------------------------------------+');

        if ecranCombat then
          begin
            ecrireEnPositionXY(90, 10,'Attaquer :        ');
            if civ.Histoire_PetitCamp1
              then ecrireEnPositionXY(90, 12,'1 - Petit camp humain 1')
              else
                begin
                  ecrireEnPositionXY(pos_x+29,pos_y+5,'      ');
                  ecrireEnPositionXY(pos_x+29,pos_y+6,'      ');
                  ecrireEnPositionXY(pos_x+29,pos_y+7,'      ');
                  ecrireEnPositionXY(pos_x+29,pos_y+8,'      ');
                end;

            if civ.Histoire_PetitCamp2
              then ecrireEnPositionXY(90, 13,'2 - Petit camp humain 2')
              else
                begin
                  ecrireEnPositionXY(pos_x+45,pos_y+4,'      ');
                  ecrireEnPositionXY(pos_x+45,pos_y+5,'      ');
                  ecrireEnPositionXY(pos_x+45,pos_y+6,'      ');
                  ecrireEnPositionXY(pos_x+45,pos_y+7,'      ');
                end;

            if civ.Histoire_PetitCamp3
              then ecrireEnPositionXY(90, 14,'3 - Petit camp humain 3')
              else
                begin
                  ecrireEnPositionXY(pos_x+57,pos_y+5,'      ');
                  ecrireEnPositionXY(pos_x+57,pos_y+6,'      ');
                  ecrireEnPositionXY(pos_x+57,pos_y+7,'      ');
                  ecrireEnPositionXY(pos_x+57,pos_y+8,'      ');
                end;

            if not(civ.Histoire_PetitCamp1 or civ.Histoire_PetitCamp2 or civ.Histoire_PetitCamp3) then
              begin
                ecrireEnPositionXY(90, 12,'Vous devez posséder');
                ecrireEnPositionXY(90, 13,'un dragon pour');
                ecrireEnPositionXY(90, 14,'attaquer le grand');
                ecrireEnPositionXY(90, 15,'camp humain !');
              end;

          end
        else
          begin
            ecrireEnPositionXY(90, 10,'Camps détruits:');
            if not(civ.Histoire_PetitCamp1) then
              begin
                ecrireEnPositionXY(pos_x+29,pos_y+5,'      ');
                ecrireEnPositionXY(pos_x+29,pos_y+6,'      ');
                ecrireEnPositionXY(pos_x+29,pos_y+7,'      ');
                ecrireEnPositionXY(pos_x+29,pos_y+8,'      ');
                ecrireEnPositionXY(90, 12,'- Petit camp humain 1');
              end;
            if not(civ.Histoire_PetitCamp2) then
              begin
                ecrireEnPositionXY(pos_x+45,pos_y+4,'      ');
                ecrireEnPositionXY(pos_x+45,pos_y+5,'      ');
                ecrireEnPositionXY(pos_x+45,pos_y+6,'      ');
                ecrireEnPositionXY(pos_x+45,pos_y+7,'      ');
                ecrireEnPositionXY(90, 13,'- Petit camp humain 2');
              end;
            if not(civ.Histoire_PetitCamp3) then
              begin
                ecrireEnPositionXY(pos_x+57,pos_y+5,'      ');
                ecrireEnPositionXY(pos_x+57,pos_y+6,'      ');
                ecrireEnPositionXY(pos_x+57,pos_y+7,'      ');
                ecrireEnPositionXY(pos_x+57,pos_y+8,'      ');
                ecrireEnPositionXY(90, 14,'- Petit camp humain 3');
              end;

            if civ.Histoire_PetitCamp1 and civ.Histoire_PetitCamp2 and civ.Histoire_PetitCamp3 then
            begin
              ecrireEnPositionXY(90, 12,'- Aucun');
            end;
          end;

      end
    else
      begin
        ecrireEnPositionXY(pos_x,pos_y+0 ,'+----------------------------------------------------------------------+');
        ecrireEnPositionXY(pos_x,pos_y+1 ,'|                                                                      |');
        ecrireEnPositionXY(pos_x,pos_y+2 ,'|         +                                           +              + |');
        ecrireEnPositionXY(pos_x,pos_y+3 ,'|   *    / \    *                                             +        |');
        ecrireEnPositionXY(pos_x,pos_y+4 ,'|  OnO  :xxx:  OnO            x     (______ ^\-/^ ______)              |');
        ecrireEnPositionXY(pos_x,pos_y+5 ,'|  I I   I I   I I                  /_.-=-.\| " |/.-=-._\         +    |');
        ecrireEnPositionXY(pos_x,pos_y+6 ,'|  I I   I I   I I                   /_    \(o_o)/    _\               |');
        ecrireEnPositionXY(pos_x,pos_y+7 ,'|  O_O_O_O_O_O_O_O                    /_  /\/ ^ \/\  _\      +         |');
        ecrireEnPositionXY(pos_x,pos_y+8 ,'|   +-----------+                       \/ | / \ | \/            +    z|');
        ecrireEnPositionXY(pos_x,pos_y+9 ,'|    GRAND  CAMP                          /((( )))\       +       zzzzz|');
        ecrireEnPositionXY(pos_x,pos_y+10,'|      HUMAIN                zzzz       __\ \___/ /__   zzzzzzzzzzz....|');
        ecrireEnPositionXY(pos_x,pos_y+11,'|                          zz....zzzzz ((----- -----))) ...............|');
        ecrireEnPositionXY(pos_x,pos_y+12,'|                      zzz............................... * * .........|');
        ecrireEnPositionXY(pos_x,pos_y+13,'|                     zz................x.......x......../VVV\ ..LE ...|');
        ecrireEnPositionXY(pos_x,pos_y+14,'|                    zz ...............X  VOTRE  X...... I_o_I MARCHE  |');
        ecrireEnPositionXY(pos_x,pos_y+15,'|       _+_         zz.................X   CAMP  X...... I_O_I ........|');
        ecrireEnPositionXY(pos_x,pos_y+16,'|    /~~   ~~\     zz...................x.......x......................|');
        ecrireEnPositionXY(pos_x,pos_y+17,'| /~~         ~~\zz....................................................|');
        ecrireEnPositionXY(pos_x,pos_y+18,'|{               }........................................XXXXXXXXX....|');
        ecrireEnPositionXY(pos_x,pos_y+19,'| \  _-     -_  /......................................XX         XXX..|');
        ecrireEnPositionXY(pos_x,pos_y+20,'|   ~  \\ //  ~z.....................................XX   LA CITE   X..|');
        ecrireEnPositionXY(pos_x,pos_y+21,'|_- -   | | _-zz... LA FORET SACREE .................X DES SYLVAINS  X.|');
        ecrireEnPositionXY(pos_x,pos_y+22,'|  _ -  | |    z.....................................X              XX.|');
        ecrireEnPositionXY(pos_x,pos_y+23,'+----+-//-\\-----------------------------------------------------------+');

        ecrireEnPositionXY(90, 17,'Vous possédez le Dragon !');
        if ecranCombat then
        begin
          ecrireEnPositionXY(90, 12,'1 - Attaquer le');
          ecrireEnPositionXY(90, 13,'    Grand Camp Humain !');
        end;

      end;

    if ecranCombat then
      begin
        ecrireEnPositionXY(90, 24,'0 - Ne pas combattre');
        game.Input := -1;
        while not((game.Input >= 0) and (game.Input <= 3)) do
          begin
            demanderReponse(game);
          end;
      end
    else
      begin
        ecrireEnPositionXY(90, 24,'0 - Continuer');
        game.Input := -1;
        while not(game.Input = 0) do
          begin
            demanderReponse(game);
          end;
      end;


  end;

  procedure ecran_FinDuJeu(var game: TGame; var civ : TCivilisation; var combat: TCombat);
  {RÔLE ET PRINCIPE : grace a l'affichage, on informe le joueur que l'on a gagné le combat final et donc terminé le jeu.
  * la procedure sert a l'affichage d'un court dialogue d'ambiance}
  begin
    //ecran fin de jeu
    effacerEcran();

    ecrireAuCentre(7, ' VOUS AVEZ ABATTU LES CAMPEMENTS DES HUMAINS ! ');
    ecrireAuCentre(9, '*  *  *');

    ecrireEnPositionXY(20, 12, 'LES SYLVAINS : ');
    ecrireEnPositionXY(35, 12, 'Oh '+civ.NomHeros+' ! Nous avons remporté ce combat!');
    ecrireEnPositionXY(35, 13, 'Les rumeurs sur vous sont donc vraies : ');
    ecrireEnPositionXY(35, 14, 'Vous etes le plus grand stratège du siècle!');

    ecrireEnPositionXY(20, 22, '>   Faisons un banquet!');

    //appuyez sur entrée pour continuer
    dessinerCadreXY(35,26,85,28, simple, White, Black);
    ecrireAuCentre(27,'Appuyez sur Entrée pour continuer.');
    readln;

    effacerEcran;
    ecrireAuCentre(7, 'CREDITS');
    ecrireAuCentre(9, '*  *  *');

    ecrireEnPositionXY(10,13, 'Kévin KIBONGUI, chef de projet : Codage, conception, coordination de l''équipe');
    ecrireEnPositionXY(10,15, 'Polina MARAZYUK : Codage, conception, compte-rendu');
    ecrireEnPositionXY(10,17, 'Zakaria SLIFI : Codage');
    ecrireEnPositionXY(10,19, 'Alexandre RIFFAULT : Codage');

    dessinerCadreXY(35,26,85,28, simple, White, Black);
    ecrireAuCentre(27,'Appuyez sur Entrée pour continuer.');
    readln;

    game.Screen := 'ecranPrincipal';
  end;

  //ReadKey
  {$REGION}
  {
  function ArrowReadKey():String;
  var
    input: Char;
  begin
    input := ReadKey();
    if keypressed then
      begin
        input := ReadKey();

        if input = 'K' then result := 'Left'
        else if input = 'M' then result := 'Right'
        else if input = 'H' then result := 'Up'
        else if input = 'P' then result := 'Down'
        else result := 'None';
      end
    else result := input;
    ArrowReadKey := result;
    readln;
  end;
  }
  {$ENDREGION}

end.
