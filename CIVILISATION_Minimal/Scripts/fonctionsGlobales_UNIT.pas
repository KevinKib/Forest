﻿unit fonctionsGlobales_UNIT;
{Cette unité comprend toutes les fonctions d'affichage qui peuvent être utilisées dans toutes les autres unités.}

interface

	uses
	  moduleGestionEcran_UNIT,
	  System.SysUtils,
	  initialisationVariables_UNIT;

	procedure sautLigne (nb : Integer);
	procedure displayHeader(var texteCivilisation, texteTour: String; nomCivilisation: String; nbTour: Integer);
	procedure ecrireEnPositionXY(posX, posY: Integer; texte: string);
	procedure ecrireAuCentre(posY: Integer; texte: string);

implementation

	procedure sautLigne (nb : Integer);
	{RÔLE : Cette procédure permet d'effectuer des sauts de ligne.
    UPDATE : Obsolète, grâce au module de gestion des écrans.}
	var
		i : Integer;
    {PRINCIPE : on fait nb iterations en affichant des sauts de ligne}
	begin
		for i := 1 to nb do writeln('');
	end;
	
	procedure displayHeader(var texteCivilisation, texteTour: String; nomCivilisation: String; nbTour: Integer);
	{RÔLE : Cette procédure affiche le cadre, ainsi que la civilsation et le numéro du tour actuels en en-tête.}
	{PRINCIPE : Le role est permis grace aux procedures d'affichage}
	begin
		// Affichage du cadre
    dessinerCadreXY(0,0,119,4,simple, White, Black);
    dessinerCadreXY(0,4,119,30,simple, White, Black);

    // Affichage des données du header
    texteCivilisation := 'Civilisation: '+nomCivilisation;
    texteTour         := 'Tour: '+IntToStr(nbTour);

    ecrireEnPositionXY(5,2,texteCivilisation);
    ecrireEnPositionXY(105,2,texteTour);
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
    SCREEN_SIZE: Integer = 120;
  begin
    position.x := round((SCREEN_SIZE-length(texte))/2);
    position.y := posY;
    ecrireEnPosition(position, texte);
  end;


end.
