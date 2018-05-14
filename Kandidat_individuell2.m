%% Kandidat projekt , heuristik 2
clear;
% Karta �ver fiktiv stad.
% xled = 600;
% yled = 600;
% stad = zeros(xled,yled);
tid = 57600; % Antal sekunder p� 16 timmar
%Skapar en matris f�r de 10 taxibilarna som kommer anv�ndas.
Antal_bilar = 5;
Taxibilar = zeros(Antal_bilar,5);
Taxibilar(:,2) = 300; % Startposition f�r taxibilarnar i x-led
Taxibilar(:,3) = 300; % Startposition f�r taxibilarnar i y-led
listan = xlsread('Kundlista500');
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
for i = 1:rows-1
    j = i +1;
    if (kundlista(i,6) == kundlista(j,6))
        kundlista(j,6) = kundlista(j,6) +1;
    end
end
%0 = ej aktuell, kunden har inte ringt.
%k 1 = kunden har ringt och taxi �r p�v�g/taxi k�r kunden till kundens slutdestination.
%2 = Kunden har blivit betj�nad.

%plats_taxi = 4; % Antalet platser i taxibilen.
klockan = 0; % klockan g�r mellan 0 och 57600 sekunder (16 timmar).
riktning_x = zeros(10,4); % Riktningen som taxin ska f�rdas i x-led.
riktning_y = zeros(10,4); % Riktningen som taxin ska f�rdas i y-led.
antal_paus = 1;
%L�gg till en till for-loop f�r att k�ra heuristiken flera g�nger.
for i = 1:tid
    %     x = i/1800;
    %     if(floor(x) == x && x ~=0)
    %         pause
    %         disp(['Antal pauser: ',num2str(antal_paus)]);
    %         antal_paus = antal_paus +1;
    %     end
    for j = 1:rows
        if (kundlista(j,8) == -1)
            s = 1;
            strackaB = [];
            for k = 1:Antal_bilar
                if (Taxibilar(k,1) == 0) % Tilldelar en taxi ett jobb om taxin �r ledig
                    riktning_x(k,1) = (kundlista(j,1) - Taxibilar(k,2));
                    riktning_y(k,1) = (kundlista(j,2) - Taxibilar(k,3));
                    strackaB(s,1) = abs(riktning_x(k,1)) + abs(riktning_y(k,1));
                    strackaB(s,2) = k;
                    s = s+1;
                    kundlista(j,12) = k;
                    break;
                end
            end
            if (Taxibilar(k,1) == 0 && kundlista(j,12) == k)
                strackaB2 = strackaB(:,1);
                [m,pos] = min(strackaB2(strackaB2 > 0));
                z = strackaB(pos,2);
               
                % disp(['Taxibil nr: ',num2str(k),' betj�nar kund nr: ', num2str(j)])
                % Ber�knar riktningen taxin ska f�rdas f�r att h�mta upp en kund.
                riktning_x(z,2) = riktning_x(z,1)/abs(riktning_x(z,1));
                riktning_y(z,2) = riktning_y(z,1)/abs(riktning_y(z,1));
                % Ber�knar riktningen taxin ska f�rdas f�r att l�mna av en kund.
                riktning_x(z,3) = (kundlista(j,3) - kundlista(j,1));
                riktning_x(z,4) = riktning_x(z,3)/abs(riktning_x(z,3));
                riktning_y(z,3) = (kundlista(j,4) - kundlista(j,2));
                riktning_y(z,4) = riktning_y(z,3)/abs(riktning_y(z,3));
                Taxibilar(z,1) = 1; % S�tter taxibilens status till 1.
                Taxibilar(z,5) = 0; % �terst�ller tiden f�r kunden att ta sig in/ut ur bilen.
                Taxibilar(z,4) = Taxibilar(z,4) + 1; % Counter, f�r hur m�nga k�rningar varje taxibil tar p� sig.
                kundlista(j,8) = 1;% Taxibil skickas till en kund
                kundlista(j,12) = z;
            else
                kundlista(j,9) = kundlista(j,9) + 1;
            end
        end
            
            if (klockan == kundlista(j,6)) % Kund ringer in
                s = 1;
                stracka = [];
                for k = 1:Antal_bilar
                    if (Taxibilar(k,1) == 0) % Tilldelar en taxi ett jobb om taxin �r ledig
                        riktning_x(k,1) = (kundlista(j,1) - Taxibilar(k,2));
                        riktning_y(k,1) = (kundlista(j,2) - Taxibilar(k,3));
                        stracka(s,1) = abs(riktning_x(k,1)) + abs(riktning_y(k,1));
                        stracka(s,2) = k;
                        s = s+1;
                        kundlista(j,8) = 1;
                    else
                        kundlista(j,8) = -1;
                    end
                end
                if (klockan == kundlista(j,6) && Taxibilar(k,1) == 0)
                    stracka2 = stracka(:,1);
                    [m,pos] = min(stracka2(stracka2 > 0));
                    z = stracka(pos,2);
                    
                    Taxibilar(z,4) = Taxibilar(z,4) + 1; % Counter, f�r hur m�nga k�rningar varje taxibil tar p� sig.
                    % disp(['Taxibil nr: ',num2str(k),' betj�nar kund nr: ', num2str(j)])
                    Taxibilar(z,1) = 1; % S�tter taxibilens status till 2.
                    Taxibilar(z,5) = 0; % �terst�ller tiden f�r kunden att ta sig in/ut ur bilen.
                    % Ber�knar riktningen taxin ska f�rdas f�r att h�mta upp en kund.
                    riktning_x(z,2) = riktning_x(z,1)/abs(riktning_x(z,1));
                    riktning_y(z,2) = riktning_y(z,1)/abs(riktning_y(z,1));
                    
                    % Ber�knar riktningen taxin ska f�rdas f�r att l�mna av en kund.
                    riktning_x(z,3) = (kundlista(j,3) - kundlista(j,1));
                    riktning_x(z,4) = riktning_x(z,3)/abs(riktning_x(z,3));
                    riktning_y(z,3) = (kundlista(j,4) - kundlista(j,2));
                    riktning_y(z,4) = riktning_y(z,3)/abs(riktning_y(z,3));
                    kundlista(j,8) = 1;% Taxibil skickas till en kund
                    kundlista(j,12) = z;
                end
                
                break % Avbryter loopen n�r en taxi tilldelas en kund.
            end
            
            %Ber�knar hur taxibilarna f�rdas d� de ska till en kund.
            
            for k = 1:Antal_bilar
                if (Taxibilar(k,1) == 1 && kundlista(j,8) == 1 && kundlista(j,12) == k)
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
                            kundlista(j,10) = klockan; %Sparar tiden d� kunden blir upplockad
                            %       disp(['Taxibil nr: ',num2str(k),' har h�mtat upp kund nr: ',num2str(j)])
                        end
                    else
                        Taxibilar(k,5) = Taxibilar(k,5) + 1; % R�knar tiden f�r kunden att ta sig
                    end
                end
                if (Taxibilar(k,1) == 2 && kundlista(j,8) == 2 && kundlista(j,12) == k)  %Om kunden har plockats upp
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
                            kundlista(j,11) = klockan; %Sparar tiden d� kunden blir avl�mnad
                            %  disp(['Taxibil nr: ',num2str(k),' har l�mnat upp kund nr: ',num2str(j)])
                        end
                    else
                        Taxibilar(k,5) = Taxibilar(k,5) + 1; % R�knar tiden f�r kunden att ta sig
                    end
                end
            end
        end
        klockan = klockan +1;
end
Totalt_avlamnde_kunder = sum(Taxibilar(:,4));
Total_vantetid = sum(kundlista(:,9));
Total_vantetid_snitt_minuter = Total_vantetid /(rows *60);