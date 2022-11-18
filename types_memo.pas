unit types_memo;

interface

uses sdl;

{ ~~~~~~~~~~ LES TYPES ~~~~~~~~~~ }

Type Coord = record 
    x, y : Integer;
    end;

{ ~~~~~~~~~~ LES CONSTANTES ~~~~~~~~~~ }

const LARGEUR = 400;
    HAUTEUR = 400;
    w = 80;
    cols = LARGEUR div w;
    rows = HAUTEUR div w;
    nbCell = cols*rows;
    Max_a_retenir = 10;

{ ~~~~~~~~~~ LES VARIABLES ~~~~~~~~~~ }

var grid : array[0..nbCell-1] of Coord;
    Aretenir : array[0..Max_a_retenir] of Coord;
    index_Aretenir : Integer;
    flag : Boolean;

{ ~~~~~~~~~~ LES PROCEDURES ~~~~~~~~~~ }
procedure fillRect(x, y, w, h, r, g, b : Integer; screen : PSDL_Surface);
procedure blitSurface(x, y, w, h : Integer; screen, surface : PSDL_Surface);


implementation

procedure fillRect(x, y, w, h, r, g, b : Integer; screen : PSDL_Surface);
{ Simplifie la procedure SDL_FillRect }
var destination_rect : TSDL_RECT;
begin
    destination_rect.x := x;
    destination_rect.y := y;
    destination_rect.w := w;
    destination_rect.h := h;
    SDL_FillRect(screen, @destination_rect, SDL_MapRGB(screen^.format, r, g, b));
end;

procedure blitSurface(x, y, w, h : Integer; screen, surface : PSDL_Surface);
{ Simplifie la procedure SDL_BlitSurface }
var destination_rect : TSDL_RECT;
begin
    destination_rect.x := x;
    destination_rect.y := y;
    destination_rect.w := w;
    destination_rect.h := h;
    SDL_BlitSurface(surface, NIL, screen, @destination_rect);
end;

end.