unit fonctionsProgramme;

interface

  uses
    System.SysUtils,
    moduleGestionEcran_UNIT;

  procedure fadeToWhite(transition: Integer);
  {RÔLE : Permet d'afficher une transition en fondu vers le blanc d'un ecran}
  procedure fadeToBlack(transition: Integer);
  {RÔLE : Permet d'afficher une transition en fondu vers le noir d'un ecran}
  procedure ecrireEnPositionXY(posX, posY: Integer; texte: string);
  {RÔLE : Permet d'écrire du texte en position XY, passés en parametre}
  procedure ecrireAuCentre(posY: Integer; texte: string);
  {RÔLE : Permet d'écrire un texte au centre de la ligne coordonnée Y}

implementation

  procedure fadeToWhite(transition: Integer);
  {PRINCIPE : On colorie l'ecran entièrement dans des nuances de gris consecutives, de noir en blanc}
  begin
    effacerEtColorierEcran(Black);
    sleep(transition);
    effacerEtColorierEcran(DarkGray);
    sleep(transition);
    effacerEtColorierEcran(LightGray);
    sleep(transition);
    effacerEtColorierEcran(White);
    couleurTexte(Black);
  end;

  procedure fadeToBlack(transition: Integer);
  {PRINCIPE : On colorie l'ecran entièrement dans des nuances de gris consecutives, de blanc en noir}
  begin
    effacerEtColorierEcran(White);
    sleep(transition);
    effacerEtColorierEcran(LightGray);
    sleep(transition);
    effacerEtColorierEcran(DarkGray);
    sleep(transition);
    effacerEtColorierEcran(Black);
    couleurTexte(White);
  end;

  procedure ecrireEnPositionXY(posX, posY: Integer; texte: string);
  {PRINCIPE : On recupere les coordonnées puis on appelle la procedure ecrireEnPosition afin d'afficher le texte a cette position la}
  var
    position: coordonnees;
  begin
    position.x := posX;
    position.y := posY;
    ecrireEnPosition(position, texte);
  end;

  procedure ecrireAuCentre(posY: Integer; texte: string);
  {PRINCIPE : On recupere la coordonnée Y de la ligne concernée puis on appelle la procedure ecrireEnPosition afin d'afficher le texte 
  * a cette position la. En prenant la largeur de l'ecran et en la divisant par 2 on obtient le centre.}
  var
    position: coordonnees;
  const
    screenSize: Integer = 120;
  begin
    position.x := round((screenSize-length(texte))/2);
    position.y := posY;
    ecrireEnPosition(position, texte);
  end;

  end.
