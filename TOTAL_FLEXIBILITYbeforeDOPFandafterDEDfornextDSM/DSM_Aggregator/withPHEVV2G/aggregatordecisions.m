Celphev=0.015;% This can be requested and received form the PHEV aggregator,assuming tconnect-tdisconnect = 15/60 hours
Ephevinit = 10/1000;
Ephevv2ginit = 10/1000;
Estorinit=0.01;
Pphevmax=0.1;
Pphevv2gmax=0.1;
Pstormax= 0.1;
Ploadinit=0.6;
Ploadmax=1.0;
Pnodemax=1.0;
Eelphevv2g=0.0192;%This is also requested and received from the PHEV aggregator.
%%The change is the lower bound for the PHEV when the Cel�phev or the
%%Eelphevv2g changes and will be replaced by those values
for i= 1:96
    Pload(i,1)= i*(0.01)-0;
    Pres(i,1)=0.6*Pnodemax;
    
    %Pload= 1100;
    %Pres=100;
    
    % Pl(i,1) = Pload(i,1)-Pres(i,1);
    %     if Pl(i,1) < 0
    %         disp('Overproduction case')
    %         if abs(Pl(i,1))<= 650
    %             c = 1.0;
    %             d=1.0;
    %         else abs(Pl(i,1))> 650
    %             PD(i,1) = -1*(abs(Pl(i,1))-650);
    %
    %         end
    %     [PD(i,1),Pstor(i,1),Pphev(i,1)]=battery_soc_OVP(Pl(i,1),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,d,Pnodemax)
    C=(Pres(i,1)-Pload(i,1));
    if C>0
        if     (Pres(i,1)-Pload(i,1))<0.650
            c=1.0;
            d=1.0;
            e=1;
            [PD(i,1),Pstor(i,1),Pphev(i,1),Pphevv2g(i,1)]=battery_soc_OVP( (Pres(i,1)-Pload(i,1)),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,d,Pphevv2gmax,Ephevv2ginit,e,Eelphevv2g)
        else
            PD(i,1)=-1*((Pres(i,1)-Pload(i,1))-(Pstormax-Estorinit)-(Pphevmax-Ephevinit)-(Pphevv2gmax-Ephevv2ginit));
            Pstor(i,1)=Pstormax;
            Pphev(i,1)=Pphevmax;
            Pphevv2g(i,1)=Pphevv2gmax;
        end
        
    elseif Pres(i,1)>Pnodemax && Pload(i,1)<0.8*Ploadmax
        c= 1.0; d= 1.0; e=1.0;
        [PD(i,1),Pstor(i,1),Pphev(i,1),Pphevv2g(i,1)]=battery_soc(Pload(i,1),Pres(i,1),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,Ploadinit,d,Pphevv2gmax,Ephevv2ginit,Eelphevv2g,e)
    elseif 0.8*Pnodemax<Pres(i,1)   && Pres(i,1)<Pnodemax && Pload(i,1)<0.8*Ploadmax
        c= 0.7; d =0.7; e=0.7;
    elseif Pres(i,1)>Pnodemax && Pload(i,1)>0.8*Ploadmax
        c= 0.5;d=0.5; e=0.5;
        [PD(i,1),Pstor(i,1),Pphev(i,1),Pphevv2g(i,1)]=battery_soc(Pload(i,1),Pres(i,1),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,Ploadinit,d,Pphevv2gmax,Ephevv2ginit,Eelphevv2g,e)
    elseif Pload(i,1)<0.4*Ploadmax
        c = 1.0;
        d = 0.9; e= 0.9;
        [PD(i,1),Pstor(i,1),Pphev(i,1),Pphevv2g(i,1)]=battery_soc(Pload(i,1),Pres(i,1),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,Ploadinit,d,Pphevv2gmax,Ephevv2ginit,Eelphevv2g,e)
    elseif Pres(i,1)>1.2*Pnodemax && Pload(i,1) < 0.8*Ploadmax
        c=1.0;
        d=1.0;e=1;
        [PD(i,1),Pstor(i,1),Pphev(i,1),Pphevv2g(i,1)]=battery_soc(Pload(i,1),Pres(i,1),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,Ploadinit,d,Pphevv2gmax,Ephevv2ginit,Eelphevv2g,e)
    elseif Pres(i,1)>0.6*Pnodemax && Pres(i,1)<0.8*Pnodemax && Pload(i,1)<0.6*Ploadmax
        c= 0.8; d=0.7;e=1;
        [PD(i,1),Pstor(i,1),Pphev(i,1),Pphevv2g(i,1)]=battery_soc(Pload(i,1),Pres(i,1),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,Ploadinit,d,Pphevv2gmax,Ephevv2ginit,Eelphevv2g,e)
    elseif Pload(i,1)< 0.5*Ploadmax
        c= 0.8;
        d=0.8;e=0.8;
        [PD(i,1),Pstor(i,1),Pphev(i,1),Pphevv2g(i,1)]=battery_soc(Pload(i,1),Pres(i,1),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,Ploadinit,d,Pphevv2gmax,Ephevv2ginit,Eelphevv2g,e)
    else
        c=0.4;d=0.4; e=0.4;
        [PD(i,1),Pstor(i,1),Pphev(i,1),Pphevv2g(i,1)]=battery_soc(Pload(i,1),Pres(i,1),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,Ploadinit,d,Pphevv2gmax,Ephevv2ginit,Eelphevv2g,e)
        
    end
    
    % [PD(i,1),Pstor(i,1),Pphev(i,1)]=battery_soc(Pload(i,1),Pres(i,1),Celphev,Ephevinit,Estorinit,Pphevmax,Pstormax,c,Ploadinit,d)
end
figure(1)
plot(1:96,Pload)
hold on
plot(1:96,PD)
hold on
plot(1:96,Pphev)
hold on
plot(1:96,Pstor)
hold on
plot(1:96,Pres)
hold on
plot(1:96,Pphevv2g)
legend('TOTAL LOAD','NET OPTIMIZED LOAD','Pphev','Pstor','Pres','Pphevv2g')
%     figure(2)
%     plot(PD(i,1),Pstor(i,1))
%     figure(3)
%     plot(Pstor(i,1),Pphev(i,1))
%     figure(4)
%     plot(Pstor(i,1),Pstormax)
%     figure(5)
%     plot(Pphev(i,1),Pphevmax)

