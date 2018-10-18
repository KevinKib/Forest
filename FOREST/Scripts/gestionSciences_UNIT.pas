unit gestionSciences_UNIT;
{Cette unit� a pour r�le la gestion du centre de sciences et de recherche, c'est-�-dire la biblioth�que}


interface

  uses
    fonctionsGlobales_UNIT, 
    moduleGestionEcran_UNIT, 
    System.SysUtils, 
    initialisationVariables_UNIT;

  procedure gestionSciences(var game: TGame; var civ: TCivilisation; var combat: TCombat);
    {R�LE : Cette proc�dure a pour r�le de g�rer le menu de la recherche de la biblioth�que c'est-�-dire son affichage. Le joueur peut ensuite acc�der � un
	* menu descriptif de chaque recherche, plus d�taill�}

implementation

  var
    texteRecherche : String;
    texteAffichage : String;
    texteInfoJoueur: String;
    rechercheID    : Integer;

  const
    PRIX_EPEE_TRANCHANTE  : Integer = 70;
    TRAV_EPEE_TRANCHANTE  : Integer = 50;

    PRIX_ARTILLERIE       : Integer = 80;
    TRAV_ARTILLERIE       : Integer = 60;

    PRIX_POTION_MAGIQUE   : Integer = 100;
    TRAV_POTION_MAGIQUE   : Integer = 50;

    PRIX_BAC_COMPOST      : Integer = 0;
    TRAV_BAC_COMPOST      : Integer = 100;

    PRIX_BROCANTE         : Integer = 5;
    TRAV_BROCANTE         : Integer = 80;

    PRIX_STRATEGIE        : Integer = 50;
    TRAV_STRATEGIE        : Integer = 50;


  procedure conditions(civ: TCivilisation; prix: Integer);
  {R�LE : Cette proc�dure a pour role de g�rer les conditions d'acc�s du joueur aux recherches (ex: pas possible si d�j� une recherche en cours}
  {PRINCIPE : On teste si le joueur a d�j� une recherche en cours ou non grace a civ.CurrentRecherche ainsi que les radis qu'ils poss�dent afin que
  * le tout soit en ad�quation avec l'action choisie. Si le joueur a assez de radis et n'a aucune recherche en cours, il peut se permettre
  * d'entamer une nouvelle recherche }
  begin
    if (civ.CurrentRecherche <> 'Aucun') and not(civ.gold < prix) then texteInfoJoueur := 'Vous avez d�ja une recherche en cours !'
    else if not(civ.CurrentRecherche <> 'Aucun') and (civ.gold < prix) then texteInfoJoueur := 'Vous n''avez pas assez de radis.'
    else texteInfoJoueur := 'Vous avez d�ja une recherche en cours et pas assez de radis!';
  end;

  procedure epeeTranchante(prix, travail: Integer; var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette proc�dure a pour role de g�rer la recherche "Epee Tranchante" (Augmente les degats inflig�s par les soldats)}
  {PRINCIPE : Si les conditions le permettent, la recherche est lanc�e et on modifie les variables concern�es par les changements}
  begin

    if (civ.CurrentRecherche = 'Aucun') AND (civ.gold >= prix) then
      begin

        texteInfoJoueur := 'Recherche lanc�e !';
        civ.Travail_Max_Recherche := travail;
        civ.CurrentRecherche := 'Ep�e Tranchante';
        civ.gold := civ.gold - prix;
        civ.recherche_EpeeTranchante := True;
      end
    else conditions(civ, prix);

  end;

  procedure artillerie(prix, travail: Integer; var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette proc�dure a pour role de g�rer la recherche "Artillerie" (Augmente les degats inflig�s par les canons)}
  {PRINCIPE : Si les conditions le permettent, la recherche est lanc�e et on modifie les variables concern�es par les changements}
  begin
    if (civ.CurrentRecherche = 'Aucun') AND (civ.gold >= prix) then
      begin
        texteInfoJoueur := 'Recherche lanc�e !';
        civ.Travail_Max_Recherche := travail;
        civ.CurrentRecherche := 'Artillerie';
        civ.gold := civ.gold - prix;
        civ.recherche_Artillerie := True;
      end
    else conditions(civ, prix);
  end;

  procedure potionMagique(prix, travail: Integer; var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette proc�dure a pour role de g�rer la recherche "Potion magique" (Diminue le temps de construction necessaire)}
  {PRINCIPE : Si les conditions le permettent, la recherche est lanc�e et on modifie les variables concern�es par les changements}
  begin
    if (civ.CurrentRecherche = 'Aucun') AND (civ.gold >= prix) then
      begin
        texteInfoJoueur := 'Recherche lanc�e !';
        civ.Travail_Max_Recherche := travail;
        civ.CurrentRecherche := 'Potion magique';
        civ.gold := civ.gold - prix;
        civ.recherche_PotionMagique := True;

      end
   else conditions(civ, prix);
  end;

  procedure bacCompost(prix, travail: Integer; var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette proc�dure a pour role de g�rer la recherche "Bac a compost" (Augmente la production de nourriture)}
  {PRINCIPE : Si les conditions le permettent, la recherche est lanc�e et on modifie les variables concern�es par les changements}
  begin
    if (civ.CurrentRecherche = 'Aucun') AND (civ.gold >= prix) then
      begin
        texteInfoJoueur := 'Recherche lanc�e !';
        civ.Travail_Max_Recherche := travail;
        civ.CurrentRecherche := 'Bac � Compost';
        civ.gold := civ.gold - prix;
        civ.recherche_BacCompost := True;
      end
    else conditions(civ, prix);
  end;

  procedure brocanteForestiere (prix, travail: Integer; var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette proc�dure a pour role de g�rer la recherche "La brocante foresti�re" (Diminue les prix au march�}
  {PRINCIPE : Si les conditions le permettent, la recherche est lanc�e et on modifie les variables concern�es par les changements}
    begin
      if (civ.CurrentRecherche = 'Aucun') AND (civ.gold >= prix) then
        begin
          texteInfoJoueur := 'Recherche lanc�e !';
          civ.Travail_Max_Recherche := travail;
          civ.CurrentRecherche := 'Brocante Foresti�re';
          civ.gold := civ.gold - prix;
          civ.recherche_Brocante := True;
        end
      else conditions(civ, prix);
    end;

  procedure strategie(prix, travail: Integer; var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette proc�dure a pour role de g�rer la recherche "Strat�gie de Combat Contre Les Humains"}
  {PRINCIPE : Si les conditions le permettent, la recherche est lanc�e et une fenetre affichant les resultats de la recherche s'affiche � la fin de l'etude}
     begin
      if (civ.CurrentRecherche = 'Aucun') AND (civ.gold >= prix) then
        begin
          texteInfoJoueur := 'Recherche lanc�e !';
          civ.Travail_Max_Recherche := travail;
          civ.CurrentRecherche := 'Strat�gie';
          civ.gold := civ.gold - prix;
          civ.recherche_Strategie := True;
        end
      else conditions(civ, prix);
    end;

  procedure menuRecherche(recherche: String; var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette proc�dure a pour r�le de g�rer le menu de la recherche de la biblioth�que c'est-�-dire son affichage}
  {R�LE : On affiche les travaux d'�tudes disponibles au joueur avec leur prix et une description courte. On lit l'entr�e du joueur qui d�cide quelle etude
  * sera lanc�e ou pas}
  var
    lancerRecherche: Boolean;
  begin

    if civ.CurrentRecherche = 'Aucun' then
      begin
        lancerRecherche := False;
        if      (recherche = 'Ep�e Tranchante')     then lancerRecherche := not(civ.recherche_EpeeTranchante)
        else if (recherche = 'Artillerie')          then lancerRecherche := not(civ.recherche_Artillerie)
        else if (recherche = 'Potion magique')      then lancerRecherche := not(civ.recherche_PotionMagique)
        else if (recherche = 'Bac � Compost')       then lancerRecherche := not(civ.recherche_BacCompost)
        else if (recherche = 'Brocante Foresti�re') then lancerRecherche := not(civ.recherche_Brocante)
        else if (recherche = 'Strat�gie')           then lancerRecherche := not(civ.recherche_Strategie);

        if lancerRecherche then
        begin
          effacerEcran;
          displayHeader(game, civ);
          rechercheID := 0;

          if (recherche = 'Ep�e Tranchante') then
            begin
              // Description
              {$REGION}
              rechercheID := 1;

              ecrireAuCentre(5,'Recherche : Epee Tranchante');

              ecrireAuCentre(9,'DESCRIPTION');
              ecrireAuCentre(10,'Affute les �p�es des soldats, donc augmente leur puissance d''attaque !');

              ecrireAuCentre(14,'Travail n�cessaire:');
              ecrireAuCentre(15,IntToStr(TRAV_EPEE_TRANCHANTE));
              ecrireAuCentre(17,'Prix en radis:');
              ecrireAuCentre(18,IntToSTR(PRIX_EPEE_TRANCHANTE));
              {$ENDREGION}
            end
          else if (recherche = 'Artillerie') then
            begin
              // Description
              {$REGION}
              rechercheID := 2;

              ecrireAuCentre(5,'Recherche : Artillerie');

              ecrireAuCentre(9,'DESCRIPTION');
              ecrireAuCentre(10,'D�veloppe une nouvelle technologie pour les canons afin d''am�liorer leur efficacit� !');

              ecrireAuCentre(14,'Travail n�cessaire:');
              ecrireAuCentre(15,IntToStr(TRAV_ARTILLERIE));
              ecrireAuCentre(17,'Prix en radis:');
              ecrireAuCentre(18,IntToSTR(PRIX_ARTILLERIE));
              {$ENDREGION}
            end
          else if (recherche = 'Potion magique') then
            begin
              // Description
              {$REGION}
              rechercheID := 3;

              ecrireAuCentre(5,'Recherche : Potion Magique');

              ecrireAuCentre(9,'DESCRIPTION');
              ecrireAuCentre(10,'Augmente la productivit� de la population !');

              ecrireAuCentre(14,'Travail n�cessaire:');
              ecrireAuCentre(15,IntToStr(TRAV_POTION_MAGIQUE));
              ecrireAuCentre(17,'Prix en radis:');
              ecrireAuCentre(18,IntToSTR(PRIX_POTION_MAGIQUE));
              {$ENDREGION}
            end
          else if (recherche = 'Bac � Compost') then
            begin
              // Description
              {$REGION}
              rechercheID := 4;

              ecrireAuCentre(5,'Recherche : Bac � Compost');

              ecrireAuCentre(9,'DESCRIPTION');
              ecrireAuCentre(10,'Augmente la production de nourriture !');

              ecrireAuCentre(14,'Travail n�cessaire:');
              ecrireAuCentre(15,IntToStr(TRAV_BAC_COMPOST));
              ecrireAuCentre(17,'Prix en radis:');
              ecrireAuCentre(18,IntToSTR(PRIX_BAC_COMPOST));
              {$ENDREGION}
            end
          else if (recherche = 'Brocante Foresti�re') then
            begin
              // Description
              {$REGION}
              rechercheID := 5;

              ecrireAuCentre(5,'Recherche : Brocante Foresti�re');

              ecrireAuCentre(9,'DESCRIPTION');
              ecrireAuCentre(10,'Permet d''obtenir des r�ductions sur le march� !');

              ecrireAuCentre(14,'Travail n�cessaire:');
              ecrireAuCentre(15,IntToStr(TRAV_BROCANTE));
              ecrireAuCentre(17,'Prix en radis:');
              ecrireAuCentre(18,IntToSTR(PRIX_BROCANTE));
              {$ENDREGION}
            end
          else if (recherche = 'Strat�gie') then
            begin
              // Description
              {$REGION}
              rechercheID := 6;

              ecrireAuCentre(5,'Recherche : Strat�gie');

              ecrireAuCentre(9,'DESCRIPTION');
              ecrireAuCentre(10,'Th�orise les strat�gies de combat pour vaincre les humains !');

              ecrireAuCentre(14,'Travail n�cessaire:');
              ecrireAuCentre(15,IntToStr(TRAV_STRATEGIE));
              ecrireAuCentre(17,'Prix en radis:');
              ecrireAuCentre(18,IntToSTR(PRIX_STRATEGIE));
              {$ENDREGION}
            end;

          ecrireAuCentre(21,'Voulez-vous lancer cette recherche ?');
          ecrireAuCentre(23,'1 - Oui');
          ecrireAuCentre(24,'2 - Non');

          game.Input := 0;
          while not((game.Input = 1) or (game.Input = 2)) do
          begin
            demanderReponse(game);
          end;

          if game.Input = 1 then
            begin
              case rechercheID of
                1: epeeTranchante (PRIX_EPEE_TRANCHANTE,TRAV_EPEE_TRANCHANTE,game,civ,combat);
                2: artillerie     (PRIX_ARTILLERIE,TRAV_ARTILLERIE,game,civ,combat);
                3: potionMagique  (PRIX_POTION_MAGIQUE,TRAV_POTION_MAGIQUE,game,civ,combat);
                4: bacCompost     (PRIX_BAC_COMPOST,TRAV_BAC_COMPOST,game,civ,combat);
                5: brocanteForestiere (PRIX_BROCANTE,TRAV_BROCANTE,game,civ,combat);
                6: strategie      (PRIX_STRATEGIE,TRAV_STRATEGIE,game,civ,combat);
              end;
            end;
        end;
      end
    else texteInfoJoueur := 'Vous avez d�j� une recherche en cours !';



  end;

  procedure gestionSciences(var game: TGame; var civ: TCivilisation; var combat: TCombat);
  {R�LE : Cette proc�dure a pour r�le de g�rer le menu de la recherche de la biblioth�que c'est-�-dire son affichage. Le joueur peut ensuite acc�der � un
  * menu descriptif de chaque recherche, plus d�taill�}
  {PRINCIPE  : On affiche les radis et le travail disponibles puis on lit l'entr�e du joueur qui s�lectionne une telle ou telle recherche qui l'int�resse}
  begin
    // Header
      displayHeader(game, civ);

    // Titre
      ecrireAuCentre(6,'Ecran de gestion des sciences et recherches') ;
      ecrireAuCentre(7,'-------------------------------------------') ;

    //Affichage ameliorations

      if not(civ.recherche_EpeeTranchante)  then ecrireEnPositionXY(6,15,'1 - Ep�e Tranchante');
      if not(civ.recherche_Artillerie)      then ecrireEnPositionXY(6,16,'2 - Artillerie');
      if not(civ.recherche_PotionMagique)   then ecrireEnPositionXY(6,17,'3 - Potion magique');
      if not(civ.recherche_BacCompost)      then ecrireEnPositionXY(6,18,'4 - Bac � compost');
      if not(civ.recherche_Brocante)        then ecrireEnPositionXY(6,19,'5 - La brocante foresti�re');
      if not(civ.recherche_Strategie)       then ecrireEnPositionXY(6,20,'6 - Strat�gie de Combat Contre Les Humains');

      ecrireEnPositionXY(3,23,'0 - Sortir de la biblioth�que');

    //Affichage
      texteRecherche := 'Recherche actuelle: '+civ.CurrentRecherche;
      texteAffichage := 'Travail accumul�: '+IntToStr(civ.travailRecherche) + '/' + IntToStr(civ.Travail_Max_Recherche);
      ecrireEnPositionXY(3,12,texteRecherche);
      ecrireEnPositionXY(3,13,texteAffichage);
      ecrireAuCentre(25,texteInfoJoueur);

    // Affichage du cadre de r�ponse
      demanderReponse(game);

    // Lecture de la r�ponse du joueur
      case game.Input of
        0: game.Screen := 'ecranPrincipal';
        1: menuRecherche('Ep�e Tranchante', game, civ, combat);
        2: menuRecherche('Artillerie', game, civ, combat);
        3: menuRecherche('Potion magique', game, civ, combat);
        4: menuRecherche('Bac � Compost', game, civ, combat);
        5: menuRecherche('Brocante Foresti�re', game, civ, combat);
        6: menuRecherche('Strat�gie', game, civ, combat);
      end;
  end;

end.
