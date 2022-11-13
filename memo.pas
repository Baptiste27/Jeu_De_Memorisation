program memo;

uses sdl, types_memo, sysutils;

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
        fillRect(i, j, w-2, w-2, 150, 0, 150, screen);
        SDL_Flip(screen);
        SDL_Delay(2000);
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
var x, y : Integer;
    i, j : LongInt;
begin
    SDL_PumpEvents();
    SDL_GetMouseState(i, j);            // Donne les coordonnées de la souris
    x := i div w;
    y := j div w;
    position_souris := grid[index(x, y)];               // Cellule sur laquelle la souris est positionné

end;

var fenetre : PSDL_Surface;
    k : Integer;
    retenir_restant : Integer;
    event : TSDL_Event;
    flag : Boolean;

begin
    Randomize;
    retenir_restant := 0;
    flag := False;
    initialise(fenetre);
    setup;
    affiche_grid(fenetre);
    SDL_Flip(fenetre);
    SDL_Delay(2000);

    while (retenir_restant <> Aretenir - 1) or (flag <> True) do
    begin
        while SDL_WaitEvent(@event) do
        begin
            if (event.type_ = SDL_MOUSEBUTTONDOWN) then
            begin
                if position_souris = Aretenir[retenir_restant] then retenir_restant := retenir_restant + 1;
                else flag = True;
            end;
        end;
    end;


    for k := 0 to 2 do
    begin
        choix_aleatoire;
    end;
    affichage_Aretenir(fenetre);
    SDL_Delay(5000);
    termine(fenetre);
end.