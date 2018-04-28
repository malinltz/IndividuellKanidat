%% Kandidat projekt , heuristik 1
clear all;
% Karta �ver fiktiv stad.
% xled = 600;
% yled = 600;
% stad = zeros(xled,yled);
tid = 57600; % Antal sekunder p� 16 timmar
%Skapar en matris f�r de 10 taxibilarna som kommer anv�ndas.
Taxibilar = zeros(10,5);
Taxibilar(:,2) = 300; % Startposition f�r taxibilarnar i x-led
Taxibilar(:,3) = 300; % Startposition f�r taxibilarnar i y-led

listan = xlsread('Kundlista');
[rows,columns] = size(listan);
% for i = 1:rows
%     %Ber�knar avst�ndet fr�n upph�mtning till anl�mning av varje kund
%     dist(i) = abs(listan(i,2) - listan(i,4)) + abs(listan(i,3) - listan(i,5));
%     %Ber�kning av totala distansen taxin f�r �ka enligt kundens sammarbetsvilja.
%     Totaldis(i) = (1+listan(i,6)) * dist(i); % anv�nds endast i heuristk 2.
% end

% Sorterar kundlistan efter tiden som kunderna ringer in. Ringer in f�rst =
% kommer �verst

kundlista = sortrows(listan,6);
A = zeros(1,rows); % L�gger till en nollvektor d�r nollan motsvarar kundens status.
kundlista = [kundlista, A',A',A',A']; %Kundens status motsvarar,
%0 = ej aktuell, kunden har inte ringt.
%k 1 = kunden har ringt och taxi �r p�v�g/taxi k�r kunden till kundens slutdestination.
%2 = Kunden har blivit betj�nad.

%plats_taxi = 4; % Antalet platser i taxibilen.
klockan = 0; % klockan g�r mellan 0 och 57600 sekunder (16 timmar).
riktning_x = zeros(10,4); % Riktningen som taxin ska f�rdas i x-led.
riktning_y = zeros(10,4); % Riktningen som taxin ska f�rdas i y-led.
antal_paus = 1;
%L�gg till en till for-loop f�r att k�ra heuristiken flera g�nger.
for i = 0:tid
    x = i/1800;
    if(floor(x) == x && x ~=0)
        pause
        disp(['Antal pauser: ',num2str(antal_paus)]);
        antal_paus = antal_paus +1;
    end
    for j = 1:rows
        if (kundlista(j,8) == -1)
            for k = 1:10
                if (Taxibilar(k,1) == 0) % Tilldelar en taxi ett jobb om taxin �r ledig
                    
                    Taxibilar(k,4) = Taxibilar(k,4) + 1; % Counter, f�r hur m�nga k�rningar varje taxibil tar p� sig.
                    % disp(['Taxibil nr: ',num2str(k),' betj�nar kund nr: ', num2str(j)])
                    Taxibilar(k,1) = 1; % S�tter taxibilens status till 2.
                    Taxibilar(k,5) = 0; % �terst�ller tiden f�r kunden att ta sig in/ut ur bilen.
                    % Ber�knar riktningen taxin ska f�rdas f�r att h�mta upp en kund.
                    riktning_x(k,2) = riktning_x(k,1)/abs(riktning_x(k,1));
                    riktning_y(k,2) = riktning_y(k,1)/abs(riktning_y(k,1));
                    % Ber�knar riktningen taxin ska f�rdas f�r att l�mna av en kund.
                    riktning_x(k,3) = (kundlista(j,3) - kundlista(j,1));
                    riktning_x(k,4) = riktning_x(k,3)/abs(riktning_x(k,3));
                    riktning_y(k,3) = (kundlista(j,4) - kundlista(j,2));
                    riktning_y(k,4) = riktning_y(k,3)/abs(riktning_y(k,3));
                    kundlista(j,8) = 1;% Taxibil skickas till en kund
                    kundlista(j,11) = k;
                    break % Avbryter loopen n�r en taxi tilldelas en kund.
                end
            end
        end
        if (klockan == kundlista(j,6)) % Kund ringer in
            s = 1;
            for k = 1:10
                if (Taxibilar(k,1) == 0) % Tilldelar en taxi ett jobb om taxin �r ledig
                    riktning_x(k,1) = (kundlista(j,1) - Taxibilar(k,2));
                    riktning_y(k,1) = (kundlista(j,2) - Taxibilar(k,3));
                    
                    stracka(s,1) = abs(riktning_x(k,1)) + abs(riktning_y(k,1));
                    stracka(s,2) = k;
                    s = s+1;
                else
                    kundlista(j,8) = -1;
                end
                
            end
            A = min(stracka(:,1));
            ridx = find(stracka(:,1) == A)
            z = ridx(1)
            
            Taxibilar(z,4) = Taxibilar(z,4) + 1; % Counter, f�r hur m�nga k�rningar varje taxibil tar p� sig.
            % disp(['Taxibil nr: ',num2str(k),' betj�nar kund nr: ', num2str(j)])
            Taxibilar(z,1) = 1; % S�tter taxibilens status till 2.
            Taxibilar(z,5) = 0; % �terst�ller tiden f�r kunden att ta sig in/ut ur bilen.
          % Ber�knar riktningen taxin ska f�rdas f�r att h�mta upp en kund.
            riktning_x(z,2) = riktning_x(z,1)/abs(riktning_x(z,1));
            riktning_y(z,2) = riktning_y(z,1)/abs(riktning_y(z,1));
            
            % Ber�knar riktningen taxin ska f�rdas f�r att l�mna av en kund.
            riktning_x(z,3) = (kundlista(j,3) - kundlista(j,1));
            riktning_x(z,4) = riktning_x(k,3)/abs(riktning_x(z,3));
            riktning_y(z,3) = (kundlista(j,4) - kundlista(j,2));
            riktning_y(z,4) = riktning_y(z,3)/abs(riktning_y(z,3));
            kundlista(j,8) = 1;% Taxibil skickas till en kund
            kundlista(j,12) = z;
            
           break % Avbryter loopen n�r en taxi tilldelas en kund.

        end
        
        %Ber�knar hur taxibilarna f�rdas d� de ska till en kund.
        
        for k = 1:10
            if (Taxibilar(k,1) == 1 && kundlista(j,8) == 1 && kundlista(j,11) == k)
                if (Taxibilar(k,5) == 100) % Extra tid f�r att kunde ska ta sig in i taxin.
                    if(Taxibilar(k,2) ~= kundlista(j,1)) % kollar att taxin har "r�tt" v�rde i x-led
                        Taxibilar(k,2) = Taxibilar(k,2) + (riktning_x(k,2));
                    end
                    if(Taxibilar(k,2) == kundlista(j,1) && Taxibilar(k,3) ~= kundlista(j,2))
                        Taxibilar(k,3) = Taxibilar(k,3) + (riktning_y(k,2));
                    end
                    if(Taxibilar(k,2) == kundlista(j,1) && Taxibilar(k,3) == kundlista(j,2))
                        Taxibilar(k,1) = 2; %Kunden har plockats upp
                        Taxibilar(k,5) = 0;
                        kundlista(j,8) = 2;
                        kundlista(j,9) = klockan; %Sparar tiden d� kunden blir upplockad
                        %       disp(['Taxibil nr: ',num2str(k),' har h�mtat upp kund nr: ',num2str(j)])
                    end
                else
                    Taxibilar(k,5) = Taxibilar(k,5) + 1; % R�knar tiden f�r kunden att ta sig
                end
            end
            if (Taxibilar(k,1) == 2 && kundlista(j,8) == 2 && kundlista(j,11) == k)  %Om kunden har plockats upp
                if (Taxibilar(k,5) == 100) % Extra tid f�r att kunde ska ta sig in i taxin.
                    if(Taxibilar(k,2) ~= kundlista(j,3)) % kollar att taxin har "r�tt" v�rde i x-led
                        Taxibilar(k,2) = Taxibilar(k,2) + (riktning_x(k,4));
                        
                    end
                    if(Taxibilar(k,2) == kundlista(j,3) && Taxibilar(k,3) ~= kundlista(j,4))
                        Taxibilar(k,3) = Taxibilar(k,3) + (riktning_y(k,4));
                        
                    end
                    if(Taxibilar(k,2) == kundlista(j,3) && Taxibilar(k,3) == kundlista(j,4)) % kollar att bilen �r framme vid kundens slutdestionation
                        Taxibilar(k,1) = 0; %Kunden har l�mnats av
                        Taxibilar(k,5) = 0;
                        kundlista(j,8) = 3;
                        kundlista(j,10) = klockan; %Sparar tiden d� kunden blir avl�mnad
                        %      disp(['Taxibil nr: ',num2str(k),' har l�mnat upp kund nr: ',num2str(j)])
                    end
                else
                    Taxibilar(k,5) = Taxibilar(k,5) + 1; % R�knar tiden f�r kunden att ta sig
                end
            end
        end
    end
    klockan = klockan +1;
end