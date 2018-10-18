unit initialisationVariables_UNIT;
  { R�LE :  Cette unit� a pour r�le d'initialiser toutes les variables et types de variables
  utilis�es dans tout le programme. }

interface

type
    TGame = record
          Input: Integer;                 // Contient toutes les r�ponses du joueur
          Run: Boolean;                   // D�termine si le jeu tourne ou non
          Screen: String;                 // Ecran actuel du jeu
          NbTour: Integer;                // Num�ro du tour actuel
          end;

    TCivilisation = record
          {DEFINITION DE LA CIVILISATION}
          Nom: String;                    // Nom de la civilisation
          Ville: String;                  // Nom de la ville de cette civilisation
          Population: Integer;            // Quantit� de population

          {ATTRIBUTS DE LA CIVILISATION}
          Food: Integer;                  // Quantit� de nourriture
          Food_Max: Integer;              // Quantit� de stockage de nourriture
          Food_Par_Tour: Integer;         // Quantit� de nourriture produite par tour
          Nb_Tours_Levelup: Integer;      // Nombre de tours avant croissance
          Caserne: Boolean;               // D�termine si la caserne a �t� construite
          PointsRecrutement: Integer;     // Nombre de points de recrutement

          {VARIABLES DE CONSTRUCTION}
          Construction_Texte: String;     // Affichage du statut de la construction en cours
          CurrentConstruction: String;    // D�finit la construction actuelle
          NbConstructions: Integer;       // Nombre de constructions achev�es
          lvlFerme: Integer;              // Niveau actuel de la ferme
          lvlMine: Integer;               // Niveau actuel de la mine
          lvlCarriere: Integer;           // Niveau actuel de la carri�re
          lvlCaserne: Integer;            // Niveau actuel de la caserne
          Travail: Integer;               // Quantit� de travail accumul�
          Travail_Max: Integer;           // Quantit� de travail n�cessit�e pour la construction
          Travail_Par_Tour: Integer;      // Quantit� de travail disponible par tour pour la construction

          {VARIABLES DE TEXTE}
          texteCivilisation: String;
          texteTour: String;
          texteConstruction: String;
          texteTravail: String;
          end;

    TCombat = record
          Adversaire: String;             // Nom de l'adversaire de combat
          SoldatsDispo: Integer;          // Nombre de soldats disponibles pour le joueur
          CanonsDispo: Integer;           // Nombre de canons disponibles pour le joueur
          SoldatsEnnemis: Integer;        // Nombre de soldats disponibles pour l'ennemi
          CanonsEnnemis: Integer;         // Nombre de canons disponibles pour l'ennemi
          texteRecrutement: String;       // Texte s'affichant lors du recrutement sur l'�cran de gestion militaire
          end;

procedure initialisationVariables(var game: TGame; var civ: TCivilisation; var combat: TCombat);

implementation

  procedure initialisationVariables(var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE ET PRINCIPE : Cette proc�dure initialise les diff�rentes variables gr�ce � l'affectation Pascal}
  begin

    game.Screen := 'menuInitial';
    game.Input  := 0;
    game.Run    := True;
    game.NbTour := 1;

    civ.Nom               := 'France';       // test des variables
    civ.Ville             := 'Paris' ;
    civ.Population        := 1;
    civ.Food              := 0;
    civ.Food_Max          := 10;
    civ.Food_Par_Tour     := 1 ;
    civ.Nb_Tours_Levelup  := 10;
    civ.PointsRecrutement := 0;

    civ.CurrentConstruction := 'Aucun';
    civ.lvlFerme          := 0;
    civ.lvlMine           := 0;
    civ.lvlCarriere       := 0;
    civ.lvlCaserne        := 0;
    civ.Travail           := 0;
    civ.Travail_Max       := 0;
    civ.Travail_Par_Tour  := civ.Population;
    civ.NbConstructions   := 0;

    civ.texteConstruction := '';
    civ.texteTravail      := '';
    civ.texteCivilisation := '';
    civ.texteTour         := '';

    combat.Adversaire         := 'Petit camps barbare';
    combat.SoldatsDispo       := 5;
    combat.CanonsDispo        := 0;
    combat.SoldatsEnnemis     := 0;
    combat.CanonsEnnemis      := 0;
    combat.texteRecrutement   := '';

  end;


end.
