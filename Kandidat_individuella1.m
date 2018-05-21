%% Kandidat projekt , heuristik 1
clear all;
% Karta över fiktiv stad.
xled = 600;
yled = 600;
stad = zeros(xled,yled);
tid = 57600; % Antal sekunder på 16 timmar
%Skapar en matris för de 10 taxibilarna som kommer användas.
Antal_bilar = 10;
Taxibilar = zeros(Antal_bilar,5);
Taxibilar(:,2) = 300; % Startposition för taxibilarnar i x-led
Taxibilar(:,3) = 300; % Startposition för taxibilarnar i y-led
x=0:600;
y=0:600;
listan = xlsread('Kundlista250_2');
[rows,columns] = size(listan);

kundlista = sortrows(listan,6);
A = zeros(1,rows); % Lägger till en nollvektor där nollan motsvarar kundens status.
kundlista = [kundlista, A',A',A',A',A',A']; %Kundens status motsvarar,
%0 = ej aktuell, kunden har inte ringt.
%k 1 = kunden har ringt och taxi är påväg/taxi kör kunden till kundens slutdestination.
%2 = Kunden har blivit betjänad.
%plats_taxi = 4; % Antalet platser i taxibilen.
klockan = 0; % klockan går mellan 0 och 57600 sekunder (16 timmar).
riktning_x = zeros(10,4); % Riktningen som taxin ska färdas i x-led.
riktning_y = zeros(10,4); % Riktningen som taxin ska färdas i y-led.

%Lägg till en till for-loop för att köra heuristiken flera gånger.
 for i = 0:tid


    for j = 1:rows
        if (kundlista(j,8) == -1)
             for k = 1:Antal_bilar
                if (Taxibilar(k,1) == 0) % Tilldelar en taxi ett jobb om taxin är ledig;
                    
                    disp(['Taxibil nr: ',num2str(k),' betjänar kund nr: ', num2str(j)])
                    Taxibilar(k,1) = 1; % Sätter taxibilens status till 2.
                    Taxibilar(k,5) = 0; % Återställer tiden för kunden att ta sig in/ut ur bilen.
                    % Beräknar riktningen taxin ska färdas för att hämta upp en kund.
                    riktning_x(k,1) = (kundlista(j,1) - Taxibilar(k,2));
                    riktning_x(k,2) = riktning_x(k,1)/abs(riktning_x(k,1));
                    riktning_y(k,1) = (kundlista(j,2) - Taxibilar(k,3));
                    riktning_y(k,2) = riktning_y(k,1)/abs(riktning_y(k,1));
                    % Beräknar riktningen taxin ska färdas för att lämna av en kund.
                    riktning_x(k,3) = (kundlista(j,3) - kundlista(j,1));
                    riktning_x(k,4) = riktning_x(k,3)/abs(riktning_x(k,3));
                    riktning_y(k,3) = (kundlista(j,4) - kundlista(j,2));
                    riktning_y(k,4) = riktning_y(k,3)/abs(riktning_y(k,3));
                    kundlista(j,8) = 1;% Taxibil skickas till en kund
                    kundlista(j,12) = k;
                    break % Avbryter loopen när en taxi tilldelas en kund.
                else 
                    kundlista(j,9) = kundlista(j,9) + 1;
                end
             end
        end
        
        if (klockan == kundlista(j,6)) % Kund ringer in

            for k = 1:Antal_bilar
                if (Taxibilar(k,1) == 0) % Tilldelar en taxi ett jobb om taxin är ledig
                    disp(['Taxibil nr: ',num2str(k),' betjänar kund nr: ', num2str(j)])
                    Taxibilar(k,1) = 1; % Sätter taxibilens status till 2.
                    Taxibilar(k,5) = 0; % Återställer tiden för kunden att ta sig in/ut ur bilen.
                    % Beräknar riktningen taxin ska färdas för att hämta upp en kund.
                    riktning_x(k,1) = (kundlista(j,1) - Taxibilar(k,2));
                    riktning_x(k,2) = riktning_x(k,1)/abs(riktning_x(k,1));
                    riktning_y(k,1) = (kundlista(j,2) - Taxibilar(k,3));
                    riktning_y(k,2) = riktning_y(k,1)/abs(riktning_y(k,1));
                    % Beräknar riktningen taxin ska färdas för att lämna av en kund.
                    riktning_x(k,3) = (kundlista(j,3) - kundlista(j,1));
                    riktning_x(k,4) = riktning_x(k,3)/abs(riktning_x(k,3));
                    riktning_y(k,3) = (kundlista(j,4) - kundlista(j,2));
                    riktning_y(k,4) = riktning_y(k,3)/abs(riktning_y(k,3));
                    kundlista(j,8) = 1;% Taxibil skickas till en kund
                    kundlista(j,12) = k;
                    break % Avbryter loopen när en taxi tilldelas en kund.
                else
                    kundlista(j,8) = -1;
                end
            end
        end

        %Beräknar hur taxibilarna färdas då de ska till en kund.
        
        for k = 1:Antal_bilar
            if (Taxibilar(k,1) == 1 && kundlista(j,8) == 1 && kundlista(j,12) == k)
                if (Taxibilar(k,5) == 100) % Extra tid för att kunde ska ta sig in i taxin.
                    if(Taxibilar(k,2) ~= kundlista(j,1)) % kollar att taxin har "rätt" värde i x-led
                        Taxibilar(k,2) = Taxibilar(k,2) + (riktning_x(k,2));
                    end
                    if(Taxibilar(k,2) == kundlista(j,1) && Taxibilar(k,3) ~= kundlista(j,2))
                        Taxibilar(k,3) = Taxibilar(k,3) + (riktning_y(k,2));
                    end
                    if(Taxibilar(k,2) == kundlista(j,1) && Taxibilar(k,3) == kundlista(j,2))
                        Taxibilar(k,1) = 2; %Kunden har plockats upp
                        Taxibilar(k,5) = 0;
                        kundlista(j,8) = 2;
                        kundlista(j,10) = klockan; %Sparar tiden då kunden blir upplockad
                 %       disp(['Taxibil nr: ',num2str(k),' har hämtat upp kund nr: ',num2str(j)])
                    end
                else
                    Taxibilar(k,5) = Taxibilar(k,5) + 1; % Räknar tiden för kunden att ta sig
                end
            end
            if (Taxibilar(k,1) == 2 && kundlista(j,8) == 2 && kundlista(j,12) == k)  %Om kunden har plockats upp
                if (Taxibilar(k,5) == 100) % Extra tid för att kunde ska ta sig in i taxin.
                    if(Taxibilar(k,2) ~= kundlista(j,3)) % kollar att taxin har "rätt" värde i x-led
                        Taxibilar(k,2) = Taxibilar(k,2) + (riktning_x(k,4));
                        
                    end
                    if(Taxibilar(k,2) == kundlista(j,3) && Taxibilar(k,3) ~= kundlista(j,4))
                        Taxibilar(k,3) = Taxibilar(k,3) + (riktning_y(k,4));
                        
                    end
                    if(Taxibilar(k,2) == kundlista(j,3) && Taxibilar(k,3) == kundlista(j,4)) % kollar att bilen är framme vid kundens slutdestionation
                        Taxibilar(k,1) = 0; %Kunden har lämnats av
                        Taxibilar(k,5) = 0;
                        kundlista(j,8) = 3;
                        kundlista(j,11) = klockan; %Sparar tiden då kunden blir avlämnad
                        disp(['Taxibil nr: ',num2str(k),' har lämnat upp kund nr: ',num2str(j)])
                        Taxibilar(k,4) = Taxibilar(k,4) +1;
                    end
                else
                    Taxibilar(k,5) = Taxibilar(k,5) + 1; % Räknar tiden för kunden att ta sig
                end
            end
        end

    end
    klockan = klockan +1; 

end
Totalt_avlamnde_kunder = sum(Taxibilar(:,4));
Total_vantetid = sum(kundlista(:,9));
Total_vantetid_snitt_minuter = Total_vantetid /(rows *60);