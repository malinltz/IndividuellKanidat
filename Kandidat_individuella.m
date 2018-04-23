%% Kandidat projekt , heuristik 1

% Karta över fiktiv stad.
%xled = 600;
%yled = 600;
%stad = zeros(xled,yled);
tid = 57600; % Antal sekunder på 16 timmar
%Skapar en matris för de 10 taxibilarna som kommer användas.
Taxibilar = zeros(10,5);
Taxibilar(:,2) = 300; % Startposition för taxibilarnar i x-led
Taxibilar(:,3) = 300; % Startposition för taxibilarnar i y-led

listan = xlsread('Kundlista');
[rows,columns] = size(listan);

for i = 1:rows
    %Beräknar avståndet från upphämtning till anlämning av varje kund
    dist(i) = abs(listan(i,2) - listan(i,4)) + abs(listan(i,3) - listan(i,5));
    %Beräkning av totala distansen taxin får åka enligt kundens sammarbetsvilja.
    Totaldis(i) = (1+listan(i,6)) * dist(i);
end

% Sorterar kundlistan efter tiden som kunderna ringer in. Ringer in först =
% kommer överst
kundlista = sortrows(listan,6);
A = zeros(1,rows); % Lägger till en nollvektor där nollan motsvarar kundens status.
kundlista = [kundlista, A']; %Kundens status motsvarar,
%0 = ej aktuell, kunden har inte ringt.
%k 1 = kunden har ringt och taxi är påväg/taxi kör kunden till kundens slutdestination.
%2 = Kunden har blivit betjänad.

%bagtid = 12; % Tiden i sekunder att färdas 100m, mellan 2 noder (hastighet = 8.33m/s)
%plats_taxi = 4; % Antalet platser i taxibilen.
klockan = 0; % klockan går mellan 0 och 57600 sekunder (16 timmar).
riktning_x = zeros(10,2); % Riktningen som taxin ska färdas i x-led.
riktning_y = zeros(10,2); % Riktningen som taxin ska färdas i y-led.

for i = 0:tid
    for j = 1:rows
        if (klockan == kundlista(j,6)) % Kund ringer in
            kundlista(j,8) = 1; % Taxibil skickas till en kund.
        end
        
        for k = 1:10
            if (Taxibilar(k,1) == 0 && kundlista(j,8) == 1) % Tilldelar en taxi ett jobb om taxin är ledig
                Taxibilar(k,4) = Taxibilar(k,4) + 1; % Counter, för hur många körningar varje taxibil tar på sig.
                Taxibilar(k,1) = 1; % Sätter taxibilens status till 1.
                Taxibilar(k,5) = 0; % Återställer tiden för kunden att ta sig in/ut ur bilen.
                kundlista(j,8) = 2; % kundens status = upphämtad och påväg till slutdestination.
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
                break % Avbryter loopen när en taxi tilldelas en kund.
            end
        end
        %Beräknar hur taxibilarna färdas då de ska till en kund.
        for k = 1:10
            if (Taxibilar(k,1) == 1 && kundlista(j,8) == 2)
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
                        kundlista(j,8) = 3;
                        disp(['Taxibil nr: ',num2str(k),' har hämtat upp kund nr: ',num2str(j)])
                    end
                else
                    Taxibilar(k,5) = Taxibilar(k,5) + 1; % Räknar tiden för kunden att ta sig
                end
            end
            
            if (Taxibilar(k,1) == 2 && kundlista(j,8) == 3)  %Om kunden har plockats upp
                if (Taxibilar(k,5) == 100) % Extra tid för att kunde ska ta sig in i taxin.
                    if(Taxibilar(k,2) ~= kundlista(j,3)) % kollar att taxin har "rätt" värde i x-led
%                         Taxibilar(k,2) = Taxibilar(k,2) + (riktning_x(k,4));
%                         disp('Söker avlämning i x-led för taxi nr: ')
%                         disp(k)
%                         disp('för kund nr: ')
%                         disp(j)
                    end
                    if(Taxibilar(k,2) == kundlista(j,3) && Taxibilar(k,3) ~= kundlista(j,4))
%                         Taxibilar(k,3) = Taxibilar(k,3) + (riktning_y(k,4));
%                         disp('Söker avlämning i y-led för taxi nr: ')
%                         disp(k)
%                         disp('för kund nr: ')
%                         disp(j)
                    end
                    if(Taxibilar(k,2) == kundlista(j,3) && Taxibilar(k,3) == kundlista(j,4)) % kollar att bilen är framme vid kundens slutdestionation
                        Taxibilar(k,1) = 0; %Kunden har lämnats av
                        Taxibilar(k,5) = 0;

                        
                    end
                else
                    Taxibilar(k,5) = Taxibilar(k,5) + 1; % Räknar tiden för kunden att ta sig
                end
            end
        end
    end
    klockan = klockan +1;
end
