program memo;

uses sdl, types_memo, sysutils;           // types_memo in 'unit/types_memo.pas'

procedure initialise(var screen : PSDL_Surface);
begin
    SDL_Init(SDL_INIT_VIDEO);
    screen :=  SDL_SetVideoMode(LARGEUR, HAUTEUR, 32, SDL_SWSURFACE);
end;

procedure termine(var screen : PSDL_Surface);
begin
    SDL_FreeSurface(screen);
    SDL_Quit();
end;

procedure setup;
{ Initialise les cellules }
var i, j, k : Integer;
    cellule : Coord;
begin
    k := 0;
    //writeln(Length(grid));
    for j := 0 to rows-1 do
    begin
        for i := 0 to cols-1 do
        begin
            cellule.x := i;
            cellule.y := j;
            grid[k] := cellule;             // Initialisation de la grille
            k := k + 1;
        end;
    end;
    index_Aretenir := 0;            // Initialise l'index du tableau Aretenir
end;

procedure affiche_grid(var screen : PSDL_Surface);
{ Affiche les cellules }
var i, j, k : Integer;
begin
    for k := 0 to Length(grid) - 1 do
    begin
        i := grid[k].x * w;
        j := grid[k].y * w;
        fillRect(i, j, w-2, w-2, 100, 100, 100, screen);            // -2 permet de laisser un espace entre chaques cellules
    end;
end;

procedure choix_aleatoire;
{ Choisi aléatoirement une novelle cellule à retenir }
var aleatoire : Integer;
begin
    aleatoire := random(nbCell);
    Aretenir[index_Aretenir] := grid[aleatoire];
    index_Aretenir := index_Aretenir + 1;           
end;

procedure affichage_Aretenir(var screen : PSDL_SURFACE);
{ Affiche les cellules à retenir d'une autre couleur pendant un certain temps}
var k, i, j : Integer;
begin
    for k := 0 to index_Aretenir - 1 do         // index_Aretenir indique la place de la prochaine cellule dans le tableau Aretenir => - 1
    begin
        i := Aretenir[k].x * w;
        j := Aretenir[k].y * w;
        fillRect(i, j, w-2, w-2, 255, 14, 208, screen);
        SDL_Flip(screen);
        SDL_Delay(1000);
        fillRect(i, j, w-2, w-2, 100, 100, 100, screen);
        SDL_Flip(screen);
    end;

end;

function index(x, y : Integer) : Integer;
{ Calcul l'index de la cellule dans un tableau a 1 dimension}
begin
    index := x + y * cols;
end;

function position_souris: Coord;
{ Converti la position de la souris i j en position d'une cellule de position x y}
var x, y : Integer;
    i, j : LongInt;
begin
    SDL_PumpEvents();
    SDL_GetMouseState(i, j);            // Donne les coordonnées de la souris
    x := i div w;
    y := j div w;
    position_souris := grid[index(x, y)];               // Cellule sur laquelle la souris est positionné

end;

procedure affiche_clique(cell : Coord; screen : PSDL_SURFACE);
var i, j: Integer;
begin
    if flag = True then
    begin
        i := cell.x * w;
        j := cell.y * w;
        fillRect(i, j, w-2, w-2, 255, 0, 0, screen);
        SDL_Flip(screen);
        SDL_Delay(300);
        fillRect(i, j, w-2, w-2, 100, 100, 100, screen);
        SDL_Flip(screen);
    end
    else 
    begin
        i := cell.x * w;
        j := cell.y * w;
        fillRect(i, j, w-2, w-2, 51, 255, 255, screen);
        SDL_Flip(screen);
        SDL_Delay(100);
        fillRect(i, j, w-2, w-2, 100, 100, 100, screen);
        SDL_Flip(screen);
    end;
end;

procedure boucle_jeu(screen : PSDL_SURFACE);
var retenir_restant : Integer;
    event : TSDL_Event;
    suite : Boolean;
begin
    retenir_restant := 0;
    flag := False;
    suite := False;
    SDL_EventState(SDL_MOUSEBUTTONDOWN, SDL_Enable);

    while not suite do            // Tant qu'il y a des cases a retenir ou tant qu'il n'y a pas d'erreur
        begin
            repeat 
                SDL_WaitEvent(@event);
            until (event.type_ = SDL_MOUSEBUTTONDOWN) and (event.button.button = SDL_BUTTON_LEFT);          // Regarde si l'utilisateur a utilisé le clique droit de sa souris
            if (event.type_ = SDL_MOUSEBUTTONDOWN) then
            begin
                writeln('Clique droit');
                if (position_souris.x = Aretenir[retenir_restant].x) and (position_souris.y = Aretenir[retenir_restant].y) then 
                begin
                    retenir_restant := retenir_restant + 1;
                    writeln(retenir_restant);
                end
                else flag := True;
            end;
            affiche_clique(position_souris, screen);
            if (retenir_restant = index_Aretenir) or (flag = True) then suite := True;
        end;

end;

var fenetre : PSDL_Surface;
    k : Integer;
begin
    Randomize;
    initialise(fenetre);
    setup;
    affiche_grid(fenetre);
    SDL_Flip(fenetre);
    SDL_Delay(2000);

    for k := 0 to 1 do
    begin
        choix_aleatoire;
    end;
    while flag <> True do
    begin
        SDL_EventState(SDL_MOUSEBUTTONDOWN, SDL_IGNORE);            // Evite d'avoir queue de clique avant et pendant l'affichage des cases a retenir
        affichage_Aretenir(fenetre);
        boucle_jeu(fenetre);
        SDL_Delay(1000);
        choix_aleatoire;
    end;
    //SDL_Delay(5000);
    if flag = True then writeln('PERDDUUU') else writeln('GGGGAAAAAAGGGGNNNNEEEE');
    termine(fenetre);
end.