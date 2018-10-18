unit initialisationVariables_UNIT;
  { R�LE :  Cette unit� a pour r�le d'initialiser toutes les variables et types de variables
  utilis�es dans tout le programme. }

interface

type

    TGame = record
          Input: Integer;                   // Contient toutes les r�ponses du joueur
          Run: Boolean;                     // D�termine si le jeu tourne ou non
          Screen: String[255];              // Ecran actuel du jeu
          NbTour: Integer;                  // Num�ro du tour actuel
          end;

    TCivilisation = record
          {DEFINITION DE LA CIVILISATION}
          Nom: String[255];                 // Nom de la civilisation
          NomHeros: String[255];            // Nom du h�ros (Ryu'Than)
          Ville: String[255];               // Nom de la ville de cette civilisation
          Population: Integer;              // Quantit� de population

          {ATTRIBUTS DE LA CIVILISATION}
          Food: Integer;                    // Quantit� de nourriture
          Food_Max: Integer;                // Quantit� de stockage de nourriture
          Food_Par_Tour: Integer;           // Quantit� de nourriture produite par tour
          Nb_Tours_Levelup: Integer;        // Nombre de tours avant croissance
          PointsRecrutement: Integer;       // Nombre de points de recrutement

          {VARIABLES DE CONSTRUCTION}
          Construction_Texte: String[255];  // Affichage du statut de la construction en cours
          CurrentConstruction: String[255]; // D�finit la construction actuelle
          lvlFerme: Integer;                // Niveau actuel de la ferme
          lvlMine: Integer;                 // Niveau actuel de la mine
          lvlCarriere: Integer;             // Niveau actuel de la carri�re
          lvlCaserne: Integer;              // Niveau actuel de la caserne
          lvlBibliotheque: integer;
          lvlMarche : Integer;              // Niveau actuel du march�
          lvlParc   : Integer;
          Travail: Integer;                 // Quantit� de travail accumul�
          Travail_Max: Integer;             // Quantit� de travail n�cessit�e pour la construction
          Travail_Par_Tour: Integer;        // Quantit� de travail disponible par tour pour la construction
          Travail_Texte: String[255];       // Texte que doit afficher le script pour le travail accumul�

          NbConstructions: Integer;
          ConstructionLancee_Texte: String[255];// Texte affich� lorsqu'une construction est lanc�e
          Croissance_Texte: String[255];    // Texte affich� correspondant au nombre de tours avant la croissance
          texteCivilisation: String[255];
          texteTour: String[255];
          texteConstruction: String[255];
          texteTravail: String[255];
          gold   : Integer;                    // Quantit� d'or
          bonheur: Integer;
          Dragon : Boolean;                 // Bool�en qui d�termine la pr�sence d'un dragon ou non
          Histoire_PetitCamp1: Boolean;
          Histoire_PetitCamp2: Boolean;
          Histoire_PetitCamp3: Boolean;
          nbCamp: Integer;

          CurrentRecherche: String[255];
          travailRecherche: Integer;
          Travail_Max_Recherche : Integer;

          recherche_EpeeTranchante: Boolean;
          recherche_Artillerie: Boolean;
          recherche_PotionMagique: Boolean;
          recherche_BacCompost: Boolean;
          recherche_Brocante: Boolean;
          recherche_Strategie: Boolean;
          end;

    TCombat = record
          Adversaire: String[255];        // Nom de l'adversaire de combat
          SoldatsDispo: Integer;          // Nombre de soldats disponibles pour le joueur
          CanonsDispo: Integer;           // Nombre de canons disponibles pour le joueur
          SoldatsEnnemis: Integer;        // Nombre de soldats disponibles pour l'ennemi
          CanonsEnnemis: Integer;         // Nombre de canons disponibles pour l'ennemi
          Recrutement_Texte: String[255];      //Texte s'affichant lors du recrutement sur l'�cran de gestion militaire
          Recrutement_Texte_Couleur: String[255];
          Seed : integer;                  //Graine servant � diff�rencer l'attaque du petit/grand cmap barbare
          Bonus_Soldats: Real;
          Bonus_Canons: Real;
          end;


    TSave = record
      game: TGame;
      civ: TCivilisation;
      combat: TCombat;
    end;

    TInfo = record
      filename1: String[255];
      filename2: String[255];
      filename3: String[255];
    end;

  procedure initialisationVariables(var game: TGame; var civ: TCivilisation; var combat: TCombat);

implementation

  procedure initialisationVariables(var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE ET PRINCIPE : Cette proc�dure initialise les diff�rentes variables gr�ce � l'affectation}
  begin

    game.Screen := 'menuInitial'; // Ecran actuel.
    game.Input := 0;
    game.Run := True;
    game.NbTour := 1;

    civ.Nom               := 'Sylvains';       // test des variables
    civ.NomHeros          := 'Ryu''Than';
    civ.Ville             := 'Paris' ;
    civ.Population        := 1;
    civ.Food              := 0;
    civ.Food_Max          := 10;
    civ.Food_Par_Tour     := 1 ;
    civ.Nb_Tours_Levelup  := 10;
    civ.PointsRecrutement := 5;

    civ.CurrentConstruction := 'Aucun';
    civ.lvlFerme          := 0;
    civ.lvlMine           := 0;
    civ.lvlCarriere       := 0;
    civ.lvlCaserne        := 0;
    civ.lvlBibliotheque   := 0;
    civ.lvlMarche         := 0;
    civ.lvlParc           := 0;
    civ.Travail           := 0;
    civ.Travail_Max       := 0;
    civ.Travail_Par_Tour  := 1;
    civ.NbConstructions   := 0;
    civ.ConstructionLancee_Texte := '';
    civ.gold              := 100;
    civ.bonheur           := 6;

    civ.texteConstruction := '';
    civ.texteTravail      := '';
    civ.texteCivilisation := '';
    civ.texteTour         := '';

    civ.CurrentRecherche      := 'Aucun';
    civ.TravailRecherche      := 0;
    civ.Travail_Max_Recherche := 0;

    civ.Dragon              := False;                 // Bool�en qui d�termine la pr�sence d'un dragon ou non
    civ.Histoire_PetitCamp1 := True;
    civ.Histoire_PetitCamp2 := True;
    civ.Histoire_PetitCamp3 := True;
    civ.nbCamp              := 0;

    civ.recherche_EpeeTranchante  := False;
    civ.recherche_Artillerie      := False;
    civ.recherche_PotionMagique   := False;
    civ.recherche_BacCompost      := False;
    civ.recherche_Brocante        := False;
    civ.recherche_Strategie       := False;

    combat.Recrutement_Texte  := '';
    combat.Recrutement_Texte_couleur := 'White';
    combat.Adversaire         := 'Petit camps barbare';
    combat.SoldatsDispo       := 1;
    combat.CanonsDispo        := 0;
    combat.SoldatsEnnemis     := 0;
    combat.CanonsEnnemis      := 0;
    combat.Bonus_Soldats      := 1;
    combat.Bonus_Canons       := 1;

  end;


end.
