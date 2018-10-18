unit sauvegarde_UNIT;
{Cette unit� a pour r�le la gestion des fichiers de sauvegarde binaires.}


interface

uses

	  System.SysUtils,
	  initialisationVariables_UNIT;

	procedure writeFile(nbFile: Integer; game: TGame; civ: TCivilisation; combat: TCombat);
	{R�LE : Permet d'�crire les donn�es du record de sauvegarde dans un fichier binaire au nom du joueur}
	procedure readFile(nbFile: Integer; var game: TGame; var civ: TCivilisation; var combat: TCombat);
	{R�LE : Permet de r�cup�rer les donn�es du record de sauvegarde dans un fichier binaire au nom du joueur}
	procedure writeInfo(info: TInfo);
	{R�LE : Permet d'�crire les noms de fichier dans informations.bin.}
	procedure readInfo(var info: TInfo);
	{R�LE : Permet de r�cup�rer les noms de fichier du fichier informations.bin.}

implementation

var
  saveFile: file of TSave;
  save: TSave;

  saveInfo: file of TInfo;
  info: TInfo;

const
  SAVE_FILE_NAMES: Array[1..3] of String = ('Saves\file1.bin', 'Saves\file2.bin', 'Saves\file3.bin');

procedure convert(var game: TGame; var civ: TCivilisation; var combat: TCombat);
{R�LE :  Assembler les trois records du jeu en un seul record afin de n'utiliser qu'un seul fichier pour la sauvegarde}
{PRINCIPE : on convertit notre trio de record dans les record du save par simple affectation}
begin
  save.game   := game;
  save.civ    := civ;
  save.combat := combat;
end;

procedure unconvert(var game: TGame; var civ: TCivilisation; var combat: TCombat);
{R�LE : Extrait le record utilis� pour la sauvegarde pour le rendre utilisable dans le jeu}
{PRINCIPE : on recupere le trio de record save dans les record courants du jeu par simple affectation}
begin
  game    := save.game;
  civ     := save.civ;
  combat  := save.combat;
end;

procedure writeFile(nbFile: Integer; game: TGame; civ: TCivilisation; combat: TCombat);
{PRINCIPE : on enregistre les trois variables record dans le record de sauvegarde. on lit les informations provenant de notre fichier informations.bin
* (qui stocke les noms de fichier), on enregistre ensuite le nom du fichier de sauvegarde dans la variable qui stocke le nom du h�ros, on ecrit le nom
* de notre sauvegarde dans le fichier d'informations, on assigne un fichier a notre programme, on l'ouvre en ecriture, on ecrit dans le fichier, puis on le ferme.}
begin
  // On enregistre les donn�es de nos trois variables record dans le record de sauvegarde.
  convert(game, civ, combat);

  // On lit les informations provenant de notre fichier informations.bin (qui stocke les noms de fichier).
  readInfo(info);

  // On enregistre le nom du fichier de sauvegarde dans la variable qui stocke le nom du h�ros.
  case nbFile of
    1: info.filename1 := civ.NomHeros;
    2: info.filename2 := civ.NomHeros;
    3: info.filename3 := civ.NomHeros;
  end;

  // On �crit le nom de notre sauvegarde dans le fichier d'informations.
  writeInfo(info);

  // On assigne un fichier � notre programme.
  assign(saveFile,SAVE_FILE_NAMES[nbFile]);

  // On ouvre notre fichier en �criture.
  rewrite(saveFile);

  // On �crit dans notre fichier.
  write(saveFile, save);

  // On ferme notre fichier.
  close(saveFile);
end;

procedure readFile(nbFile: Integer; var game: TGame; var civ: TCivilisation; var combat: TCombat);
{PRINCIPE : on assigne le fichier selectionne par le joueur a notre programme, on l'ouvre en lecture, on enregistre les donnees du fichier
* dans la variable passee en param�tre, on ferme le fichier puis on entregistre les donnees de notre variable save dans les trois variables record}
begin

  // On assigne le fichier s�lectionn� par le joueur � notre programme.
  assign(saveFile,SAVE_FILE_NAMES[nbFile]);

  // On ouvre notre fichier en lecture.
  reset(saveFile);

  // On enregistre les donn�es du fichier dans la variable pass�e en param�tre.
  read(saveFile, save);

  // On ferme notre fichier.
  close(saveFile);

  // On enregistre les donn�es de notre variable save dans nos trois variables record.
  unconvert(game, civ, combat);
end;

procedure writeInfo(info: TInfo);
{PRINCIPE : on assigne un fichier a notre programme, on l'ouvre en ecriture, on ecrit dans le fichier et on le ferme}
begin
  // On assigne un fichier � notre programme.
  assign(saveInfo,'Saves\info.bin');

  // On ouvre notre fichier en �criture.
  rewrite(saveInfo);

  // On �crit dans notre fichier.
  write(saveInfo, info);

  // On ferme notre fichier.
  close(saveInfo);
end;

procedure readInfo(var info: TInfo);
{PRINCIPE : on assigne un fichier a notre programme, on l'ouvre en lecture, on enregistre les donn�es du fichier dans la variable passee en parametre et on le ferme}
begin

  // On assigne un fichier � notre programme.
  assign(saveInfo,'Saves\info.bin');

  // On ouvre notre fichier en lecture.
  reset(saveInfo);

  // On enregistre les donn�es du fichier dans la variable pass�e en param�tre.
  read(saveInfo, info);

  // On ferme notre fichier.
  close(saveInfo);

end;









// test
{$REGION}
{
procedure ecrireFich();
var
  f: file of ElementPile;
  x: PItem;
begin
  assign(f, nom);
  rewrite(f);
  x := p.pSommet;
  while x<>NIL do
  begin
    write(f, x^.elt);
    x := x.suivant;
  end;
  close(f);
end;

function lireFich(nom: String): Pile;
var
  f: file of ElementPile;
  e: ElementPile;
  p: Pile;
  i, nb: Integer;
begin
  assign(f, nom);
  reset(f);
  nb := filesize(f);
  init(p);
  for i := nb-1 downto 0 do
  begin
    seek(f, i);
    read(f, e);
    empile(p, e);
  end;
  close(f);
  lireFich := p;
end;
}
{$ENDREGION}

end.
